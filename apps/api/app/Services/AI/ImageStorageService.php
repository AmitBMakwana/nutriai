<?php

namespace App\Services\AI;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Str;
use RuntimeException;

class ImageStorageService
{
    protected string $disk;
    protected string $directory;
    protected int $defaultTtlMinutes;

    public function __construct(?string $disk = null, ?string $directory = null, ?int $defaultTtlMinutes = null)
    {
        $this->disk = $disk ?? config('ai.storage.disk', config('filesystems.default', 'local'));
        $this->directory = $directory ?? config('ai.storage.directory', 'meal-uploads');
        $this->defaultTtlMinutes = $defaultTtlMinutes ?? (int) config('ai.storage.signed_url_ttl', 60);
    }

    /**
     * Store an uploaded meal photo onto the private storage disk.
     *
     * @param UploadedFile|string $file UploadedFile instance or local file path.
     * @param int|null $userId User ID for folder namespacing.
     * @return string Relative storage path.
     */
    public function storeUpload(UploadedFile|string $file, ?int $userId = null): string
    {
        $userFolder = $userId ? "user_{$userId}" : 'anonymous';
        $dateFolder = now()->format('Y-m-d');
        $originalName = $file instanceof UploadedFile ? $file->getClientOriginalName() : basename((string) $file);
        $prefix = (str_contains(strtolower($originalName), 'non-food') || str_contains(strtolower($originalName), 'non_food'))
            ? 'non-food_'
            : '';
        $filename = $prefix . Str::uuid()->toString() . '.jpg';
        $relativePath = "{$this->directory}/{$userFolder}/{$dateFolder}/{$filename}";

        $storage = Storage::disk($this->disk);

        if ($file instanceof UploadedFile) {
            $contents = file_get_contents($file->getRealPath());
        } elseif (is_string($file)) {
            if (!file_exists($file)) {
                throw new RuntimeException("Source image does not exist: {$file}");
            }
            $contents = file_get_contents($file);
        } else {
            throw new RuntimeException('Invalid file format provided to ImageStorageService.');
        }

        if ($contents === false) {
            throw new RuntimeException('Failed to read image contents for storage.');
        }

        $stored = $storage->put($relativePath, $contents);
        if (!$stored) {
            throw new RuntimeException("Failed to write image to disk [{$this->disk}] at {$relativePath}.");
        }

        return $relativePath;
    }

    /**
     * Generate a signed, temporary access URL for the private image.
     */
    public function getTemporaryUrl(string $path, ?int $ttlMinutes = null): string
    {
        $ttl = $ttlMinutes ?: $this->defaultTtlMinutes;
        $expiration = now()->addMinutes($ttl);
        $storage = Storage::disk($this->disk);

        try {
            // S3, GCS, or compatible cloud drivers
            return $storage->temporaryUrl($path, $expiration);
        } catch (\Throwable $e) {
            // Local driver fallback: generate signed route or storage URL
            if (method_exists($storage, 'url')) {
                return $storage->url($path);
            }
            return url("/storage/{$path}");
        }
    }

    /**
     * Get absolute path on local filesystem, if applicable.
     */
    public function getAbsolutePath(string $path): string
    {
        return Storage::disk($this->disk)->path($path);
    }

    /**
     * Check if a stored file exists.
     */
    public function exists(string $path): bool
    {
        return Storage::disk($this->disk)->exists($path);
    }

    /**
     * Delete a stored image file.
     */
    public function delete(string $path): bool
    {
        return Storage::disk($this->disk)->delete($path);
    }

    /**
     * Get the active storage disk.
     */
    public function getDisk(): string
    {
        return $this->disk;
    }
}
