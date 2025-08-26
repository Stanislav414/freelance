<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Models\Order;
use App\Models\User;
use App\Models\Chat;
use App\Models\ChatParticipant;
use App\Models\Message;

class OrderController extends Controller
{
    /**
     * Получить все открытые заказы на платформе
     */
    public function getAllOpenOrders(Request $request): JsonResponse
    {
        $orders = Order::with(['workType', 'materials', 'attributes.attributeType', 'attributes.value', 'user', 'customerReview', 'executorReview'])
            ->where('status', 'open')
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($order) use ($request) {
                // Добавляем информацию о возможности оставить отзыв
                $order->can_review = $order->canBeReviewedByUser(auth()->id());
                $order->has_review = $order->hasReviewFromUser(auth()->id());
                return $order;
            });
            
        return response()->json($orders);
    }

    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $orders = Order::with(['workType', 'materials', 'attributes.attributeType', 'attributes.value', 'user', 'executor', 'customerReview', 'executorReview'])
            ->where(function($query) use ($request) {
                $query->where('user_id', $request->user()->id)  // Заказы где пользователь заказчик
                      ->orWhere('executor_id', $request->user()->id);  // Заказы где пользователь исполнитель
            })
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($order) use ($request) {
                // Добавляем информацию о возможности оставить отзыв
                $order->can_review = $order->canBeReviewedByUser($request->user()->id);
                $order->has_review = $order->hasReviewFromUser($request->user()->id);
                return $order;
            });
            
        return response()->json($orders);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'work_type_id' => 'nullable|exists:work_types,id',
            'title' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'deadline' => 'nullable|date|after:today',
            'budget' => 'nullable|numeric|min:0',
            'attributes' => 'array',
            'attributes.*.attribute_type_id' => 'nullable|exists:order_attribute_types,id',
            'attributes.*.value_id' => 'nullable|exists:order_attribute_values,id',
            'attributes.*.value' => 'nullable|string',
            'materials' => 'array',
            'materials.*.type' => 'nullable|string',
            'materials.*.description' => 'nullable|string',
            'materials.*.file_url' => 'nullable|string|max:500',
            'executor_id' => 'nullable|exists:users,id',
            'selected_tariff_id' => 'nullable|exists:tariffs,id',
            'selected_services' => 'nullable|array',
            'selected_options' => 'nullable|array',
            'calculated_price' => 'nullable|numeric|min:0',
            'slides_quantity' => 'nullable|integer|min:1|max:50',
        ]);

        // Авторизованный пользователь всегда является заказчиком
        $customerId = $request->user()->id;

        // Статус определяется автоматически от наличия исполнителя
        $initialStatus = !empty($data['executor_id'])
            ? Order::STATUS_PENDING_APPROVAL
            : Order::STATUS_OPEN;

        $order = Order::create([
            'user_id' => $customerId,
            'work_type_id' => $data['work_type_id'] ?? 1, // Дефолтное значение
            'title' => $data['title'] ?? 'Тестовый заказ',
            'description' => $data['description'] ?? 'Описание заказа',
            'deadline' => $data['deadline'] ?? now()->addDays(7),
            'budget' => $data['budget'] ?? 1000,
            'status' => $initialStatus,
            'executor_id' => $data['executor_id'] ?? null,
            'executor_offers' => !empty($data['executor_id']) ? [$data['executor_id']] : null,
            'was_created_without_executor' => empty($data['executor_id']),
            'selected_tariff_id' => $data['selected_tariff_id'] ?? null,
            'selected_services' => $data['selected_services'] ?? null,
            'selected_options' => $data['selected_options'] ?? null,
            'calculated_price' => $data['calculated_price'] ?? ($data['budget'] ?? 1000),
            'slides_quantity' => $data['slides_quantity'] ?? null,
        ]);

        if (!empty($data['attributes'])) {
            foreach ($data['attributes'] as $attr) {
                // Проверяем, есть ли value_id или value
                if (isset($attr['value_id']) && $attr['value_id']) {
                    $order->attributes()->create([
                        'attribute_type_id' => $attr['attribute_type_id'],
                        'value_id' => $attr['value_id']
                    ]);
                } elseif (isset($attr['value']) && $attr['value']) {
                    $order->attributes()->create([
                        'attribute_type_id' => $attr['attribute_type_id'],
                        'value' => $attr['value']
                    ]);
                }
            }
        }
        if (!empty($data['materials'])) {
            foreach ($data['materials'] as $mat) {
                // Автоматически добавляем https:// если URL не содержит протокол
                if (!empty($mat['file_url']) && !preg_match('/^https?:\/\//', $mat['file_url'])) {
                    $mat['file_url'] = 'https://' . $mat['file_url'];
                }
                $order->materials()->create($mat);
            }
        }

        // Создаем чат если указан исполнитель
        if (!empty($data['executor_id'])) {
            $this->createChatForOrder($order, $data['executor_id']);
        }

        return response()->json($order->load(['attributes.attributeType', 'attributes.value', 'materials']), 201);
    }

    /**
     * Назначить исполнителя к заказу
     */
    public function assignExecutor(Request $request, Order $order): JsonResponse
    {
        $request->validate([
            'executor_id' => 'required|exists:users,id',
            'status' => 'required|string|in:pending_approval,in_progress,done,cancelled'
        ]);

        // Проверяем, что заказ принадлежит текущему пользователю
        if ($order->user_id !== $request->user()->id) {
            return response()->json(['message' => 'У вас нет прав для изменения этого заказа'], 403);
        }

        // Проверяем, что заказ еще не имеет исполнителя
        if ($order->executor_id) {
            return response()->json(['message' => 'К заказу уже назначен исполнитель'], 400);
        }

        // Обновляем заказ
        $order->update([
            'executor_id' => $request->executor_id,
            'status' => $request->status
        ]);

        // Создаем чат для заказа, если его еще нет
        $existingChat = Chat::where('order_id', $order->id)->first();
        if (!$existingChat) {
            $this->createChatForOrder($order, $request->executor_id);
        }

        // Создаем системное сообщение о назначении исполнителя
        if ($request->status === 'pending_approval') {
            $this->createSystemMessage($order, 'Исполнитель назначен к заказу. Статус заказа: На согласовании');
        } else if ($request->status === 'in_progress') {
            $this->createSystemMessage($order, 'Исполнитель назначен к заказу. Статус заказа: В работе');
        }

        return response()->json([
            'message' => 'Исполнитель успешно назначен к заказу',
            'order' => $order->fresh()
        ]);
    }

    /**
     * Обновить статус заказа
     */
    public function updateStatus(Request $request, Order $order): JsonResponse
    {
        $request->validate([
            'status' => 'required|string|in:open,pending_approval,in_progress,pending_review,revision,completed,cancelled,disputed',
            'executor_id' => 'nullable|exists:users,id'
        ]);

        // Проверяем права доступа
        $user = $request->user();
        
        // Проверяем, что пользователь не пытается взять свой собственный заказ
        if ($request->status === 'pending_approval' && $request->executor_id === $user->id && $order->user_id === $user->id) {
            return response()->json(['message' => 'Вы не можете взять свой собственный заказ'], 400);
        }
        
        // Разрешаем изменение если:
        // 1. Пользователь является заказчиком заказа
        // 2. Пользователь является исполнителем заказа
        // 3. Пользователь пытается взять заказ (статус меняется на pending_approval и устанавливается executor_id)
        $canUpdate = $order->user_id === $user->id || 
                    $order->executor_id === $user->id ||
                    ($request->status === 'pending_approval' && $request->executor_id === $user->id && $order->status === 'open');
        
        if (!$canUpdate) {
            return response()->json(['message' => 'У вас нет прав для изменения этого заказа'], 403);
        }

        // Логируем данные для отладки
        \Log::info('Updating order status', [
            'order_id' => $order->id,
            'old_status' => $order->status,
            'new_status' => $request->status,
            'old_executor_id' => $order->executor_id,
            'new_executor_id' => $request->executor_id,
            'user_id' => $user->id
        ]);

        // Обновляем заказ
        $updateData = ['status' => $request->status];
        if ($request->has('executor_id')) {
            $updateData['executor_id'] = $request->executor_id;
        }

        $order->update($updateData);

        // Создаем чат для заказа, если его еще нет и назначен исполнитель
        if ($request->has('executor_id') && $request->executor_id && !$order->fresh()->chat) {
            $this->createChatForOrder($order->fresh(), $request->executor_id);
        }

        // Создаем системное сообщение о изменении статуса
        $statusMessages = [
            Order::STATUS_OPEN => 'Заказ открыт для поиска исполнителя',
            Order::STATUS_PENDING_APPROVAL => 'Заказ находится на согласовании',
            Order::STATUS_IN_PROGRESS => 'Заказ взят в работу',
            Order::STATUS_PENDING_REVIEW => 'Работа отправлена на проверку',
            Order::STATUS_REVISION => 'Заказ на доработке',
            Order::STATUS_COMPLETED => 'Заказ выполнен',
            Order::STATUS_CANCELLED => 'Заказ отменен',
            Order::STATUS_DISPUTED => 'По заказу открыт спор',
        ];

        if (isset($statusMessages[$request->status])) {
            $this->createSystemMessage($order->fresh(), $statusMessages[$request->status] . '. Статус заказа: ' . $order->fresh()->getStatusDisplay());
        }

        // Логируем результат
        \Log::info('Order updated successfully', [
            'order_id' => $order->id,
            'new_status' => $order->fresh()->status,
            'new_executor_id' => $order->fresh()->executor_id
        ]);

        return response()->json([
            'message' => 'Статус заказа успешно обновлен',
            'order' => $order->fresh()->load(['workType', 'materials', 'attributes.attributeType', 'attributes.value', 'user', 'executor'])
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $order = \App\Models\Order::with([
            'workType',
            'materials',
            'attributes.value',
            'attributes.attributeType',
            'user:id,name,surname,email', // Добавляем конкретные поля пользователя
            'executor:id,name,surname,email', // Также добавляем информацию об исполнителе если есть
            'customerReview', // Отзыв от заказчика на исполнителя
            'executorReview' // Отзыв от исполнителя на заказчика
        ])->find($id);

        if (!$order) {
            return response()->json(['message' => 'Order not found'], 404);
        }

        // Добавляем полное имя заказчика
        if ($order->user) {
            $order->customer = [
                'id' => $order->user->id,
                'name' => trim($order->user->name . ' ' . ($order->user->surname ?? '')),
                'email' => $order->user->email
            ];
        }

        // Добавляем информацию о возможности оставить отзыв
        $order->can_review = $order->canBeReviewedByUser(request()->user()->id);
        $order->has_review = $order->hasReviewFromUser(request()->user()->id);

        return response()->json($order);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, Order $order): JsonResponse
    {
        $user = $request->user();
        if ($order->user_id !== $user->id) {
            return response()->json(['message' => 'Можно удалить только свой заказ'], 403);
        }
        if (!in_array($order->status, [Order::STATUS_OPEN, Order::STATUS_PENDING_APPROVAL])) {
            return response()->json(['message' => 'Удаление доступно только для открытых и на согласовании заказов'], 400);
        }
        $order->delete();
        return response()->json(['message' => 'Заказ удален']);
    }

    /**
     * Завершить заказ (заказчик принимает работу)
     */
    public function completeOrder(Request $request, Order $order): JsonResponse
    {
        $user = $request->user();
        
        // Проверяем права доступа - только заказчик может завершить заказ
        if ($order->user_id !== $user->id) {
            return response()->json(['message' => 'Только заказчик может завершить заказ'], 403);
        }

        // Проверяем, можно ли завершить заказ
        if (!$order->canBeCompletedByCustomer()) {
            return response()->json(['message' => 'Заказ не может быть завершен в текущем статусе'], 400);
        }

        // Обновляем статус заказа
        $order->update(['status' => Order::STATUS_COMPLETED]);

        // Перемещаем чат в архив, если он существует
        $chat = $order->chat;
        if ($chat) {
            $chat->update(['category' => 'archive']);
        }

        // Создаем системное сообщение в чате
        $this->createSystemMessage($order, 'Заказ завершен заказчиком. Статус заказа: Завершен');

        return response()->json([
            'message' => 'Заказ успешно завершен',
            'order' => $order->fresh()->load(['workType', 'materials', 'attributes.attributeType', 'attributes.value', 'user', 'executor'])
        ]);
    }

    /**
     * Отправить заказ на доработку
     */
    public function sendToRevision(Request $request, Order $order): JsonResponse
    {
        $request->validate([
            'revision_comment' => 'required|string|max:1000'
        ]);

        $user = $request->user();
        
        // Проверяем права доступа - только заказчик может отправить на доработку
        if ($order->user_id !== $user->id) {
            return response()->json(['message' => 'Только заказчик может отправить заказ на доработку'], 403);
        }

        // Проверяем, можно ли отправить на доработку
        if (!$order->canBeRevised()) {
            return response()->json(['message' => 'Заказ не может быть отправлен на доработку в текущем статусе'], 400);
        }

        // Инкремент счётчика доработок и перевод в статус "На доработке"
        $order->update([
            'status' => Order::STATUS_REVISION,
            'revision_count' => ($order->revision_count ?? 0) + 1,
        ]);

        // Системное сообщение в чат с текстом доработки
        $chat = $order->chat;
        if ($chat) {
            Message::create([
                'chat_id' => $chat->id,
                'user_id' => null, // системное
                'content' => 'Заказ отправлен на доработку. Статус заказа: На доработке. Комментарий: ' . $request->revision_comment,
                'type' => 'system',
                'status' => 'sent',
            ]);
        }

        return response()->json([
            'message' => 'Заказ отправлен на доработку',
            'order' => $order->fresh()->load(['workType', 'materials', 'attributes.attributeType', 'attributes.value', 'user', 'executor'])
        ]);
    }

    /**
     * Отменить заказ
     */
    public function cancelOrder(Request $request, Order $order): JsonResponse
    {
        $user = $request->user();
        
        // Проверяем права доступа - заказчик или исполнитель могут отменить заказ
        if ($order->user_id !== $user->id && $order->executor_id !== $user->id) {
            return response()->json(['message' => 'У вас нет прав для отмены этого заказа'], 403);
        }

        // Проверяем, можно ли отменить заказ в зависимости от роли
        $isCustomer = $order->user_id === $user->id;
        $isExecutor = $order->executor_id === $user->id;
        
        if ($isCustomer && !$order->canBeCancelledByCustomer()) {
            return response()->json(['message' => 'Заказчик не может отменить заказ в текущем статусе'], 400);
        }
        
        if ($isExecutor && !$order->canBeCancelledByExecutor()) {
            return response()->json(['message' => 'Исполнитель не может отменить заказ в текущем статусе'], 400);
        }

        // Обновляем статус заказа
        $order->update(['status' => Order::STATUS_CANCELLED]);

        // Перемещаем чат в архив, если он существует
        $chat = $order->chat;
        if ($chat) {
            $chat->update(['category' => 'archive']);
        }

        // Создаем системное сообщение в чате
        $cancelledBy = $order->user_id === $user->id ? 'заказчиком' : 'исполнителем';
        $this->createSystemMessage($order, "Заказ отменен {$cancelledBy}. Статус заказа: Отменен");

        return response()->json([
            'message' => 'Заказ успешно отменен',
            'order' => $order->fresh()->load(['workType', 'materials', 'attributes.attributeType', 'attributes.value', 'user', 'executor'])
        ]);
    }

    /**
     * Создать спор по заказу
     */
    public function createDispute(Request $request, Order $order): JsonResponse
    {
        $request->validate([
            'dispute_reason' => 'required|string|max:1000'
        ]);

        $user = $request->user();
        
        // Проверяем права доступа - заказчик или исполнитель могут создать спор
        if ($order->user_id !== $user->id && $order->executor_id !== $user->id) {
            return response()->json(['message' => 'У вас нет прав для создания спора по этому заказу'], 403);
        }

        // Проверяем, можно ли создать спор
        if (!$order->canBeDisputed()) {
            return response()->json(['message' => 'Спор не может быть создан в текущем статусе заказа'], 400);
        }

        // Обновляем статус заказа
        $order->update(['status' => Order::STATUS_DISPUTED]);

        // Перемещаем чат в архив, если он существует
        $chat = $order->chat;
        if ($chat) {
            $chat->update(['category' => 'archive']);
        }

        // Создаем системное сообщение в чате
        $disputedBy = $order->user_id === $user->id ? 'заказчиком' : 'исполнителем';
        $this->createSystemMessage($order, "Создан спор {$disputedBy}. Статус заказа: Спор. Причина: {$request->dispute_reason}");

        return response()->json([
            'message' => 'Спор по заказу создан',
            'order' => $order->fresh()->load(['workType', 'materials', 'attributes.attributeType', 'attributes.value', 'user', 'executor'])
        ]);
    }

    /**
     * Исполнитель завершил работу
     */
    public function finishWork(Request $request, Order $order): JsonResponse
    {
        $user = $request->user();

        $request->validate([
            'work_link' => 'nullable|string|max:2048'
        ]);
        
        // Проверяем права доступа - только исполнитель может завершить работу
        if ($order->executor_id !== $user->id) {
            return response()->json(['message' => 'Только исполнитель может завершить работу'], 403);
        }

        // Проверяем, можно ли завершить работу
        if (!$order->canBeCompletedByExecutor()) {
            return response()->json(['message' => 'Работа не может быть завершена в текущем статусе'], 400);
        }

        // Обновляем статус заказа и сохраняем ссылку, если передана
        $update = ['status' => Order::STATUS_PENDING_REVIEW];
        if ($request->filled('work_link')) {
            $update['work_link'] = $request->input('work_link');
        }
        $order->update($update);

        // Создаем системное сообщение в чате
        $message = 'Исполнитель завершил работу. Статус заказа: На проверке. Ожидается проверка заказчиком.';
        if ($order->work_link) {
            $message .= " Ссылка на работу: {$order->work_link}";
        }
        $this->createSystemMessage($order, $message);

        return response()->json([
            'message' => 'Работа завершена и отправлена на проверку',
            'order' => $order->fresh()->load(['workType', 'materials', 'attributes.attributeType', 'attributes.value', 'user', 'executor'])
        ]);
    }

    /**
     * Исполнитель берёт заказ в работу
     */
    public function take(Request $request, $id)
    {
        $user = $request->user();
        $order = \App\Models\Order::findOrFail($id);
        if ($order->status !== 'open') {
            return response()->json(['message' => 'Заказ уже в работе или закрыт'], 400);
        }
        $order->executor_id = $user->id;
        $order->status = 'in_progress';
        $order->save();

        // Создаем чат для заказа
        $this->createChatForOrder($order, $user->id);

        return response()->json($order->load(['workType', 'materials', 'attributes.attributeType', 'attributes.value', 'user', 'executor']));
    }



    public function getExecutorsForOrder(Order $order): JsonResponse
    {
        // Определяем специализацию на основе типа заказа
        $workType = $order->workType;
        $specialization = $this->getSpecializationFromWorkType($workType->name);

        $executors = User::where(function($query) use ($specialization) {
                $query->where('specializations', 'LIKE', '%"' . $specialization . '"%')
                      ->orWhere('specializations', 'LIKE', '%' . $specialization . '%');
            })
            ->where('id', '!=', $order->user_id) // Исключаем заказчика
            ->with(['orders' => function($query) {
                $query->where('status', Order::STATUS_COMPLETED);
            }])
            ->get()
            ->map(function($executor) {
                $completedOrders = $executor->orders->count();
                $averageRating = $executor->orders->avg('rating') ?? 4.5;

                return [
                    'id' => $executor->id,
                    'name' => $executor->name . ' ' . $executor->surname,
                    'avatar' => $executor->avatar,
                    'specializations' => $executor->specializations,
                    'description' => $executor->description,
                    'rating' => round($averageRating, 1),
                    'completed_orders' => $completedOrders,
                    'hourly_rate' => 500,
                    'is_verified' => true,
                ];
            })
            ->sortByDesc('rating')
            ->take(6);

        return response()->json($executors);
    }

    private function getSpecializationFromWorkType($workTypeName): string
    {
        $workTypeToSpecialization = [
            'Дизайн карточки для МП' => 'mp_card_design',
            'Видео до 30 секунд' => 'video',
            'Цветокоррекция фото' => 'color_correction',
            'Оформление сторис' => 'social_media'
        ];

        return $workTypeToSpecialization[$workTypeName] ?? 'graphic_design';
    }

    /**
     * Создать чат для заказа с исполнителем
     */
    private function createChatForOrder(Order $order, int $executorId): void
    {
        // Проверяем, существует ли уже чат для этого заказа
        $existingChat = Chat::where('order_id', $order->id)->first();
        
        if ($existingChat) {
            // Если чат уже существует, просто создаем системное сообщение
            $this->createSystemMessageForExistingChat($order, $existingChat, $executorId);
            return;
        }

        // Создаем чат
        $chat = Chat::create([
            'order_id' => $order->id,
            'title' => "Заказ #{$order->id}",
            'category' => 'active',
            'is_active' => true
        ]);

        // Добавляем участников чата с проверкой на существование
        $this->addChatParticipantIfNotExists($chat->id, $order->user_id, 'customer');
        $this->addChatParticipantIfNotExists($chat->id, $executorId, 'executor');

        // Создаем системное сообщение в зависимости от статуса заказа
        $this->createSystemMessageForNewChat($order, $chat, $executorId);
    }

    /**
     * Добавить участника чата, если он еще не существует
     */
    private function addChatParticipantIfNotExists(int $chatId, int $userId, string $role): void
    {
        $existingParticipant = ChatParticipant::where('chat_id', $chatId)
            ->where('user_id', $userId)
            ->first();

        if (!$existingParticipant) {
            ChatParticipant::create([
                'chat_id' => $chatId,
                'user_id' => $userId,
                'role' => $role,
                'is_active' => true
            ]);
        }
    }

    /**
     * Создать системное сообщение для нового чата
     */
    private function createSystemMessageForNewChat(Order $order, Chat $chat, int $executorId): void
    {
        $executor = User::find($executorId);
        
        if ($order->status === 'pending_approval') {
            // Заказ создан для конкретного исполнителя
            Message::create([
                'chat_id' => $chat->id,
                'user_id' => null, // Системное сообщение
                'content' => "Создан новый заказ \"{$order->title}\" для исполнителя {$executor->name} {$executor->surname}. Заказ находится на согласовании.",
                'type' => 'system',
                'status' => 'sent'
            ]);
        } else if ($order->status === 'in_progress') {
            // Исполнитель взял заказ в работу
            Message::create([
                'chat_id' => $chat->id,
                'user_id' => null, // Системное сообщение
                'content' => "Исполнитель {$executor->name} {$executor->surname} взял заказ \"{$order->title}\" в работу.",
                'type' => 'system',
                'status' => 'sent'
            ]);
        }
    }

    /**
     * Создать системное сообщение для существующего чата
     */
    private function createSystemMessageForExistingChat(Order $order, Chat $chat, int $executorId): void
    {
        $executor = User::find($executorId);
        
        if ($order->status === 'in_progress') {
            // Исполнитель взял заказ в работу
            Message::create([
                'chat_id' => $chat->id,
                'user_id' => null, // Системное сообщение
                'content' => "Исполнитель {$executor->name} {$executor->surname} взял заказ \"{$order->title}\" в работу.",
                'type' => 'system',
                'status' => 'sent'
            ]);
        }
    }

    /**
     * Создать системное сообщение в чате
     */
    private function createSystemMessage(Order $order, string $message): void
    {
        // Проверяем, есть ли чат для этого заказа
        $chat = Chat::where('order_id', $order->id)->first();
        
        if ($chat) {
            Message::create([
                'chat_id' => $chat->id,
                'user_id' => null, // Системное сообщение
                'content' => $message,
                'type' => 'system',
                'status' => 'sent'
            ]);
        }
    }
}
