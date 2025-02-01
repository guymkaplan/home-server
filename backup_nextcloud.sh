#!/bin/bash

BACKUP_DIR="/mnt/external"
BACKUP_NAME="nextcloud_backup_$(date +%Y%m%d).7z"
DATA_DIR="/var/snap/nextcloud/common/nextcloud/data"

# Check available space on the backup disk (e.g., 90% full threshold)
THRESHOLD=80
DISK_USAGE=$(df "$BACKUP_DIR" | grep -v Filesystem | awk '{print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -ge "$THRESHOLD" ]; then
    echo "Disk usage is above $THRESHOLD%. Deleting oldest backup."

    # Find and delete the oldest backup (sorted by modification time)
    OLDEST_BACKUP=$(ls -1t $BACKUP_DIR/nextcloud_backup*.7z | tail -n 1)
    rm -f "$OLDEST_BACKUP"
    echo "Deleted oldest backup: $OLDEST_BACKUP"
fi

# Now create the new backup
echo "Creating a new backup: $BACKUP_NAME"
sudo 7z a "$BACKUP_DIR/$BACKUP_NAME" "$DATA_DIR"

echo "Backup completed."
