#!/bin/bash
read -p "Introduzca un número " NUM
let PAR=NUM%2
if [ $PAR -eq 0 ];then
echo "El número $NUM es par"
else
echo "El número $NUM es impar"
fi
