#!/bin/bash
PROGNAME=$(basename $0)

if test -z ${ASTERISK_VERSION}; then
  echo "${PROGNAME}: ASTERISK_VERSION required" >&2
  exit 1
fi

set -ex

# O setup de timezone foi removido para manter a configuração em GMT0
# Set Timezone to Sao_Paulo
# rm -f /etc/localtime
# ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

useradd --system asterisk

## import system information vars
. /etc/os-release 

DEBIAN_FRONTEND=noninteractive 

TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

apt-get -y update
apt-get -y upgrade

apt-get install -y tzdata

apt-get -y install debconf-utils && \
        echo "libvpb1 libvpb1/countrycode string 55" | debconf-set-selections && \
        echo "tzdata tzdata/Areas select Etc"        | debconf-set-selections && \
        echo "tzdata tzdata/Zones/Etc select UTC"    | debconf-set-selections && \
        echo "Etc/UTC" > /etc/timezone && \
        export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
        apt-get -y install gosu libcap2 libedit2 libjansson4 libpopt0 libsqlite3-0 libssl1.1 libsystemd0 liburiparser1 libuuid1 libxml2 libxslt1.1 \
            libjack0 libresample1 libodbc1 libpq5 libsdl1.2debian libcurl4 libgsm1 liblua5.1-0 libgmime-3.0-0 libical3 libiksemel3 libneon27-gnutls \
            libportaudio2 libpri1.4 libradcli4 libspandsp2 libspeex1 libspeexdsp1 libsqlite0 libsrtp2-1 libss7-2.0 libsybdb5 libtonezone2.0 libvorbisfile3 && \
        apt-get clean

apt-get install -y build-essential

apt-get install -y curl git-core subversion wget libjansson-dev sqlite autoconf automake libxml2-dev libncurses5-dev libtool

mkdir -p /usr/src/asterisk

cd /usr/src/asterisk
curl -vL http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-${ASTERISK_VERSION}.tar.gz | tar --strip-components 1 -xz

# patch para atualização do MAXPTIME em relação as exigências da VIVO
# wget https://arquivos.leucotron.com.br/update/patch/asterisk/18/main/codec_builtin.c 
# cp codec_builtin.c ./main/codec_builtin.c

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

apt-get clean

exec rm -f /build-asterisk.sh
