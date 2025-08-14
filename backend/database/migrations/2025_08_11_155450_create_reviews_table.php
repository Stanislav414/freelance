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
        Schema::create('reviews', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained('orders')->onDelete('cascade');
            $table->foreignId('reviewer_id')->constrained('users')->onDelete('cascade'); // Кто оставляет отзыв
            $table->foreignId('reviewed_id')->constrained('users')->onDelete('cascade'); // О ком отзыв
            $table->integer('rating')->comment('Оценка от 1 до 5');
            $table->text('text')->comment('Текст отзыва');
            $table->boolean('is_public')->default(true)->comment('Публичный ли отзыв');
            $table->timestamps();
            
            // Индексы для быстрого поиска
            $table->index(['reviewed_id', 'is_public']);
            $table->index(['order_id']);
            $table->unique(['order_id', 'reviewer_id']); // Один отзыв на заказ от одного пользователя
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reviews');
    }
};
