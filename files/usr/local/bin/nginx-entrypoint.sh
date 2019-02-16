#!/bin/bash
set -e
set -x

NGINX_CONF=/etc/nginx/conf.d/app.conf

# poor man's interpolation engine
sed -i -e 's|${CERT_PATH}|'"$CERT_PATH"'|' -e 's|${WEBDAV_DOMAIN}|'"$WEBDAV_DOMAIN"'|' $NGINX_CONF

htpasswd -bc /etc/nginx/htpasswd $WEBDAV_USERNAME $WEBDAV_PASSWORD

exec nginx -g 'daemon off;'
