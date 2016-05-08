#!/bin/bash
SUBD=$(ls -1d $1/*)
TOTAL=0

for j in $SUBD
do
if [ -d "$j" ]; then
	let TOTAL=TOTAL+1
fi
done
echo "$1 tiene un total de $TOTAL subdirectorios"

