#!/bin/bash
#Author: José Luis Garrido Labrador
#Organitation: Burgos University
#School year: 2015/2016 - 2nd semester
#Description: Simulation of Round Robin Algorithm and memory management
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
#Función Informacion que muestra al usuario la informacion de los datos introducidos
function Informacion {
	echo " -----------------------------------------------"
	echo "|	Proceso	|	Llegada	|	Ráfaga	|"
		for (( y=0; y<$i; y++))
	do
		echo " -----------------------------------------------"
		echo "|	${proc_name[$y]}	|	${proc_arr[$y]}	|	${proc_exe[$y]}	|"
	done
	echo " -----------------------------------------------"
}
#Función InformacionPrint guarda en un fichero la informacion
function InformacionPrint {
	echo " -----------------------------------------------"  >> informe.txt
	echo "|	Proceso	|	Llegada	|	Ráfaga	|"  >> informe.txt
		for (( y=0; y<$i; y++))
	do
		echo " -----------------------------------------------"  >> informe.txt
		echo "|	${proc_name[$y]}	|	${proc_arr[$y]}	|	${proc_exe[$y]}	|"  >> informe.txt
	done
	echo " -----------------------------------------------"  >> informe.txt
}
#Función Fichero, lee datos de un fichero
function Fichero {
	x=0
	for y in $(cat InputRR.txt)
	do
		proc_name[$x]=$(echo $y | cut -f1 -d";")
		proc_arr[$x]=$(echo $y | cut -f2 -d";")
		proc_exe[$x]=$(echo $y | cut -f3 -d";")
		let x=x+1
	done
}
#Función EspAcu; aumenta el tiempo de espera acumulado de cada proceso
function EspAcu() {
	for (( y=0; y<$proc; y++ ))
	do
		if [ $y -ne $z -o $1 -eq 1 ] && [ "${proc_exe[$y]}" -ne 0 ];then
			let proc_waitA[$y]=proc_waitA[$y]+clock_time
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
#Comienzo del programa
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
	fi
done
j=0
while [ $j -eq 0 ] 2> /dev/null ;do
	read -p "Introduzca el quantum: " quantum
	if [ \( $quantum -gt 0 \) -a \( $j -eq 0 \) ] 2> /dev/null;then
		j=1
	fi
done
read -p "Meter lo datos de manera manual? [s,N] " manu
#Vectores de informacion
declare proc_name[$proc] #Nombre de cada proceso
declare proc_arr[$proc] #Turno de llegada del proceso
declare proc_exe[$proc] #Tiempo de ejecución o ráfaga; se reducirá según el quantum
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
		clear
		Informacion
		#echo "${proc_name[$(expr $i-1)]}, ${proc_arr[$(expr $i-1)]}, ${proc_exe[$(expr $i-1)]}"
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
#Declaro las ultimas variables
declare proc_waitA[$proc] #Tiempo de espera acumulado
declare proc_waitR[$proc] #Tiempo de espera real
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
i=0 #Posición del porceso que se debe ejecutar ahora
m=$(expr $proc - 1) #Cantidad de procesos que se han de ejecutar (empezando por 0)
j=0
exe=0	#Ejecuciones que ha habido en una vuelta de lista
#Comienza el agoritmo a funcionar
while [ $e -eq 0 ]
do
	if [ $i -gt $m ];then #Si hemos llegado al final del vector lista
		i=0
		if [ $exe -eq 0 ];then
			let clock=clock+1 #Si no ha habido ninguna ejecución en la lista anterior ir al siguiente turno
			clock_time=1
			EspAcu 1
		fi
		exe=0
	fi
	z=${proc_order[$i]}
	#Primera condición si la ejecución no es 0 (terminado), segunda si el momento de llegada es menor o igual al turno de reloj actual
	if [ "${proc_arr[$z]}" -le $clock ];then 
		if [ "${proc_exe[$z]}" -ne 0 ];then
			if [ "${proc_exe[$z]}" -le $quantum ];then #El proceso termina en este tiempo
				echo "${proc_name[$z]}($clock,0)"
				echo "${proc_name[$z]}($clock,0)" >>informe.txt
				let clock=clock+proc_exe[$z]
				proc_ret[$z]=$clock	#El momento de retorno será igual al momento de salida en el reloj			
				let proc_retR[$z]=proc_ret[$z]-proc_arr[$z]
				let end=end+1
				clock_time=${proc_exe[$z]} #Cuanto tiempo se ha estado ejecutando en este turno
				EspAcu 0
				proc_exe[$z]=0
				let exe=exe+1
			else 
				let clock=clock+quantum
				clock_time=$quantum #Cuanto tiempo se ha estado ejecutando en este turno
				EspAcu 0
				let proc_exe[$z]=proc_exe[$z]-quantum
				let exe=exe+1
				echo "${proc_name[$z]}($clock,${proc_exe[$z]})"
				echo "${proc_name[$z]}($clock,${proc_exe[$z]})" >>informe.txt
			fi
		fi
	fi	
	let i=i+1
	if [ $end -eq $proc ];then #Si todos los procesos terminados son igual a los procesos introducidos
		e=1
	fi
done
#Damos valor a proc_waitR
for (( y=0; y<$proc; y++ ))
do
	let proc_waitR[$y]=proc_waitA[$y]-proc_arr[$y]
done
#Imprimimos los resultados
echo " -------------------------------------------------------------------------------- "
echo "|    Proceso    |     Esp A     |     Esp R     |    Retorno A   |  Retorno Real |"
echo " -------------------------------------------------------------------------------- "  >> informe.txt
echo "|    Proceso    |     Esp A     |     Esp R     |    Retorno A   |  Retorno Real |"  >> informe.txt
for (( y=0; y<$proc; y++ ))
do
	echo " -------------------------------------------------------------------------------- "
	echo "|	${proc_name[$y]}	|	${proc_waitA[$y]}	|	${proc_waitR[$y]}	|	${proc_ret[$y]}	|	${proc_retR[$y]}	|"
	echo " -------------------------------------------------------------------------------- "  >> informe.txt
	echo "|	${proc_name[$y]}	|	${proc_waitA[$y]}	|	${proc_waitR[$y]}	|	${proc_ret[$y]}	|	${proc_retR[$y]}	|"  >> informe.txt
done
echo " -------------------------------------------------------------------------------- "
echo " -------------------------------------------------------------------------------- "  >> informe.txt
#Cáclulo de valores medios
media 'proc_waitR[@]'
media_wait=$?
media 'proc_retR[@]'
media_ret=$?
echo "Los tiempos medio se calculan con los valores reales"
echo "Tiempo de espera medio: $media_wait"
echo "Tiempo de retorno medio: $media_ret"