#!/bin/bash
if [ -d "$1" ]; then
	SUBD=$(ls -1d $1/*)
	TOTAL=0

	for j in $SUBD
	do
	if [ -d "$j" ]; then
        	let TOTAL=TOTAL+1
	fi
	done
	echo "$1 es un directorio con $TOTAL subdirectorios"
elif [ -s "$1" ]; then
	echo "$1 es un fichero y no está vacio"
elif [ -f "$1" ];then
	echo "$1 es un fichero y está vacio"
else
	echo "$1 no es un fichero o directorio"
fi
