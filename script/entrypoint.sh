#!/bin/sh
set -e

#BASE_URL_ESCAPED=$(echo $BASE_URL | sed 's|\.|\\\\.|g')
#sed -i "s|BASE_URL|$BASE_URL_ESCAPED|g" /etc/nginx/nginx.conf
#sed -i "s|DNS_RESOLVER|$DNS_RESOLVER|g" /etc/nginx/nginx.conf
/data/script/createConfigs.sh

exec "$@"