#!/bin/bash

####################################################################################
#TUTORES:	
#•	Jose Manuel Saiz

#AUTORES:
#•	Daniel Santidrian Alonso
#•	David Zotes Gonzalez

############## LICENCIA #################
#CC BY-NC-SA 3.0 ES 
#Creative Commons
#BY - Atribución (BY)
#NC - No uso Comercial (NC)
#SA - Compartir Igual (SA)

####################################################################################

#Programa a partir del cual introducimos datos - Tema 5 Gestión de memoria
#@version v1
#@date 11/07/2014

#Sinopsis: programa que ordena los procesos para introducirlos en memoria.

#Formato de salida: color verde
amarillo='\e[1;33m'
red='\e[1;31m'
morado='\e[0;35m'
green='\e[1;32m'
NC='\e[0m' # No Color


proceso=(`cat datos.txt | cut -f 1 -d":"`)
tamano=(`cat datos.txt | cut -f 2 -d":"`)
tiempo=(`cat datos.txt | cut -f 3 -d":"`)
llegada=(`cat datos.txt | cut -f 4 -d":"`)


for ((i=0;i<${#proceso[@]};i++)){
	for ((j=i;j<${#proceso[@]};j++)){

		a=${llegada[$i]};
		b=${llegada[$j]};    #asigno a unas variables 

		if [ "$a" -gt "$b" ];
		then

			aux2=${proceso[$i]};
            proceso[$i]=${proceso[$j]};
            proceso[$j]=$aux2;

			aux3=${tamano[$i]};
            tamano[$i]=${tamano[$j]};
            tamano[$j]=$aux3;

			aux=${tiempo[$i]};
            tiempo[$i]=${tiempo[$j]};   
            tiempo[$j]=$aux;

            aux1=${llegada[$i]};
            llegada[$i]=${llegada[$j]};
            llegada[$j]=$aux1;      
						
		fi
	}

	echo "${proceso[$i]}:${tamano[$i]}:${tiempo[$i]}:${llegada[$i]}" >> datos1.txt
}

cat datos1.txt > datos.txt