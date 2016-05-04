#!/bin/bash
SUBD=$(ls -d $1/*)
TOTAL=0

for j in $SUBD
do
if [ -f "$j" ]; then
	let TOTAL=TOTAL+1
fi
done
echo "$1 tiene un total de $TOTAL ficheros regulares"

