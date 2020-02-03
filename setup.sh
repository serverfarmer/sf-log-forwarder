#!/bin/sh
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.install



base=/opt/farm/ext/log-forwarder/templates/$OSVER

if [ "$SYSLOG" = "true" ]; then
	echo "install sf-log-receiver extension instead of sf-log-forwarder"
	exit 0
fi

if [ ! -f $base/rsyslog.tpl ] || [ ! -f /etc/rsyslog.conf ]; then
	echo "skipping rsyslog setup, unsupported operating system version"
	exit 1
fi

oldmd5=`md5sum /etc/rsyslog.conf`
save_original_config /etc/rsyslog.conf

echo "configuring rsyslog as log forwarder"
cat $base/rsyslog.tpl |sed s/%%syslog%%/$SYSLOG/g >/etc/rsyslog.conf
newmd5=`md5sum /etc/rsyslog.conf`

if [ "$oldmd5" != "$newmd5" ]; then
	service rsyslog restart
else
	echo "skipping rsyslog restart, configuration has not changed"
fi
