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
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // Заказчик
            $table->unsignedBigInteger('work_type_id')->nullable(); // Тип работы
            $table->string('title'); // Название заказа
            $table->text('description')->nullable(); // Описание заказа
            $table->decimal('budget', 10, 2)->nullable(); // Бюджет
            $table->date('deadline')->nullable(); // Срок выполнения
            $table->string('status')->default('open'); // Статус заказа
            $table->unsignedBigInteger('executor_id')->nullable(); // Исполнитель
            $table->foreign('executor_id')->references('id')->on('users')->onDelete('set null');
            $table->timestamps();
            
            // Add foreign key constraint separately
            $table->foreign('work_type_id')->references('id')->on('work_types')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
