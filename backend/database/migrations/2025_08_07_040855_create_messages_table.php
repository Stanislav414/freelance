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
        Schema::create('messages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chat_id')->constrained('chats')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->text('content'); // Текст сообщения
            $table->enum('type', ['text', 'system'])->default('text'); // Тип сообщения
            $table->enum('status', ['sent', 'delivered', 'read'])->default('sent'); // Статус сообщения
            $table->timestamp('read_at')->nullable(); // Время прочтения
            $table->boolean('is_deleted')->default(false); // Удалено ли сообщение
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('messages');
    }
};
