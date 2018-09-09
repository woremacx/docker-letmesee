#!/bin/sh

/etc/init.d/apache2 configtest
export APACHE_CONFDIR=/etc/apache2
. /etc/apache2/envvars
/usr/sbin/apache2 -DFOREGROUND
