#!/bin/bash
# Boot script for Apache Answer on Railway.
#  - one volume at /data holds config, the SQLite database, uploads and cache, so redeploys keep everything
#  - Railway mounts volumes owned by root; this image runs as root, so write-test the mount and fail loudly if it is not writable
#  - `answer init` installs from the AUTO_INSTALL environment variables on first boot only (admin user, site URL, SQLite)
#  - the listen address is rewritten on every boot to Railway's injected PORT, because Railway's HTTP healthcheck
#    dials that port and the config file written at first boot would otherwise pin a stale one
set -eu

DATA=/data
: "${ADMIN_PASSWORD:?ADMIN_PASSWORD must be set (the template generates it)}"
: "${SITE_URL:?SITE_URL must be set (the template sets https://RAILWAY_PUBLIC_DOMAIN)}"
PORT="${PORT:-8080}"

mkdir -p "$DATA"
echo "[railway] volume $DATA owner uid=$(stat -c %u "$DATA")"
if ! ( touch "$DATA/.write-test" && rm -f "$DATA/.write-test" ); then
  echo "[railway] FATAL: $DATA is not writable"; exit 1
fi

export SITE_ADDR=":$PORT"
/usr/bin/answer init
CONF="$DATA/conf/config.yaml"
if [ ! -s "$CONF" ]; then
  echo "[railway] FATAL: $CONF was not created; auto-install failed (see log above)"; exit 1
fi
sed -i -E "s|^(    addr: ).*|\1:${PORT}|" "$CONF"
echo "[railway] listening on :$PORT, public URL $SITE_URL"
/usr/bin/answer upgrade
exec /usr/bin/answer run -C "$DATA/"
