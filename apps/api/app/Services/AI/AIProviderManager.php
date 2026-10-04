<?php

namespace App\Services\AI;

use App\Services\AI\Contracts\FoodAnalysisProvider;
use App\Services\AI\Providers\ClaudeFoodAnalysisProvider;
use App\Services\AI\Providers\FakeFoodAnalysisProvider;
use App\Services\AI\Providers\GeminiFoodAnalysisProvider;
use App\Services\AI\Providers\OpenAIFoodAnalysisProvider;
use App\Services\AI\Validators\AIResponseValidator;
use Closure;
use Illuminate\Contracts\Foundation\Application;
use InvalidArgumentException;

class AIProviderManager
{
    protected Application $app;
    protected array $drivers = [];
    protected array $customCreators = [];

    public function __construct(Application $app)
    {
        $this->app = $app;
    }

    /**
     * Get an AI provider driver instance.
     */
    public function driver(?string $name = null): FoodAnalysisProvider
    {
        $name = $name ?: $this->getDefaultDriver();

        if (!isset($this->drivers[$name])) {
            $this->drivers[$name] = $this->resolve($name);
        }

        return $this->drivers[$name];
    }

    /**
     * Resolve the given driver.
     */
    protected function resolve(string $name): FoodAnalysisProvider
    {
        if (isset($this->customCreators[$name])) {
            return $this->customCreators[$name]($this->app);
        }

        $method = 'create' . ucfirst(strtolower($name)) . 'Driver';
        if (method_exists($this, $method)) {
            return $this->$method();
        }

        throw new InvalidArgumentException("AI Provider driver [{$name}] is not supported.");
    }

    /**
     * Create the Gemini driver instance.
     */
    public function createGeminiDriver(): FoodAnalysisProvider
    {
        $config = $this->app['config']->get('ai.providers.gemini', []);
        $validator = $this->app->make(AIResponseValidator::class);

        return new GeminiFoodAnalysisProvider($config, $validator);
    }

    /**
     * Create the Claude driver instance.
     */
    public function createClaudeDriver(): FoodAnalysisProvider
    {
        $config = $this->app['config']->get('ai.providers.claude', []);
        return new ClaudeFoodAnalysisProvider($config);
    }

    /**
     * Create the OpenAI driver instance.
     */
    public function createOpenaiDriver(): FoodAnalysisProvider
    {
        $config = $this->app['config']->get('ai.providers.openai', []);
        return new OpenAIFoodAnalysisProvider($config);
    }

    /**
     * Create the Fake driver instance.
     */
    public function createFakeDriver(): FoodAnalysisProvider
    {
        $validator = $this->app->make(AIResponseValidator::class);
        return new FakeFoodAnalysisProvider($validator);
    }

    /**
     * Register a custom driver creator Closure.
     */
    public function extend(string $driver, Closure $callback): self
    {
        $this->customCreators[$driver] = $callback;
        unset($this->drivers[$driver]);
        return $this;
    }

    /**
     * Get the default driver name.
     */
    public function getDefaultDriver(): string
    {
        $dbProvider = \App\Models\AppSetting::get('ai.provider');
        return !empty($dbProvider) ? (string) $dbProvider : $this->app['config']->get('ai.default', 'gemini');
    }

    /**
     * Dynamically call the default driver's methods.
     */
    public function __call(string $method, array $parameters)
    {
        return $this->driver()->$method(...$parameters);
    }
}
