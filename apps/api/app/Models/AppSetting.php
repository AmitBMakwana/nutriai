<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;

class AppSetting extends Model
{
    use HasFactory;

    protected $fillable = [
        'group',
        'key',
        'value',
        'type',
        'description',
    ];

    /**
     * Get a setting value by key, reading from cache if available.
     */
    public static function get(string $key, mixed $default = null): mixed
    {
        return Cache::remember("app_setting.{$key}", 3600, function () use ($key, $default) {
            $setting = static::where('key', $key)->first();
            if (!$setting) {
                return $default;
            }
            return static::castValue($setting->value, $setting->type);
        });
    }

    /**
     * Set a setting value and update cache immediately.
     */
    public static function set(string $key, mixed $value, string $type = 'string', ?string $group = 'general', ?string $description = null): static
    {
        $setting = static::firstOrNew(['key' => $key]);
        $setting->group = $group ?? $setting->group ?? 'general';
        $setting->type = $type;
        $setting->value = static::formatValueForStorage($value, $type);
        if ($description !== null) {
            $setting->description = $description;
        }
        $setting->save();

        Cache::forget("app_setting.{$key}");
        Cache::put("app_setting.{$key}", static::castValue($setting->value, $type), 3600);

        return $setting;
    }

    /**
     * Cast raw string value to appropriate PHP type.
     */
    public static function castValue(mixed $value, string $type): mixed
    {
        if ($value === null) {
            return null;
        }

        return match ($type) {
            'integer', 'int' => (int) $value,
            'float', 'double' => (float) $value,
            'boolean', 'bool' => filter_var($value, FILTER_VALIDATE_BOOLEAN),
            'json', 'array' => json_decode((string) $value, true) ?? [],
            default => (string) $value,
        };
    }

    /**
     * Format a value for database text column storage.
     */
    public static function formatValueForStorage(mixed $value, string $type): ?string
    {
        if ($value === null) {
            return null;
        }

        return match ($type) {
            'boolean', 'bool' => $value ? '1' : '0',
            'json', 'array' => is_string($value) ? $value : json_encode($value),
            default => (string) $value,
        };
    }
}
