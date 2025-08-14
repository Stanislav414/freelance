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
        Schema::table('users', function (Blueprint $table) {
            // Добавляем новые поля для описаний
            $table->text('executor_description')->nullable()->after('description');
            $table->text('customer_description')->nullable()->after('executor_description');
            
            // Переименовываем старое поле description в general_description для общей информации
            $table->renameColumn('description', 'general_description');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Возвращаем старое название поля
            $table->renameColumn('general_description', 'description');
            
            // Удаляем новые поля
            $table->dropColumn(['executor_description', 'customer_description']);
        });
    }
};
