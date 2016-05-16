#!/bin/bash
#Author: José Luis Garrido Labrador
#Organitation: Burgos University
#School year: 2015/2016 - 2nd semester
#Description: Simulation of Round Robin Algorithm and memory management
#Licence: CC-BY-SA (Documentation), GPLv3 (Source)

#Variables globales de ayuda
MAX=9999 

##Funciones
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
}
#Función Informacion que muestra al usuario la informacion de los datos introducidos
function Informacion {
	echo " --------------------------------------------------------------- "
	echo "|    Proceso    |    Llegada    |     Ráfaga    |    Memoria    |"
		for (( y=0; y<$i; y++))
	do
		echo " --------------------------------------------------------------- "
		echo "|	${proc_name[$y]}	|	${proc_arr[$y]}	|	${proc_exe[$y]}	|	${proc_mem[$y]}	|"
	done
	echo " --------------------------------------------------------------- "
}
#Función InformacionPrint guarda en un fichero la informacion
function InformacionPrint {
	echo " --------------------------------------------------------------- "  >> informe.txt
	echo "|    Proceso    |    Llegada    |     Ráfaga    |    Memoria    |"  >> informe.txt
		for (( y=0; y<$i; y++))
	do
		echo " --------------------------------------------------------------- "  >> informe.txt
		echo "|	${proc_name[$y]}	|	${proc_arr[$y]}	|	${proc_exe[$y]}	|	${proc_mem[$y]}	|"  >> informe.txt
	done
	echo " --------------------------------------------------------------- "  >> informe.txt
}
#Función Fichero, lee datos de un fichero
function Fichero {
	x=0
	for y in $(cat InputRR.txt)
	do
		proc_name[$x]=$(echo $y | cut -f1 -d";")
		proc_arr[$x]=$(echo $y | cut -f2 -d";")
		proc_exe[$x]=$(echo $y | cut -f3 -d";")
		proc_mem[$x]=$(echo $y | cut -f4 -d";")
		let x=x+1
	done
}
#Función EspAcu; aumenta el tiempo de espera acumulado de cada proceso
function EspAcu() {
	for (( y=0; y<$proc; y++ ))
	do
		if [ $y -ne $z -o $1 -eq 1 ] && [ "${proc_exe[$y]}" -ne 0 ];then
			let proc_waitA[$y]=proc_waitA[$y]+1
		fi
	done
}
#Función media; calcula la media de valores de un vector
function media() {
	local array=("${!1}")
	media=0
	for (( y=0; y<$proc; y++ ))
	do
		media=$(expr $media + ${array[$y]})
	done
	media=$(expr $media / $proc)
	return $media
}
#Función OcuMem; llena la memoria del proceso pasado por parámetro. $1  nombre de proceso, $2 origen $3 memoria del proceso
function OcuMem() {
	for (( y=$2; y<$(expr $2 + $3) ; y++))
	do
		mem[$y]=$1
	done
	return $(expr $y - 1)
}
#Función DesOcuMem; libera la memoria de un determinado sitio. $1 origen $2 final
function DesOcuMem() {
	for (( y=$1; y<$2 ; y++))
	do
		mem[$y]=0
	done
}
#Función PartFree; calcula las distintas particiones libres, su tamaño y su posición
function PartFree {
	for (( y=0; y<$MAX ; y++ ))
	do
		partition[$y]=0
	done
	for (( y=0, part=0, h=0 ; y<${#mem[@]}; y++ ))
	do
		if [ ${mem[$y]} = "Li" ];then
			if [ $h -eq 0 ];then
				part_init[$part]=$y
				h=1
			fi
			let partition[$part]=partition[$part]+1
		else
			if [ $h -eq 1 ];then
				h=0
				let part=part+1
			fi
		fi
	done
}
##Comienzo del programa
clear
#Header
echo " -----------------------------------------------"
echo "|		Simulación de			|"
echo "|		Round Robin y			|"
echo "|		Gestión de memoria		|"
echo "|		Particiones dinámicas,		|"
echo "|		Ajuste al mejor,		|"
echo "|		Reubicable			|"
echo "|		Creado por:			|"
echo "|		José Luis Garrido Labrador	|"
echo "|		Luis Pedrosa Ruiz		|"
echo "|		Licencias:			|"
echo "|		CC-BY-SA (Documentación)	|"
echo "|		GPLv3 (Código)			|"
echo " -----------------------------------------------"
echo " -----------------------------------------------"  > informe.txt
echo "|		Simulación de			|"  >> informe.txt
echo "|		Round Robin y			|"  >> informe.txt
echo "|		Gestión de memoria		|"  >> informe.txt
echo "|		Particiones dinámicas,		|"  >> informe.txt
echo "|		Ajuste al mejor,		|"  >> informe.txt
echo "|		Reubicable			|"  >> informe.txt
echo "|		Creado por:			|"  >> informe.txt
echo "|		José Luis Garrido Labrador	|"  >> informe.txt
echo "|		Luis Pedrosa Ruiz		|"  >> informe.txt
echo "|		Licencias:			|"  >> informe.txt
echo "|		CC-BY-SA (Documentación)	|"  >> informe.txt
echo "|		GPLv3 (Código)			|"  >> informe.txt
echo " -----------------------------------------------"  >> informe.txt
#Captura de datos
j=0
while [ $j -eq 0 ] 2> /dev/null ;do
	read -p "Introduzca un número de procesos: " proc
	if [ \( $proc -gt 0 \) -a \( $? -eq 0 \) ] 2> /dev/null;then
		j=1
	else
		echo "Dato incorrecto"
	fi
done
j=0
while [ $j -eq 0 ] 2> /dev/null ;do
	read -p "Introduzca el quantum: " quantum
	if [ \( $quantum -gt 0 \) -a \( $j -eq 0 \) ] 2> /dev/null;then
		j=1
	else
		echo "Dato incorrecto"
	fi
done
j=0
while [ $j -eq 0 ] 2> /dev/null ;do
	read -p "Introduzca al cantidad de memoria (MB) min 100: " mem_aux
	if [ \( $mem_aux -ge 100 \) -a \( $? -eq 0 \) ] 2> /dev/null;then
		j=1
	else
		echo "Dato incorrecto"
	fi
done
read -p "Meter lo datos de manera manual? [s,N] " manu
#Vectores de informacion
declare mem[$mem_aux] #Memoria de tamaño 1 MB por palabra
for (( y=0; y<$mem_aux; y++ ))
do
	mem[$y]="Li" #Inicializo la memoria a libre
done
declare proc_name[$proc] #Nombre de cada proceso
declare proc_arr[$proc] #Turno de llegada del proceso
declare proc_exe[$proc] #Tiempo de ejecución o ráfaga; se reducirá según el quantum
declare proc_mem[$proc] #Memoria que necesita cada proceso
declare proc_order[$proc] #Orden de la lista
clear
i=1
if [ $manu = "S" ] 2>/dev/null || [ $manu = "s" ] 2>/dev/null;then
	while [ $i -le $proc ];do
		j=0
		while [ $j -eq 0 ];do
			error=0
			read -p "Introduzca el nombre del proceso $i: " proc_name[$(expr $i-1)]
			SinRepetir
			if [ "${proc_name[$(expr $i-1)]}" -a $error -eq 0 ] 2> /dev/null ;then
				j=1;
			else
				echo "Nombre incorrecto o ya utilizado"
			fi
		done
		j=0
		while [ $j -eq 0 ];do
			read -p "Introduzca el turno de llegada de ${proc_name[$(expr $i-1)]}: " proc_arr[$(expr $i-1)]
			if [ "${proc_arr[$(expr $i-1)]}" -ge 0 ] 2> /dev/null ;then
				j=1
			else
				echo "Dato incorrecto"
			fi
		done
		j=0
		while [ $j -eq 0 ];do
			read -p "Introduzca la ráfaga de ${proc_name[$(expr $i-1)]}: " proc_exe[$(expr $i-1)]
			if [ "${proc_exe[$(expr $i-1)]}" -gt 0 ] 2> /dev/null ;then
				j=1
			else
				echo "Dato incorrecto"
			fi
		done
		j=0
		while [ $j -eq 0 ];do
			read -p "Introduzca la memoria (MB) que necesita ${proc_name[$(expr $i-1)]}: " proc_mem[$(expr $i-1)]
			if [ "${proc_mem[$(expr $i-1)]}" -gt 0 ] 2> /dev/null ;then
				j=1
			else
				echo "Dato incorrecto"
			fi
		done
		clear
		Informacion		
		let i=i+1
	done
else
	i=$proc
	Fichero
	clear
	Informacion
fi
InformacionPrint
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
read -p "Pulse cualquier tecla para ver la secuencia de procesos"
#Declaro las ultimas variables
declare proc_init[$proc]  #Posición de memoria dondé empieza 
declare proc_waitA[$proc] #Tiempo de espera acumulado
declare proc_waitR[$proc] #Tiempo de espera real
declare proc_memI[$proc]  #Palabra inicial
declare proc_memF[$proc]  #Palabra final
declare partition[$MAX]	  #Tamaño de las distintas particiones libres
min=${proc_order[0]}
clock=${proc_arr[$min]}	#Tiempo de ejecución
for (( i=0; i<$proc; i++ ))
do
	proc_waitA[$i]=$clock
done
declare proc_ret[$proc] #Tiempo de retorno
declare proc_retR[$proc] #Tiempo que ha estado el proceso desde entró hasta que terminó
end=0 #Procesos terminados
e=0 #e=0 aun no ha terminado, e=1 ya se terminó
j=0
exe=0	#Ejecuciones que ha habido en una vuelta de lista
quantum_aux=$quantum #Quantum del que se dispone
i=0 #Posición del porceso que se debe ejecutar ahora
#Comienza el agoritmo a funcionar
while [ $e -eq 0 ]
do
	if [ $i -eq $proc ];then #Si hemos llegado al final del vector lista
		if [ $exe -eq 0 ];then
			let clock=clock+1 #Si no ha habido ninguna ejecución en la lista anterior ir al siguiente turno
			EspAcu 1
		fi
		exe=0
		i=0
	fi
	z=${proc_order[$i]}
	AsignaMem $clock
	#Primera condición si la ejecución no es 0 (terminado), segunda si el momento de llegada es menor o igual al turno de reloj actual
	if [ "${proc_arr[$z]}" -le $clock ];then 
		if [ "${proc_exe[$z]}" -ne 0 ];then
			if [ $quantum_aux -eq $quantum ];then #Cambio de contexto
				clock_time=$clock
				OcuMem ${proc_name[$z]} 0 ${proc_mem[$z]}
			fi
			if [ $quantum_aux -gt 0 ];then #Pasa un ciclo
				let clock=clock+1
				let quantum_aux=quantum_aux-1
				proc_exe[$z]=$(expr ${proc_exe[$z]} - 1)
				EspAcu 0
				exe=1
			fi
			if [ "${proc_exe[$z]}" -eq 0 ];then #El proceso termina en este tiempo
				proc_ret[$z]=$clock	#El momento de retorno será igual al momento de salida en el reloj			
				let proc_retR[$z]=proc_ret[$z]-proc_arr[$z]
				quantum_aux=0								
				let end=end+1		
			fi
			if [ $quantum_aux -eq 0 ];then #Fin del uso de quantum del proceso
				echo "|${proc_name[$z]}($clock_time,${proc_exe[$z]})|"
				let i=i+1
				quantum_aux=$quantum
			fi
		else
			let i=i+1
		fi
	fi
	if [ $end -eq $proc ];then #Si todos los procesos terminados son igual a los procesos introducidos
		e=1
	fi
done
#Damos valor a proc_waitR
for (( y=0; y<$proc; y++ ))
do
	let proc_waitR[$y]=proc_waitA[$y]-proc_arr[$y]
done
read -p "Pulsa cualquier tecla para ver resumen."
#Imprimimos los resultados
echo " ------------------------------------------------------------------------------- "
echo "|    Proceso    |     Esp A     |     Esp R     |    Retorno A  |  Retorno Real |"
echo " ------------------------------------------------------------------------------- "  >> informe.txt
echo "|    Proceso    |     Esp A     |     Esp R     |    Retorno A  |  Retorno Real |"  >> informe.txt
for (( y=0; y<$proc; y++ ))
do
	echo " ------------------------------------------------------------------------------- "
	echo "|	${proc_name[$y]}	|	${proc_waitA[$y]}	|	${proc_waitR[$y]}	|	${proc_ret[$y]}	|	${proc_retR[$y]}	|"
	echo " ------------------------------------------------------------------------------- "  >> informe.txt
	echo "|	${proc_name[$y]}	|	${proc_waitA[$y]}	|	${proc_waitR[$y]}	|	${proc_ret[$y]}	|	${proc_retR[$y]}	|"  >> informe.txt
done
echo " ------------------------------------------------------------------------------- "
echo " ------------------------------------------------------------------------------- "  >> informe.txt
#Cálculo de valores medios
media 'proc_waitR[@]'
media_wait=$?
media 'proc_retR[@]'
media_ret=$?
echo "Los tiempos medio se calculan con los valores reales"
echo "Tiempo de espera medio: $media_wait"
echo "Tiempo de retorno medio: $media_ret"
echo "Los tiempos medio se calculan con los valores reales" >> informe.txt
echo "Tiempo de espera medio: $media_wait" >> informe.txt
echo "Tiempo de retorno medio: $media_ret" >> informe.txt
echo "${mem[@]}"