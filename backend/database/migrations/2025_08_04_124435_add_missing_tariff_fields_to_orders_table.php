<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->unsignedBigInteger('selected_tariff_id')->nullable(); // Выбранный тариф
            $table->json('selected_services')->nullable(); // Массив выбранных услуг с их ценами
            $table->json('selected_options')->nullable(); // Массив выбранных дополнительных опций
            $table->decimal('calculated_price', 10, 2)->nullable(); // Рассчитанная цена на основе тарифов
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['selected_services', 'selected_options', 'calculated_price']);
            // Проверяем, существует ли поле selected_tariff_id перед его удалением
            if (Schema::hasColumn('orders', 'selected_tariff_id')) {
                $table->dropColumn('selected_tariff_id');
            }
        });
    }
};
