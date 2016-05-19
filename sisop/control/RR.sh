#!/bin/bash
#Author: José Luis Garrido Labrador
#Organitation: Burgos University
#School year: 2015/2016 - 2nd semester
#Description: Simulation of Round Robin Algorithm and memory management
#Licence: CC-BY-SA (Documentation), GPLv3 (Source)

#Variables globales de ayuda
MAX=9999 
#Colores
coffe='\e[0;33m'
yellow='\e[1;33m'
green='\e[1;32m'
purple='\e[1;35m'
red='\e[1;31m'
cyan='\e[1;36m'
cyan_back='\e[1;44m'
black='\e[1;30m'
blue='\e[1;34m'
white='\e[0;39m'
inverted='\e[7m'
NC='\e[0m' # No Color
Li="${cyan}Li${NC}"

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
	echo "Los datos de los procesos son los siguientes" >> informe.txt
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
		if [ "${proc_exe[$y]}" -ne 0 ];then
			if [ $y -ne $z -o $1 -eq 1 ];then
				if [ ${proc_waitA[$y]} != "NE" ] 2> /dev/null;then
					let proc_waitA[$y]=proc_waitA[$y]+1
				fi
			fi
		fi
	done
}
#Función media; calcula la media de valores de un vector
function media() {
	local array=("${!1}")
	media=0
	tot=0
	for (( y=0; y<$proc; y++ ))
	do
		if [ "${proc_stop[$y]}" -eq 0 ] 2> /dev/null ;then
			media=$(expr $media + ${array[$y]})
			let tot=tot+1
		fi
	done
	media=$(expr $media / $tot)
	return $media
}
#Función OcuMem; llena la memoria del proceso pasado por parámetro. $1  nombre de proceso, $2 origen $3 fin $4 identificador vectorial del proceso
function OcuMem() {
	for (( y=$2; y<=$3; y++ ))
	do
		mem[$y]=$1
		mem_dir[$y]=$4
	done
}
#Función DesOcuMem; libera la memoria de un determinado sitio. $1 origen $2 final
function DesOcuMem() {
	for (( y=$1; y<=$2; y++ ))
	do
		mem[$y]=${Li}
		mem_dir[$y]=-1
	done
}
#Función PartFree; calcula las distintas particiones libres, su tamaño y su posición
function PartFree {
	for (( y=0; y<$MAX ; y++ ))
	do
		partition[$y]=0
	done
	part=0
	h=0
	for (( y=0; y<${#mem[@]}; y++ ))
	do
		value=${mem[$y]}
		if [ $value == ${Li} ];then
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
#Función AsignaMem; asigna la memoria a los procesos
function AsignaMem() {
	auxiliar=0
	reubic=1
	for (( zed=0; zed<$proc; zed++ ))
	do
		if [ $1 -eq "${proc_arr_aux[$zed]}" ];then
			if [ $mem_total -lt "${proc_mem[$zed]}" ];then
				echo "El proceso ${proc_name[$zed]} necesita mas memoria que la total, nunca se ejecutará"
				echo "El proceso ${proc_name[$zed]} necesita mas memoria que la total, nunca se ejecutará" >> informe.txt
				proc_stop[$zed]=1
				let end=end+1
				proc_waitA[$zed]="NE"
				proc_waitR[$zed]="NE"
				proc_retR[$zed]="NE"
				proc_ret[$zed]="NE"
			elif [ $mem_aux -lt ${proc_mem[$zed]} ];then
				echo "El proceso ${proc_name[$zed]} necesita mas memoria de la disponible actualmente, se ejecutará más adelante"
				echo "El proceso ${proc_name[$zed]} necesita mas memoria de la disponible actualmente, se ejecutará más adelante" >> informe.txt
				let proc_arr_aux[$zed]=proc_arr_aux[$zed]+1
				proc_stop[$zed]=1
			else
				PartFree
				memoriaLibre=$MAX
				#Ahora debo buscar la particion de memoria que menos esté ocupada 
				for (( ex=0; ex<=$part; ex++ ))
				do
					if [ ${proc_mem[$zed]} -le ${partition[$ex]} ];then
						if [ ${partition[$ex]} -lt $memoriaLibre ];then
							memoriaLibre=${partition[$ex]}
							proc_memI[$zed]=${part_init[$ex]}
							reubic=0
						fi
					fi
				done
				if [ $reubic -eq 1 ];then
					reubicar
					proc_memI[$zed]=$?
				fi
				let proc_memF[$zed]=proc_memI[$zed]+proc_mem[$zed]
				let proc_memF[$zed]=proc_memF[$zed]-1
				OcuMem ${proc_name[$zed]} ${proc_memI[$zed]} ${proc_memF[$zed]} $zed		
				auxiliar=1
				proc_stop[$zed]=0
				let mem_aux=mem_aux-proc_mem[$zed]
				echo -e "${yellow}El proceso ${proc_name[$zed]} ha entrado en memoria${NC}"
				echo "El proceso ${proc_name[$zed]} ha entrado en memoria" >> informe.txt
			fi
		fi
		reubic=1
	done
	if [ $fin -eq 1 ];then
		auxiliar=1
	fi
}
#Funcion reubicar; reubica la memoria desplazandola hacia la izquierda todos los programas
function reubicar {
	before=0
	local aux
	local aux2=0
	local ret
	for (( w=0; w<$mem_total; w++))
	do
		if [ ${mem_dir[$w]} -eq -1 -a $before -eq 0 ];then
				before=1
				aux_init=$w
		elif [ $before -eq 1 -a ${mem_dir[$w]} -ne -1 ];then
				aux=${mem_dir[$w]}
				aux2=1
				DesOcuMem ${proc_memI[$aux]} ${proc_memF[$aux]}
				proc_memI[$aux]=$aux_init
				let proc_memF[$aux]=proc_memI[$aux]+proc_mem[$aux]
				let proc_memF[$aux]=proc_memF[$aux]-1
				OcuMem ${proc_name[$aux]} ${proc_memI[$aux]} ${proc_memF[$aux]} $aux
				before=0
				w=proc_memF[$aux]
		fi
	done
	if [ $aux2 -eq 1 ];then
		echo -e "${inverted}La memoria se ha reubicado${NC}"
		echo "La memoria se ha reubicado" >> informe.txt
	fi
	let ret=${proc_memF[$aux]}+1
	return $ret
}
#Función SiNo; comprueba si se ha medito un si o un no
function SiNo(){
	local j=0
	if [ $1 = "s" -o $1 = "S" -o $1 = "n" -o $1 = "N" ] 2> /dev/null ;then
		j=1
	fi
	return $j
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
mem_aux=100 #Memoria en Megas
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
echo "El quantum escogido es $quantum" >> informe.txt
j=0
while [ $j -eq 0 ] 2> /dev/null ;do
	read -p "Introduzca al cantidad de memoria (MB) min 100: " mem_aux
	if [ \( $mem_aux -ge 100 \) -a \( $? -eq 0 \) ] 2> /dev/null;then
		j=1
	else
		echo "Dato incorrecto"
	fi
done
read -p "Meter lo datos de manera manual? [s,n] " manu
SiNo $manu
while [ $? -eq 0 ];do
	echo "Valor incorrecto"
	read -p "Meter lo datos de manera manual? [s,n] " manu
	SiNo $manu
done
read -p "Desea ejecutar la simulación automáticamente? [s,n] " auto
SiNo $auto
while [ $? -eq 0 ];do
	echo "
	Valor incorrecto"
	read -p "Desea ejecutar la simulación automáticamente? [s,n] " auto
	SiNo $auto
done

#Vectores de informacion
declare mem[$mem_aux] #Memoria de tamaño 1 MB por palabra
for (( y=0; y<$mem_aux; y++ ))
do
	mem[$y]=${Li} #Inicializo la memoria a libre
done
declare proc_name[$proc] #Nombre de cada proceso
declare proc_arr[$proc] #Turno de llegada del proceso
declare proc_exe[$proc] #Tiempo de ejecución o ráfaga; se reducirá según el quantum
declare proc_mem[$proc] #Memoria que necesita cada proceso
mem_total=$mem_aux 		#Memoria total de la que dispongo
declare proc_order[$proc] #Orden de la lista
declare proc_stop[$proc] #Procesos que no pueden ejecutarse porque no tienen memoria (1 = parado, 0 no parado)

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
declare proc_arr_aux[$proc] #Momento en el que el proceso puede ocupar memoria
for (( y=0; y<$proc; y++ ))
do
	proc_arr_aux[$y]=${proc_arr[$y]}
done
min=${proc_order[0]}
clock=${proc_arr[$min]}	#Ráfaga actual
for (( i=0; i<$proc; i++ ))
do
	proc_waitA[$i]=$clock
done
for (( y=0; y<$proc; y++ ))
do
	proc_stop[$y]=0
done
declare mem_dir[$mem_aux]
for (( y=0; y<$mem_aux; y++ ))
do
	mem_dir[$y]=-1
done
declare proc_ret[$proc] #Tiempo de retorno
declare proc_retR[$proc] #Tiempo que ha estado el proceso desde entró hasta que terminó
declare mem_print[$proc] #Memoria que se guardará en el fichero (sin colores)
end=0 #Procesos terminados
e=0 #e=0 aun no ha terminado, e=1 ya se terminó
j=0
exe=0	#Ejecuciones que ha habido en una vuelta de lista
quantum_aux=$quantum #Quantum del que se dispone
i=0 #Posición del porceso que se debe ejecutar ahora
fin=0
mot=0
#Comienza el agoritmo a funcionar
while [ $e -eq 0 ];do
	clear
	echo -e "${red}Ráfaga $clock${NC}"
	echo "" >> informe.txt
	echo "Ráfaga $clock" >> informe.txt
	if [ $fin -eq 1 ];then
    	let mem_aux=mem_aux+proc_mem[$proc_bef]
    	DesOcuMem ${proc_memI[$proc_bef]} ${proc_memF[$proc_bef]}
		let end=end+1
		echo -e "${blue}El proceso ${proc_name[$proc_bef]} retornó en la ráfaga ${proc_ret[$proc_bef]}, la memoria asignada fue liberada${NC}"
		echo "El proceso ${proc_name[$proc_bef]} retornó en la ráfaga ${proc_ret[$proc_bef]}, la memoria asignada fue liberada" >> informe.txt
	fi
	AsignaMem $clock
	fin=0 
	z=${proc_order[$i]}
	if [ $end -ne $proc ];then
		while [ "${proc_exe[$z]}" -eq 0 ] || [ "${proc_stop[$z]}" -eq 1 ] || [ "${proc_arr[$z]}" -gt $clock ] 
		do #El proceso esta parado, terminado o aun no ha llegado
			if [ $i -eq $proc ];then #Si hemos llegado al final del vector lista
				i=0
				z=${proc_order[$i]}
				if [ $exe -eq 0 ];then
					let clock=clock+1 #Si no ha habido ninguna ejecución en la lista anterior ir al siguiente turno
					EspAcu 1
				fi
				exe=0
			else
				let i=i+1
				z=${proc_order[$i]}
			fi
		done
	fi	
	if [ $quantum_aux -eq $quantum ] && [ $end -ne $proc ];then #Cambio de contexto
		clock_time=$clock
		echo -e "${blue}El proceso ${proc_name[$z]} entra ahora en el procesador${NC}"
		echo "El proceso ${proc_name[$z]} entra ahora en el procesador" >> informe.txt
	fi
	if [ $quantum_aux -gt 0 ] && [ $end -ne $proc ];then #Pasa un ciclo
		let clock=clock+1
		let quantum_aux=quantum_aux-1
		proc_exe[$z]=$(expr ${proc_exe[$z]} - 1)
		EspAcu 0
		exe=1
	fi
	if [ "${proc_exe[$z]}" -eq 0 ] && [ $end -ne $proc ];then #El proceso termina en este tiempo
		proc_ret[$z]=$clock	#El momento de retorno será igual al momento de salida en el reloj			
		let proc_retR[$z]=proc_ret[$z]-proc_arr[$z]
		quantum_aux=0								
		fin=1
		proc_bef=$z
		mot=1
		echo "El proceso ${proc_name[$z]} termina en esta ráfaga"
	fi
	if [ $quantum_aux -eq 0 ] && [ $end -ne $proc ];then #Fin del uso de quantum del proceso
		if [ $mot -eq 0 ];then
			echo "El proceso ${proc_name[$z]} agota su quantum en este tiempo, ráfagas restantes: ${proc_exe[$z]}"
			echo "El proceso ${proc_name[$z]} agota su quantum en este tiempo, ráfagas rstántes ${proc_exe[$z]}" >> informe.txt
		else
			mot=0
		fi
		echo -e "${cyan_back}|${proc_name[$z]}($clock_time,${proc_exe[$z]})|${NC}"
		echo "|${proc_name[$z]}($clock_time,${proc_exe[$z]})|" >> informe.txt
		let i=i+1
		quantum_aux=$quantum
	fi
	if [ $auxiliar -eq 1 ];then
		echo -e "${purple}Memoria libre actual $mem_aux MB${NC}"
		echo -e "${gree}Distribución actual de la memoria${NC}"
		echo -e "${mem[@]}"
		echo "Memoria libre actual $mem_aux MB$" >> informe.txt
		echo "Distribución actual de la memoria" >> informe.txt
		for (( jk=0; jk<$mem_total; jk++ ))
		do
			if [ ${mem[$jk]} = "${Li}" ];then
				mem_print[$jk]="Li"
			else
				mem_print[$jk]=${mem[$jk]}
			fi
		done
		echo "${mem_print[@]}" >> informe.txt
		auxiliar=0
	fi
	if [ $auto = "n" ] || [ $auto = "N" ];then
		read -p "Pulse intro para continuar"
	else
		sleep 3
	fi
	if [ $end -eq $proc ];then #Si todos los procesos terminados son igual a los procesos introducidos
			e=1
	fi
done
#Damos valor a proc_waitR
for (( y=0; y<$proc; y++ ))
do
	if [ "${proc_stop[$y]}" -eq 0 ] 2> /dev/null ;then
		let proc_waitR[$y]=proc_waitA[$y]-proc_arr[$y]
	fi
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