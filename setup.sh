#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.custom
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

save_original_config /etc/rsyslog.conf

echo "configuring rsyslog as log forwarder"
cat $base/rsyslog.tpl |sed s/%%syslog%%/$SYSLOG/g >/etc/rsyslog.conf

service rsyslog restart
