# vim:set ft=dockerfile:
FROM debian:12

ENV APP_VER=20.9.3
#ENV APP_VER=18.24.3
#ENV APP_VER=21.4.3

LABEL maintainer="Afonso Henrique Moreira Magalhaes <afonso@leucotron.com.br>"

ENV ASTERISK_VERSION=20.9.3
ENV OPUS_ASTERISK_VERSION=asterisk-20.0/x86-64
ENV OPUS_CODEC=codec_opus-20.0_current-x86_64

# ENV ASTERISK_VERSION=18.24.3
# ENV OPUS_ASTERISK_VERSION=asterisk-18.0/x86-64
# ENV OPUS_CODEC=codec_opus-18.0_current-x86_64

# ENV ASTERISK_VERSION=21.4.3
# ENV OPUS_ASTERISK_VERSION=asterisk-21.0/x86-64
# ENV OPUS_CODEC=codec_opus-21.0-current-x86_64

ADD rootfs /
COPY build-asterisk.sh /
COPY build-postinstall.sh /
COPY build-start.sh /
RUN /build-start.sh

EXPOSE 5060/udp 5060/tcp 10000-20000/udp
VOLUME /var/lib/asterisk/sounds /var/lib/asterisk/keys /var/spool/asterisk /var/log/asterisk /var/log/supervisor

CMD ["/usr/bin/supervisord"]