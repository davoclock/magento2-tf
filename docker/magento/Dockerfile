FROM  alpine:3.12

#####     OS RELATED COMMANDS     #####

#PACKAGES TO BE INSTALLED
ENV PHP_PACKAGES php7-bcmath php7-ctype php7-curl php7-dom php7-gd php7-iconv php7-intl php7-mbstring php7-openssl php7-pdo_mysql php7-simplexml php7-soap php7-xsl php7-zip php7-fpm php7-opcache php7-session
ENV COMPOSER_PACKAGES php7-phar php7-cli php7-json php7-xml php7-xmlwriter php7-tokenizer composer
ENV OS_PACKAGES tzdata supervisor git
ENV WEB_PACKAGES nginx 

#INSTALL PACKAGES
RUN apk add $WEB_PACKAGES $PHP_PACKAGES $OS_PACKAGES $COMPOSER_PACKAGES &&\
    rm -rf /var/lib/apt/lists/*

#SET TIMEZONE TO EASTERN TIME
RUN cp /usr/share/zoneinfo/America/Toronto /etc/localtime &&\
    echo "America/Toronto" >> /etc/timezone &&\
#CREATE DIRECTORY FOR NGINX PID
    mkdir -p /run/nginx

#SET NGINX, SUPERVISOR, PHP CONFIGURATION FILES
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf
COPY php.ini /etc/php7/php.ini

######     MAGENTO RELATED COMMANDS     #####

#CREATE MAGENTO USER WITH UID: 1000 (for consistency across containers and to establish permissions for EFS). CREATE MAGENTO GROUP.
RUN adduser -D magento -u 1000 &&\
    addgroup magento magento &&\
#SWITCH FOLDERS TO PREP NGINX DOCUMENT ROOT
    mkdir  /var/www/html &&\
    chown -R magento.magento /var/www/html

#MAGENTO INSTALLATION
USER magento
RUN cd /var/www/html &&\
    git clone -b "storefront-2.4" https://github.com/magento/magento2.git &&\
    mkdir -p /var/www/html/magento2/pub/media &&\
    chmod u+x magento2/bin/magento && \
    chmod g+ws magento2 &&\
    cd magento2 &&\
    find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + &&\
    find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + &&\
    composer update &&\
    composer install

#COPY NGINX CONFIG TO NGINX DIRECTORY
USER root
RUN cp /var/www/html/magento2/nginx.conf.sample /etc/nginx/conf.d/magento2.conf

CMD ["/usr/bin/supervisord -c /etc/supervisord.conf"]