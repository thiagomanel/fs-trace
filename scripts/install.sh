#!/bin/bash
source fs-trace.cfg

chown tracer.lsd -R $installdir

echo "creating diectories..."
mkdir -p $installdir/log
mkdir -p $installdir/logs
mkdir -p $installdir/tmp

chown tracer.lsd -R $installdir/log
chown tracer.lsd -R $installdir/logs
chown tracer.lsd -R $installdir/tmp
