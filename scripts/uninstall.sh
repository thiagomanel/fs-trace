#!/bin/bash

source fs-trace.cfg

/etc/init.d/tracer stop

echo "Removing from starting system..."
/usr/sbin/update-rc.d -f tracer remove

echo "Removing link from init.d..."
rm -f /etc/init.d/tracer

echo "Removing from crontab..."
rm -f /etc/cron.d/tracer

#echo "Removing from fstab..."
#umount /local/tracer/logs_nfs
#rm -f /tmp/fstab.tmp 
#grep -v tracer_logs /etc/fstab > /tmp/fstab.tmp && cat /tmp/fstab.tmp > /etc/fstab && rm -f /tmp/fstab.tmp

#vim /etc/logrotate.d/rsyslog
