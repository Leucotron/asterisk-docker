#!/bin/bash
PROGNAME=$(basename $0)

if test -z ${ASTERISK_VERSION}; then
  echo "${PROGNAME}: ASTERISK_VERSION required" >&2
  exit 1
fi

set -ex

useradd --system asterisk

yum -y install \
  cpp \
  gcc \
  gcc-c++ \
  make \
  ncurses \
  ncurses-devel \
  libxml2 \
  libxml2-devel \
  openssl-devel \
  newt-devel \
  libuuid-devel \
  net-snmp-devel \
  xinetd \
  tar \
  libffi-devel \
  sqlite-devel \
  curl \
  bison

mkdir -p /usr/src/asterisk

cd /usr/src/asterisk
curl -vL http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VERSION}.tar.gz | tar --strip-components 1 -xz

# 1.5 jobs per core works out okay
: ${JOBS:=$(($(nproc) + $(nproc) / 2))}

mkdir -p /etc/asterisk/

./contrib/scripts/install_prereq install
./contrib/scripts/get_mp3_source.sh

./configure --libdir=/usr/lib64 --with-jansson-bundled
make menuselect/menuselect menuselect-tree menuselect.makeopts

# we don't need any sounds in docker, they will be mounted as volume
menuselect/menuselect --disable pbx_ael menuselect.makeopts
menuselect/menuselect --disable CHAN_SIP menuselect.makeopts
menuselect/menuselect --disable CEL_PGSQL menuselect.makeopts
menuselect/menuselect --disable CDR_PGSQL menuselect.makeopts
menuselect/menuselect --disable RES_CONFIG_PGSQL menuselect.makeopts

menuselect/menuselect --enable format_mp3 menuselect.makeopts
menuselect/menuselect --enable codec_opus menuselect.makeopts
menuselect/menuselect --enable codec_silk menuselect.makeopts
menuselect/menuselect --enable codec_siren7 menuselect.makeopts
menuselect/menuselect --enable codec_siren14 menuselect.makeopts
menuselect/menuselect --enable codec_g729a menuselect.makeopts
menuselect/menuselect --enable EXTRA-SOUNDS-EN-WAV menuselect.makeopts

make -j ${JOBS} all
make install

# copy default configs
# cp /usr/src/asterisk/configs/basic-pbx/*.conf /etc/asterisk/
make samples
make dist-clean

# set runuser and rungroup
sed -i -E 's/^;(run)(user|group)/\1\2/' /etc/asterisk/asterisk.conf
sed -i -e 's/# MAXFILES=/MAXFILES=/' /usr/sbin/safe_asterisk

chown -R asterisk:asterisk /etc/asterisk \
  /var/*/asterisk \
  /usr/*/asterisk \
  /usr/lib64/asterisk
chmod -R 750 /var/spool/asterisk

cd /
rm -rf /usr/src/asterisk

yum -y clean all
rm -rf /var/cache/yum/*

exec rm -f /build-asterisk.sh
