FROM ubuntu:14.04

RUN useradd letmesee
RUN apt-get -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
       ruby ruby-dev eb-utils libeb16-dev \
       apache2 git zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN gem install iconv stem

COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html
ENV HOME /var/www/html

WORKDIR /var/www/html/rubyeb19
RUN ruby extconf.rb && \
    make install

WORKDIR /var/www/html

RUN a2enmod cgi \
    && cp bin/apache.sh /usr/local/sbin \
    && cp conf/000-default.conf /etc/apache2/sites-available/000-default.conf \
    && mkdir -p /var/run/apache2

EXPOSE 80
CMD [ "/usr/local/sbin/apache.sh" ]
