<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('messages', function (Blueprint $table) {
            $table->index(['chat_id', 'created_at'], 'messages_chat_created_idx');
            $table->index(['chat_id', 'user_id'], 'messages_chat_user_idx');
            $table->index(['chat_id', 'read_at'], 'messages_chat_read_idx');
        });

        Schema::table('chats', function (Blueprint $table) {
            $table->index(['order_id'], 'chats_order_idx');
            $table->index(['category'], 'chats_category_idx');
            $table->index(['updated_at'], 'chats_updated_idx');
        });

        Schema::table('chat_participants', function (Blueprint $table) {
            $table->index(['chat_id'], 'chat_participants_chat_idx');
            $table->index(['user_id'], 'chat_participants_user_idx');
            $table->index(['chat_id', 'last_read_at'], 'chat_participants_read_idx');
        });
    }

    public function down(): void
    {
        Schema::table('messages', function (Blueprint $table) {
            $table->dropIndex('messages_chat_created_idx');
            $table->dropIndex('messages_chat_user_idx');
            $table->dropIndex('messages_chat_read_idx');
        });

        Schema::table('chats', function (Blueprint $table) {
            $table->dropIndex('chats_order_idx');
            $table->dropIndex('chats_category_idx');
            $table->dropIndex('chats_updated_idx');
        });

        Schema::table('chat_participants', function (Blueprint $table) {
            $table->dropIndex('chat_participants_chat_idx');
            $table->dropIndex('chat_participants_user_idx');
            $table->dropIndex('chat_participants_read_idx');
        });
    }
};


