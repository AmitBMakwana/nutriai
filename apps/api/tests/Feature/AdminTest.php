<?php

namespace Tests\Feature;

use App\Models\AppSetting;
use App\Models\AuditLog;
use App\Models\Food;
use App\Models\Meal;
use App\Models\User;
use App\Services\AI\AIProviderManager;
use App\Services\Subscription\EntitlementService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Cache;
use Spatie\Permission\Models\Role;
use Tests\TestCase;

class AdminTest extends TestCase
{
    use RefreshDatabase;

    protected User $adminUser;
    protected User $regularUser;

    protected function setUp(): void
    {
        parent::setUp();

        // Reset permission cache
        app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

        // Create admin role
        Role::create(['name' => 'admin']);

        // Create admin user
        $this->adminUser = User::factory()->create([
            'email' => 'admin@nutriai.app',
            'is_disabled' => false,
        ]);
        $this->adminUser->assignRole('admin');

        // Create regular user without admin role
        $this->regularUser = User::factory()->create([
            'email' => 'user@example.com',
            'is_disabled' => false,
        ]);
    }

    public function test_guests_cannot_access_admin_dashboard_and_are_redirected_to_login(): void
    {
        $response = $this->get('/admin');

        $response->assertRedirect(route('admin.login'));
    }

    public function test_non_admin_users_cannot_access_admin_portal(): void
    {
        $response = $this->actingAs($this->regularUser)->get('/admin');

        $response->assertForbidden();
    }

    public function test_admin_user_can_access_dashboard_and_modules(): void
    {
        $this->actingAs($this->adminUser)
            ->get(route('admin.dashboard'))
            ->assertOk()
            ->assertSee('NutriAI')
            ->assertSee('Total Users');

        $this->actingAs($this->adminUser)
            ->get(route('admin.users.index'))
            ->assertOk();

        $this->actingAs($this->adminUser)
            ->get(route('admin.foods.index'))
            ->assertOk();

        $this->actingAs($this->adminUser)
            ->get(route('admin.meals.index'))
            ->assertOk();

        $this->actingAs($this->adminUser)
            ->get(route('admin.ai.usage'))
            ->assertOk();

        $this->actingAs($this->adminUser)
            ->get(route('admin.ai.settings'))
            ->assertOk();

        $this->actingAs($this->adminUser)
            ->get(route('admin.subscriptions.index'))
            ->assertOk();

        $this->actingAs($this->adminUser)
            ->get(route('admin.system.settings'))
            ->assertOk();

        $this->actingAs($this->adminUser)
            ->get(route('admin.audit-logs.index'))
            ->assertOk();
    }

    public function test_admin_can_toggle_user_status_and_audit_log_is_recorded(): void
    {
        $this->assertFalse($this->regularUser->is_disabled);

        $response = $this->actingAs($this->adminUser)
            ->post(route('admin.users.toggle-status', $this->regularUser->id));

        $response->assertRedirect();
        $this->regularUser->refresh();
        $this->assertTrue($this->regularUser->is_disabled);

        $this->assertDatabaseHas('audit_logs', [
            'admin_id' => $this->adminUser->id,
            'action' => 'disable_user',
            'target_id' => $this->regularUser->id,
        ]);
    }

    public function test_admin_can_verify_custom_food_and_record_audit_log(): void
    {
        $food = Food::create([
            'name' => 'Custom Protein Bar',
            'serving_size' => 60,
            'serving_unit' => 'g',
            'calories' => 210,
            'protein' => 20,
            'carbs' => 22,
            'fat' => 7,
            'is_verified' => false,
            'created_by_user_id' => $this->regularUser->id,
        ]);

        $this->assertFalse($food->is_verified);

        $response = $this->actingAs($this->adminUser)
            ->post(route('admin.foods.verify', $food->id));

        $response->assertRedirect();
        $food->refresh();
        $this->assertTrue($food->is_verified);

        $this->assertDatabaseHas('audit_logs', [
            'admin_id' => $this->adminUser->id,
            'action' => 'verify_food',
            'target_id' => $food->id,
        ]);
    }

    public function test_admin_can_import_foods_via_csv(): void
    {
        $csvContent = "name,serving_size,serving_unit,calories,protein,carbs,fat,brand,barcode\n"
                    . "Greek Yogurt 0%,170,g,100,18,6,0,Fage,012345678901\n"
                    . "Almond Butter,32,g,190,7,7,17,Justin's,098765432109\n";

        $file = UploadedFile::fake()->createWithContent('foods.csv', $csvContent);

        $response = $this->actingAs($this->adminUser)
            ->post(route('admin.foods.import-csv'), [
                'csv_file' => $file,
            ]);

        $response->assertRedirect();
        $this->assertDatabaseHas('foods', ['name' => 'Greek Yogurt 0%', 'is_verified' => true]);
        $this->assertDatabaseHas('foods', ['name' => 'Almond Butter', 'is_verified' => true]);

        $this->assertDatabaseHas('audit_logs', [
            'admin_id' => $this->adminUser->id,
            'action' => 'import_foods',
        ]);
    }

    public function test_ai_settings_changes_affect_the_api_with_caching(): void
    {
        $entitlementService = app(EntitlementService::class);
        $aiManager = app(AIProviderManager::class);

        // Initial default free quota
        $this->assertEquals(5, $entitlementService->getMonthlyScanQuota($this->regularUser));

        // Admin updates AI settings via Admin form
        $response = $this->actingAs($this->adminUser)
            ->post(route('admin.ai.settings.update'), [
                'provider' => 'mock',
                'model' => 'mock-vision-v2',
                'temperature' => 0.15,
                'max_tokens' => 1500,
                'prompt' => 'Custom vision system prompt for food testing',
                'quota_free' => 25,
                'quota_pro' => 200,
                'quota_premium' => -1,
            ]);

        $response->assertRedirect();

        // Check AppSetting in DB and cached
        $this->assertEquals('mock', AppSetting::get('ai.provider'));
        $this->assertEquals('mock-vision-v2', AppSetting::get('ai.model'));
        $this->assertEquals(0.15, AppSetting::get('ai.temperature'));
        $this->assertEquals(1500, AppSetting::get('ai.max_tokens'));
        $this->assertEquals(25, AppSetting::get('ai.quota_free'));

        // Verify API EntitlementService immediately reflects new cached quota without config alteration
        $newFreeQuota = $entitlementService->getMonthlyScanQuota($this->regularUser);
        $this->assertEquals(25, $newFreeQuota);

        // Verify AIProviderManager reflects new DB provider driver
        $defaultDriver = $aiManager->getDefaultDriver();
        $this->assertEquals('mock', $defaultDriver);

        // Verify audit log exists
        $this->assertDatabaseHas('audit_logs', [
            'admin_id' => $this->adminUser->id,
            'action' => 'update_ai_settings',
        ]);
    }

    public function test_admin_can_purge_system_cache_and_audit_log_is_recorded(): void
    {
        Cache::put('test_key', 'test_val', 3600);
        $this->assertEquals('test_val', Cache::get('test_key'));

        $response = $this->actingAs($this->adminUser)
            ->post(route('admin.system.clear-cache'));

        $response->assertRedirect();
        $this->assertNull(Cache::get('test_key'));

        $this->assertDatabaseHas('audit_logs', [
            'admin_id' => $this->adminUser->id,
            'action' => 'clear_system_cache',
        ]);
    }
}
