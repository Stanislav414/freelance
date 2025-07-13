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
        Schema::create('order_attribute_values', function (Blueprint $table) {
            $table->id();
            $table->foreignId('attribute_type_id')->constrained('order_attribute_types')->onDelete('cascade'); // Связь с типом характеристики
            $table->string('value'); // Техническое значение
            $table->string('label'); // Отображаемое значение
            $table->integer('sort_order')->default(0); // Порядок сортировки
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('order_attribute_values');
    }
};
