FROM bitnami/minideb-extras:jessie-r107
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.34-0 --checksum be3de7b24e809b3678f18da08ab220cbca09b458e895d5d6f491afc6f333ebe1
RUN bitnami-pkg unpack php-7.0.30-8 --checksum c9bcf8d4c9c280645e44de07ae4a0e8d436333688094d5587b4b0766036cff8a
RUN bitnami-pkg unpack mysql-client-10.1.34-0 --checksum 2954d9390cb8b91dc924beacc179ed03050f6c5cb7ad328010cdbde1ab05c1e9
RUN bitnami-pkg install libphp-7.0.30-8 --checksum 0fb74a5477bdf72ee85751af91ee2e41beec5b18657a9891d7081a3e2ce7289e
RUN bitnami-pkg unpack wordpress-4.9.7-0 --checksum 3ed5d1345e340a7953ff548f8f3195db0f7d2288f34ab00c919984a5c09ac3bc

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="wordpress" \
    BITNAMI_IMAGE_VERSION="4.9.7-debian-8-r9" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER="" \
    SMTP_USERNAME="" \
    WORDPRESS_BLOG_NAME="User's Blog!" \
    WORDPRESS_DATABASE_NAME="bitnami_wordpress" \
    WORDPRESS_DATABASE_PASSWORD="" \
    WORDPRESS_DATABASE_USER="bn_wordpress" \
    WORDPRESS_EMAIL="user@example.com" \
    WORDPRESS_FIRST_NAME="FirstName" \
    WORDPRESS_HOST="" \
    WORDPRESS_HTTPS_PORT="443" \
    WORDPRESS_HTTP_PORT="80" \
    WORDPRESS_LAST_NAME="LastName" \
    WORDPRESS_PASSWORD="bitnami" \
    WORDPRESS_TABLE_PREFIX="wp_" \
    WORDPRESS_USERNAME="user"

RUN install_packages vim
#RUN ls /
#RUN mv /app/wp-basic-auth /bitnami/wordpress/wp-content/plugins/wp-basic-auth
COPY app /app
#RUN php /app/App.php > /app.log &

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
