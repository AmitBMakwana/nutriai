#!/bin/sh
set -e

# ==============================================================================
# NutriAI Automated Database Backup Script
# Creates a compressed MySQL dump and archives to S3-compatible object storage
# ==============================================================================

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/tmp/backups"
BACKUP_FILE="${BACKUP_DIR}/nutriai_backup_${TIMESTAMP}.sql.gz"

echo "=== Starting NutriAI Database Backup [${TIMESTAMP}] ==="

mkdir -p "${BACKUP_DIR}"

# 1. Perform consistent mysqldump with gzip compression
echo "[1/3] Dumping database '${DB_DATABASE}' from '${DB_HOST}'..."
mysqldump \
    --host="${DB_HOST:-mysql}" \
    --port="${DB_PORT:-3306}" \
    --user="${DB_USERNAME:-nutriai}" \
    --password="${DB_PASSWORD}" \
    --single-transaction \
    --quick \
    --skip-lock-tables \
    --routines \
    --triggers \
    "${DB_DATABASE:-nutriai}" | gzip -9 > "${BACKUP_FILE}"

BACKUP_SIZE=$(du -h "${BACKUP_FILE}" | cut -f1)
echo "[2/3] Backup created: ${BACKUP_FILE} (Size: ${BACKUP_SIZE})"

# 2. Upload to S3 if AWS credentials and bucket are configured
if [ -n "${AWS_BUCKET}" ] && [ -n "${AWS_ACCESS_KEY_ID}" ]; then
    echo "[3/3] Uploading backup to s3://${AWS_BUCKET}/backups/..."
    aws s3 cp "${BACKUP_FILE}" "s3://${AWS_BUCKET}/backups/nutriai_backup_${TIMESTAMP}.sql.gz" \
        ${AWS_ENDPOINT_URL:+--endpoint-url "${AWS_ENDPOINT_URL}"}
    echo "Backup successfully uploaded to S3."
else
    echo "[3/3] S3 credentials not provided. Storing locally in ${BACKUP_FILE}."
fi

# 3. Cleanup local backups older than 7 days
find "${BACKUP_DIR}" -type f -name "nutriai_backup_*.sql.gz" -mtime +7 -delete

echo "=== Database Backup Completed Successfully ==="
