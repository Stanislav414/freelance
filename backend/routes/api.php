<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PasswordResetController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Восстановление пароля
Route::post('/password/send-code', [PasswordResetController::class, 'sendResetCode']);
Route::post('/password/verify-code', [PasswordResetController::class, 'verifyCode']);
Route::post('/password/reset', [PasswordResetController::class, 'resetPassword']);
Route::post('/password/validate', [PasswordResetController::class, 'validatePassword']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // Заказы (теперь защищены)
    Route::apiResource('orders', \App\Http\Controllers\Api\OrderController::class)->only(['index', 'store', 'show']);
    Route::delete('/orders/{order}', [\App\Http\Controllers\Api\OrderController::class, 'destroy']);
    Route::get('/orders/open/all', [\App\Http\Controllers\Api\OrderController::class, 'getAllOpenOrders']);
    Route::post('/orders/{id}/take', [\App\Http\Controllers\Api\OrderController::class, 'take']);
    Route::post('/orders/{order}/assign-executor', [\App\Http\Controllers\Api\OrderController::class, 'assignExecutor']);
    Route::post('/orders/{order}/update-status', [\App\Http\Controllers\Api\OrderController::class, 'updateStatus']);
    
    // Новые маршруты для управления заказами
    Route::post('/orders/{order}/complete', [\App\Http\Controllers\Api\OrderController::class, 'completeOrder']);
    Route::post('/orders/{order}/revision', [\App\Http\Controllers\Api\OrderController::class, 'sendToRevision']);
    Route::post('/orders/{order}/cancel', [\App\Http\Controllers\Api\OrderController::class, 'cancelOrder']);
    Route::post('/orders/{order}/dispute', [\App\Http\Controllers\Api\OrderController::class, 'createDispute']);
    Route::post('/orders/{order}/finish-work', [\App\Http\Controllers\Api\OrderController::class, 'finishWork']);
    
    // Предложения исполнителям
    Route::post('/orders/{order}/send-offer', [\App\Http\Controllers\Api\OrderOfferController::class, 'sendOffer']);
    Route::post('/orders/{order}/accept-offer', [\App\Http\Controllers\Api\OrderOfferController::class, 'acceptOffer']);
    Route::post('/orders/{order}/decline-offer', [\App\Http\Controllers\Api\OrderOfferController::class, 'declineOffer']);
});

// Типы работ
Route::get('/work-types', [\App\Http\Controllers\Api\WorkTypeController::class, 'index']);
Route::get('/work-types/{id}/attributes', [\App\Http\Controllers\Api\WorkTypeController::class, 'attributes']);

// Типы характеристик заказа с их значениями
Route::get('/order-attribute-types', [\App\Http\Controllers\Api\OrderAttributeTypeController::class, 'index']);

// Портфолио исполнителей
Route::get('/users/{id}', [\App\Http\Controllers\Api\PortfolioController::class, 'getExecutor']);
Route::get('/executors/{id}/stats', [\App\Http\Controllers\Api\PortfolioController::class, 'getStats']);
Route::get('/executors/{id}/projects', [\App\Http\Controllers\Api\PortfolioController::class, 'getExecutorProjects']);
Route::get('/executors/{id}/reviews', [\App\Http\Controllers\Api\PortfolioController::class, 'getReviews']);
Route::get('/executors/{id}/given-reviews', [\App\Http\Controllers\Api\PortfolioController::class, 'getGivenReviews']);

// Портфолио заказчиков
Route::get('/customers/{id}/projects', [\App\Http\Controllers\Api\PortfolioController::class, 'getCustomerProjects']);
Route::get('/customers/{id}/stats', [\App\Http\Controllers\Api\PortfolioController::class, 'getCustomerStats']);

// Обновление профиля пользователя
Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/users/{id}/update', [\App\Http\Controllers\Api\PortfolioController::class, 'updateProfile']);
});

// Лучшие работы портфолио
Route::get('/portfolio/projects/{id}', [\App\Http\Controllers\Api\PortfolioController::class, 'getPortfolioWorks']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/projects', [\App\Http\Controllers\Api\PortfolioController::class, 'addProject']);
    
    // Управление лучшими работами портфолио
    Route::post('/portfolio/projects', [\App\Http\Controllers\Api\PortfolioController::class, 'addPortfolioWork']);
    Route::put('/portfolio/projects/{id}', [\App\Http\Controllers\Api\PortfolioController::class, 'updatePortfolioWork']);
    Route::delete('/portfolio/projects/{id}', [\App\Http\Controllers\Api\PortfolioController::class, 'deletePortfolioWork']);
});

// Новый поиск
Route::get('/search/orders', [\App\Http\Controllers\Api\NewSearchController::class, 'searchOrders']);
Route::get('/search/executors', [\App\Http\Controllers\Api\NewSearchController::class, 'searchExecutors']);
Route::get('/search/combined', [\App\Http\Controllers\Api\NewSearchController::class, 'combinedSearch']);
Route::get('/users/all', [\App\Http\Controllers\Api\NewSearchController::class, 'getAllUsers']);

// Старые маршруты (для совместимости)
Route::get('/orders/search', [\App\Http\Controllers\Api\NewSearchController::class, 'searchOrders']);
Route::get('/executors/search', [\App\Http\Controllers\Api\NewSearchController::class, 'searchExecutors']);
Route::get('/executors/by-specialization', [\App\Http\Controllers\Api\NewSearchController::class, 'searchExecutorsBySpecialization']);

Route::get('/orders/{order}/executors', [\App\Http\Controllers\Api\OrderController::class, 'getExecutorsForOrder']);

// Обновление профиля
Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/profile/update', [\App\Http\Controllers\Api\ProfileController::class, 'update']);
    Route::post('/profile/update-executor', [\App\Http\Controllers\Api\ProfileController::class, 'updateExecutor']);
    Route::post('/profile/update-customer', [\App\Http\Controllers\Api\ProfileController::class, 'updateCustomer']);
});

// Тарифы и услуги
Route::get('/tariffs', [\App\Http\Controllers\Api\TariffController::class, 'index']);
Route::get('/tariffs/work-type/{workTypeId}/services', [\App\Http\Controllers\Api\TariffController::class, 'getServicesByWorkType']);
Route::get('/tariffs/additional-options', [\App\Http\Controllers\Api\TariffController::class, 'getAdditionalOptions']);

// Чат
Route::middleware(['auth:sanctum'])->group(function () {
    Route::get('/chats', [\App\Http\Controllers\Api\ChatController::class, 'index']);
    Route::get('/chats/{chatId}/messages', [\App\Http\Controllers\Api\ChatController::class, 'messages']);
    Route::post('/chats/{chatId}/messages', [\App\Http\Controllers\Api\ChatController::class, 'sendMessage']);
    Route::post('/chats/{chatId}/read', [\App\Http\Controllers\Api\ChatController::class, 'markAsRead']);
    Route::put('/chats/{chatId}/category', [\App\Http\Controllers\Api\ChatController::class, 'changeCategory']);
    Route::post('/orders/{orderId}/create-chat', [\App\Http\Controllers\Api\ChatController::class, 'createChatForOrder']);
    Route::post('/chats/import', [\App\Http\Controllers\Api\ChatController::class, 'import']);
    
    // Отзывы
    Route::post('/reviews', [\App\Http\Controllers\Api\ReviewController::class, 'store']);
    Route::get('/reviews/user/{userId}', [\App\Http\Controllers\Api\ReviewController::class, 'getUserReviews']);
    Route::get('/reviews/order/{orderId}', [\App\Http\Controllers\Api\ReviewController::class, 'getOrderReview']);
    Route::get('/reviews/user/{userId}/by-type', [\App\Http\Controllers\Api\ReviewController::class, 'getUserReviewsByType']);
});