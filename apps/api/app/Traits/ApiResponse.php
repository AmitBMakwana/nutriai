<?php

namespace App\Traits;

use Illuminate\Http\JsonResponse;

trait ApiResponse
{
    protected function success(mixed $data = [], string $message = 'Success', int $statusCode = 200): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => empty($data) ? (object)[] : $data
        ], $statusCode);
    }

    protected function error(string $message, mixed $errors = [], int $statusCode = 400): JsonResponse
    {
        return response()->json([
            'success' => false,
            'message' => $message,
            'errors' => empty($errors) ? (object)[] : $errors
        ], $statusCode);
    }
}
