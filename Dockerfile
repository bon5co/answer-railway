# Apache Answer for Railway.
# Upstream pinned by digest. Installation runs from environment variables (AUTO_INSTALL), so there is no
# setup wizard to claim: the admin account exists before the first request. The wrapper entrypoint
# write-tests the Railway volume, binds Railway's injected PORT (the healthcheck dials it) and starts Answer.
FROM apache/answer@sha256:5ff4b4757366f74c4afaed6244b4da5c91c5b3eb1f58c68c8faecd3a456b89af

ENV AUTO_INSTALL=true \
    DB_TYPE=sqlite3 \
    DB_FILE=/data/answer.db \
    LANGUAGE=en_US \
    SITE_NAME=Answer \
    ADMIN_NAME=admin \
    ADMIN_EMAIL=admin@example.com \
    CONTACT_EMAIL=admin@example.com \
    EXTERNAL_CONTENT_DISPLAY=ask_before_display \
    TIMEZONE=UTC

COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod 755 /usr/local/bin/railway-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
