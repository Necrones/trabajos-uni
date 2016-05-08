#!/bin/bash

read -p "Introduce el mensaje " mensaje
echo $mensaje > mensaje.txt
cat mensaje.txt | write $1 $2
