<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ProfileController extends Controller
{
    /**
     * Обновить профиль пользователя
     */
    public function update(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'nullable|string|max:255',
            'surname' => 'nullable|string|max:255',
            'specializations' => 'nullable|array',
            'specializations.*' => 'string|max:255|in:video,color_correction,motion_design,video_editing,graphic_design,logo_design,branding,presentation,advertising,social_media,mp_card_design,business_card_design',
            'executor_description' => 'nullable|string|max:1000',
            'customer_description' => 'nullable|string|max:1000',
            'avatar' => 'nullable|string',
        ]);

        $user = $request->user();
        
        // Обновляем только переданные поля, чтобы не перезаписывать другие
        if ($request->has('name')) {
            $user->name = $request->name;
        }
        if ($request->has('surname')) {
            $user->surname = $request->surname;
        }
        if ($request->has('specializations')) {
            $user->specializations = $request->specializations;
        }
        if ($request->has('executor_description')) {
            $user->executor_description = $request->executor_description;
        }
        if ($request->has('customer_description')) {
            $user->customer_description = $request->customer_description;
        }
        if ($request->has('avatar')) {
            $user->avatar = $request->avatar;
        }
        
        $user->save();
        
        // Логируем обновление для отладки
        \Log::info('Profile updated via ProfileController', [
            'user_id' => $user->id,
            'request_data' => $request->all(),
            'before_update' => [
                'executor_description' => $user->getOriginal('executor_description'),
                'customer_description' => $user->getOriginal('customer_description'),
                'specializations' => $user->getOriginal('specializations')
            ],
            'after_update' => [
                'executor_description' => $user->executor_description,
                'customer_description' => $user->customer_description,
                'specializations' => $user->specializations
            ]
        ]);

        // Получаем обновленные данные пользователя
        $updatedUser = $user->fresh();
        
        // Добавляем информацию о роли для фронтенда
        $updatedUser->current_role = $request->header('X-User-Role') ?? 'customer';

        return response()->json([
            'message' => 'Профиль успешно обновлен',
            'user' => $updatedUser,
        ]);
    }
    
    /**
     * Обновить профиль исполнителя
     */
    public function updateExecutor(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'nullable|string|max:255',
            'surname' => 'nullable|string|max:255',
            'specializations' => 'nullable|array',
            'specializations.*' => 'string|max:255|in:video,color_correction,motion_design,video_editing,graphic_design,logo_design,branding,presentation,advertising,social_media,mp_card_design,business_card_design',
            'executor_description' => 'nullable|string|max:1000',
            'avatar' => 'nullable|string',
        ]);

        $user = $request->user();
        
        // Обновляем только переданные поля исполнителя
        if ($request->has('name')) {
            $user->name = $request->name;
        }
        if ($request->has('surname')) {
            $user->surname = $request->surname;
        }
        if ($request->has('specializations')) {
            $user->specializations = $request->specializations;
        }
        if ($request->has('executor_description')) {
            $user->executor_description = $request->executor_description;
        }
        if ($request->has('avatar')) {
            $user->avatar = $request->avatar;
        }
        
        $user->save();
        
        \Log::info('Executor profile updated', [
            'user_id' => $user->id,
            'updated_fields' => $request->all()
        ]);

        return response()->json([
            'message' => 'Профиль исполнителя успешно обновлен',
            'user' => $user->fresh(),
        ]);
    }
    
    /**
     * Обновить профиль заказчика
     */
    public function updateCustomer(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'nullable|string|max:255',
            'surname' => 'nullable|string|max:255',
            'customer_description' => 'nullable|string|max:1000',
            'avatar' => 'nullable|string',
        ]);

        $user = $request->user();
        
        // Обновляем только переданные поля заказчика
        if ($request->has('name')) {
            $user->name = $request->name;
        }
        if ($request->has('surname')) {
            $user->surname = $request->surname;
        }
        if ($request->has('customer_description')) {
            $user->customer_description = $request->customer_description;
        }
        if ($request->has('avatar')) {
            $user->avatar = $request->avatar;
        }
        
        $user->save();
        
        \Log::info('Customer profile updated', [
            'user_id' => $user->id,
            'updated_fields' => $request->all()
        ]);

        return response()->json([
            'message' => 'Профиль заказчика успешно обновлен',
            'user' => $user->fresh(),
        ]);
    }
} 