#!/bin/bash
#Ethan Emmons
#Purpose: This script restores a backup file back to the file system
#Last Revision Date: 12/5/21
#Variables: 
#COMPRESSION: compression method
#EMAIL: email to send logs to
#BACKUP_TARGET: where to store backup
#TARGET_TYPE: filesystem for BACKUP_TARGET
#TARGET_SERVER: DNS/IP of target server
#TARGET_FS: mount point of the BACKUP_TARGET
#USER: username of the SMB share
#PASSWORD: password of the SMB share

#store user file that user entered
BACKUP_FILE=$1
#REGEX to match lines that do not start with a # and contains an =
eval "$(grep '^[^#]*?*=?*' backup.conf)"
#REGEX match lines that d not start with # and contains a :
RAW_ENTRIES=($(grep '^[^#]*?*:?*' backup.conf))

for ENTRY in ${RAW_ENTRIES[@]}
do
if [[ $(echo $ENTRY | cut -d: -f1) == $(echo $BACKUP_FILE | cut -d. -f2) ]]
then
    read -p "Are you sure you want to restore from backup? Existing files will be overwritten. [Y/N]: " RESP
    if [[ $RESP == "Y" ]]
    then
        tar --overwrite -xzf $1 -C /
        echo "Restore completed!"
    else
        echo "Restore canceled!"
    fi
fi
done