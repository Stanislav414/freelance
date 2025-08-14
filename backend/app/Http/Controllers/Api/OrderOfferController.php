<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class OrderOfferController extends Controller
{
    /**
     * Отправить предложение исполнителю
     */
    public function sendOffer(Request $request, Order $order): JsonResponse
    {
        $request->validate([
            'executor_id' => 'required|exists:users,id',
        ]);

        // Проверяем, что заказ принадлежит текущему пользователю
        if ($order->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Недостаточно прав'], 403);
        }

        // Проверяем, что заказ еще не назначен исполнителю
        if ($order->executor_id) {
            return response()->json(['message' => 'Заказ уже назначен исполнителю'], 400);
        }

        $executorId = $request->executor_id;
        
        // Получаем текущие предложения
        $offers = $order->executor_offers ?? [];
        
        // Проверяем, не было ли уже предложения этому исполнителю
        if (in_array($executorId, $offers)) {
            return response()->json(['message' => 'Предложение уже отправлено этому исполнителю'], 400);
        }

        // Добавляем нового исполнителя в список предложений
        $offers[] = $executorId;
        
        // Обновляем заказ
        $order->update([
            'executor_offers' => $offers,
            'status' => 'pending_approval'
        ]);

        return response()->json([
            'message' => 'Предложение отправлено исполнителю',
            'order' => $order->load(['workType', 'user', 'executor'])
        ]);
    }

    /**
     * Получить предложения для исполнителя
     */
    public function getOffersForExecutor(Request $request): JsonResponse
    {
        $offers = Order::where('status', 'pending_approval')
            ->whereJsonContains('executor_offers', $request->user()->id)
            ->with(['workType', 'user', 'attributes.attributeType', 'attributes.value', 'materials'])
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($order) {
                return [
                    'id' => $order->id,
                    'title' => $order->title,
                    'description' => $order->description,
                    'budget' => $order->budget,
                    'deadline' => $order->deadline,
                    'work_type' => $order->workType->name,
                    'customer' => [
                        'name' => $order->user->name . ' ' . $order->user->surname,
                        'avatar' => $order->user->avatar,
                    ],
                    'attributes' => $order->attributes->map(function ($attr) {
                        return [
                            'name' => $attr->attributeType->label,
                            'value' => $attr->value ?? $attr->valueRelation->label ?? 'Не указано'
                        ];
                    }),
                    'materials' => $order->materials,
                    'created_at' => $order->created_at,
                ];
            });

        return response()->json($offers);
    }

    /**
     * Принять предложение
     */
    public function acceptOffer(Request $request, Order $order): JsonResponse
    {
        // Проверяем, что заказ предлагался текущему исполнителю
        if (!in_array($request->user()->id, $order->executor_offers ?? [])) {
            return response()->json(['message' => 'Предложение не найдено'], 404);
        }

        // Проверяем, что заказ еще не принят
        if ($order->executor_id) {
            return response()->json(['message' => 'Заказ уже принят другим исполнителем'], 400);
        }

        // Назначаем исполнителя и меняем статус
        $order->update([
            'executor_id' => $request->user()->id,
            'status' => 'in_progress'
        ]);

        return response()->json([
            'message' => 'Заказ принят',
            'order' => $order->load(['workType', 'user', 'executor'])
        ]);
    }

    /**
     * Отклонить предложение
     */
    public function declineOffer(Request $request, Order $order): JsonResponse
    {
        // Проверяем, что заказ предлагался текущему исполнителю
        if (!in_array($request->user()->id, $order->executor_offers ?? [])) {
            return response()->json(['message' => 'Предложение не найдено'], 404);
        }

        // Убираем исполнителя из списка предложений
        $offers = $order->executor_offers ?? [];
        $offers = array_diff($offers, [$request->user()->id]);
        
        // Если больше нет предложений, возвращаем статус в open
        $status = empty($offers) ? 'open' : 'pending_approval';
        
        $order->update([
            'executor_offers' => array_values($offers),
            'status' => $status
        ]);

        return response()->json([
            'message' => 'Предложение отклонено',
            'order' => $order->load(['workType', 'user', 'executor'])
        ]);
    }
}
