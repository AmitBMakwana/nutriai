<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\User;

class AuthenticationTest extends TestCase
{
    use RefreshDatabase;

    public function test_register_success()
    {
        $response = $this->postJson('/api/v1/register', [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertStatus(201)
                 ->assertJsonStructure(['success', 'message', 'data' => ['id', 'name', 'email']]);
                 
        $this->assertDatabaseHas('user_profiles', ['user_id' => $response['data']['id']]);
    }

    public function test_register_validation_fails()
    {
        $response = $this->postJson('/api/v1/register', [
            'name' => 'John Doe',
            'email' => 'not-an-email',
            'password' => 'short',
        ]);

        $response->assertStatus(422)
                 ->assertJsonStructure(['success', 'message', 'errors']);
    }

    public function test_register_duplicate_email()
    {
        User::factory()->create(['email' => 'john@example.com']);

        $response = $this->postJson('/api/v1/register', [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertStatus(422);
    }

    public function test_login_success()
    {
        $user = User::factory()->create(['password' => bcrypt('password123')]);

        $response = $this->postJson('/api/v1/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertStatus(200)
                 ->assertJsonStructure(['success', 'message', 'data' => ['user', 'token']]);
    }

    public function test_login_failure()
    {
        $user = User::factory()->create(['password' => bcrypt('password123')]);

        $response = $this->postJson('/api/v1/login', [
            'email' => $user->email,
            'password' => 'wrongpassword',
        ]);

        $response->assertStatus(422);
    }

    public function test_me_requires_auth()
    {
        $response = $this->getJson('/api/v1/me');
        
        $response->assertStatus(401)
                 ->assertJson(['success' => false, 'message' => 'Unauthenticated']);
    }

    public function test_me_success()
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;

        $response = $this->getJson('/api/v1/me', ['Authorization' => "Bearer $token"]);

        $response->assertStatus(200)
                 ->assertJsonPath('data.email', $user->email);
    }

    public function test_logout_revokes_token()
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;

        $response = $this->postJson('/api/v1/logout', [], ['Authorization' => "Bearer $token"]);
        $response->assertStatus(200);

        $this->assertCount(0, $user->tokens);
    }
}
