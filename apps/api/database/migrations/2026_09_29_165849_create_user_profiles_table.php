<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
    public function up(): void {
        Schema::create('user_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('gender')->nullable();
            $table->date('date_of_birth')->nullable();
            $table->integer('height_cm')->nullable();
            $table->float('weight_kg')->nullable();
            $table->float('target_weight_kg')->nullable();
            $table->string('activity_level')->nullable();
            $table->string('goal')->nullable();
            $table->string('diet_type')->nullable();
            $table->string('unit_system')->default('metric');
            $table->timestamps();
        });
    }
    public function down(): void {
        Schema::dropIfExists('user_profiles');
    }
};
