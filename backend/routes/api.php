<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // Заказы (теперь защищены)
    Route::apiResource('orders', \App\Http\Controllers\Api\OrderController::class)->only(['index', 'store', 'show']);
    Route::post('/orders/{id}/take', [\App\Http\Controllers\Api\OrderController::class, 'take']);
});

// Типы работ
Route::get('/work-types', [\App\Http\Controllers\Api\WorkTypeController::class, 'index']);
Route::get('/work-types/{id}/attributes', [\App\Http\Controllers\Api\WorkTypeController::class, 'attributes']);

// Типы характеристик заказа с их значениями
Route::get('/order-attribute-types', [\App\Http\Controllers\Api\OrderAttributeTypeController::class, 'index']);