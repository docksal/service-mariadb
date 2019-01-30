ARG FROM
FROM ${FROM}

ARG VERSION

# Docksal settings
COPY ${VERSION}/default.cnf /etc/mysql/conf.d/10-default.cnf

VOLUME /var/lib/mysql

COPY docker-entrypoint.d /docker-entrypoint.d
COPY healthcheck.sh /opt/healthcheck.sh

COPY docker-entrypoint.patch /usr/local/bin/docker-entrypoint.patch

# Apply patch for running scripts placed in /docker-entrypoint.d/* by root
RUN set -xe; \
    sed -i '/\$(id -u)/ r /usr/local/bin/docker-entrypoint.patch' /usr/local/bin/docker-entrypoint.sh; \
    rm -f /usr/local/bin/docker-entrypoint.patch

EXPOSE 3306
CMD ["mysqld"]

# Health check script
HEALTHCHECK --interval=5s --timeout=1s --retries=12 CMD ["/opt/healthcheck.sh"]
