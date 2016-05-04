#!/bin/bash
if [ -d "$1" ]; then
	echo "$1 es un directorio"
elif [ -s "$1" ]; then
	echo "$1 es un fichero y no está vacio"
elif [ -f "$1" ];then
	echo "$1 es un fichero y está vacio"
else
	echo "$1 no es un fichero o directorio"
fi
