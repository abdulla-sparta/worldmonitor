#!/bin/sh
set -e
export API_UPSTREAM="${API_UPSTREAM:-https://api.worldmonitor.app}"
# Railway provides PORT dynamically; default to 8080 for Railway compatibility
export PORT="${PORT:-8080}"
envsubst '${API_UPSTREAM} ${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
exec nginx -g "daemon off;"
