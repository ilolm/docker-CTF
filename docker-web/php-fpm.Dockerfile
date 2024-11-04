FROM php:8.2-fpm-alpine

COPY ./html/* /var/www/html/
RUN docker-php-ext-install mysqli
