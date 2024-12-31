#!/bin/bash

# Backup directory
BACKUP_DIR=~/postgres-docker/backups
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Perform backup
docker exec postgres_db pg_dump -U myuser -d mydb -F c -f /var/lib/postgresql/data/backup_${TIMESTAMP}.backup

# Move backup file
mv ~/postgres-docker/data/backup_${TIMESTAMP}.backup $BACKUP_DIR/

# Keep only last 7 backups
cd $BACKUP_DIR && ls -t | tail -n +8 | xargs -r rm --