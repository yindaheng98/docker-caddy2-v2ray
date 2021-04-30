FROM --platform=${TARGETPLATFORM} caddy:alpine
LABEL maintainer "V2Fly Community <dev@v2fly.org>"

WORKDIR /root
ARG TARGETPLATFORM
ARG TAG
COPY v2ray.sh /root/v2ray.sh

RUN set -ex \
	&& apk add --no-cache tzdata openssl ca-certificates supervisor \
	&& mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray \
	&& chmod +x /root/v2ray.sh \
	&& /root/v2ray.sh "${TARGETPLATFORM}" "${TAG}"
	
COPY supervisord.conf /root/supervisord.conf

VOLUME /etc/v2ray
CMD [ "supervisord", "-c", "/root/supervisord.conf", "-e", "debug" ]
