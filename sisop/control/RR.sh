#!/bin/bash
#Author: José Luis Garrido Labrador
#Organitation: Burgos University
#School year: 2015/2016 - 2nd semester
#Description: Simulation of Round Robin Algorithm
#Licence: CC-BY-SA (Documentation), GPLv3 (Source)

#Funciones
#Función SinRepetir - comprueba si se ha puesto el mismo nombre antes
function SinRepetir {
	if [ $i -ne 1 ];then
		for ((z=0 ; z<$(expr $i-1) ; z++ ))
		do
			if [ "${proc_name[$(expr $i-1)]}" == "${proc_name[$z]}" ];then
				error=1
			fi
		done
	fi
	if [ $error -eq 1 ];then
		echo "Nombre ya utilizado, ponga un nuevo nombre"
	fi
}


#Header
echo " -----------------------------------------------"
echo "|		Algoritmo Round Robin		|"
echo "|		Creado por:			|"
echo "|		José Luis Garrido Labrador	|"
echo "|		Licencias:			|"
echo "|		CC-BY-SA (Documentación)	|"
echo "|		GPLv3 (Código)			|"
echo " -----------------------------------------------"
#Captura de datos
proc=0
quantum=0
while [ \( "$proc" -le 0 \) ] 2> /dev/null ;do
read -p "Introduzca un número de procesos: " proc
done
while [ "$quantum" -le 0 ] 2> /dev/null ;do
read -p "Introduzca el quantum: " quantum
done
#Vectores de informacion
declare proc_name[proc] #Nombre de cada proceso
declare proc_arr[proc] #Turno de llegada del proceso
declare proc_exe[proc] #Tiempo de ejecución o ráfaga; se reducirá según el quantum
declare proc_order[proc] #Orden de la lista
clear
i=1
while [ $i -le $proc ];do
	j=0
	while [ $j -eq 0 ];do
		error=0
		read -p "Introduzca el nombre del proceso $i: " proc_name[$(expr $i-1)]
		SinRepetir
		if [ "${proc_name[$(expr $i-1)]}" -a $error -eq 0 ] 2> /dev/null ;then
			j=1;
		fi
	done
	j=0
	while [ $j -eq 0 ];do
		read -p "Introduzca el turno de llegada del proceso $i: " proc_arr[$(expr $i-1)]
		if [ "${proc_arr[$(expr $i-1)]}" -ge 0 ] 2> /dev/null ;then
			j=1
		fi
	done
	j=0
	while [ $j -eq 0 ];do
		read -p "Introduzca la ráfaga del proceso $i: " proc_exe[$(expr $i-1)]
		if [ "${proc_exe[$(expr $i-1)]}" -gt 0 ] 2> /dev/null ;then
			j=1
		fi
	done
	echo "${proc_name[$(expr $i-1)]}, ${proc_arr[$(expr $i-1)]}, ${proc_exe[$(expr $i-1)]}"
	let i=i+1
done
#Inicializo el vector de orden
for (( i=0; i<$proc; i++ ))
do
	proc_order[$i]=-1
done
#Creación de la lista según llegada
for (( i=$(expr $proc-1); i>=0; i-- ))
do
	max=0
	for (( j=0; j<$proc; j++ ))
	do
		for (( z=$i, coin=0; z<=$(expr $proc-1); z++ ))
		do
			if [ $j -eq "${proc_order[$z]}" ];then
				coin=1
			fi
		done
	if [ $coin -eq 0 ];then
		if [ "${proc_arr[$j]}" -ge $max ];then
			aux=$j
			max="${proc_arr[$j]}"
		fi
	fi
	done
	proc_order[$i]=$aux
done
for (( i=0; i<$proc; i++))
do
echo "${proc_order[$i]}"
done