<?php

namespace App\Enums;

enum ActivityLevel: string
{
    case SEDENTARY = 'sedentary';
    case LIGHTLY_ACTIVE = 'lightly_active';
    case MODERATELY_ACTIVE = 'moderately_active';
    case VERY_ACTIVE = 'very_active';
    case EXTRA_ACTIVE = 'extra_active';
    case EXTREMELY_ACTIVE = 'extremely_active';
}
