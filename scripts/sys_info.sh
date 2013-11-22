#!/bin/bash

TRACE_PATH=/local/tracer
TMP=$TRACE_PATH/tmp
TIME_DATE=$(date +%Y%m%d%H%M%S)
LOGS_PATH=$TRACE_PATH/logs_nfs/sys_logs/$HOSTNAME/$TIME_DATE

function packages() {
	dpkg -l > $TMP/packages.log
}

function cpu() {
	cat /proc/cpuinfo > $TMP/cpu.log
}

function memory() {
	free -m > $TMP/memory.log
}

function hd() {
	fdisk -l > $TMP/hd.log
	df -lh >> $TMP/hd.log
}

function move_logs() {
	cd $TMP
	mkdir -p $LOGS_PATH
	mv authentication.log $LOGS_PATH
	mv cpu.log $LOGS_PATH
	mv hd.log $LOGS_PATH
	mv memory.log $LOGS_PATH
	mv packages.log $LOGS_PATH
}

function move_syslog() {
	cd $TMP
	mkdir -p $LOGS_PATH
	mv syslog.log $LOGS_PATH
}

function auth_log() {
	cp /var/log/auth.log $TMP/authentication.log
}

function syslog_log() {
	cp /var/log/syslog $TMP/syslog.log
}


case $1 in
	syslog)
		syslog_log;
		move_syslog;
		;;
	config)
		packages;
		cpu;
		memory;
		hd;
		auth_log;
		move_logs;
		;;
	*)
		echo "Usage: {syslog|config}"
		echo "syslog: copy /var/log/syslog to the nfs directory."
		echo "config: create files with authetication (/var/log/auth.log), hd, memory and cpu info into the nfs directory."
		exit 1
esac
