<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Log;

class NewSearchController extends Controller
{
    /**
     * Поиск заказов
     */
    public function searchOrders(Request $request): JsonResponse
    {
        try {
            Log::info('NewSearchController::searchOrders called');
            
            $query = trim($request->get('q', ''));
            Log::info('Search query: ' . $query);
            
            // Если запрос слишком короткий
            if (strlen($query) < 2) {
                Log::info('Query too short, returning empty array');
                return response()->json([]);
            }
            
            // Ищем реальные заказы только со статусом 'open'
            $orders = Order::where('status', '=', 'open')
                ->where(function($q) use ($query) {
                    $q->where('title', 'LIKE', "%{$query}%")
                      ->orWhere('description', 'LIKE', "%{$query}%");
                })
                ->with(['workType:id,name', 'user:id,name,surname'])
                ->orderBy('created_at', 'desc')
                ->limit(10)
                ->get();
            
            Log::info('Found real open orders: ' . $orders->count());
            
            // Форматируем результаты
            $result = $orders->map(function ($order) {
                return [
                    'id' => $order->id,
                    'title' => $order->title ?? 'Без названия',
                    'description' => $order->description ?? 'Описание отсутствует',
                    'budget' => $order->budget ?? 0,
                    'deadline' => $order->deadline ?? null,
                    'work_type' => $order->workType?->name ?? 'Не указан',
                    'status' => $order->status,
                    'user' => [
                        'name' => $order->user?->name ?? '',
                        'surname' => $order->user?->surname ?? '',
                    ],
                    'created_at' => $order->created_at?->format('Y-m-d H:i:s'),
                ];
            });
            
            // Возвращаем только реальные результаты, без тестовых данных
            
            return response()->json($result);
            
        } catch (\Exception $e) {
            Log::error('Error in searchOrders: ' . $e->getMessage());
            Log::error('Stack trace: ' . $e->getTraceAsString());
            return response()->json(['error' => 'Search failed'], 500);
        }
    }
    
    /**
     * Поиск исполнителей
     */
    public function searchExecutors(Request $request): JsonResponse
    {
        try {
            Log::info('NewSearchController::searchExecutors called');
            
            $query = trim($request->get('q', ''));
            Log::info('Search query: ' . $query);
            
            // Если запрос слишком короткий
            if (strlen($query) < 2) {
                Log::info('Query too short, returning empty array');
                return response()->json([]);
            }
            
            // Ищем реальных пользователей в БД
            $users = User::where(function($q) use ($query) {
                    $q->where('name', 'LIKE', "%{$query}%")
                      ->orWhere('surname', 'LIKE', "%{$query}%")
                      ->orWhere('executor_description', 'LIKE', "%{$query}%");
                })
                ->whereNotNull('name')
                ->select('id', 'name', 'surname', 'avatar', 'specialization', 'specializations', 'executor_description', 'rating')
                ->orderBy('id')
                ->limit(10)
                ->get();
            
            Log::info('Found real users: ' . $users->count());
            
            // Форматируем результаты
            $result = $users->map(function ($user) {
                // Подсчитываем количество выполненных заказов для этого исполнителя
                $completedOrders = Order::where('executor_id', $user->id)
                    ->where('status', 'completed')
                    ->count();
                
                return [
                    'id' => $user->id,
                    'name' => $user->name ?? 'Без имени',
                    'surname' => $user->surname ?? '',
                    'avatar' => null, // Временно отключено
                    'specialization' => $user->specialization ?? 'Не указана',
                    'specializations' => $user->specializations ? (is_string($user->specializations) ? json_decode($user->specializations, true) : $user->specializations) : [],
                    'description' => $user->executor_description ?? 'Описание отсутствует',
                    'rating' => $user->rating ?? 0,
                    'completed_orders' => $completedOrders,
                ];
            });
            
            Log::info('Formatted ' . $result->count() . ' executor results');
            return response()->json($result);
            
        } catch (\Exception $e) {
            Log::error('Error in searchExecutors: ' . $e->getMessage());
            Log::error('Stack trace: ' . $e->getTraceAsString());
            return response()->json(['error' => 'Search failed'], 500);
        }
    }
    
    /**
     * Получить всех пользователей для поиска
     */
    public function getAllUsers(Request $request): JsonResponse
    {
        try {
            Log::info('NewSearchController::getAllUsers called');
            
            // Получаем всех пользователей с именами
            $users = User::whereNotNull('name')
                ->select('id', 'name', 'surname', 'avatar', 'specialization', 'specializations', 'executor_description', 'rating')
                ->orderBy('name')
                ->limit(100) // Ограничиваем для производительности
                ->get();
            
            Log::info('Found users: ' . $users->count());
            
            // Форматируем результаты
            $result = $users->map(function ($user) {
                // Подсчитываем количество выполненных заказов для этого исполнителя
                $completedOrders = Order::where('executor_id', $user->id)
                    ->where('status', 'completed')
                    ->count();
                
                return [
                    'id' => $user->id,
                    'name' => $user->name ?? 'Без имени',
                    'surname' => $user->surname ?? '',
                    'avatar' => null, // Временно отключено
                    'specialization' => $user->specialization ?? 'Не указана',
                    'specializations' => $user->specializations ? (is_string($user->specializations) ? json_decode($user->specializations, true) : $user->specializations) : [],
                    'description' => $user->executor_description ?? 'Описание отсутствует',
                    'rating' => $user->rating ?? 0,
                    'completed_orders' => $completedOrders,
                ];
            });
            
            // Фильтрация по специализации заказа (если передана)
            $specialization = $request->get('specialization');
            if ($specialization) {
                $allowed = ['mp_card_design', 'business_card_design', 'video'];
                if (!in_array($specialization, $allowed)) {
                    $specialization = null; // защита от неожиданных значений
                }
            }

            if ($specialization) {
                $result = $result->filter(function ($u) use ($specialization) {
                    $specs = $u['specializations'] ?? [];
                    return is_array($specs) && in_array($specialization, $specs);
                })->values();
            }

            return response()->json($result);
            
        } catch (\Exception $e) {
            Log::error('Error in getAllUsers: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to get users'], 500);
        }
    }

    /**
     * Комбинированный поиск (заказы + исполнители)
     */
    public function combinedSearch(Request $request): JsonResponse
    {
        try {
            Log::info('NewSearchController::combinedSearch called');
            
            $query = trim($request->get('q', ''));
            Log::info('Combined search query: ' . $query);
            
            if (strlen($query) < 2) {
                return response()->json([
                    'orders' => [],
                    'executors' => []
                ]);
            }
            
            // Параллельный поиск заказов и исполнителей
            $ordersResponse = $this->searchOrders($request);
            $executorsResponse = $this->searchExecutors($request);
            
            $ordersData = json_decode($ordersResponse->getContent(), true);
            $executorsData = json_decode($executorsResponse->getContent(), true);
            
            // Если указан work_type_name или specialization, фильтруем исполнителей под заказ
            $workTypeName = $request->get('work_type_name');
            $specialization = $request->get('specialization');
            if (!$specialization && $workTypeName) {
                $map = [
                    'Дизайн карточки для МП' => 'mp_card_design',
                    'Дизайн визитки' => 'business_card_design',
                    'Видео' => 'video',
                    'Видео до 30 секунд' => 'video',
                ];
                $specialization = $map[$workTypeName] ?? null;
            }
            if ($specialization) {
                $executorsData = array_values(array_filter($executorsData, function ($u) use ($specialization) {
                    $specs = $u['specializations'] ?? [];
                    return is_array($specs) && in_array($specialization, $specs);
                }));
            }

            return response()->json([
                'orders' => $ordersData,
                'executors' => $executorsData
            ]);
            
        } catch (\Exception $e) {
            Log::error('Error in combinedSearch: ' . $e->getMessage());
            return response()->json([
                'orders' => [],
                'executors' => [],
                'error' => 'Search failed'
            ], 500);
        }
    }

    /**
     * Получить исполнителей по специализации
     */
    public function searchExecutorsBySpecialization(Request $request): JsonResponse
    {
        try {
            $specialization = $request->get('specialization');
            if (!$specialization) {
                return response()->json([]);
            }

            // Разрешенные специализации, которые поддерживаются на платформе
            $allowed = ['mp_card_design', 'business_card_design', 'video'];
            if (!in_array($specialization, $allowed)) {
                return response()->json([]);
            }

            // Получаем пользователей и фильтруем по специализации на PHP уровне для совместимости,
            // так как поле может храниться в формате JSON-строки
            $users = User::whereNotNull('name')
                ->select('id', 'name', 'surname', 'avatar', 'specializations', 'executor_description', 'rating')
                ->orderBy('id')
                ->limit(100)
                ->get();

            $result = $users->map(function ($user) {
                // Подсчитываем количество выполненных заказов для этого исполнителя
                $completedOrders = Order::where('executor_id', $user->id)
                    ->where('status', 'completed')
                    ->count();
                
                // Также проверим все заказы этого пользователя как исполнителя
                $allOrdersAsExecutor = Order::where('executor_id', $user->id)->count();
                $allCompletedOrders = Order::where('status', 'completed')->count();
                
                Log::info("User {$user->id} ({$user->name}): completed_orders = {$completedOrders}");
                
                return [
                    'id' => $user->id,
                    'name' => $user->name ?? 'Без имени',
                    'surname' => $user->surname ?? '',
                    'avatar' => null,
                    'specializations' => $user->specializations ? (is_string($user->specializations) ? json_decode($user->specializations, true) : $user->specializations) : [],
                    'description' => $user->executor_description ?? 'Описание отсутствует',
                    'rating' => $user->rating ?? 0,
                    'completed_orders' => $completedOrders,
                ];
            })->filter(function ($u) use ($specialization) {
                $specs = $u['specializations'] ?? [];
                return is_array($specs) && in_array($specialization, $specs);
            })->values();

            return response()->json($result);
        } catch (\Exception $e) {
            Log::error('Error in searchExecutorsBySpecialization: ' . $e->getMessage());
            return response()->json([], 500);
        }
    }
}
