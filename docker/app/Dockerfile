FROM php:7.4-apache

ENV USER_ID 1000
ENV GROUP_ID 1000

# Install dependencies
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
  apt-utils \
  sendmail-bin \
  sendmail \
  sudo \
  libbz2-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  libfreetype6-dev \
  libgeoip-dev \
  wget \
  libgmp-dev \
  libgpgme11-dev \
  libmagickwand-dev \
  libmagickcore-dev \
  libicu-dev \
  libldap2-dev \
  libpspell-dev \
  libtidy-dev \
  libxslt1-dev \
  libyaml-dev \
  libzip-dev \
  zip \

  unzip \
  gnupg \
  vim \
  git \
  openssh-client \
  msmtp \
  && rm -rf /var/lib/apt/lists/*

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-configure \
  ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-configure \
  opcache --enable-opcache

# Install required PHP extensions
RUN docker-php-ext-install -j$(nproc) \
  bcmath \
  bz2 \
  calendar \
  exif \
  gd \
  gettext \
  gmp \
  intl \
  ldap \
  mysqli \
  opcache \
  pdo_mysql \
  pspell \
  shmop \
  soap \
  sockets \
  sysvmsg \
  sysvsem \
  sysvshm \
  tidy \
  xmlrpc \
  xsl \
  zip \
  pcntl

RUN pecl install -o -f \
  geoip-1.1.1 \
  gnupg \
  igbinary \
  imagick \
  mailparse \
  msgpack \
  oauth \
  pcov \
  propro \
  raphf \
  redis \
  xdebug-2.9.8 \
  yaml

RUN curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
  && mkdir -p /tmp/blackfire \
  && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
  && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
  && ( echo extension=blackfire.so \
  && echo blackfire.agent_socket=tcp://blackfire:8707 ) > $(php -i | grep "additional .ini" | awk '{print $9}')/blackfire.ini \
  && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz
RUN rm -f /usr/local/etc/php/conf.d/*sodium.ini \
  && rm -f /usr/local/lib/php/extensions/*/*sodium.so \
  && apt-get remove libsodium* -y  \
  && mkdir -p /tmp/libsodium  \
  && curl -sL https://github.com/jedisct1/libsodium/archive/1.0.18-RELEASE.tar.gz | tar xzf - -C  /tmp/libsodium \
  && cd /tmp/libsodium/libsodium-1.0.18-RELEASE/ \
  && ./configure \
  && make && make check \
  && make install  \
  && cd / \
  && rm -rf /tmp/libsodium  \
  && pecl install -o -f libsodium

RUN docker-php-ext-enable \
  bcmath \
  blackfire \
  bz2 \
  calendar \
  exif \
  gd \
  geoip \
  gettext \
  gmp \
  gnupg \
  igbinary \
  imagick \
  intl \
  ldap \
  mailparse \
  msgpack \
  mysqli \
  oauth \
  opcache \
  pcov \
  pdo_mysql \
  propro \
  pspell \
  raphf \
  redis \
  shmop \
  soap \
  sockets \
  sodium \
  sysvmsg \
  sysvsem \
  sysvshm \
  tidy \
  xdebug \
  xmlrpc \
  xsl \
  yaml \
  zip \
  pcntl

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

#Add PHP-SPX profiler
RUN cd /usr/lib && git clone https://github.com/NoiseByNorthwest/php-spx.git
RUN cd /usr/lib/php-spx && phpize && ./configure && make && make install

ADD php-dev.ini /usr/local/etc/php/conf.d/999-dev-magento.ini
ADD msmtprc /etc/msmtprc
RUN chmod 600 /etc/msmtprc

RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data

RUN a2enmod rewrite; \
  a2enmod ssl; \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \
  mkdir -p /root/.composer; \
  touch /var/log/syslog; \
  touch /var/log/cron.log;

#fix comoser cache for www-data
RUN mkdir -p /var/www/.composer
RUN mkdir -p /var/www/.cache
RUN mkdir -p /var/www/.config
RUN mkdir -p /var/www/install

#composer auth file
ADD auth.json /root/.composer/auth.json
ADD auth.json /var/www/.composer/auth.json

RUN chown -R www-data:www-data /var/www
RUN chown -R www-data:www-data /etc/msmtprc

WORKDIR /var/www/html

RUN npm install --global yarn


RUN echo "root:root" | chpasswd
RUN echo "www-data:root" | chpasswd

#fix sudo usage for www-data
RUN adduser www-data sudo
