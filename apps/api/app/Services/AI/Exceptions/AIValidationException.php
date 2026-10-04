<?php

namespace App\Services\AI\Exceptions;

use Exception;

class AIValidationException extends Exception
{
    /**
     * Raw payload from the AI model that failed validation, if available.
     */
    protected ?string $rawPayload;

    public function __construct(string $message, ?string $rawPayload = null, int $code = 0, ?\Throwable $previous = null)
    {
        parent::__construct($message, $code, $previous);
        $this->rawPayload = $rawPayload;
    }

    public function getRawPayload(): ?string
    {
        return $this->rawPayload;
    }
}
