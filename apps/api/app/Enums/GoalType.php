<?php

namespace App\Enums;

enum GoalType: string
{
    case MAINTAIN = 'maintain';
    case LOSE_WEIGHT = 'lose_weight';
    case GAIN_WEIGHT = 'gain_weight';
    case BUILD_MUSCLE = 'build_muscle';
}
