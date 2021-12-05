#!/bin/bash
#Ethan Emmons
#Purpose: This script reads a configuration file and automates backups of directories
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

#store user entered backup entry target
BACKUP_NAME=$1
#REGEX to match lines that do not start with a # and contains an =
eval "$(grep '^[^#]*?*=?*' backup.conf)"
#REGEX match lines that d not start with # and contains a :
RAW_ENTRIES=($(grep '^[^#]*?*:?*' backup.conf))

compress(){
    #function that compresses the files and stores the compressed files in a log file
    if [[  $1 == "gzip"  ]]
    then
    DATE=$(date +'%Y-%m-%d.%H:%M')
    echo "BACKUP MADE ON: $DATE" > /var/log/backup/$BACKUP_NAME.$DATE
    tar -czvf "$BACKUP_TARGET/$HOSTNAME.$BACKUP_NAME.$DATE.tar.gz" $2 1>> /var/log/backup/$BACKUP_NAME.$DATE 2>/dev/null
    else
    echo "Unsupported compression method: $1"
    fi
}

#iterate through the matches lines and check if the first field equals the user entered backup name
for ENTRY in ${RAW_ENTRIES[@]}
do
if [[ $(echo $ENTRY | cut -d: -f1) == $BACKUP_NAME ]]
then
    if [[ ! -d $BACKUP_TARGET ]]; then mkdir $BACKUP_TARGET; fi
    if [[ ! -d /var/log/backup ]]; then mkdir /var/log/backup; fi
    compress $COMPRESSION $(echo $ENTRY | cut -d: -f2)
fi
done
echo "Backup complete!"