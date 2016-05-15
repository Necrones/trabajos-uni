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

#@date 31/05/2014
#@version 1.8
#Sinopsis: programa que recoge datos desde un fichero y a partir de los parámetros que le sean introduccidos crea las particiones con los tamaños indicados y resuelve la asignación de memoria de cada proceso con particiones fijas, FCFS y criterio del que mejor se adapte.

#Colores de salida
amarillo='\e[1;33m'
green='\e[1;32m'
morado='\e[1;35m'
red='\e[1;31m'
cyan='\e[1;36m'
negro='\e[1;30m'
azul='\e[1;34m'
blanco='\e[0;39m'
NC='\e[0m' # No Color



#Guardo los valores de proceso, memoria y tiempo del archivo agrupados en tres arrays
proceso=(`cat datos.txt | cut -f 1 -d":"`)
memoria=(`cat datos.txt | cut -f 2 -d":"`)
tiempoEj=(`cat datos.txt | cut -f 3 -d":"`)
llegada=(`cat datos.txt | cut -f 4 -d":"`)

############################## PUEBA COLORES #################################
function colorear(){
echo ""
for ((s=0 ; $s < ${#vec_ocu_nom[@]} ; s++))
do

	#echo Toma s tonta: $s
	if [[ (${vec_ocu_nom[$s]} == "Li") ]]
		then
			 echo -e -n "${blanco}Li ${NC}"
	fi

	if [[ (${vec_ocu_nom[$s]} == "T1") ]]
		then 
			echo -e -n "${amarillo}T1 ${NC}"
	fi

	if [[ (${vec_ocu_nom[$s]} == "T2") ]]
		then 
			echo -e -n "${red}T2 ${NC}"
	fi

	if [[ (${vec_ocu_nom[$s]} == "T3") ]]
		then 
			echo -e -n "${cyan}T3 ${NC}"
	fi

	if [[ (${vec_ocu_nom[$s]} == "T4") ]]
		then
			 echo -e -n "${morado}T4 ${NC}"
	fi

	if [[ (${vec_ocu_nom[$s]} == "T5") ]]
		then 
			echo -e -n "${azul}T5 ${NC}"
	fi

	if [[ (${vec_ocu_nom[$s]} == "T6") ]]
		then 
			echo -e -n "${green}T6 ${NC}"
	fi

	if [[ (${vec_ocu_nom[$s]} == "T7") ]]
		then 
			echo -e -n "${amarillo}T7 ${NC}"
	fi

	if [[ (${vec_ocu_nom[$s]} == "T8") ]]
		then 
			echo -e -n "${red}T8 ${NC}"
	fi
done
echo "   - $tiempo" 

}

function colorearNC(){
echo "" >> resultadoFCFS.txt
for ((s=0 ; $s < ${#vec_ocu_nom[@]} ; s++))
do

	#echo Toma s tonta: $s
	if [[ (${vec_ocu_nom[$s]} == "Li") ]]
		then
			 echo -n "Li " >> resultadoFCFS.txt
	fi

	if [[ (${vec_ocu_nom[$s]} == "T1") ]]
		then 
			echo -n "T1 " >> resultadoFCFS.txt
	fi

	if [[ (${vec_ocu_nom[$s]} == "T2") ]]
		then 
			echo -n "T2 " >> resultadoFCFS.txt
	fi

	if [[ (${vec_ocu_nom[$s]} == "T3") ]]
		then 
			echo -n "T3 " >> resultadoFCFS.txt
	fi

	if [[ (${vec_ocu_nom[$s]} == "T4") ]]
		then
			 echo -n "T4 " >> resultadoFCFS.txt
	fi

	if [[ (${vec_ocu_nom[$s]} == "T5") ]]
		then 
			echo -n "T5 " >> resultadoFCFS.txt
	fi

	if [[ (${vec_ocu_nom[$s]} == "T6") ]]
		then 
			echo -n "T6 " >> resultadoFCFS.txt
	fi

	if [[ (${vec_ocu_nom[$s]} == "T7") ]]
		then 
			echo -n "T7 " >> resultadoFCFS.txt
	fi

	if [[ (${vec_ocu_nom[$s]} == "T8") ]]
		then 
			echo -n "T8 " >> resultadoFCFS.txt
	fi
done
echo "   - $tiempo" >> resultadoFCFS.txt

}


function part(){ #Colorear y poner puntos
for ((k=0;k<${#tam_party[@]};k++))
	do
		echo -e -n "${green}↓  ${NC}"
	done
}


###############################################################################


#Parametros que recibe el archivo
#$1 -> número de particiones
#$2-$n -> tamaño de las n particiones

#Guardo todos los parámetros introducidos en un vector.
declare -a param=($*)

#Creo una variable en la que almaceno el número de procesos asignados.
pr_asignado=0

#Creo una variable que controla el tiempo que se consume en la ejecución
tiempo=0
m=2

#Compruebo que el número de parámetros introduccidos es correcto.
if [[ $1 -eq $((${#param[@]}-1)) ]]
then

	#Guardo el tamaño de cada partición en un vector.
	for (( i=0 ; i<$1 ; i++ ))
	do
		tam_party[$i]=${param[$(($i+1))]}
		vec_ocu[$i]=0
		vec_ocu_nom[$i]="Li"
	done

#Pinto en pantalla el encabezado de la salida
clear

	echo
	echo -e "${green}		Criterio a la que mejor se adapte ${NC}"
	echo
	echo -e "${morado}===============================================================================================================================${NC}"
	echo 
	echo
	echo                         DATOS:
	echo ---------------------------------------------------------
	cat datos.txt
	echo ---------------------------------------------------------
	echo 
	echo
	echo                         PARTICIONES:
	echo ---------------------------------------------------------
	echo T - ${tam_party[*]}
	echo ---------------------------------------------------------

	echo ""
	echo ""
	echo -e "${green}${tam_party[*]}  ${NC}  - Particiones"
	#----------
	part
	echo #Nueva linea
	#----------



	echo "" >> resultadoFCFS.txt
	echo "		Criterio a la que mejor se adapte" >> resultadoFCFS.txt
	echo ""  >> resultadoFCFS.txt
	echo "===============================================================================================================================" >> resultadoFCFS.txt
	echo "" >> resultadoFCFS.txt
	echo "" >> resultadoFCFS.txt
	echo "                        DATOS:" >> resultadoFCFS.txt
	echo "---------------------------------------------------------" >> resultadoFCFS.txt
	cat datos.txt >> resultadoFCFS.txt
	echo "---------------------------------------------------------" >> resultadoFCFS.txt
	echo "" >> resultadoFCFS.txt
	echo "" >> resultadoFCFS.txt
	echo "                        PARTICIONES:" >> resultadoFCFS.txt
	echo "---------------------------------------------------------" >> resultadoFCFS.txt
	echo "T - ${tam_party[*]}" >> resultadoFCFS.txt
	echo "---------------------------------------------------------" >> resultadoFCFS.txt


	echo "" >> resultadoFCFS.txt
	echo "" >> resultadoFCFS.txt
	echo "${tam_party[*]}    - Particiones" >> resultadoFCFS.txt
	#----------
	for ((k=0;k<${#tam_party[@]};k++))
	do
		echo -n "↓  " >> resultadoFCFS.txt
	done
	echo "" >> resultadoFCFS.txt #Nueva linea
	#----------




	for ((i=0 ; $pr_asignado<${#proceso[@]} ; i++))
	do
#echo 1for $i
#echo proceso: ${proceso[$i]}
	
		#Compruebo que el proceso anterior ha sido asignado
		if [[ $i -ne $pr_asignado ]]
		then
#echo 1if
			for (( j=0 ; j<${#vec_ocu[@]} ; j++ ))
			do
				if [[ ${vec_ocu[$j]} -gt 0 ]]
				then
					vec_ocu[$j]=$((${vec_ocu[$j]}-1))
				fi
				if [[ ${vec_ocu[$j]} -eq 0 ]]
				then
					vec_ocu_nom[$j]="Li"
				fi	
			done
			tiempo=$(($tiempo+1))
			i=$(($i-1))
		fi 
		
		#Calculo la diferencia del tamaño de la partición menos el tamaño del proceso.
		unset resta	#Vacío el vector para evitar posibles errores.
		for (( j=0 ; j<${#tam_party[@]} ; j++ ))
		do
			resta[$j]=$((${tam_party[$j]}-${memoria[$i]}))
		done
#echo resta ${resta[*]}

		#Compruebo las particiones en las que el proceso entra y que están libres. Almaceno su posición en un vector.
		unset par_lib	#Vacío el vector para evitar posibles errores.
		no_entra=0	#Contador del número de particiones en la que no entra
		for (( j=0 ; j<${#tam_party[@]} ; j++ ))
		do
#echo 3for $j
			if [[ ${resta[$j]} -ge 0 && ${vec_ocu[$j]} -eq 0 ]]
			then
				par_lib[$((${#par_lib[@]}+1))]=$j
			fi
		done

		for (( j=0 ; j< ${#tam_party[@]} ; j++ ))
		do
			if [[ ${resta[$j]} -lt 0 ]]
			then
				no_entra=$(($no_entra+1))
			fi
		done
#echo par lib: ${par_lib[*]} / ${#par_lib[*]} 

		if [[ $no_entra -eq ${#tam_party[@]} ]]
		then
			echo ¡¡Pero que pedazo de proceso!! A mi eso no me entra...
			echo "¡¡Pero que pedazo de proceso!! A mi eso no me entra..." >> resultadoFCFS.txt
			pr_asignado=$(($pr_asignado +1))
		else
			#Comparo las particiones que acabo de evaluar para saber cual es la más pequeña (pues será en la que primero se adapte).
			var_par_lib=${par_lib[1]}	#Creo una variable que va a almacenar la dirección de la partición que primero se ajuste.
#echo var_par_lib1: $var_par_lib tam_party menor: ${tam_party[$var_par_lib]}
			

			#En el caso de que el proceso entre en la partición libre asigno el valor de la estancia de dicho proceso a la posición del vec_ocu que está guardada en el vector par_lib (que guarda las posiciones de las particiones libres).
			if [[ ${memoria[$i]} -le ${tam_party[$var_par_lib]} && ${vec_ocu[$var_par_lib]} -eq 0 ]]
			then
				vec_ocu[$var_par_lib]=${tiempoEj[$i]}
				vec_ocu_nom[$var_par_lib]=${proceso[$i]}
				pr_asignado=$(($pr_asignado+1))		
			fi
		fi
#echo tam_party: ${tam_party[*]}
#echo tam_party menor: ${tam_party[$var_par_lib]}
#echo vec ocu: ${vec_ocu[*]}
#echo vec ocu nom: ${vec_ocu_nom[*]}
#echo pr_asignado: $pr_asignado i: $i
####################################################

#echo ""
#echo -e "${azul}-------------------------------------------------------------"
#echo -n -e "${azul}Llega el proceso ->  "
#head -$m datos.txt |tail -1

#echo "" >> resultadoFCFS.txt
#echo "-------------------------------------------------------------" >> resultadoFCFS.txt
#echo -n "Llega el proceso ->  " >> resultadoFCFS.txt
#head -$m datos.txt |tail -1 >> resultadoFCFS.txt


#echo ""
#echo -n -e "${azul}Procesos pendientes de llegar ->  "
#for ((q=$(($m+1));q<$((${#proceso[@]}+2));q++)){
#echo -n ` head -$q datos.txt|tail -1|cut -f 1 -d":" `
#echo -n "  "
#}
#echo ""
#echo -e "${azul}-------------------------------------------------------------"


#echo "" >> resultadoFCFS.txt
#echo -n "Procesos pendientes de llegar ->  " >> resultadoFCFS.txt
#for ((q=$(($m+1));q<$((${#proceso[@]}+2));q++)){
#echo -n ` head -$q datos.txt|tail -1|cut -f 1 -d":" ` >> resultadoFCFS.txt
#echo -n "  " >> resultadoFCFS.txt
#}
#echo "" >> resultadoFCFS.txt
#echo "-------------------------------------------------------------" >> resultadoFCFS.txt

#m=$(($m+1))


			colorear
			colorearNC
####################################################
	done

	#Bucle que consume las estancias de los procesos aún activos
	for (( i=0 ; i<${#vec_ocu[@]} ; i++ ))
	do
		while [[ ${vec_ocu[$i]} -ne 0 ]]
		do
			for (( j=0 ; j<${#vec_ocu[@]} ; j++ ))
			do
				if [[ ${vec_ocu[$j]} -gt 0 ]]
				then
					vec_ocu[$j]=$((${vec_ocu[$j]}-1))
				fi
				if [[ ${vec_ocu[$j]} -eq 0 ]]
				then
					vec_ocu_nom[$j]="Li"
				fi
			done
			tiempo=$(($tiempo+1))
##########################################################
			 colorear
			 colorearNC
##########################################################
		done
	done
else
	echo Número de parámetros introduccidos incorrecto.
	echo "Número de parámetros introduccidos incorrecto." >> resultadoFCFS.txt
	./practicaControl.sh
fi

echo
echo
echo -e " 			${morado}LEYENDA ${NC} ";
echo -e "			      _ En vertical ${red} | ${NC} a la derecha. Espacio que ocupa la partición en el tiempo. ";
echo -e "		 	      _ En horizontal ${red}_${NC} Tamaño que ocupa la partición en memoria.";
echo -e "			      _ ${red}Px${NC} Proceso, siendo x el número de proceso";
echo -e "			      _ Li ${red}->${NC} Espacio libre en la partición.";

echo "" >> resultadoFCFS.txt
echo "" >> resultadoFCFS.txt
echo  " 			LEYENDA  " >> resultadoFCFS.txt
echo  "			      _ En vertical  |  a la derecha. Espacio que ocupa la partición en el tiempo. " >> resultadoFCFS.txt
echo  "		 	      _ En horizontal _ Tamaño que ocupa la partición en memoria." >> resultadoFCFS.txt
echo  "			      _ Px Proceso, siendo x el número de proceso" >> resultadoFCFS.txt
echo  "			      _ Li -> Espacio libre en la partición." >> resultadoFCFS.txt


