ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN \
  apkArch="$(apk --print-arch)"; \
  case "${apkArch}" in \
    x86_64) export CFARCH="amd64" ;; \
    armhf) export CFARCH="arm" ;; \
    x86) export CFARCH="386" ;; \
    aarch64) export CFARCH="arm64" ;; \
    *) export CFARCH="${apkArch}" ;; \
  esac && \
  apk add --no-cache wget python3 && \
  wget --no-hsts -O /usr/bin/cloudflared "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${CFARCH}" && \
  chmod a+x /usr/bin/cloudflared

WORKDIR /data
COPY run.sh /

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]