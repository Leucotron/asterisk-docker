#!/bin/bash
PROGNAME=$(basename $0)

if test -z ${ASTERISK_VERSION}; then
  echo "${PROGNAME}: ASTERISK_VERSION required" >&2
  exit 1
fi

set -ex

# Set Timezone to Sao_Paulo
rm -f /etc/localtime
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

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
curl -vL http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-${ASTERISK_VERSION}.tar.gz | tar --strip-components 1 -xz

# 1.5 jobs per core works out okay
: ${JOBS:=$(($(nproc) + $(nproc) / 2))}

mkdir -p /etc/asterisk/

./contrib/scripts/install_prereq install

./configure --libdir=/usr/lib64 --with-pjproject-bundled --with-jansson-bundled
make menuselect/menuselect menuselect-tree menuselect.makeopts

# we don't need any sounds in docker, they will be mounted as volume
menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts
menuselect/menuselect --disable pbx_ael menuselect.makeopts

menuselect/menuselect --enable codec_opus menuselect.makeopts
menuselect/menuselect --enable codec_silk menuselect.makeopts
menuselect/menuselect --enable codec_siren7 menuselect.makeopts
menuselect/menuselect --enable codec_siren14 menuselect.makeopts
menuselect/menuselect --enable codec_g729a menuselect.makeopts
menuselect/menuselect --enable CORE-SOUNDS-EN-WAV menuselect.makeopts
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

# Install opus, for some reason menuselect option above does not working
mkdir -p /usr/src/codecs/opus &&
  cd /usr/src/codecs/opus &&
  curl -vsL http://downloads.digium.com/pub/telephony/codec_opus/${OPUS_CODEC}.tar.gz | tar --strip-components 1 -xz &&
  cp *.so /usr/lib64/asterisk/modules/ &&
  cp codec_opus_config-en_US.xml /var/lib/asterisk/documentation/

# Codec g729, it depends of processors, please verify before install
#mkdir -p /usr/src/codecs/g729 &&
#  cd /usr/src/codecs/g729 &&  
#  wget http://asterisk.hosting.lv/bin/${G729_CODEC}.so &&
#  cp *.so /usr/lib64/asterisk/modules/

chown -R asterisk:asterisk /etc/asterisk \
  /var/*/asterisk \
  /usr/*/asterisk \
  /usr/lib64/asterisk
chmod -R 750 /var/spool/asterisk

cd /
rm -rf /usr/src/asterisk \
  /usr/src/codecs

yum -y clean all
rm -rf /var/cache/yum/*

exec rm -f /build-asterisk.sh
