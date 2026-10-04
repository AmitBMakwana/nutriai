<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
    public function up(): void {
        Schema::create('daily_summaries', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->date('summary_date');
            $table->integer('calories')->default(0);
            $table->float('protein')->default(0);
            $table->float('carbs')->default(0);
            $table->float('fat')->default(0);
            $table->float('fiber')->default(0);
            $table->integer('water_ml')->default(0);
            $table->timestamps();
            $table->unique(['user_id', 'summary_date']);
        });
    }
    public function down(): void {
        Schema::dropIfExists('daily_summaries');
    }
};
