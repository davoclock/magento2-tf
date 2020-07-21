FROM  alpine:3.12


ENV PHP_PACKAGES php7-bcmath php7-ctype php7-curl php7-dom php7-gd php7-iconv php7-intl php7-mbstring php7-openssl php7-pdo_mysql php7-simplexml php7-soap php7-xsl php7-zip php7-fpm php7-opcache php7-session
ENV COMPOSER_PACKAGES php7-phar php7-cli php7-json php7-xml php7-xmlwriter php7-tokenizer
ENV PACKAGES nginx tzdata supervisor

RUN apk add $PHP_PACKAGES $PACKAGES $COMPOSER_PACKAGES
RUN cp /usr/share/zoneinfo/America/Toronto /etc/localtime && echo "America/Toronto" >> /etc/timezone
RUN apk del tzdata

#Set Memory Limit (2G)
RUN sed -i -e '/memory_limit =/ s/= .*/= 2G/' /etc/php7/php.ini \
    sed -i -e '/zlib.output_compression =/ s/= .*/= On/' /etc/php7/php.ini

RUN apk del $COMPOSER_PACKAGES

#Set nginx config
COPY nginx.conf /etc/nginx/conf.d/magento.conf
COPY supervisord.conf /etc/supervisord.conf

RUN mkdir -p /run/nginx
RUN mkdir -r /var/www/html/magento2/pub/media
RUN adduser -D magento -u 1000
RUN addgroup magento magento
RUN rm -rf /etc/nginx/conf.d/default.conf
RUN cd /var/www/html

#MAGENTO SETUP
RUN su - magento
RUN git clone -b "storefront-2.4" https://github.com/magento/magento2.git
RUN chown -R magento.magento magento2
RUN chmod u+x magento2/bin/magento
RUN chmod g+ws magento2
RUN cd magento2
RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
RUN find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
RUN composer update && composer install
RUN cp /var/www/html/magento2/nginx.conf.sample /etc/nginx/conf.d/magento2.conf

CMD ["/usr/bin/supervisord -c /etc/supervisord.conf"]