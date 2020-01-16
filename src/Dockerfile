# vim:set ft=dockerfile:
FROM centos:7

LABEL maintainer="Matheus Machado Guerzoni Duarte <matheus.duarte@leucotron.com.br>"

ENV ASTERISK_VERSION 17.1.0

COPY build-asterisk.sh /
RUN /build-asterisk.sh

EXPOSE 5060/udp 5060/tcp 10000-20000/udp
VOLUME /var/lib/asterisk/sounds /var/lib/asterisk/keys /var/lib/asterisk/phoneprov /var/spool/asterisk /var/log/asterisk

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddf", "-c", "-T", "-W", "-U", "asterisk", "-p"]
