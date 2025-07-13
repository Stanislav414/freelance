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
        Schema::create('work_types', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // Название типа работы
            $table->text('description')->nullable(); // Описание
            $table->decimal('average_price', 10, 2)->nullable(); // Средняя цена
            $table->string('average_time')->nullable(); // Среднее время (например, '2 дня')
            $table->boolean('is_custom')->default(false); // Уникальный заказ или нет
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('work_types');
    }
};
