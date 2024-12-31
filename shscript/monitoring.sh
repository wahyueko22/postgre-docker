#!/bin/bash

# Check if container is running
if ! docker ps | grep -q postgres_db; then
    echo "PostgreSQL container is not running!"
    exit 1
fi

# Check database connection
if ! docker exec postgres_db pg_isready -U myuser -d mydb; then
    echo "Cannot connect to database!"
    exit 1
fi

# Check disk space
DISK_USAGE=$(df -h ~/postgres-docker/data | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 80 ]; then
    echo "Warning: Disk usage is above 80%!"
fi