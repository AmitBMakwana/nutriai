<?php

namespace Tests\Feature;

use Tests\TestCase;

class HealthCheckTest extends TestCase
{
    public function test_api_v1_health_returns_status_and_services(): void
    {
        $response = $this->getJson('/api/v1/health');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'status',
                'timestamp',
                'environment',
                'version',
                'services' => [
                    'database',
                    'redis',
                    'storage',
                ],
            ]);

        $this->assertEquals('healthy', $response->json('status'));
        $this->assertEquals('up', $response->json('services.database'));
        $this->assertEquals('up', $response->json('services.storage'));
    }

    public function test_root_health_endpoint_is_accessible(): void
    {
        $response = $this->getJson('/health');

        $response->assertStatus(200)
            ->assertJsonPath('status', 'healthy');
    }
}
