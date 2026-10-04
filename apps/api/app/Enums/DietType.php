<?php

namespace App\Enums;

enum DietType: string
{
    case EVERYTHING = 'everything';
    case STANDARD = 'standard';
    case VEGETARIAN = 'vegetarian';
    case VEGAN = 'vegan';
    case KETO = 'keto';
    case PALEO = 'paleo';
    case PESCATARIAN = 'pescatarian';
    case OTHER = 'other';
}
