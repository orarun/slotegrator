#!/bin/bash

# Default values
backup_dir="~/backup"
user="user"
remote_server="remote_ip"
debug_mode=false
remote_dirs="/remote/backup_dir1 /remote/backup_dir2"
backup_type="full"

# Function to display help
display_help() {
    echo "Usage: $0 [-b <backup_dir>] [-u <user>] [-r <remote_server>] [-d] [-d <remote_dirs>] [-t <backup_type>] [-h]"
    echo "-b: Set backup directory (default: ~/backup)"
    echo "-u: Set user (default: user)"
    echo "-r: Set remote server's IP (default: remote_ip)"
    echo "-d: Enable debug mode (default: false)"
    echo "-s: Set backup directories on remote server (default: /remote/backup_dir1 /remote/backup_dir2)"
    echo "-t: Set backup type: full or inc (incremental) (default: full)"
    echo "-h: Display help"
}

# Process command line arguments
while getopts ":b:u:r:ds:t:h" opt; do
    case $opt in
        b)
            backup_dir=$OPTARG
            ;;
        u)
            user=$OPTARG
            ;;
        r)
            remote_server=$OPTARG
            ;;
        d)
            debug_mode=true
            ;;
        s)
            remote_dirs=$OPTARG
            ;;
        t)
            backup_type=$OPTARG
            ;;
        h)
            display_help
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Connect to remote server and copy files
if [[ $debug_mode == true ]]; then
    echo "Connecting to $remote_server as $user..."
fi

# Copy files from remote server to local host
if [[ $backup_type == "full" ]]; then
    rsync -avz --progress -e "ssh -o StrictHostKeyChecking=no" $user@$remote_server:$remote_dirs $backup_dir
elif [[ $backup_type == "inc" ]]; then
    rsync -avz --progress --backup --suffix=_$(date +%Y%m%d%H%M%S) -e "ssh -o StrictHostKeyChecking=no" $user@$remote_server:$remote_dirs $backup_dir
else
    echo "Invalid backup type: $backup_type. Please choose 'full' or 'inc'."
    exit 1
fi

# Rotate old backup files
sudo logrotate -f /etc/logrotate.d/backup

# Print completion message
if [[ $debug_mode == true ]]; then
    echo "Backup completed successfully!"
fi
