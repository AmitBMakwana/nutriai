<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Redis;
use Illuminate\Support\Facades\Storage;
use Throwable;

class HealthCheckController extends Controller
{
    public function check(): JsonResponse
    {
        $services = [
            'database' => 'down',
            'redis' => 'down',
            'storage' => 'down',
        ];

        $isHealthy = true;

        // 1. Check Database connectivity
        try {
            DB::connection()->getPdo();
            $services['database'] = 'up';
        } catch (Throwable $e) {
            $services['database'] = 'down';
            $isHealthy = false;
        }

        // 2. Check Redis connectivity
        try {
            Redis::connection()->ping();
            $services['redis'] = 'up';
        } catch (Throwable $e) {
            if (app()->environment('production') && (config('queue.default') === 'redis' || config('cache.default') === 'redis')) {
                $services['redis'] = 'down';
                $isHealthy = false;
            } else {
                $services['redis'] = 'skipped';
            }
        }

        // 3. Check Storage read/write
        try {
            $disk = config('filesystems.default', 'local');
            Storage::disk($disk)->put('.health-check.tmp', 'ok');
            Storage::disk($disk)->delete('.health-check.tmp');
            $services['storage'] = 'up';
        } catch (Throwable $e) {
            $services['storage'] = 'down';
            $isHealthy = false;
        }

        $statusCode = $isHealthy ? 200 : 503;

        return response()->json([
            'status' => $isHealthy ? 'healthy' : 'unhealthy',
            'timestamp' => now()->toIso8601String(),
            'environment' => config('app.env'),
            'version' => '1.0.0',
            'services' => $services,
        ], $statusCode);
    }
}
