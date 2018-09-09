FROM ubuntu:16.04

# make user
RUN useradd letmesee

# copy
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html

# install
RUN apt-get -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
       apache2 zlib1g-dev build-essential \
       libeb16-dev curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# apache
RUN a2enmod cgi \
    && cp /var/www/html/bin/apache.sh /usr/local/sbin \
    && cp /var/www/html/conf/000-default.conf /etc/apache2/sites-available/000-default.conf \
    && mkdir -p /var/run/apache2

# ruby
RUN set -ex \
    && cd /tmp \
    && curl -LO https://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.bz2 \
    && tar xf ruby-1.8.7-p374.tar.bz2 \
    && cd ruby-1.8.7-p374 \
    && ./configure \
    && make -j$(nproc) \
    && make install \
    && cd /tmp \
    && rm -rf ruby-1.8.7-p374

# rubyeb19
RUN set -ex \
    && cp -Rp /var/www/html/rubyeb19 /tmp/rubyeb19 \
    && cd /tmp/rubyeb19 \
    && ruby extconf.rb \
    && make install

# misc
ENV HOME /var/www/html
WORKDIR /var/www/html
EXPOSE 80
CMD [ "/usr/local/sbin/apache.sh" ]
