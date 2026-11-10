# answer-railway

Wrapper image for [Apache Answer](https://github.com/apache/answer) (a Q&A platform with a REST API) on Railway.

The upstream image is pinned by digest. The wrapper adds an entrypoint and baked defaults that:

- install Answer from environment variables on first boot (`AUTO_INSTALL`), so the admin account exists before the first request and there is no setup wizard to claim,
- store everything (config, SQLite database, uploads, cache) on the volume at `/data`, write-tested at every boot,
- rewrite the listen address to Railway's injected `PORT` on every boot (Railway's HTTP healthcheck dials it).

Mount one volume at `/data`. Set `ADMIN_PASSWORD` and `SITE_URL`. Published as `ghcr.io/bon5co/answer-railway`. Used by the Railway template "Apache Answer".
