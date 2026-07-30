#!/bin/bash

source "../$(dirname "$0")/.env"

mkdir -p "${BACKUP_DIR}"
docker exec openproject-db pg_dump -U "${DB_USER}" -d "${DB_NAME}" | gzip > "${BACKUP_DIR}/backup.sql.gz"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup done: ${BACKUP_DIR}/backup.sql.gz"