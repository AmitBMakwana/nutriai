# NutriAI API Documentation

## Standard Envelope
All responses adhere to the following JSON envelopes:

**Success:**
```json
{
  "success": true,
  "message": "Success",
  "data": {}
}
```

**Error:**
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "email": ["The email has already been taken."]
  }
}
```

## Authentication

### `POST /api/v1/register`
**Request:**
```json
{
  "name": "Amit",
  "email": "amit@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```
**Response (201):**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "id": 1,
    "name": "Amit",
    "email": "amit@example.com",
    "avatar": null,
    "timezone": "UTC",
    "created_at": "2026-09-29T12:00:00.000000Z"
  }
}
```

### `POST /api/v1/login`
**Request:**
```json
{
  "email": "amit@example.com",
  "password": "password123"
}
```
**Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "name": "Amit",
      "email": "amit@example.com",
      "avatar": null,
      "timezone": "UTC",
      "created_at": "2026-09-29T12:00:00.000000Z"
    },
    "token": "1|abc123token"
  }
}
```

### `GET /api/v1/me` (Auth Required)
**Response (200):**
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "id": 1,
    "name": "Amit",
    "email": "amit@example.com",
    "avatar": null,
    "timezone": "UTC",
    "created_at": "2026-09-29T12:00:00.000000Z"
  }
}
```

### `POST /api/v1/logout` (Auth Required)
**Response (200):**
```json
{
  "success": true,
  "message": "Logout successful",
  "data": {}
}
```

### `POST /api/v1/password/forgot`
**Request:**
```json
{
  "email": "amit@example.com"
}
```

### `POST /api/v1/password/reset`
**Request:**
```json
{
  "email": "amit@example.com",
  "token": "reset-token",
  "password": "newpassword123",
  "password_confirmation": "newpassword123"
}
```

## Onboarding & Profile

### `POST /api/v1/onboarding` (Auth Required)
Saves initial health baseline, calculates targets, and marks onboarding complete.
**Request:**
```json
{
  "goal": "lose_weight",
  "gender": "male",
  "date_of_birth": "1995-06-15",
  "height_cm": 178,
  "weight_kg": 82.5,
  "target_weight_kg": 75.0,
  "activity_level": "moderately_active",
  "diet_type": "everything",
  "unit_system": "metric"
}
```
**Response (200):**
```json
{
  "success": true,
  "message": "Onboarding completed successfully",
  "data": {
    "profile": {
      "id": 1,
      "user_id": 1,
      "goal": "lose_weight",
      "gender": "male",
      "date_of_birth": "1995-06-15",
      "height_cm": 178,
      "weight_kg": 82.5,
      "target_weight_kg": 75.0,
      "activity_level": "moderately_active",
      "diet_type": "everything",
      "unit_system": "metric",
      "is_completed": true,
      "created_at": "2026-10-02T10:00:00.000000Z",
      "updated_at": "2026-10-02T10:00:00.000000Z"
    },
    "user": {
      "id": 1,
      "name": "Amit",
      "email": "amit@example.com",
      "avatar": null,
      "timezone": "UTC",
      "is_onboarding_completed": true,
      "created_at": "2026-10-02T10:00:00.000000Z"
    }
  }
}
```

### `GET /api/v1/profile` (Auth Required)
Returns authenticated user profile.
**Response (200):**
```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "data": {
    "id": 1,
    "user_id": 1,
    "goal": "lose_weight",
    "gender": "male",
    "date_of_birth": "1995-06-15",
    "height_cm": 178,
    "weight_kg": 82.5,
    "target_weight_kg": 75.0,
    "activity_level": "moderately_active",
    "diet_type": "everything",
    "unit_system": "metric",
    "is_completed": true
  }
}
```

### `PUT /api/v1/profile` (Auth Required)
Updates profile attributes and validates realistic ranges.
**Request:**
```json
{
  "weight_kg": 81.0,
  "goal": "build_muscle"
}
```
**Response (200):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "profile": {
      "id": 1,
      "user_id": 1,
      "weight_kg": 81.0,
      "goal": "build_muscle"
    },
    "user": {
      "id": 1,
      "name": "Amit",
      "is_onboarding_completed": true
    }
  }
}
```

## Nutrition Goals

### `GET /api/v1/goals` (Auth Required)
Retrieves the active nutrition goals for the authenticated user.

**Response (200):**
```json
{
  "success": true,
  "message": "Nutrition goals retrieved successfully",
  "data": {
    "id": 1,
    "user_id": 1,
    "daily_calories": 2125,
    "protein_grams": 159,
    "carbs_grams": 213,
    "fat_grams": 71,
    "water_ml": 2750,
    "effective_from": "2026-10-02"
  }
}
```

### `POST /api/v1/goals/calculate` (Auth Required)
Calculates and returns a preview of calorie, macro, and water targets based on profile parameters without persisting to the database.

**Request:**
```json
{
  "gender": "male",
  "date_of_birth": "1995-06-15",
  "height_cm": 175,
  "weight_kg": 75.0,
  "activity_level": "moderately_active",
  "goal": "lose_weight"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Nutrition goals calculated successfully",
  "data": {
    "daily_calories": 2125,
    "protein_grams": 159,
    "carbs_grams": 213,
    "fat_grams": 71,
    "water_ml": 2750
  }
}
```

### `PUT /api/v1/goals` (Auth Required)
Manually overrides the daily calories, macronutrient distribution, and water target for the authenticated user, saving a new active goal record effective today.

**Request:**
```json
{
  "daily_calories": 2000,
  "protein_grams": 160,
  "carbs_grams": 190,
  "fat_grams": 65,
  "water_ml": 3000
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Nutrition goals updated successfully",
  "data": {
    "id": 2,
    "user_id": 1,
    "daily_calories": 2000,
    "protein_grams": 160,
    "carbs_grams": 190,
    "fat_grams": 65,
    "water_ml": 3000,
    "effective_from": "2026-10-02"
  }
}
```

## Dashboard

### `GET /api/v1/dashboard` (Auth Required)
Retrieves aggregated daily nutrition summary, active goals, consumed values, hydration progress, and grouped meals for a specific date (defaults to today in user's timezone).

**Query Parameters:**
- `date` (optional): `YYYY-MM-DD` (e.g. `2026-10-02`). Defaults to current date in user's configured timezone.

**Response (200):**
```json
{
  "success": true,
  "message": "Dashboard data retrieved successfully",
  "data": {
    "date": "2026-10-02",
    "calories": {
      "target": 2100,
      "consumed": 1300,
      "remaining": 800,
      "percentage": 61.9
    },
    "macros": {
      "protein": {
        "target": 160,
        "consumed": 90.0,
        "remaining": 70.0,
        "percentage": 56.3
      },
      "carbs": {
        "target": 210,
        "consumed": 130.0,
        "remaining": 80.0,
        "percentage": 61.9
      },
      "fat": {
        "target": 70,
        "consumed": 42.0,
        "remaining": 28.0,
        "percentage": 60.0
      }
    },
    "water": {
      "target": 2750,
      "consumed": 1250,
      "remaining": 1500,
      "percentage": 45.5
    },
    "meals": {
      "breakfast": {
        "type": "breakfast",
        "calories": 450,
        "protein": 30.0,
        "carbs": 50.0,
        "fat": 15.0,
        "meals": [
          {
            "id": 1,
            "meal_type": "breakfast",
            "meal_date": "2026-10-02",
            "meal_time": "08:30:00",
            "total_calories": 450,
            "total_protein": 30.0,
            "total_carbs": 50.0,
            "total_fat": 15.0,
            "total_fiber": 5.0,
            "source": "manual",
            "items": []
          }
        ]
      },
      "lunch": {
        "type": "lunch",
        "calories": 650,
        "protein": 45.0,
        "carbs": 60.0,
        "fat": 22.0,
        "meals": []
      },
      "dinner": {
        "type": "dinner",
        "calories": 0,
        "protein": 0.0,
        "carbs": 0.0,
        "fat": 0.0,
        "meals": []
      },
      "snack": {
        "type": "snack",
        "calories": 200,
        "protein": 15.0,
        "carbs": 20.0,
        "fat": 5.0,
        "meals": []
      }
    }
  }
}
```

## Foods

### `GET /api/v1/foods/search?q=` (Auth Required)
Searches verified foods and authenticated user's custom foods. Returns paginated results with `is_favorite` flag.

**Response (200):**
```json
{
  "success": true,
  "message": "Foods retrieved successfully",
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 1,
        "name": "Chicken Breast",
        "brand": null,
        "serving_size": 100,
        "serving_unit": "g",
        "calories": 165,
        "protein": 31.0,
        "carbs": 0.0,
        "fat": 3.6,
        "fiber": 0.0,
        "is_verified": true,
        "is_favorite": true
      }
    ],
    "total": 1
  }
}
```

### `POST /api/v1/foods/custom` (Auth Required)
Creates a custom food for the authenticated user.

**Request:**
```json
{
  "name": "Homemade Protein Shake",
  "brand": "Kitchen",
  "serving_size": 350,
  "serving_unit": "ml",
  "calories": 320,
  "protein": 35.5,
  "carbs": 25.0,
  "fat": 6.0,
  "fiber": 4.0
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Custom food created successfully",
  "data": {
    "id": 2,
    "name": "Homemade Protein Shake",
    "brand": "Kitchen",
    "serving_size": 350,
    "serving_unit": "ml",
    "calories": 320,
    "protein": 35.5,
    "carbs": 25.0,
    "fat": 6.0,
    "fiber": 4.0,
    "is_verified": false,
    "user_id": 1
  }
}
```

### `POST /api/v1/foods/{id}/favorite` (Auth Required)
Toggles the favorite status of a food for the authenticated user.

**Response (200):**
```json
{
  "success": true,
  "message": "Food added to favorites",
  "data": {
    "food_id": 1,
    "is_favorite": true
  }
}
```

## Meals

### `GET /api/v1/meals?date=YYYY-MM-DD` (Auth Required)
Retrieves the authenticated user's meals for a given date with items loaded.

**Response (200):**
```json
{
  "success": true,
  "message": "Meals retrieved successfully",
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "meal_type": "breakfast",
      "meal_date": "2026-10-02",
      "meal_time": "08:30:00",
      "total_calories": 450,
      "total_protein": 30.0,
      "total_carbs": 50.0,
      "total_fat": 15.0,
      "total_fiber": 5.0,
      "source": "manual",
      "items": [
        {
          "id": 1,
          "meal_id": 1,
          "food_id": 1,
          "food_name": "Oatmeal",
          "quantity": 100,
          "unit": "g",
          "calories": 450,
          "protein": 30.0,
          "carbs": 50.0,
          "fat": 15.0,
          "fiber": 5.0
        }
      ]
    }
  ]
}
```

### `POST /api/v1/meals` (Auth Required)
Creates a new meal. Meal calories and macro totals are always calculated server-side based on foods and quantities.

**Request:**
```json
{
  "meal_type": "lunch",
  "meal_date": "2026-10-02",
  "meal_time": "13:00:00",
  "source": "manual",
  "items": [
    {
      "food_id": 1,
      "food_name": "Chicken Breast",
      "quantity": 200,
      "unit": "g"
    }
  ]
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Meal created successfully",
  "data": {
    "id": 2,
    "user_id": 1,
    "meal_type": "lunch",
    "meal_date": "2026-10-02",
    "meal_time": "13:00:00",
    "total_calories": 330,
    "total_protein": 62.0,
    "total_carbs": 0.0,
    "total_fat": 7.2,
    "total_fiber": 0.0,
    "items": [...]
  }
}
```

### `GET /api/v1/meals/{id}` (Auth Required)
Returns meal details. Subject to user ownership policy (returns 403 for unauthorized users).

### `PUT /api/v1/meals/{id}` (Auth Required)
Updates meal attributes and/or items, recalculating totals server-side.

### `DELETE /api/v1/meals/{id}` (Auth Required)
Deletes meal. Automatically updates daily summaries cache.

## AI Meal Vision & Analysis

### `POST /api/v1/meals/analyze` (Auth Required)
Analyzes an uploaded meal photo using configured AI vision provider (Google Gemini 1.5/2.0 Flash, or Fake provider in local dev/tests). Enforces monthly scan quotas (Free: 5/month, Pro: 100/month).

**Content-Type:** `multipart/form-data`

**Request Parameters:**
- `image` (file, required): Image file (JPEG, PNG, WEBP). Maximum size: 5 MB.
- `meal_type` (string, optional): One of `breakfast`, `lunch`, `dinner`, `snack`. Default: `lunch`.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Meal analyzed successfully",
  "data": {
    "analysis_id": 14,
    "status": "completed",
    "is_food": true,
    "meal_name": "North Indian Thali (Dal Makhani, Roti & Rice)",
    "meal_type": "lunch",
    "confidence": 0.94,
    "items": [
      {
        "name": "Dal Makhani",
        "quantity": 150.0,
        "unit": "g",
        "calories": 230,
        "protein": 8.5,
        "carbs": 24.0,
        "fat": 11.5,
        "confidence": 0.95
      },
      {
        "name": "Whole Wheat Roti",
        "quantity": 2.0,
        "unit": "piece",
        "calories": 210,
        "protein": 6.2,
        "carbs": 40.0,
        "fat": 2.8,
        "confidence": 0.96
      }
    ],
    "total": {
      "calories": 440,
      "protein": 14.7,
      "carbs": 64.0,
      "fat": 14.3
    },
    "notes": "Balanced vegetarian Indian meal.",
    "image_url": "https://storage.nutriai.app/meal-uploads/user_1/sample.jpg?signature=...",
    "processing_time_ms": 340
  }
}
```

**Quota Exceeded Response (429 Too Many Requests):**
```json
{
  "success": false,
  "message": "Monthly AI scan quota exceeded (5/5 scans used). Upgrade to Pro for 100 scans per month.",
  "data": {
    "used": 5,
    "quota": 5,
    "plan": "free"
  }
}
```

### `GET /api/v1/ai-analysis/{id}` (Auth Required)
Retrieves the record, status, and breakdown of a previously completed or processed meal analysis. Enforces user ownership (403 for unauthorized users).

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Analysis retrieved successfully",
  "data": {
    "analysis_id": 14,
    "status": "completed",
    "is_food": true,
    "meal_name": "North Indian Thali (Dal Makhani, Roti & Rice)",
    "confidence": 0.94,
    "items": [...],
    "total": {
      "calories": 440,
      "protein": 14.7,
      "carbs": 64.0,
      "fat": 14.3
    },
    "notes": "...",
    "image_url": "https://...",
    "processing_time_ms": 340,
    "created_at": "2026-10-02T12:00:00.000000Z"
  }
}
```


