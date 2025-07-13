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
        Schema::create('order_attribute_types', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // Техническое имя характеристики (например, 'category')
            $table->string('label'); // Отображаемое название (например, 'Категория')
            $table->integer('sort_order')->default(0); // Порядок сортировки
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('order_attribute_types');
    }
};
