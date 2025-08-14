<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\Chat;
use App\Models\Order;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Перемещаем чаты завершенных заказов в архив
        $completedOrders = Order::where('status', 'completed')->pluck('id');
        
        Chat::whereIn('order_id', $completedOrders)
            ->update(['category' => 'archive']);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Возвращаем чаты завершенных заказов в активные
        $completedOrders = Order::where('status', 'completed')->pluck('id');
        
        Chat::whereIn('order_id', $completedOrders)
            ->update(['category' => 'active']);
    }
};
