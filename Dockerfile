FROM alpine:3.6

ENV LC_ALL=en_GB.UTF-8
RUN mkdir -p /docker-entrypoint-initdb.d

RUN apk --update --no-cache add \
        mariadb \
        mariadb-client \
 && rm -rf /var/cache/apk/* \
 && sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf \
 && echo -e 'skip-host-cache\nskip-name-resolve' | awk '{ print } $1 == "[mysqld]" && c == 0 { c = 1; system("cat") }' /etc/mysql/my.cnf > /tmp/my.cnf \
 && mv /tmp/my.cnf /etc/mysql/my.cnf \
 && rm -rf /tmp/src

VOLUME /var/lib/mysql
EXPOSE 3306

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
