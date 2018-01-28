#!/bin/sh
cat /proc/cpuinfo |egrep "processor|physical id|core id" | sed 's/^processor/\nprocessor/g'
