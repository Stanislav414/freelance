<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('work_type_attribute_type', function (Blueprint $table) {
            $table->id();
            $table->foreignId('work_type_id')->constrained('work_types')->onDelete('cascade');
            $table->foreignId('attribute_type_id')->constrained('order_attribute_types')->onDelete('cascade');
            $table->boolean('required')->default(true); // Обязательное поле или нет
            $table->integer('sort_order')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('work_type_attribute_type');
    }
};
