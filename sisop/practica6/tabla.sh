#!/bin/bash
if [ -z $1 ];then
	echo "No has introducido ningún parámetro"
else
	if [ $1 -lt 1 ] || [ $1 -gt 10 ];then
                echo "El número no está entre 1 y 10"
        else
        j=1
        until [ $j -eq 11 ];do
		echo "$1 por $j es $(expr $1 \* $j)"
		let j=j+1
        done
        fi
fi
