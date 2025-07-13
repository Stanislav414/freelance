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
        Schema::create('order_attributes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained('orders')->onDelete('cascade'); // Заказ
            $table->foreignId('attribute_type_id')->constrained('order_attribute_types')->onDelete('cascade'); // Тип характеристики
            $table->foreignId('value_id')->constrained('order_attribute_values')->onDelete('cascade'); // Значение характеристики
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('order_attributes');
    }
};
