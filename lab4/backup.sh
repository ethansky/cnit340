#!/bin/bash
#Ethan Emmons
#Purpose: This script reads a configuration file and automates backups of directories
#Last Revision Date: 12/1/21
#Variables: 
#COMPRESSION: compression method
#EMAIL: email to send logs to
#BACKUP_TARGET: where to store backup
#TARGET_TYPE: filesystem for BACKUP_TARGET
#TARGET_SERVER: DNS/IP of target server
#TARGET_FS: mount point of the BACKUP_TARGET
#USER: username of the SMB share
#PASSWORD: password of the SMB share

#REGEX to match lines that do not start with a # and contains an =
eval "$(grep '^[^#]*?*=?*' backup.conf)"
echo "Compression method: $COMPRESSION"
echo "Email: $EMAIL"
echo "Backup target: $BACKUP_TARGET"
echo "Target type: $TARGET_TYPE"
echo "Target server: $TARGET_SERVER"
echo "Target filesystem: $TARGET_FS"
echo "SMB username: $USER"
echo "SMB password: $PASSWORD"

HOME_ENTRIES=$(grep '^[^#]*?*:?*' backup.conf | cut -d: -f1)
echo -n "Home directories: ${HOME_ENTRIES[@]}" | tr '\n' ' '