<?php

namespace Tests\Feature;

use App\Services\AI\AIProviderManager;
use App\Services\AI\Contracts\FoodAnalysisProvider;
use App\Services\AI\ImageStorageService;
use App\Services\AI\Providers\ClaudeFoodAnalysisProvider;
use App\Services\AI\Providers\FakeFoodAnalysisProvider;
use App\Services\AI\Providers\GeminiFoodAnalysisProvider;
use App\Services\AI\Providers\OpenAIFoodAnalysisProvider;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Storage;
use InvalidArgumentException;
use RuntimeException;
use Tests\TestCase;

class AIProviderManagerTest extends TestCase
{
    use RefreshDatabase;

    protected AIProviderManager $manager;

    protected function setUp(): void
    {
        parent::setUp();
        $this->manager = $this->app->make(AIProviderManager::class);
    }

    public function test_resolves_default_provider_from_config(): void
    {
        Config::set('ai.default', 'fake');
        $provider = $this->manager->driver();

        $this->assertInstanceOf(FakeFoodAnalysisProvider::class, $provider);
    }

    public function test_resolves_fake_driver_returning_realistic_indian_meal(): void
    {
        $provider = $this->manager->driver('fake');
        $this->assertInstanceOf(FakeFoodAnalysisProvider::class, $provider);

        $result = $provider->analyze('/dummy/path/meal.jpg');

        $this->assertTrue($result['is_food']);
        $this->assertStringContainsString('Thali', $result['meal_name']);
        $this->assertNotEmpty($result['estimated_items']);
        $this->assertGreaterThan(0, $result['total_calories']);
        $this->assertGreaterThan(0, $result['total_protein']);
        $this->assertGreaterThan(0, $result['total_carbs']);
        $this->assertGreaterThan(0, $result['total_fat']);

        // Check realistic items
        $itemNames = array_column($result['estimated_items'], 'name');
        $this->assertContains('Dal Makhani', $itemNames);
        $this->assertContains('Whole Wheat Roti', $itemNames);
    }

    public function test_fake_driver_handles_non_food_images(): void
    {
        $provider = $this->manager->driver('fake');
        $result = $provider->analyze('/path/to/non-food-sample.jpg');

        $this->assertFalse($result['is_food']);
        $this->assertEquals(0, $result['total_calories']);
        $this->assertEmpty($result['estimated_items']);
    }

    public function test_resolves_gemini_driver_instance(): void
    {
        $provider = $this->manager->driver('gemini');
        $this->assertInstanceOf(GeminiFoodAnalysisProvider::class, $provider);
    }

    public function test_claude_driver_throws_not_implemented_exception(): void
    {
        $provider = $this->manager->driver('claude');
        $this->assertInstanceOf(ClaudeFoodAnalysisProvider::class, $provider);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('Claude food analysis provider is not yet implemented');

        $provider->analyze('/dummy/path.jpg');
    }

    public function test_openai_driver_throws_not_implemented_exception(): void
    {
        $provider = $this->manager->driver('openai');
        $this->assertInstanceOf(OpenAIFoodAnalysisProvider::class, $provider);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('OpenAI food analysis provider is not yet implemented');

        $provider->analyze('/dummy/path.jpg');
    }

    public function test_throws_invalid_argument_exception_for_unknown_driver(): void
    {
        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('driver [deepseek] is not supported');

        $this->manager->driver('deepseek');
    }

    public function test_can_extend_manager_with_custom_driver(): void
    {
        $this->manager->extend('custom_mock', function () {
            return new class implements FoodAnalysisProvider {
                public function analyze(string $imagePath): array
                {
                    return ['is_food' => true, 'meal_name' => 'Custom Meal'];
                }
            };
        });

        $provider = $this->manager->driver('custom_mock');
        $result = $provider->analyze('test.jpg');

        $this->assertEquals('Custom Meal', $result['meal_name']);
    }

    public function test_image_storage_service_stores_and_manages_files(): void
    {
        Storage::fake('local');
        Config::set('ai.storage.disk', 'local');

        $storageService = new ImageStorageService('local', 'test-meals');
        $fakeFile = UploadedFile::fake()->image('food.jpg', 640, 480);

        $storedPath = $storageService->storeUpload($fakeFile, 42);

        $this->assertStringStartsWith('test-meals/user_42/', $storedPath);
        $this->assertTrue($storageService->exists($storedPath));

        $tempUrl = $storageService->getTemporaryUrl($storedPath);
        $this->assertNotEmpty($tempUrl);

        $deleted = $storageService->delete($storedPath);
        $this->assertTrue($deleted);
        $this->assertFalse($storageService->exists($storedPath));
    }
}
