<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('foods', function (Blueprint $table) {
            $table->index(['is_verified', 'name'], 'idx_foods_verified_name');
            $table->index(['user_id', 'is_verified'], 'idx_foods_user_verified');
        });

        Schema::table('ai_analyses', function (Blueprint $table) {
            $table->index(['user_id', 'created_at'], 'idx_ai_analyses_user_created');
            $table->index(['status', 'provider'], 'idx_ai_analyses_status_provider');
        });

        Schema::table('subscriptions', function (Blueprint $table) {
            $table->index(['user_id', 'status'], 'idx_subs_user_status');
            $table->index(['plan', 'status'], 'idx_subs_plan_status');
        });

        Schema::table('webhook_events', function (Blueprint $table) {
            $table->index(['provider', 'event_id'], 'idx_webhook_events_provider_event');
        });

        Schema::table('audit_logs', function (Blueprint $table) {
            $table->index(['admin_id', 'action'], 'idx_audit_logs_admin_action');
            $table->index(['created_at'], 'idx_audit_logs_created_at');
        });
    }

    public function down(): void
    {
        Schema::table('foods', function (Blueprint $table) {
            $table->dropIndex('idx_foods_verified_name');
            $table->dropIndex('idx_foods_user_verified');
        });

        Schema::table('ai_analyses', function (Blueprint $table) {
            $table->dropIndex('idx_ai_analyses_user_created');
            $table->dropIndex('idx_ai_analyses_status_provider');
        });

        Schema::table('subscriptions', function (Blueprint $table) {
            $table->dropIndex('idx_subs_user_status');
            $table->dropIndex('idx_subs_plan_status');
        });

        Schema::table('webhook_events', function (Blueprint $table) {
            $table->dropIndex('idx_webhook_events_provider_event');
        });

        Schema::table('audit_logs', function (Blueprint $table) {
            $table->dropIndex('idx_audit_logs_admin_action');
            $table->dropIndex('idx_audit_logs_created_at');
        });
    }
};
