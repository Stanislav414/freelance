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
        Schema::create('portfolio_works', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // Исполнитель
            $table->string('title'); // Название проекта
            $table->text('description'); // Описание проекта
            $table->string('specialization'); // Тип работы (video, graphic_design, etc.)
            $table->string('url')->nullable(); // Ссылка на работу (Behance, Dribbble, etc.)
            $table->string('image')->nullable(); // Путь к изображению
            $table->boolean('is_featured')->default(false); // Рекомендуемая работа
            $table->integer('sort_order')->default(0); // Порядок сортировки
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('portfolio_works');
    }
};