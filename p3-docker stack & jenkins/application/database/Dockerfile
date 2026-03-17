FROM postgres:15

# ENV POSTGRES_DB=cinema
# ENV POSTGRES_USER=postgres
# ENV POSTGRES_PASSWORD=postgres

VOLUME ["/var/lib/postgresql/data"]

HEALTHCHECK --interval=10s --timeout=10s --start-period=10s --retries=10 \
  CMD pg_isready -U postgres || exit 1

EXPOSE 5432
