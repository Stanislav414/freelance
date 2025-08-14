<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Review;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ReviewController extends Controller
{
    /**
     * Оставить отзыв к заказу
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'order_id' => 'required|exists:orders,id',
            'rating' => 'required|integer|min:1|max:5',
            'text' => 'required|string|min:10|max:1000',
        ]);

        $user = $request->user();
        $order = Order::findOrFail($request->order_id);

        // Проверяем права на оставление отзыва
        // Теперь и заказчик, и исполнитель могут оставлять отзывы
        if ($order->user_id !== $user->id && $order->executor_id !== $user->id) {
            return response()->json(['error' => 'Только участники заказа могут оставить отзыв'], 403);
        }

        if ($order->status !== Order::STATUS_COMPLETED) {
            return response()->json(['error' => 'Отзыв можно оставить только к завершенному заказу'], 400);
        }

        // Проверяем, не оставлял ли уже этот пользователь отзыв на конкретного участника
        if ($order->hasReviewFromUser($user->id)) {
            return response()->json(['error' => 'Вы уже оставили отзыв на этого участника заказа'], 400);
        }

        // Определяем, кто оставляет отзыв и на кого
        $reviewerId = $user->id;
        $reviewedId = null;
        
        if ($order->user_id === $user->id) {
            // Заказчик оставляет отзыв на исполнителя
            $reviewedId = $order->executor_id;
        } else {
            // Исполнитель оставляет отзыв на заказчика
            $reviewedId = $order->user_id;
        }

        // Создаем отзыв
        $review = Review::create([
            'order_id' => $order->id,
            'reviewer_id' => $reviewerId,
            'reviewed_id' => $reviewedId,
            'rating' => $request->rating,
            'text' => $request->text,
            'is_public' => true,
        ]);

        // Логируем создание отзыва для отладки
        \Log::info('Review created successfully', [
            'review_id' => $review->id,
            'order_id' => $order->id,
            'reviewer_id' => $reviewerId,
            'reviewed_id' => $reviewedId,
            'rating' => $request->rating,
            'reviewer_role' => $order->user_id === $reviewerId ? 'customer' : 'executor',
            'reviewed_role' => $order->user_id === $reviewedId ? 'customer' : 'executor'
        ]);

        // Обновляем рейтинг того, на кого оставлен отзыв
        $reviewedUser = \App\Models\User::find($reviewedId);
        if ($reviewedUser) {
            $reviewedUser->update([
                'rating' => $reviewedUser->getAverageRatingAttribute()
            ]);
            
            \Log::info('User rating updated', [
                'user_id' => $reviewedId,
                'new_rating' => $reviewedUser->rating
            ]);
        }

        return response()->json([
            'message' => 'Отзыв успешно оставлен',
            'review' => $review->load(['reviewer:id,name,surname', 'reviewed:id,name,surname'])
        ], 201);
    }

    /**
     * Получить отзывы пользователя
     */
    public function getUserReviews($userId): JsonResponse
    {
        $reviews = Review::where('reviewed_id', $userId)
            ->where('is_public', true)
            ->with(['reviewer:id,name,surname,avatar', 'order:id,title'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($reviews);
    }

    /**
     * Получить отзывы пользователя с разделением по типам
     */
    public function getUserReviewsByType($userId): JsonResponse
    {
        // Получаем отзывы, где пользователь является заказчиком (отзывы на него от исполнителей)
        $customerReviews = Review::where('reviewed_id', $userId)
            ->whereHas('order', function($query) use ($userId) {
                $query->where('user_id', $userId); // Заказы, где пользователь - заказчик
            })
            ->where('is_public', true)
            ->with([
                'reviewer:id,name,surname,avatar', 
                'order:id,title,work_type_id',
                'order.workType:id,name'
            ])
            ->orderBy('created_at', 'desc')
            ->get();

        // Получаем отзывы, где пользователь является исполнителем (отзывы на него от заказчиков)
        $executorReviews = Review::where('reviewed_id', $userId)
            ->whereHas('order', function($query) use ($userId) {
                $query->where('executor_id', $userId); // Заказы, где пользователь - исполнитель
            })
            ->where('is_public', true)
            ->with([
                'reviewer:id,name,surname,avatar', 
                'order:id,title,work_type_id',
                'order.workType:id,name'
            ])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'customer_reviews' => $customerReviews, // Отзывы на заказчика
            'executor_reviews' => $executorReviews, // Отзывы на исполнителя
            'total_customer_reviews' => $customerReviews->count(),
            'total_executor_reviews' => $executorReviews->count(),
            'average_customer_rating' => $customerReviews->avg('rating'),
            'average_executor_rating' => $executorReviews->avg('rating')
        ]);
    }

    /**
     * Получить отзыв к конкретному заказу
     */
    public function getOrderReview($orderId): JsonResponse
    {
        $review = Review::where('order_id', $orderId)
            ->with(['reviewer:id,name,surname,avatar'])
            ->first();

        if (!$review) {
            return response()->json(['error' => 'Отзыв не найден'], 404);
        }

        return response()->json($review);
    }
}
