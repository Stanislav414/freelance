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
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['type', 'goal', 'platform', 'format', 'orientation', 'sound']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->string('type')->nullable();
            $table->string('goal')->nullable();
            $table->string('platform')->nullable();
            $table->string('format')->nullable();
            $table->string('orientation')->nullable();
            $table->string('sound')->nullable();
        });
    }
};
