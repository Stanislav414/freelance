<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Order;
use App\Models\PortfolioWork;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use App\Models\Review; // Added this import for Review model

class PortfolioController extends Controller
{
    /**
     * Получить данные пользователя
     */
    public function getExecutor($id): JsonResponse
    {
        $user = User::findOrFail($id);
        
        $specializations = $user->specializations ? (is_string($user->specializations) ? json_decode($user->specializations, true) : $user->specializations) : [];
        
        return response()->json([
            'id' => $user->id,
            'name' => $user->name,
            'surname' => $user->surname,
            'email' => $user->email,
            'avatar' => null, // Временно отключено
            'specialization' => $user->specialization ?? 'Пользователь',
            'specializations' => $specializations,
            'executor_description' => $user->executor_description ?? '',
            'customer_description' => $user->customer_description ?? '',
            'rating' => $user->rating ?? 0,
        ]);
    }

    /**
     * Получить статистику пользователя
     */
    public function getStats($id): JsonResponse
    {
        // Добавляем отладочную информацию
        \Log::info('Getting stats for user', ['user_id' => $id]);
        
        $user = User::findOrFail($id);
        
        // Подсчитываем выполненные заказы (где пользователь исполнитель)
        $completedOrdersAsExecutor = Order::where('executor_id', $id)
            ->where('status', 'completed')
            ->count();
            
        \Log::info('Completed orders as executor', ['count' => $completedOrdersAsExecutor]);
        
        // Подсчитываем выполненные заказы (где пользователь заказчик)
        $completedOrdersAsCustomer = Order::where('user_id', $id)
            ->where('status', 'completed')
            ->count();
            
        \Log::info('Completed orders as customer', ['count' => $completedOrdersAsCustomer]);
        
        // Общее количество завершенных заказов
        $totalCompletedOrders = $completedOrdersAsExecutor + $completedOrdersAsCustomer;
        
        // Средняя цена проекта (для исполнителя)
        $avgProjectPrice = Order::where('executor_id', $id)
            ->where('status', 'completed')
            ->avg('budget');
        
        // Количество отзывов по типам
        $customerReviewsCount = $user->customer_reviews_count;
        $executorReviewsCount = $user->executor_reviews_count;
        $totalReceivedReviewsCount = $customerReviewsCount + $executorReviewsCount;
        
        // Количество отзывов (оставленных пользователем)
        $givenReviewsCount = Review::where('reviewer_id', $id)
            ->where('is_public', true)
            ->count();
            
        \Log::info('Reviews count by type', [
            'customer_reviews' => $customerReviewsCount, 
            'executor_reviews' => $executorReviewsCount,
            'total_received' => $totalReceivedReviewsCount,
            'given' => $givenReviewsCount
        ]);
        
        // Средние рейтинги по типам
        $avgCustomerRating = $user->average_customer_rating;
        $avgExecutorRating = $user->average_executor_rating;
        
        // Среднее время ответа (заглушка)
        $avgResponseTime = '2 часа'; // TODO: реализовать подсчет
        
        return response()->json([
            'completedOrders' => $totalCompletedOrders,
            'completedOrdersAsExecutor' => $completedOrdersAsExecutor,
            'completedOrdersAsCustomer' => $completedOrdersAsCustomer,
            'avgProjectPrice' => round($avgProjectPrice ?? 0),
            'customerReviewsCount' => $customerReviewsCount,
            'executorReviewsCount' => $executorReviewsCount,
            'totalReceivedReviewsCount' => $totalReceivedReviewsCount,
            'givenReviewsCount' => $givenReviewsCount,
            'avgCustomerRating' => round($avgCustomerRating, 1),
            'avgExecutorRating' => round($avgExecutorRating, 1),
            'avgResponseTime' => $avgResponseTime,
        ]);
    }

    /**
     * Получить проекты пользователя
     */
    public function getProjects($id): JsonResponse
    {
        // Добавляем отладочную информацию
        \Log::info('Getting projects for user', ['user_id' => $id]);
        
        // Получаем проекты где пользователь исполнитель
        $executorProjects = Order::where('executor_id', $id)
            ->where('status', 'completed')
            ->with(['workType', 'customerReview', 'executorReview'])
            ->orderBy('updated_at', 'desc')
            ->get();
            
        \Log::info('Executor projects found', ['count' => $executorProjects->count()]);
        
        $executorProjects = $executorProjects->map(function ($order) {
            return [
                'id' => $order->id,
                'title' => $order->title,
                'description' => $order->description,
                'price' => $order->budget,
                'image' => null, // TODO: добавить поле для изображения проекта
                'completed_at' => $order->updated_at,
                'work_type' => $order->workType->name ?? '',
                'has_review' => $order->customerReview ? true : false, // Отзыв от заказчика на исполнителя
                'role' => 'executor', // Роль пользователя в этом проекте
                'review_status' => $order->customerReview ? 'Получен отзыв от заказчика' : 'Ожидает отзыв от заказчика',
            ];
        });
        
        // Получаем проекты где пользователь заказчик
        $customerProjects = Order::where('user_id', $id)
            ->where('status', 'completed')
            ->with(['workType', 'customerReview', 'executorReview'])
            ->orderBy('updated_at', 'desc')
            ->get();
            
        \Log::info('Customer projects found', ['count' => $customerProjects->count()]);
        
        $customerProjects = $customerProjects->map(function ($order) {
            return [
                'id' => $order->id,
                'title' => $order->title,
                'description' => $order->description,
                'price' => $order->budget,
                'image' => null, // TODO: добавить поле для изображения проекта
                'completed_at' => $order->updated_at,
                'work_type' => $order->workType->name ?? '',
                'has_review' => $order->executorReview ? true : false, // Отзыв от исполнителя на заказчика
                'role' => 'customer', // Роль пользователя в этом проекте
                'review_status' => $order->executorReview ? 'Получен отзыв от исполнителя' : 'Ожидает отзыв от исполнителя',
            ];
        });
        
        // Объединяем и сортируем по дате завершения
        $allProjects = $executorProjects->concat($customerProjects)
            ->sortByDesc('completed_at')
            ->values();
            
        \Log::info('Total projects found', ['count' => $allProjects->count()]);
        
        return response()->json($allProjects);
    }

    /**
     * Получить отзывы, которые пользователь оставил другим
     */
    public function getGivenReviews($id): JsonResponse
    {
        // Добавляем отладочную информацию
        \Log::info('Getting given reviews for user', ['user_id' => $id]);
        
        // Получаем все отзывы, которые пользователь оставил (reviewer_id)
        $givenReviews = Review::where('reviewer_id', $id)
            ->where('is_public', true)
            ->with(['reviewed:id,name,surname,avatar', 'order:id,title,user_id,executor_id'])
            ->orderBy('created_at', 'desc')
            ->get();
            
        \Log::info('Given reviews found', ['count' => $givenReviews->count()]);
        
        $reviews = $givenReviews->map(function ($review) use ($id) {
            // Определяем роль пользователя в этом отзыве
            // reviewer_id = тот, кто оставил отзыв (пользователь с ID $id)
            // reviewed_id = тот, на кого оставлен отзыв
            
            // Пользователь с ID $id является тем, кто оставил отзыв (reviewer_id)
            // Нужно определить его роль в заказе этого отзыва
            $userRole = '';
            $reviewedRole = '';
            
            if ($review->order) {
                // Пользователь с ID $id является тем, кто оставил отзыв
                // Проверяем, какую роль он играл в этом заказе
                if ($review->order->user_id == $id) {
                    // Пользователь был заказчиком в этом заказе
                    $userRole = 'заказчик';
                    $reviewedRole = 'исполнитель'; // Тот, на кого оставлен отзыв
                } elseif ($review->order->executor_id == $id) {
                    // Пользователь был исполнителем в этом заказе
                    $userRole = 'исполнитель';
                    $reviewedRole = 'заказчик'; // Тот, на кого оставлен отзыв
                }
            }
            
            \Log::info('Given review role mapping', [
                'review_id' => $review->id,
                'user_id' => $id,
                'order_user_id' => $review->order->user_id ?? null,
                'order_executor_id' => $review->order->executor_id ?? null,
                'user_role' => $userRole,
                'reviewed_role' => $reviewedRole,
                'reviewer_id' => $review->reviewer_id,
                'reviewed_id' => $review->reviewed_id
            ]);
            
            return [
                'id' => $review->id,
                'reviewed_name' => $review->reviewed->name . ' ' . $review->reviewed->surname,
                'reviewed_avatar' => null, // Временно отключено
                'rating' => $review->rating,
                'text' => $review->text,
                'created_at' => $review->created_at,
                'order_title' => $review->order->title ?? 'Заказ',
                'user_role' => $userRole, // Роль пользователя в этом отзыве (тот, кто оставил)
                'reviewed_role' => $reviewedRole, // Роль того, на кого оставлен отзыв
            ];
        });
        
        \Log::info('Processed given reviews', ['count' => $reviews->count()]);
        
        return response()->json($reviews);
    }

    /**
     * Получить отзывы о пользователе
     */
    public function getReviews($id): JsonResponse
    {
        // Добавляем отладочную информацию
        \Log::info('Getting reviews for user', ['user_id' => $id]);
        
        $user = User::findOrFail($id);
        
        // Получаем отзывы по типам
        $customerReviews = $user->customerReviews()
            ->where('is_public', true)
            ->with(['reviewer:id,name,surname,avatar', 'order:id,title,user_id,executor_id'])
            ->orderBy('created_at', 'desc')
            ->get();
            
        $executorReviews = $user->executorReviews()
            ->where('is_public', true)
            ->with(['reviewer:id,name,surname,avatar', 'order:id,title,user_id,executor_id'])
            ->orderBy('created_at', 'desc')
            ->get();
            
        \Log::info('Reviews found by type', [
            'customer_reviews' => $customerReviews->count(),
            'executor_reviews' => $executorReviews->count()
        ]);
        
        // Обрабатываем отзывы заказчика
        $processedCustomerReviews = $customerReviews->map(function ($review) {
            return [
                'id' => $review->id,
                'reviewer_name' => $review->reviewer->name . ' ' . $review->reviewer->surname,
                'reviewer_avatar' => null, // Временно отключено
                'rating' => $review->rating,
                'text' => $review->text,
                'created_at' => $review->created_at,
                'order_title' => $review->order->title ?? 'Заказ',
                'user_role' => 'заказчик', // Роль пользователя в этом отзыве
                'reviewer_role' => 'исполнитель', // Роль того, кто оставил отзыв
                'review_type' => 'customer' // Тип отзыва
            ];
        });
        
        // Обрабатываем отзывы исполнителя
        $processedExecutorReviews = $executorReviews->map(function ($review) {
            return [
                'id' => $review->id,
                'reviewer_name' => $review->reviewer->name . ' ' . $review->reviewer->surname,
                'reviewer_avatar' => null, // Временно отключено
                'rating' => $review->rating,
                'text' => $review->text,
                'created_at' => $review->created_at,
                'order_title' => $review->order->title ?? 'Заказ',
                'user_role' => 'исполнитель', // Роль пользователя в этом отзыве
                'reviewer_role' => 'заказчик', // Роль того, кто оставил отзыв
                'review_type' => 'executor' // Тип отзыва
            ];
        });
        
        // Объединяем отзывы с сортировкой по дате
        $allReviews = $processedCustomerReviews->concat($processedExecutorReviews)
            ->sortByDesc('created_at')
            ->values();
            
        return response()->json([
            'reviews' => $allReviews,
            'customer_reviews' => $processedCustomerReviews,
            'executor_reviews' => $processedExecutorReviews,
            'total_customer_reviews' => $processedCustomerReviews->count(),
            'total_executor_reviews' => $processedExecutorReviews->count(),
            'total_reviews' => $allReviews->count()
        ]);
    }

    /**
     * Добавить проект в портфолио
     */
    public function addProject(Request $request): JsonResponse
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|numeric|min:0',
            'image' => 'nullable|image|max:2048',
        ]);

        $user = $request->user();
        
        // Создаем новый заказ как "выполненный проект"
        $project = Order::create([
            'user_id' => $user->id,
            'executor_id' => $user->id, // Пользователь = создатель
            'title' => $request->title,
            'description' => $request->description,
            'budget' => $request->price,
            'status' => 'completed', // Сразу помечаем как выполненный
            'work_type_id' => 1, // TODO: добавить выбор типа работы
        ]);

        // Обработка изображения
        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('projects', 'public');
            // TODO: сохранить путь к изображению в базе данных
        }

        return response()->json([
            'message' => 'Проект успешно добавлен в портфолио',
            'project' => $project,
        ], 201);
    }

    /**
     * Обновить профиль пользователя
     */
    public function updateProfile(Request $request, $id): JsonResponse
    {
        try {
            // Проверяем, что пользователь обновляет свой профиль
            $currentUser = $request->user();
            
            // Логируем информацию об аутентификации
            \Log::info('Authentication check', [
                'user_id' => $id,
                'current_user_id' => $currentUser ? $currentUser->id : 'null',
                'current_user' => $currentUser ? $currentUser->toArray() : 'null',
                'has_user' => $currentUser ? 'yes' : 'no'
            ]);
            
            if (!$currentUser) {
                \Log::error('User not authenticated');
                return response()->json(['message' => 'Пользователь не аутентифицирован'], 401);
            }
            
            if ($currentUser->id != $id) {
                \Log::error('Insufficient permissions', [
                    'current_user_id' => $currentUser->id,
                    'requested_user_id' => $id
                ]);
                return response()->json(['message' => 'Недостаточно прав для обновления профиля'], 403);
            }

            // Логируем входящие данные для отладки
            \Log::info('Profile update request', [
                'user_id' => $id,
                'request_data' => $request->all(),
                'request_content_type' => $request->header('Content-Type'),
                'request_method' => $request->method(),
                'actual_method' => $request->input('_method', $request->method()),
                'has_avatar' => $request->hasFile('avatar'),
                'avatar_size' => $request->hasFile('avatar') ? $request->file('avatar')->getSize() : null,
                'all_input' => $request->input(),
                'all_post' => $request->post(),
                'all_get' => $request->query(),
                'request_all_count' => count($request->all()),
                'request_input_count' => count($request->input()),
                'request_post_count' => count($request->post()),
                'form_data_keys' => array_keys($request->all()),
                'authorization_header' => $request->header('Authorization'),
                'all_headers' => $request->headers->all()
            ]);

            // Проверяем, есть ли данные в запросе (улучшенная проверка для FormData)
            $hasData = !empty($request->all()) || !empty($request->input()) || !empty($request->post()) || $request->hasFile('avatar');
            
            // Дополнительная проверка для FormData
            if (!$hasData && $request->header('Content-Type') && strpos($request->header('Content-Type'), 'multipart/form-data') !== false) {
                // Для FormData пробуем прочитать данные по-другому
                $formData = $request->getContent();
                $hasData = !empty($formData) && strlen($formData) > 0;
                
                \Log::info('FormData fallback check', [
                    'form_data_content' => $formData,
                    'form_data_length' => strlen($formData),
                    'has_data_fallback' => $hasData
                ]);
            }
            
            if (!$hasData) {
                \Log::error('No data received in request', [
                    'user_id' => $id,
                    'headers' => $request->headers->all(),
                    'request_all' => $request->all(),
                    'request_input' => $request->input(),
                    'request_post' => $request->post(),
                    'has_avatar' => $request->hasFile('avatar')
                ]);
                
                return response()->json([
                    'message' => 'Данные не получены',
                    'debug' => [
                        'content_type' => $request->header('Content-Type'),
                        'method' => $request->method(),
                        'has_data' => $hasData,
                        'request_all_count' => count($request->all()),
                        'request_input_count' => count($request->input()),
                        'request_post_count' => count($request->post())
                    ]
                ], 422);
            }

            // Логируем данные перед валидацией
            \Log::info('Data before validation', [
                'user_id' => $id,
                'name' => $request->input('name'),
                'surname' => $request->input('surname'),
                'executor_description' => $request->input('executor_description'),
                'customer_description' => $request->input('customer_description'),
                'has_avatar' => $request->hasFile('avatar'),
                'all_input_data' => $request->input(),
                'all_post_data' => $request->post(),
                'all_request_data' => $request->all()
            ]);

            $request->validate([
                'name' => 'required|string|max:255',
                'surname' => 'required|string|max:255',
                'executor_description' => 'nullable|string|max:1000',
                'customer_description' => 'nullable|string|max:1000',
                'avatar' => 'nullable|image|max:5120', // Максимум 5MB
            ]);

            $user = User::findOrFail($id);

            // Обновляем основные данные
            $user->name = $request->name;
            $user->surname = $request->surname;
            $user->executor_description = $request->executor_description;
            $user->customer_description = $request->customer_description;

            // Обработка аватара
            if ($request->hasFile('avatar')) {
                // Удаляем старый аватар, если он существует
                if ($user->avatar && file_exists(public_path('storage/' . $user->avatar))) {
                    unlink(public_path('storage/' . $user->avatar));
                }

                // Сохраняем новый аватар
                $avatarPath = $request->file('avatar')->store('avatars', 'public');
                $user->avatar = $avatarPath;
            }

            $user->save();

            \Log::info('Profile updated successfully', [
                'user_id' => $id,
                'executor_description' => $user->executor_description,
                'customer_description' => $user->customer_description
            ]);

            return response()->json([
                'message' => 'Профиль успешно обновлен',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'surname' => $user->surname,
                    'email' => $user->email,
                    'avatar' => null, // Временно отключено
                    'executor_description' => $user->executor_description,
                    'customer_description' => $user->customer_description,
                ]
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            \Log::error('Profile update validation failed', [
                'user_id' => $id,
                'errors' => $e->errors(),
                'request_data' => $request->all()
            ]);
            
            return response()->json([
                'message' => 'Ошибка валидации',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            \Log::error('Profile update failed', [
                'user_id' => $id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return response()->json([
                'message' => 'Произошла ошибка при обновлении профиля',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Получить проекты заказчика (где пользователь был заказчиком)
     */
    public function getCustomerProjects($id): JsonResponse
    {
        \Log::info('Getting customer projects for user', ['user_id' => $id]);
        
        // Получаем только проекты где пользователь заказчик
        $customerProjects = Order::where('user_id', $id)
            ->where('status', 'completed')
            ->with(['workType', 'customerReview', 'executorReview'])
            ->orderBy('updated_at', 'desc')
            ->get();
            
        \Log::info('Customer projects found', ['count' => $customerProjects->count()]);
        
        $projects = $customerProjects->map(function ($order) {
            return [
                'id' => $order->id,
                'title' => $order->title,
                'description' => $order->description,
                'price' => $order->budget,
                'image' => null, // TODO: добавить поле для изображения проекта
                'completed_at' => $order->updated_at,
                'work_type' => $order->workType->name ?? '',
                'has_review' => $order->executorReview ? true : false, // Отзыв от исполнителя на заказчика
                'role' => 'customer', // Роль пользователя в этом проекте
                'review_status' => $order->executorReview ? 'Получен отзыв от исполнителя' : 'Ожидает отзыв от исполнителя',
            ];
        });
        
        return response()->json($projects);
    }

    /**
     * Получить проекты исполнителя (где пользователь был исполнителем)
     */
    public function getExecutorProjects($id): JsonResponse
    {
        \Log::info('Getting executor projects for user', ['user_id' => $id]);
        
        // Получаем только проекты где пользователь исполнитель
        $executorProjects = Order::where('executor_id', $id)
            ->where('status', 'completed')
            ->with(['workType', 'customerReview', 'executorReview'])
            ->orderBy('updated_at', 'desc')
            ->get();
            
        \Log::info('Executor projects found', ['count' => $executorProjects->count()]);
        
        $projects = $executorProjects->map(function ($order) {
            return [
                'id' => $order->id,
                'title' => $order->title,
                'description' => $order->description,
                'price' => $order->budget,
                'image' => null, // TODO: добавить поле для изображения проекта
                'completed_at' => $order->updated_at,
                'work_type' => $order->workType->name ?? '',
                'has_review' => $order->customerReview ? true : false, // Отзыв от заказчика на исполнителя
                'role' => 'executor', // Роль пользователя в этом проекте
                'review_status' => $order->customerReview ? 'Получен отзыв от заказчика' : 'Ожидает отзыв от заказчика',
            ];
        });
        
        return response()->json($projects);
    }

    /**
     * Получить статистику заказчика
     */
    public function getCustomerStats($id): JsonResponse
    {
        \Log::info('Getting customer stats for user', ['user_id' => $id]);
        
        $user = User::findOrFail($id);
        
        // Подсчитываем выполненные заказы (где пользователь заказчик)
        $completedOrdersAsCustomer = Order::where('user_id', $id)
            ->where('status', 'completed')
            ->count();
            
        // Средняя цена заказа (где пользователь заказчик)
        $avgProjectPrice = Order::where('user_id', $id)
            ->where('status', 'completed')
            ->avg('budget');
            
        // Количество отзывов на заказчика
        $customerReviewsCount = $user->customer_reviews_count;
        
        // Количество отзывов, оставленных заказчиком
        $givenReviewsCount = Review::where('reviewer_id', $id)
            ->where('is_public', true)
            ->count();
        
        return response()->json([
            'completedOrders' => $completedOrdersAsCustomer,
            'avgProjectPrice' => round($avgProjectPrice ?? 0),
            'receivedReviewsCount' => $customerReviewsCount,
            'givenReviewsCount' => $givenReviewsCount,
        ]);
    }

    /**
     * Получить лучшие работы пользователя
     */
    public function getPortfolioWorks($id): JsonResponse
    {
        Log::info('Getting portfolio works for user', ['user_id' => $id]);
        
        $works = PortfolioWork::forUser($id)
            ->ordered()
            ->get();
            
        Log::info('Portfolio works found', ['count' => $works->count()]);
        
        $portfolioWorks = $works->map(function ($work) {
            return [
                'id' => $work->id,
                'title' => $work->title,
                'description' => $work->description,
                'specialization' => $work->specialization,
                'specialization_name' => $work->specialization_name,
                'url' => $work->url,
                'image' => $work->image_url,
                'is_featured' => $work->is_featured,
                'sort_order' => $work->sort_order,
                'created_at' => $work->created_at,
                'updated_at' => $work->updated_at,
            ];
        });
        
        return response()->json($portfolioWorks);
    }

    /**
     * Добавить работу в портфолио
     */
    public function addPortfolioWork(Request $request): JsonResponse
    {
        try {
            Log::info('Adding portfolio work', [
                'user_id' => $request->user()->id,
                'request_data' => $request->all()
            ]);

            $request->validate([
                'title' => 'required|string|max:255',
                'description' => 'required|string|max:2000',
                'specialization' => 'required|string|max:100',
                'url' => 'nullable|string|max:500|regex:/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/',
            ], [
                'url.regex' => 'Пожалуйста, введите корректную ссылку (например: https://behance.net/mywork)',
                'title.required' => 'Название проекта обязательно для заполнения',
                'description.required' => 'Описание проекта обязательно для заполнения',
                'specialization.required' => 'Выберите тип работы',
            ]);

            $user = $request->user();
            
            // Проверяем лимит работ (максимум 20 работ)
            $existingWorksCount = PortfolioWork::forUser($user->id)->count();
            if ($existingWorksCount >= 20) {
                return response()->json([
                    'message' => 'Достигнут максимальный лимит работ в портфолио (20 работ)',
                ], 422);
            }

            // Обработка URL - добавляем https:// если протокол не указан
            $url = $request->url;
            if ($url && !preg_match('/^https?:\/\//', $url)) {
                $url = 'https://' . $url;
            }

            $portfolioWork = new PortfolioWork([
                'user_id' => $user->id,
                'title' => $request->title,
                'description' => $request->description,
                'specialization' => $request->specialization,
                'url' => $url,
                'sort_order' => $existingWorksCount + 1, // Ставим в конец
            ]);



            $portfolioWork->save();

            Log::info('Portfolio work created successfully', ['work_id' => $portfolioWork->id]);

            return response()->json([
                'message' => 'Работа успешно добавлена в портфолио',
                'work' => [
                    'id' => $portfolioWork->id,
                    'title' => $portfolioWork->title,
                    'description' => $portfolioWork->description,
                    'specialization' => $portfolioWork->specialization,
                    'specialization_name' => $portfolioWork->specialization_name,
                    'url' => $portfolioWork->url,
                    'image' => $portfolioWork->image_url,
                    'is_featured' => $portfolioWork->is_featured,
                    'sort_order' => $portfolioWork->sort_order,
                    'created_at' => $portfolioWork->created_at,
                ],
            ], 201);

        } catch (\Illuminate\Validation\ValidationException $e) {
            Log::error('Portfolio work validation failed', [
                'errors' => $e->errors(),
                'request_data' => $request->all()
            ]);
            
            return response()->json([
                'message' => 'Ошибка валидации',
                'errors' => $e->errors()
            ], 422);

        } catch (\Exception $e) {
            Log::error('Portfolio work creation failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return response()->json([
                'message' => 'Произошла ошибка при добавлении работы',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Обновить работу в портфолио
     */
    public function updatePortfolioWork(Request $request, $id): JsonResponse
    {
        try {
            $user = $request->user();
            $work = PortfolioWork::where('id', $id)
                ->where('user_id', $user->id)
                ->firstOrFail();

            $request->validate([
                'title' => 'required|string|max:255',
                'description' => 'required|string|max:2000',
                'specialization' => 'required|string|max:100',
                'url' => 'nullable|string|max:500|regex:/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/',
            ]);

            $work->title = $request->title;
            $work->description = $request->description;
            $work->specialization = $request->specialization;
            $work->url = $request->url;



            $work->save();

            return response()->json([
                'message' => 'Работа успешно обновлена',
                'work' => [
                    'id' => $work->id,
                    'title' => $work->title,
                    'description' => $work->description,
                    'specialization' => $work->specialization,
                    'specialization_name' => $work->specialization_name,
                    'url' => $work->url,
                    'image' => $work->image_url,
                    'is_featured' => $work->is_featured,
                    'sort_order' => $work->sort_order,
                    'updated_at' => $work->updated_at,
                ],
            ]);

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Работа не найдена'
            ], 404);

        } catch (\Exception $e) {
            Log::error('Portfolio work update failed', [
                'work_id' => $id,
                'error' => $e->getMessage()
            ]);
            
            return response()->json([
                'message' => 'Произошла ошибка при обновлении работы'
            ], 500);
        }
    }

    /**
     * Удалить работу из портфолио
     */
    public function deletePortfolioWork(Request $request, $id): JsonResponse
    {
        try {
            $user = $request->user();
            $work = PortfolioWork::where('id', $id)
                ->where('user_id', $user->id)
                ->firstOrFail();



            $work->delete();

            return response()->json([
                'message' => 'Работа успешно удалена из портфолио'
            ]);

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Работа не найдена'
            ], 404);

        } catch (\Exception $e) {
            Log::error('Portfolio work deletion failed', [
                'work_id' => $id,
                'error' => $e->getMessage()
            ]);
            
            return response()->json([
                'message' => 'Произошла ошибка при удалении работы'
            ], 500);
        }
    }
} 