#!/bin/bash
PROGNAME=$(basename $0)

set -ex

## import system information vars
. /etc/os-release 

## disable screen requests
DEBIAN_FRONTEND=noninteractive 

## set timezone
TZ=America/Sao_Paulo
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

apt-get -y update
apt-get -y upgrade
apt-get -y install tzdata supervisor apt-utils vim watch sngrep nano cron locales openssh-server ipset iptables fail2ban sqlite3

mkdir -p /var/log/supervisor

./build-asterisk.sh

./build-postinstall.sh

apt-get clean

exec rm -f /build-postinstall.sh
exec rm -f /build-start.sh

