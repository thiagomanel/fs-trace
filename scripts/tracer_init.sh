#!/bin/bash
source fs-trace.cfg

PID_FILE=$installdir/tmp/tracer.pid
START_LOG_FILE=$installdir/tmp/tracer_starts.log

start() {
	tracer_start;
	STATUS=$?;
	if [ $STATUS == 0 ]; then
		echo "[START]: $(date +%Y%m%d%H%M%S) - `date`" >> $START_LOG_FILE;
	fi
}

stop() {
	get_status;
	STATUS=$?;
	if [ $STATUS == 1 ];then
		echo "Tracer is not running.";
	else
		echo "Stopping tracer...";
		kill -s SIGTERM `cat $PID_FILE`;
		if [ $? == 0 ]; then
			echo "Tracer stopped with success.";
		else
			echo "An error has occurred trying to stop tracer.";
		fi
	fi
}

status() {
	get_status && echo "Tracer is running..." && echo "Last start: `tail -n1 $START_LOG_FILE | awk -F\"- \" '{print $2}'`" || echo "Tracer is not running...";
}

function tracer_start() {
	get_status;
	STATUS=$?;
	if [ $STATUS == 0 ];then
		echo "Tracer already running...";
		return 1;
	else
		mkdir -p $installdir/logs/systemtap_logs/$HOSTNAME
		echo "Starting tracer...";
		stap -DSTP_NO_OVERLOAD -DMAXMAPENTRIES=10000 -F -o $installdir/logs/systemtap_logs/$HOSTNAME/$(date +%Y%m%d%H%M%S)-$HOSTNAME.log -S 100 $installdir/nfs/nfsd.stp 2> $installdir/tmp/tracer.log $> $PID_FILE;
		if [ $? == 0 ]; then
			chown tracer.lsd -R $installdir/tmp;
			echo "Tracer stated with success.";
			return 0;
		else
			echo "An error has occurred trying to start tracer.";
			return 1;
		fi
	fi

}

function get_status() {
	if [ -e $PID_FILE ]; then
		PID=`cat $PID_FILE`;
	else
		return 1;
	fi;

	if [ -e /proc/$PID/status ]; then
		if [[ `pgrep stapio` = $PID ]]; then
			return 0;
		else
			return 1;
		fi;
	else
		return 1;
	fi;
}

restart() {
	echo "[RESTART-INIT]: $(date +%Y%m%d%H%M%S) - `date`">> $START_LOG_FILE;
	echo "Restarting tracer....";
	stop;
	sleep 1;
	tracer_start;
	echo "[RESTART-END]: $(date +%Y%m%d%H%M%S) - `date`">> $START_LOG_FILE;
}

###################################
case $1 in
	start)
		start;
		;;
	stop)
		stop;
		;;
	restart)
		restart;
		;;
	status)
		status;
		;;
	*)
		echo "/etc/init.d/tracer {start|stop|restart|status}"
		exit 1;
esac
