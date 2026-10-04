<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
    public function up(): void {
        Schema::create('meals', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('meal_type');
            $table->date('meal_date');
            $table->time('meal_time');
            $table->string('image_path')->nullable();
            $table->integer('total_calories')->default(0);
            $table->float('total_protein')->default(0);
            $table->float('total_carbs')->default(0);
            $table->float('total_fat')->default(0);
            $table->float('total_fiber')->default(0);
            $table->string('source')->default('manual');
            $table->timestamps();
            $table->index(['user_id', 'meal_date']);
        });
    }
    public function down(): void {
        Schema::dropIfExists('meals');
    }
};
