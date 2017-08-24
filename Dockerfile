# VERSION 7.1
# AUTHOR: Vinoth Govindarajan
# DESCRIPTION: Acquia BLT stack for Drupal 8 Projects.
# BUILD: docker build --rm -t cbcms/blt .
# SOURCE: https://bitbucket.com/cbit/blt

FROM php:7.1

MAINTAINER Vinoth Govindarajan <vgovindarajan@collegeboard.org>

# Install dependencies
RUN set -ex \
  && apt-get update -yqq \
  && apt-get install -yqq \
    git \
    unzip \
    wget \
    curl \
    libmcrypt-dev \
    libgd2-dev \
    libgd2-xpm-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libmagickwand-dev \
    mysql-client \
    openssh-client \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

# Install required PHP extensions.
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) bz2 gd pdo_mysql curl mbstring opcache zip \
  && pecl install xdebug

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 

# Add composer dependencies
RUN composer global require "hirak/prestissimo:^0.3"

CMD ["php", "-a"]
