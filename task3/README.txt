Backup script

First set the username and group in the "backup" file in the line:
'     create 755 user user'

Copy "backup" file to /etc/logrotate.d with sudo:
$ sudo cp backup /etc/logrotate.d

Create bakup folder (default: ~/backup):
$ mkdir ~/backup

