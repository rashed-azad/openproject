## Step 1: Navigate to Project Directory

```bash
cd ~/openproject
```

---

## Step 2: Install docker-compose Binary

```bash
cd ~/openproject/mother
chmod +x docker-compose
sudo xattr -rd com.apple.quarantine docker-compose
sudo cp docker-compose /opt/local/bin/docker-compose
```

Verify:
```bash
docker-compose --version
```

---

## Step 3: Start Colima

```bash
colima start --cpu 2 --memory 3
```

---

## Step 4: Create .env File

```bash
cd ~/openproject
cat > .env << 'EOF'
DB_USER=openproject_user
DB_PASSWORD=your_password_here
DB_NAME=openproject
SECRET_KEY_BASE=generate_below
HOST_NAME=localhost
APP_PORT=8081
BACKUP_DIR=/your/backup/path
EOF
```

Generate SECRET_KEY_BASE:
```bash
openssl rand -hex 32
```

Copy output and replace `generate_below` in `.env`.

---

## Step 5: Start Containers

```bash
docker-compose up -d
sleep 60
docker-compose ps
```

Both should show **Up**.

---

## Step 6: Access OpenProject

```
http://localhost:8081
```

---

## Step 7: Activate User Account

```bash
docker-compose exec openproject bundle exec rails runner "User.update_all(status: 1, admin: true)"
```

---

## Daily Commands

### Start
```bash
docker-compose up -d
```

### Stop
```bash
docker-compose down
```

### Logs
```bash
docker-compose logs openproject
```

### Status
```bash
docker-compose ps
```

---

## Configuration

### Change Port

Edit `.env`, change `APP_PORT`, restart.

### Access from Network

Edit `.env`:
```
HOST_NAME=192.168.x.x
```

---

## Backup & Restore

All scripts are inside `help/` folder. Run from project root:

### Backup
```bash
./help/backup.sh
```

### Restore
```bash
./help/restore.sh
```

### Drop Database (before restore on existing install)
```bash
./help/drop_db.sh
```

### Setup Hourly Backup (cron)
```bash
crontab -e
```

Add:
```
0 * * * * cd ~/openproject && ./help/backup.sh >> ${BACKUP_DIR}/backup.log 2>&1
```

---

## Troubleshooting

### Reset Password

```bash
docker-compose exec openproject bundle exec rails runner "User.find_by(login: 'username').update(password: 'newpass', password_confirmation: 'newpass')"
```

---