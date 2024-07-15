#!/bin/bash
PROGNAME=$(basename $0)

echo "Create backup dir"
mkdir -p /backup/etc/asterisk
mkdir -p /backup/var/lib/asterisk
mkdir -p /backup/var/log/supervisor
mkdir -p /backup/var/log/asterisk
mkdir -p /backup/var/spool/asterisk
mkdir -p /backup/var/lib/fail2ban
mkdir -p /backup/etc/fail2ban
mkdir -p /backup/var/log/fail2ban

echo "Create backup files"
cp -r /etc/asterisk /backup/etc
cp -r /var/lib/asterisk /backup/var/lib
cp -r /var/log/supervisor /backup/var/log
cp -r /var/log/asterisk /backup/var/log
cp -r /var/spool/asterisk /backup/var/spool
cp -r /var/lib/fail2ban /backup/var/lib
cp -r /etc/fail2ban /backup/etc
cp -r /var/log/fail2ban /backup/var/log

echo "Create data dir"
mkdir -p /data/etc/asterisk
mkdir -p /data/var/lib/asterisk
mkdir -p /data/var/log/supervisor
mkdir -p /data/var/log/asterisk
mkdir -p /data/var/spool/asterisk
mkdir -p /data/var/lib/fail2ban
mkdir -p /data/etc/fail2ban
mkdir -p /data/var/log/fail2ban

echo "Create data file"
cp -r /backup/etc/asterisk /data/etc
cp -r /backup/var/lib/asterisk /data/var/lib
cp -r /backup/var/log/supervisor /data/var/log
cp -r /backup/var/log/asterisk /data/var/log
cp -r /backup/var/spool/asterisk /data/var/spool
cp -r /backup/var/lib/fail2ban /data/var/lib
cp -r /backup/etc/fail2ban /data/etc
cp -r /backup/var/log/fail2ban /data/var/log

chmod 777 -R /data

echo "Create dynamic links"
rm -rf /etc/asterisk 
ln -s /data/etc/asterisk /etc/asterisk

rm -rf /var/lib/asterisk
ln -s /data/var/lib/asterisk /var/lib/asterisk

rm -rf /var/log/supervisor
ln -s /data/var/log/supervisor /var/log/supervisor 
    
rm -rf /var/log/asterisk
ln -s /data/var/log/asterisk /var/log/asterisk 

rm -rf /var/spool/asterisk
ln -s /data/var/spool/asterisk /var/spool/asterisk 

rm -rf /var/lib/fail2ban
ln -s /data/var/lib/fail2ban /var/lib/fail2ban

rm -rf /etc/fail2ban 
ln -s /data/etc/fail2ban /etc/fail2ban

rm -rf /var/log/fail2ban
ln -s /data/var/log/fail2ban /var/log/fail2ban 