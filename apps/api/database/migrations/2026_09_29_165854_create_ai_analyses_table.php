<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
    public function up(): void {
        Schema::create('ai_analyses', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('meal_id')->nullable()->constrained()->cascadeOnDelete();
            $table->string('provider');
            $table->string('model');
            $table->string('image_path');
            $table->string('status');
            $table->json('raw_response')->nullable();
            $table->json('parsed_response')->nullable();
            $table->float('confidence')->nullable();
            $table->integer('processing_time_ms')->nullable();
            $table->text('error_message')->nullable();
            $table->timestamps();
        });
    }
    public function down(): void {
        Schema::dropIfExists('ai_analyses');
    }
};
