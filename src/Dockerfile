# vim:set ft=dockerfile:
FROM centos:7

LABEL maintainer="Matheus Machado Guerzoni Duarte <matheus.duarte@leucotron.com.br>"

ENV ASTERISK_VERSION 16.7.0
ENV OPUS_CODEC asterisk-16.0/x86-64/codec_opus-16.0_1.3.0-x86_64
# Check your processor spec before install
#ENV G729_CODEC codec_g729-ast170-gcc4-glibc-x86_64-core2

COPY build-asterisk.sh /
RUN /build-asterisk.sh

EXPOSE 5060/udp 5060/tcp 10000-20000/udp
VOLUME /var/lib/asterisk/sounds /var/lib/asterisk/keys /var/lib/asterisk/phoneprov /var/spool/asterisk /var/log/asterisk

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddf", "-T", "-W", "-U", "asterisk", "-p"]
