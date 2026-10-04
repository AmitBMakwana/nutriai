# NutriAI

> **Snap your meal. Understand your nutrition. Reach your goal.**

NutriAI is an AI-powered nutrition and meal tracking mobile app with a production-grade full-stack architecture.

---

## 📱 Tech Stack

- **Mobile App (`apps/mobile`):** Flutter (Dart), Riverpod, GoRouter, Dio, Freezed, FL Chart, Secure Storage, Camera/Image Picker.
- **Backend API (`apps/api`):** Laravel 12, PHP 8.3+, MySQL 8, Redis, Laravel Queue & Scheduler, Sanctum, S3-compatible storage.
- **AI Vision Engine:** Server-side Gemini Vision provider abstraction with automatic retries and quota management.
- **Admin Portal (`apps/api/routes/web.php`):** Protected administrative dashboard for users, foods, meals, AI settings, subscriptions, and audit logs.
- **DevOps & Infrastructure (`docker/`, `.github/`):** Docker multi-stage builds, Supervisor, Redis cache/queue, automated CI/CD workflows, Sentry monitoring, and health check endpoints.

---

## 📂 Monorepo Structure

```text
nutriai/
  apps/
    mobile/       # Flutter cross-platform mobile & web application
    api/          # Laravel 12 REST API & Admin Portal
    admin/        # Admin portal scaffolding
  docs/
    PRD.md
    ARCHITECTURE.md
    API.md
    DATABASE.md
    AI.md
    SECURITY.md
    DEPLOYMENT.md
    HEALTH_DISCLAIMER.md
    PRIVACY.md
    TERMS.md
  docker/         # Production Dockerfile, Supervisor, Nginx, backups
  .github/        # GitHub Actions CI/CD workflows
  docker-compose.yml
  README.md
```

---

## 🚀 Getting Started

### Prerequisites
- PHP 8.2+ / 8.3+ & Composer
- MySQL 8.x
- Redis
- Flutter SDK (3.24+)
- Docker & Docker Compose (optional for local containerized dev)

### 1. Backend API Setup
```bash
cd apps/api
cp .env.example .env
composer install
php artisan key:generate
php artisan migrate --seed
php artisan serve --port=8000
```
- API Base: `http://127.0.0.1:8000/api/v1`
- Admin Portal: `http://127.0.0.1:8000/admin`
  - Admin Email: `admin@nutriai.app`
  - Admin Password: `AdminSecret123!`
- Health Endpoint: `http://127.0.0.1:8000/health`

### 2. Mobile App Setup
```bash
cd apps/mobile
flutter pub get

# Run on Web (Chrome)
flutter run -d chrome

# Or run on connected Android/iOS device
flutter run --flavor dev -t lib/main_dev.dart
```
- Demo User: `amit@example.com` / `password123`

---

## 🧪 Testing

- **Backend API Tests:**
  ```bash
  cd apps/api
  php artisan test
  ```
  *(128 feature & unit tests, 676 assertions)*

- **Mobile Tests & Linting:**
  ```bash
  cd apps/mobile
  flutter test
  flutter analyze
  ```
  *(130 unit/widget tests passing, 0 analyzer issues)*

---

## 📜 Documentation

- [System Architecture](docs/ARCHITECTURE.md)
- [REST API Specifications](docs/API.md)
- [Database Schema & Migrations](docs/DATABASE.md)
- [AI Vision Pipeline](docs/AI.md)
- [Security & QA Audit](docs/SECURITY.md)
- [Production Deployment Runbook & Rollback Plan](docs/DEPLOYMENT.md)
- [Privacy Policy](docs/PRIVACY.md) & [Terms of Service](docs/TERMS.md)
- [Health Disclaimer](docs/HEALTH_DISCLAIMER.md)

---

## 📄 License
Proprietary & Confidential. All rights reserved.
