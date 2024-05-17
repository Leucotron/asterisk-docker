#!/bin/bash
PROGNAME=$(basename $0)

echo "Create backup dir"
mkdir -p /backup/etc/asterisk
mkdir -p /backup/var/log/supervisor
mkdir -p /backup/var/log/asterisk
mkdir -p /backup/var/spool/asterisk
mkdir -p /backup/var/lib/asterisk/sounds
mkdir -p /backup/var/lib/asterisk/moh

echo "Create backup files"
cp -r /etc/asterisk /backup/etc
cp -r /var/log/supervisor /backup/var/log
cp -r /var/log/asterisk /backup/var/log
cp -r /var/spool/asterisk /backup/var/spool
cp -r /var/lib/asterisk/sounds /backup/var/lib/asterisk
cp -r /var/lib/asterisk/moh /backup/var/lib/asterisk

echo "Create data dir"
mkdir -p /data/etc/asterisk
mkdir -p /data/var/log/supervisor
mkdir -p /data/var/log/asterisk
mkdir -p /data/var/spool/asterisk
mkdir -p /data/var/lib/asterisk/sounds
mkdir -p /data/var/lib/asterisk/moh

echo "Create data file"
cp -r /backup/etc/asterisk /data/etc
cp -r /backup/var/log/supervisor /data/var/log
cp -r /backup/var/log/asterisk /data/var/log
cp -r /backup/var/spool/asterisk /data/var/spool
cp -r /backup/var/lib/asterisk/sounds /data/var/lib/asterisk 
cp -r /backup/var/lib/asterisk/moh /data/var/lib/asterisk

chmod 777 -R /data

echo "Create dynamic links"
rm -rf /etc/asterisk 
ln -s /data/etc/asterisk /etc/asterisk

rm -rf /var/log/supervisor
ln -s /data/var/log/supervisor /var/log/supervisor 
    
rm -rf /var/log/asterisk
ln -s /data/var/log/asterisk /var/log/asterisk 

rm -rf /var/spool/asterisk
ln -s /data/var/spool/asterisk /var/spool/asterisk 

rm -rf /var/lib/asterisk/sounds
ln -s /data/var/lib/asterisk/sounds /var/lib/asterisk/sounds

rm -rf /var/lib/asterisk/moh
ln -s /data/var/lib/asterisk/moh /var/lib/asterisk/moh