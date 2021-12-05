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

#store user entered backup entry target
BACKUP_NAME=$1

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
echo "Home directories: ${HOME_ENTRIES[@]}" | tr '\n' ' '
echo -e "\n\n"

#REGEX match lines that d not start with # and contains a :
RAW_ENTRIES=($(grep '^[^#]*?*:?*' backup.conf))
#iterate through the matches lines and check if the first field equals the user entered backup name
for ENTRY in ${RAW_ENTRIES[@]}
do
if [[ $(echo $ENTRY | cut -d: -f1) == $BACKUP_NAME ]]
then
    if [[ ! -f /backup ]]
    then
    echo cow
    fi
    compress $COMPRESSION
fi
done

compress(){
    if [[  $COMPRESSION == "gzip"  ]]
    then
    # tar -czf "$HOSTNAME.$BACKUP_NAME.tar.gz"
    DATE=$(date +'%Y-%m-%d.%H:%M')
    echo "$HOSTNAME.$BACKUP_NAME.$DATE.tar.gz"
    else
    echo "Unsupported compression method: $COMPRESSION"
    fi
}

compress