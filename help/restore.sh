#!/bin/bash

source "../$(dirname "$0")/.env"

# Check backup exists
[ ! -f "${BACKUP_DIR}/backup.sql.gz" ] && echo "ERROR: Backup not found." && exit 1

# Check container running
docker ps | grep -q openproject-db || { echo "ERROR: Container not running."; exit 1; }
# Restore
gunzip < "${BACKUP_DIR}/backup.sql.gz" | docker exec -i openproject-db psql -U "${DB_USER}" -d "${DB_NAME}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Restore done."