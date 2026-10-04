# NutriAI Production Deployment & Operations Runbook

This document defines the deployment architecture, step-by-step release procedures, disaster recovery/backup strategies, monitoring guidelines, and mobile app store submission checklist for **NutriAI**.

---

## 1. Production Architecture Overview

```
                                [ Cloudflare / CDN ]
                                         │ (HTTPS / TLS 1.3)
                                         ▼
                            [ Nginx Reverse Proxy / ALB ]
                                         │
                 ┌───────────────────────┴───────────────────────┐
                 │                                               │
                 ▼                                               ▼
         [ NutriAI API Container ]                      [ Static / Storage ]
      • PHP 8.3-FPM + Nginx                              • AWS S3 Bucket
      • Supervisor Worker (Queues)                       • Private Presigned URLs
      • Supervisor Scheduler (Cron)
                 │
      ┌──────────┴──────────┐
      ▼                     ▼
[ MySQL 8 Cluster ]    [ Redis Cluster ]
• Managed RDS          • Cache, Sessions, Quotas, Queues
• Automated Backups    • High Availability
```

### Server Components
- **API Runtime:** Multi-stage Docker image (`docker/Dockerfile.api`) containing PHP 8.3-FPM and Nginx.
- **Background Worker & Scheduler:** Managed via `docker/supervisord.conf` running `artisan queue:work --tries=3` and `artisan schedule:run`.
- **Caches & Queues:** Redis 7 with password authentication and `redis_cache` / `redis_queue` database separation.
- **Relational Storage:** MySQL 8 with InnoDB engine, utf8mb4 charset, and read-replica support.
- **Object Storage:** S3-compatible private bucket with strict CORS and short-lived presigned download URLs for user meal images.

---

## 2. Server Provisioning & Environment Configuration

### Required Secrets & Environment Variables (`.env.production`)
Ensure the following variables are securely injected via secret management (e.g., AWS Secrets Manager, GitHub Secrets, or HashiCorp Vault):

```bash
APP_NAME=NutriAI
APP_ENV=production
APP_KEY=base64:... # Generate via `php artisan key:generate`
APP_DEBUG=false
APP_URL=https://api.nutriai.app

# Database
DB_CONNECTION=mysql
DB_HOST=10.0.1.20
DB_PORT=3306
DB_DATABASE=nutriai_prod
DB_USERNAME=nutriai_app
DB_PASSWORD="<STRONG_RANDOM_PASSWORD>"

# Cache & Queues
CACHE_STORE=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis
REDIS_HOST=10.0.1.30
REDIS_PASSWORD="<STRONG_REDIS_PASSWORD>"

# Storage
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID="<IAM_ACCESS_KEY>"
AWS_SECRET_ACCESS_KEY="<IAM_SECRET_KEY>"
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=nutriai-prod-storage

# AI & RevenueCat Secrets
AI_PROVIDER=gemini
GEMINI_API_KEY="<GEMINI_PRODUCTION_KEY>"
REVENUECAT_WEBHOOK_SECRET="<REVENUECAT_SECRET>"

# Observability
LOG_CHANNEL=stack
LOG_STACK=json,sentry
SENTRY_LARAVEL_DSN="https://<sentry_key>@o0.ingest.sentry.io/<project_id>"
SENTRY_TRACES_SAMPLE_RATE=0.2
```

---

## 3. Step-by-Step Deployment Runbook

### Step 3.1: Automated CI/CD (GitHub Actions)
Deployments to staging and production are automatically triggered when merging to `staging` or `main` branches via `.github/workflows/deploy.yml`:
1. Build & test suite run (100% test pass requirement).
2. Docker image build and push to container registry (e.g., ECR/GHCR) tagged with commit SHA and `latest`.
3. Blue/Green or Rolling container update.
4. Database migrations executed with `--force`.
5. Configuration, route, and view caches generated.
6. Health check verification (`GET /health`).

### Step 3.2: Manual CLI Deployment Runbook
If deploying manually via SSH or direct server orchestration:

```bash
# 1. Pull latest code or tagged Docker image
cd /opt/nutriai
git fetch origin main && git checkout $(git describe --tags --abbrev=0)

# 2. Build or pull images
docker compose -f docker-compose.prod.yml pull

# 3. Run zero-downtime database migrations
docker compose -f docker-compose.prod.yml run --rm api php artisan migrate --force

# 4. Refresh application caches
docker compose -f docker-compose.prod.yml run --rm api php artisan config:cache
docker compose -f docker-compose.prod.yml run --rm api php artisan route:cache
docker compose -f docker-compose.prod.yml run --rm api php artisan view:cache
docker compose -f docker-compose.prod.yml run --rm api php artisan event:cache

# 5. Reload containers
docker compose -f docker-compose.prod.yml up -d --no-deps api

# 6. Restart background queue workers
docker compose -f docker-compose.prod.yml exec api supervisorctl restart laravel-worker:*

# 7. Verify system health
curl -f https://api.nutriai.app/health
```

---

## 4. Rollback Plan

If an unexpected critical failure occurs post-deployment:

### Immediate Rollback (Under 3 Minutes)
```bash
# 1. Revert container image to previous tag
export PREVIOUS_TAG="v1.0.4"
sed -i "s/IMAGE_TAG=.*/IMAGE_TAG=${PREVIOUS_TAG}/" .env

# 2. Re-deploy previous container image
docker compose -f docker-compose.prod.yml up -d --no-deps api

# 3. Roll back database migrations (if schema migration caused regression)
docker compose -f docker-compose.prod.yml run --rm api php artisan migrate:rollback --step=1

# 4. Clear/rebuild cache
docker compose -f docker-compose.prod.yml run --rm api php artisan optimize:clear
docker compose -f docker-compose.prod.yml run --rm api php artisan config:cache
docker compose -f docker-compose.prod.yml run --rm api php artisan route:cache

# 5. Restart queue workers
docker compose -f docker-compose.prod.yml exec api supervisorctl restart laravel-worker:*

# 6. Verify health
curl -f https://api.nutriai.app/health
```

---

## 5. Database Backup & Disaster Recovery Strategy

1. **Automated Daily Backups:**
   Executed via cron running `docker/backup.sh`:
   - Daily snapshots at 02:00 UTC.
   - Encrypted with GPG and uploaded directly to an off-site, immutable S3 bucket with Object Lock enabled.
   - 30-day retention on daily backups; 12-month retention on monthly archives.
2. **Point-in-Time Recovery (PITR):**
   MySQL Binary Logging (binlog) enabled with 7-day retention for point-in-time restoration.
3. **Restoration Drill:**
   ```bash
   gunzip < backup_nutriai_20261003.sql.gz | mysql -u root -p nutriai_recovery
   ```

---

## 6. Health Check, Monitoring & Alerting

### Health Endpoint
- **URL:** `GET /health`
- **Output:**
  ```json
  {
    "status": "ok",
    "timestamp": 1790900000,
    "services": {
      "database": "connected",
      "redis": "connected",
      "storage": "writable"
    },
    "version": "1.0.0"
  }
  ```
- **Uptime Monitoring:** Pingdom / BetterStack monitors `https://api.nutriai.app/health` at 30-second intervals. Alert triggers if status != 200 for 2 consecutive checks.

### Sentry Error Tracking
- Uncaught exceptions in Laravel trigger Sentry alerts in the `#ops-alerts` Slack/Discord channel.
- Performance tracing configured at 10-20% sample rate to trace slow queries and external AI API latency.

---

## 7. Flutter Mobile Release & Store Checklist

### Flavors
The mobile app supports three distinct flavor entry points:
- **Dev:** `lib/main_dev.dart` (target: local/staging API, debug logging enabled)
- **Staging:** `lib/main_staging.dart` (target: `https://staging-api.nutriai.app`)
- **Prod:** `lib/main_prod.dart` (target: `https://api.nutriai.app`, release obfuscation, Sentry reporting)

### Android Release Build
```bash
cd apps/mobile

# Build Android App Bundle (AAB) with code obfuscation and split debug symbols
flutter build appbundle \
  --target=lib/main_prod.dart \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

### iOS Release Build
```bash
cd apps/mobile

# Build iOS archive with code obfuscation and split debug symbols
flutter build ipa \
  --target=lib/main_prod.dart \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/ios/outputs/symbols
```

### Store Submission Checklist

#### Google Play Store (Android)
- [ ] Version code bumped in `pubspec.yaml` (e.g., `1.0.0+1`).
- [ ] Keystore configured in environment (`KEYSTORE_PATH`, `KEYSTORE_PASSWORD`, etc.).
- [ ] Target SDK updated to latest Android requirement (API 34+).
- [ ] Data safety questionnaire completed (Camera permission for meal recognition, analytics, account authentication).
- [ ] Privacy Policy URL set: `https://nutriai.app/privacy`.
- [ ] Health disclaimer displayed in onboarding & store listing.
- [ ] De-obfuscation symbol files (`build/app/outputs/symbols`) uploaded to Play Console.

#### Apple App Store (iOS)
- [ ] App bundle identifier: `com.nutriai.nutriai`.
- [ ] Camera (`NSCameraUsageDescription`) and Photo Library (`NSPhotoLibraryUsageDescription`) strings verified in `Info.plist`.
- [ ] Apple Privacy Nutrition Labels declared (Contact Info, User Content, Diagnostics).
- [ ] StoreKit / In-App Purchase products configured in App Store Connect matching RevenueCat identifiers (`nutriai_pro_monthly`, `nutriai_pro_yearly`).
- [ ] dSYM symbol files uploaded to Sentry / App Store Connect.
- [ ] Sign in with Apple requirement evaluated (or email/password auth properly validated with delete account capability).
- [ ] Health-estimates disclaimer clearly accessible in app settings and store description.
