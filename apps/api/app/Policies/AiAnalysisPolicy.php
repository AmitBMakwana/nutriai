<?php

namespace App\Policies;

use App\Models\AiAnalysis;
use App\Models\User;

class AiAnalysisPolicy
{
    /**
     * Determine whether the user can view the analysis.
     */
    public function view(User $user, AiAnalysis $analysis): bool
    {
        return $user->id === $analysis->user_id;
    }

    /**
     * Determine whether the user can delete the analysis.
     */
    public function delete(User $user, AiAnalysis $analysis): bool
    {
        return $user->id === $analysis->user_id;
    }
}
