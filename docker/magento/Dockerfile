#LATEST ALPINE IMAGE, SUPPORTS PHP 7.4
FROM  alpine:3.12

#PACKAGES TO BE INSTALLED
ENV PHP_PACKAGES php7-bcmath php7-ctype php7-curl php7-dom php7-gd php7-iconv php7-intl php7-mbstring php7-openssl php7-pdo_mysql php7-simplexml php7-soap php7-xsl php7-zip php7-fpm php7-opcache php7-session php7-sockets
ENV COMPOSER_PACKAGES php7-phar php7-cli php7-json php7-xml php7-xmlwriter php7-tokenizer composer
ENV OS_PACKAGES tzdata supervisor git openssh sudo
ENV WEB_PACKAGES nginx 

#INSTALL PACKAGES
RUN apk add $WEB_PACKAGES $PHP_PACKAGES $OS_PACKAGES $COMPOSER_PACKAGES &&\
    rm -rf /var/lib/apt/lists/* &&\
#SET TIMEZONE TO EASTERN TIME
    cp /usr/share/zoneinfo/America/Toronto /etc/localtime &&\
    echo "America/Toronto" >> /etc/timezone &&\
#CREATE DIRECTORY FOR NGINX PID
    mkdir -p /run/nginx &&\
#CREATE MAGENTO USER WITH UID: 1000 (for consistency across containers and to establish permissions for EFS). CREATE MAGENTO GROUP.
    adduser -D magento -u 1000 -G nginx &&\
#SWITCH FOLDERS TO PREP NGINX DOCUMENT ROOT
    mkdir  /var/www/html &&\
    chown -R magento.nginx /var/www/html &&\
    chmod g+ws /var/www/html &&\
#GENERATE KEYS TO ENABLE SSH
    ssh-keygen -A &&\
    echo "magento ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers &&\
    passwd magento -d ''

#SET NGINX, SUPERVISOR, PHP CONFIGURATION FILES
COPY magento-nginx.conf /etc/nginx/magento2.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf
COPY php.ini /etc/php7/php.ini
COPY www.conf /etc/php7/php-fpm.d/www.conf
COPY sshd_config /etc/ssh/sshd_config

#MAGENTO INSTALLATION
USER magento
RUN cd /var/www/html &&\
    git clone -b "2.3" https://github.com/magento/magento2.git &&\
    mkdir -p /var/www/html/magento2/pub/media &&\
    chmod u+x /var/www/html/magento2/bin/magento && \
    chmod g+ws /var/www/html &&\
    cd magento2 &&\
    composer update --no-dev -o --apcu-autoloader &&\
    composer install --no-dev -o --apcu-autoloader &&\
    find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + &&\
    find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +

USER root
CMD ["/usr/bin/supervisord","--configuration=/etc/supervisord.conf"]