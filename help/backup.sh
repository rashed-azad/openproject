#!/bin/bash

source .env

mkdir -p "${BACKUP_DIR}"
docker exec openproject-db pg_dump -U "${DB_USER}" -d "${DB_NAME}" | gzip > "${BACKUP_DIR}/db.sql.gz"
docker exec openproject-app tar czf - -C /var/openproject/assets . > "${BACKUP_DIR}/files.tar.gz"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup done: db.sql.gz + files.tar.gz"