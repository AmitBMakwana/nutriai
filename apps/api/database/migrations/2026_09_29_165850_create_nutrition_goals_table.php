<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
    public function up(): void {
        Schema::create('nutrition_goals', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->integer('daily_calories')->nullable();
            $table->integer('protein_grams')->nullable();
            $table->integer('carbs_grams')->nullable();
            $table->integer('fat_grams')->nullable();
            $table->integer('water_ml')->nullable();
            $table->date('effective_from')->nullable();
            $table->timestamps();
            $table->index(['user_id', 'effective_from']);
        });
    }
    public function down(): void {
        Schema::dropIfExists('nutrition_goals');
    }
};
