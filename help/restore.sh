#!/bin/bash

source .env

# Check backups exist
[ ! -f "${BACKUP_DIR}/db.sql.gz" ] && echo "ERROR: DB backup not found." && exit 1
[ ! -f "${BACKUP_DIR}/files.tar.gz" ] && echo "ERROR: Files backup not found." && exit 1
# Check container running
docker ps | grep -q openproject-db || { echo "ERROR: Container not running."; exit 1; }

gunzip < "${BACKUP_DIR}/db.sql.gz" | docker exec -i openproject-db psql -U "${DB_USER}" -d "${DB_NAME}"
docker exec -i openproject-app sh -c "rm -rf /var/openproject/assets/* && tar xzf - -C /var/openproject/assets" < "${BACKUP_DIR}/files.tar.gz"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Restore done."