#!/bin/bash

source "../$(dirname "$0")/.env"

docker-compose stop openproject
docker exec -i openproject-db psql -U "${DB_USER}" -d postgres -c "DROP DATABASE ${DB_NAME};"
docker exec -i openproject-db psql -U "${DB_USER}" -d postgres -c "CREATE DATABASE ${DB_NAME};"
docker-compose start openproject

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Database dropped."