<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Chat;
use App\Models\Message;
use App\Models\ChatParticipant;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class ChatController extends Controller
{
    /**
     * Получить список чатов для текущего пользователя
     */
    public function index(Request $request)
    {
        try {
            $user = Auth::user();
            $role = $request->get('role', 'customer'); // customer или executor
            $category = $request->get('category', 'active'); // active, archive, support

        // Получаем чаты, где пользователь является участником
        $chatsQuery = Chat::whereHas('participants', function($query) use ($user, $role) {
            $query->where('user_id', $user->id)
                  ->where('role', $role);
        })
        ->where('category', $category)
        ->with(['order.workType', 'lastMessage.user', 'participants.user']);
        
        $chats = $chatsQuery->orderBy('updated_at', 'desc')->get()
        ->map(function($chat) use ($user) {
            // Избегаем дополнительных запросов: используем уже подгруженных участников
            $otherParticipant = $chat->participants
                ->firstWhere('user_id', '!=', $user->id);

            $chat->other_user = $otherParticipant && $otherParticipant->relationLoaded('user')
                ? $otherParticipant->user
                : null;
            $chat->other_user_role = $otherParticipant ? $otherParticipant->role : null;
            $chat->unread_count = $chat->unreadCount($user->id);
            
            // Добавляем флаг наличия отзыва и возможности оставить отзыв
            if ($chat->order) {
                $chat->order->has_review = $chat->order->hasReviewFromUser($user->id);
                $chat->order->can_review = $chat->order->canBeReviewedByUser($user->id);
            }
            
            return $chat;
        });
        
        return response()->json($chats);
        } catch (\Exception $e) {
            \Log::error('Chat index error', [
                'user_id' => $user->id ?? null,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return response()->json(['error' => 'Internal server error'], 500);
        }
    }

    /**
     * Получить сообщения чата
     */
    public function messages($chatId)
    {
        $user = Auth::user();
        $limit = (int) request()->get('limit', 0);
        if ($limit < 0) { $limit = 0; }
        if ($limit > 500) { $limit = 500; } // жёсткий верхний предел
        
        // Проверяем, что пользователь является участником чата
        $participant = ChatParticipant::where('chat_id', $chatId)
            ->where('user_id', $user->id)
            ->first();

        if (!$participant) {
            return response()->json(['error' => 'Доступ запрещен'], 403);
        }

        // СНАЧАЛА отмечаем сообщения как прочитанные, чтобы в ответе уже были актуальные read_at
        Message::where('chat_id', $chatId)
            ->where('user_id', '!=', $user->id)
            ->whereNull('read_at')
            ->update(['read_at' => now()]);

        // Обновляем время последнего прочтения для участника
        $participant->update(['last_read_at' => now()]);

        // Получаем сообщения (с поддержкой лимита; при лимите берём последние N и сортируем по возрастанию)
        $baseQuery = Message::where('chat_id', $chatId)
            ->where('is_deleted', false)
            ->with(['user' => function ($q) { $q->select('id', 'name', 'surname'); }]);

        if ($limit > 0) {
            $messages = $baseQuery->orderBy('created_at', 'desc')
                ->limit($limit)
                ->get()
                ->sortBy('created_at')
                ->values();
        } else {
            $messages = $baseQuery->orderBy('created_at', 'asc')->get();
        }

        return response()->json($messages);
    }

    /**
     * Отправить сообщение
     */
    public function sendMessage(Request $request, $chatId)
    {
        $user = Auth::user();
        
        // Проверяем, что пользователь является участником чата
        $participant = ChatParticipant::where('chat_id', $chatId)
            ->where('user_id', $user->id)
            ->first();

        if (!$participant) {
            return response()->json(['error' => 'Доступ запрещен'], 403);
        }

        $request->validate([
            'content' => 'required|string|max:1000',
        ]);

        $message = Message::create([
            'chat_id' => $chatId,
            'user_id' => $user->id,
            'content' => $request->content,
            'type' => 'text',
            'status' => 'sent',
        ]);

        // Обновляем время последнего сообщения в чате
        $chat = Chat::find($chatId);
        $chat->touch();

        // Отмечаем собственное сообщение как прочитанное для отправителя
        $participant = ChatParticipant::where('chat_id', $chatId)
            ->where('user_id', $user->id)
            ->first();
        
        if ($participant) {
            $participant->update(['last_read_at' => now()]);
        }

        return response()->json($message->load('user'));
    }

    /**
     * Создать чат для заказа
     */
    public function createChatForOrder($orderId)
    {
        $user = Auth::user();
        $order = Order::findOrFail($orderId);

        // Проверяем права доступа - заказчик или исполнитель могут создать чат
        if ($order->user_id !== $user->id && $order->executor_id !== $user->id) {
            // Если заказ еще не назначен исполнителю, то любой авторизованный пользователь может создать чат
            // Это нужно для того, чтобы исполнители могли общаться с заказчиками до взятия заказа
            if ($order->status === 'open') {
                // Разрешаем создание чата для открытых заказов
            } else {
                return response()->json(['error' => 'Доступ запрещен'], 403);
            }
        }

        // Проверяем, существует ли уже чат для этого заказа
        $existingChat = Chat::where('order_id', $orderId)->first();
        if ($existingChat) {
            return response()->json($existingChat->load(['order', 'participants.user']));
        }

        // Создаем чат
        $chat = Chat::create([
            'order_id' => $orderId,
            'title' => "Заказ #{$orderId}",
            'is_active' => true,
        ]);

        // Добавляем участников
        ChatParticipant::create([
            'chat_id' => $chat->id,
            'user_id' => $order->user_id,
            'role' => 'customer',
        ]);

        // Если есть исполнитель, добавляем его
        if ($order->executor_id) {
            ChatParticipant::create([
                'chat_id' => $chat->id,
                'user_id' => $order->executor_id,
                'role' => 'executor',
            ]);
        } else {
            // Если исполнителя еще нет, но текущий пользователь хочет создать чат,
            // добавляем его как потенциального участника
            if ($user->id !== $order->user_id) {
                ChatParticipant::create([
                    'chat_id' => $chat->id,
                    'user_id' => $user->id,
                    'role' => 'executor',
                ]);
            }
        }

        return response()->json($chat->load(['order', 'participants.user']));
    }

    /**
     * Отметить сообщения как прочитанные
     */
    public function markAsRead($chatId)
    {
        $user = Auth::user();
        
        // Проверяем, что пользователь является участником чата
        $participant = ChatParticipant::where('chat_id', $chatId)
            ->where('user_id', $user->id)
            ->first();

        if (!$participant) {
            return response()->json(['error' => 'Доступ запрещен'], 403);
        }

        // Отмечаем все непрочитанные сообщения как прочитанные
        Message::where('chat_id', $chatId)
            ->where('user_id', '!=', $user->id)
            ->where('read_at', null)
            ->update(['read_at' => now()]);

        // Обновляем время последнего прочтения для участника
        $participant->update(['last_read_at' => now()]);

        return response()->json(['success' => true]);
    }

    /**
     * Изменить категорию чата
     */
    public function changeCategory(Request $request, $chatId)
    {
        $user = Auth::user();
        
        // Проверяем, что пользователь является участником чата
        $participant = ChatParticipant::where('chat_id', $chatId)
            ->where('user_id', $user->id)
            ->first();

        if (!$participant) {
            return response()->json(['error' => 'Доступ запрещен'], 403);
        }

        $request->validate([
            'category' => 'required|string|in:active,archive,support',
        ]);

        $chat = Chat::findOrFail($chatId);
        $chat->update(['category' => $request->category]);

        return response()->json([
            'success' => true,
            'chat' => $chat->load(['order', 'participants.user'])
        ]);
    }

    /**
     * Импортировать чат, его участников и сообщения из JSON-полей
     */
    public function import(Request $request)
    {
        $user = Auth::user();

        $validated = $request->validate([
            'order_id' => 'nullable|integer|exists:orders,id',
            'title' => 'nullable|string|max:255',
            'category' => 'nullable|string|in:active,archive,support',
            'is_active' => 'nullable|boolean',
            'participants' => 'required|array|min:1',
            'participants.*.user_id' => 'required|integer|exists:users,id',
            'participants.*.role' => 'required|string|in:customer,executor',
            'messages' => 'nullable|array',
            'messages.*.user_id' => 'nullable|integer|exists:users,id',
            'messages.*.content' => 'required_with:messages|string|max:2000',
            'messages.*.type' => 'nullable|string|in:text,system',
            'messages.*.status' => 'nullable|string|in:sent,delivered,read',
            'messages.*.created_at' => 'nullable|date',
            'messages.*.read_at' => 'nullable|date',
        ]);

        return DB::transaction(function () use ($validated, $user) {
            $chat = Chat::create([
                'order_id' => $validated['order_id'] ?? null,
                'title' => $validated['title'] ?? ($validated['order_id'] ? ("Заказ #" . $validated['order_id']) : 'Чат'),
                'category' => $validated['category'] ?? 'active',
                'is_active' => $validated['is_active'] ?? true,
            ]);

            // Добавляем участников, исключая дубликаты по user_id
            $addedUserIds = [];
            foreach ($validated['participants'] as $participant) {
                if (in_array($participant['user_id'], $addedUserIds, true)) {
                    continue;
                }
                ChatParticipant::create([
                    'chat_id' => $chat->id,
                    'user_id' => $participant['user_id'],
                    'role' => $participant['role'],
                    'is_active' => true,
                ]);
                $addedUserIds[] = $participant['user_id'];
            }

            // Сообщения (опционально)
            if (!empty($validated['messages'])) {
                foreach ($validated['messages'] as $msg) {
                    $message = new Message([
                        'chat_id' => $chat->id,
                        'user_id' => $msg['user_id'] ?? null,
                        'content' => $msg['content'],
                        'type' => $msg['type'] ?? 'text',
                        'status' => $msg['status'] ?? 'sent',
                        'read_at' => isset($msg['read_at']) ? Carbon::parse($msg['read_at']) : null,
                    ]);

                    // Устанавливаем created_at вручную, если передан
                    if (!empty($msg['created_at'])) {
                        $message->setCreatedAt(Carbon::parse($msg['created_at']));
                    }
                    $message->save();
                }

                // Обновляем updated_at чата на время последнего сообщения, если есть
                $lastMessage = $chat->messages()->latest('created_at')->first();
                if ($lastMessage) {
                    $chat->updated_at = $lastMessage->created_at;
                    $chat->save();
                }
            }

            return response()->json(
                $chat->load(['order', 'participants.user', 'messages.user'])
            );
        });
    }
}
