#!/bin/sh
# live filter for tshark capture packets
# FIXME - allow for a timeout?
# FIXME - allow other args?

if [ $# -ne 2 ]
then
echo "$0 device capturefile"
exit -1
else
DEV=$1
CAP=$2
fi

tshark -f 'src or dst port 123' -i $DEV -w $CAP