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
#Función Orden; ordena el vector arr según orden de menor a mayor
#Creación de la lista según llegada
function Orden {
	#Inicializo el vector de orden
	for (( p=0; p<$i; p++ ))
	do
		proc_order[$p]=-1
	done
	for (( k=$(expr $i-1); k>=0; k-- ))
	do
		max=0
		for (( jk=0; jk<$i; jk++ ))
		do
			for (( z=$k, coin=0; z<=$(expr $i-1); z++ ))
			do
				if [ $jk -eq "${proc_order[$z]}" ];then
					coin=1
				fi
			done
		if [ $coin -eq 0 ];then
			if [ ${proc_arr[$jk]} -ge $max ];then
				aux=$jk
				max=${proc_arr[$jk]}
			fi
		fi
		done
		proc_order[$k]=$aux
	done
}
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
	Orden
	echo " --------------------------------------------------------------- "
	echo "|    Proceso    |    Llegada    |     Ráfaga    |    Memoria    |"
	for (( y=0; y<$i; y++))
	do
		l=${proc_order[$y]}
		echo " --------------------------------------------------------------- "
		echo "|	${proc_name[$l]}	|	${proc_arr[$l]}	|	${proc_exe[$l]}	|	${proc_mem[$l]}	|"
	done
	echo " --------------------------------------------------------------- "
}
#Función InformacionPrint guarda en un fichero la informacion
function InformacionPrint {
	echo "Los datos de los procesos son los siguientes" >> informe.txt
	echo " --------------------------------------------------------------- "  >> informe.txt
	echo "|    Proceso    |    Llegada    |     Ráfaga    |    Memoria    |"  >> informe.txt
		for (( y=0; y<$proc; y++))
	do
		l=${proc_order[$y]}
		echo " --------------------------------------------------------------- "  >> informe.txt
		echo "|	${proc_name[$l]}	|	${proc_arr[$l]}	|	${proc_exe[$l]}	|	${proc_mem[$l]}	|"  >> informe.txt
	done
	echo " --------------------------------------------------------------- "  >> informe.txt
}
#Función Fichero, lee datos de un fichero
function Fichero {
	x=0
	r=0
	for y in $(cat InputRR.txt)
	do
		case $x in
		0)
			mem_aux=$(echo $y)
			if [ $auto != "c" ];then
				echo "La memoria es de $mem_aux MB"
			fi
			echo "La memoria es de $mem_aux MB" >> informe.txt
			;;
		1)
			quantum=$(echo $y)
			if [ $auto != "c" ];then
				echo "El quantum es $quantum"
			fi
			echo "El quantum es $quantum" >> informe.txt
			;;
		*)
			proc_name[$r]=$(echo $y | cut -f1 -d";")
			proc_arr[$r]=$(echo $y | cut -f2 -d";")
			proc_exe[$r]=$(echo $y | cut -f3 -d";")
			proc_mem[$r]=$(echo $y | cut -f4 -d";")
			let r=r+1
		esac
		let x=x+1
	done
	proc=${#proc_name[@]}
}
#Función EspAcu; aumenta el tiempo de espera acumulado de cada proceso
function EspAcu() {
	for (( y=0; y<$proc; y++ ))
	do
		if [ "${proc_exe[$y]}" -ne 0 ];then
			if [ $y -ne $z -o $1 -eq 1 ];then
				let proc_waitA[$y]=proc_waitA[$y]+1
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
			let media=media+array[$y]
			let tot=tot+1
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
	for (( y=$1; y <= $2; y++ ))
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
		if [ $value == $Li ];then
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
	for (( alpha=0; alpha<$proc; alpha++ ))
	do
		zed=${proc_order[$alpha]}
		if [ $1 -ge "${proc_arr[$zed]}" ];then
			if [ $mem_aux -lt ${proc_mem[$zed]} ];then
				if [ ${proc_stop[$zed]} -eq 0 ];then
					if [ $cola -eq $zed ]  2> /dev/null ;then
						if [ $auto != "c" ];then
							echo "El proceso ${proc_name[$zed]} necesita mas memoria de la disponible actualmente, se ejecutará más adelante"
						fi
						echo "El proceso ${proc_name[$zed]} necesita mas memoria de la disponible actualmente, se ejecutará más adelante" >> informe.txt
						#Bloqueamos la cola
						cola=$zed
						for (( beta=$alpha; beta<$proc; beta++))
						do
							st=${proc_order[$beta]}
							proc_stop[$st]=1
						done
					fi
				fi
			else
				if [ $cola -eq $zed ] 2> /dev/null;then
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
					#Desbloqueamos la cola
					for (( beta=$alpha; beta<$proc; beta++))
						do
							st=${proc_order[$beta]}
							proc_stop[$st]=0
						done
					let mem_aux=mem_aux-proc_mem[$zed]
					next=$(expr $alpha + 1)
					cola=${proc_order[$next]}
					if [ $auto != "c" ];then
						echo -e "${yellow}El proceso ${proc_name[$zed]} ha entrado en memoria${NC}"
					fi
					echo "El proceso ${proc_name[$zed]} ha entrado en memoria" >> informe.txt
				fi
			fi
		fi
		reubic=1
	done
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
		if [ $auto != "c" ];then
			echo -e "${inverted}La memoria se ha reubicado${NC}"
		fi
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
#Función Estado: dice para la ráfaga acual los datos actuales de los procesos
function Estado {
	local restante
	local memIni
	local memFin
	if [ $auto != "c" ];then
		echo ""	
		echo -e "${coffe}Al final de la ejecución de este tiempo los datos son:${NC}"
		echo " ------------------------------------------------------------------------------------------------------------------------------- "
		echo "|    Procesos   |     Tiempo esp acumulado      |      Ejecución restante       |    Memoria    |  Pos mem ini  |  Pos mem fin  |"
	fi
	echo "" >> informe.txt
	echo "Al final de la ejecución de este tiempo los datos son:" >> informe.txt
	echo " ------------------------------------------------------------------------------------------------------------------------------- " >> informe.txt
	echo "|    Procesos   |     Tiempo esp acumulado      |      Ejecución restante       |    Memoria    |  Pos mem ini  |  Pos mem fin  |" >> informe.txt
	for (( p=0; p<$proc;p++ ))
	do
		pp=${proc_order[$p]}
		if [ ${proc_exe[$pp]} -eq 0 ];then
			restante="END"
		else
			restante=${proc_exe[$pp]}
		fi
		if [ ${proc_memI[$pp]} = "-1" ] 2> /dev/null;then
			memIni="NA"
			memFin="NA"
		elif [ ${proc_memI[$pp]} = "-2" ] 2> /dev/null ;then
			memIni="END"
			memFin="END"
		else
			memIni=${proc_memI[$pp]}
			memFin=${proc_memF[$pp]}
		fi
		if [ $auto != "c" ];then
			echo " ------------------------------------------------------------------------------------------------------------------------------- " 
			echo "|	${proc_name[$pp]}	|		${proc_waitA[$pp]}		|		$restante		|	${proc_mem[$pp]}	|	$memIni	|	$memFin	|"
		fi
		echo " ------------------------------------------------------------------------------------------------------------------------------- " >>informe.txt
		echo "|	${proc_name[$pp]}	|		${proc_waitA[$pp]}		|		$restante		|	${proc_mem[$pp]}	|	$memIni	|	$memFin	|" >>informe.txt
	done
	if [ $auto != "c" ];then
		echo " ------------------------------------------------------------------------------------------------------------------------------- "
	fi
	echo " ------------------------------------------------------------------------------------------------------------------------------- " >>informe.txt
}
##Comienzo del programa
clear
#Header
echo " -------------------------------------------------------------------------------------------------- "
echo "|		Práctica de Control - Sistemas Operativos - Grado en Ingeniería Informática	   |"
echo "|                                               					       	   |"
echo "|		   Round Robin con particiones dinámicas ajustada al mejor y reubicable	    	   |"
echo "|                                                                                                  |"
echo "|					    Programado por:					   |"
echo "|			     José Luis Garrido Labrador <jgl0062@alu.ubu.es>			   |"
echo "|				   Luis Pedrosa Ruiz <lpr0026@alu.ubu.es>		    	   |"
echo "|                                                                                                  |"
echo "|					      Licencias:					   |"
echo "|				        CC-BY-SA (Documentación)				   |"
echo "|					    GPLv3 (Código)					   |"
echo " -------------------------------------------------------------------------------------------------- "
echo " -------------------------------------------------------------------------------------------------- "  > informe.txt
echo "|		Práctica de Control - Sistemas Operativos - Grado en Ingeniería Informática	   |" >> informe.txt
echo "|                                               					       	   |"  >> informe.txt
echo "|		   Round Robin con particiones dinámicas ajustada al mejor y reubicable	    	   |"  >> informe.txt
echo "|                                                                                                  |"  >> informe.txt
echo "|					    Programado por:					   |"  >> informe.txt
echo "|			     José Luis Garrido Labrador <jgl0062@alu.ubu.es>			   |"  >> informe.txt
echo "|				   Luis Pedrosa Ruiz <lpr0026@alu.ubu.es>		    	   |"  >> informe.txt
echo "|                                                                                                  |"  >> informe.txt
echo "|					      Licencias:					   |"  >> informe.txt
echo "|				        CC-BY-SA (Documentación)				   |"  >> informe.txt
echo "|					    GPLv3 (Código)					   |"  >> informe.txt
echo " -------------------------------------------------------------------------------------------------- "  >> informe.txt
#Captura de datos
read -p "Meter lo datos de manera manual? [s,n] " manu
SiNo $manu
while [ $? -eq 0 ];do
	echo "Valor incorrecto"
	read -p "Meter lo datos de manera manual? [s,n] " manu
	SiNo $manu
done
if [ $manu = "s" -o $manu = "S" ];then
	j=0
	while [ $j -eq 0 ] 2> /dev/null ;do
		read -p "Introduzca el quantum: " quantum
		if [ \( $quantum -gt 0 \) -a \( $? -eq 0 \) ] 2> /dev/null;then
			j=1
		else
			echo "Dato incorrecto"
		fi
	done
	echo "El quantum escogido es $quantum" >> informe.txt
	j=0
	while [ $j -eq 0 ] 2> /dev/null ;do
		read -p "Introduzca al cantidad de memoria (MB): " mem_aux
		if [ \( $mem_aux -ge 0 \) -a \( $? -eq 0 \) ] 2> /dev/null;then
			j=1
		else
			echo "Dato incorrecto"
		fi
	
	done
fi
j=0
while [ $j -eq 0 ]
do
	echo "Opciones de ejecución:"
	echo "[a] Transferencia manual entre tiempos"
	echo "[b] Transferencia automática entre tiempos (5s)"
	echo "[c] Ejecución completamente automática"
	read -p "Escoja una opción: " auto
		if [ $auto = "a" -o $auto = "b" -o $auto = "c" ];then
			j=1
		else
			echo "Valor incorrecto"
		fi
done

#Vectores de informacion
proc_name={} #Nombre de cada proceso
proc_arr={} #Turno de llegada del proceso
proc_exe={} #Tiempo de ejecución o ráfaga; se reducirá según el quantum
proc_mem={} #Memoria que necesita cada proceso
proc_order={} #Orden de la lista
proc_stop={} #Procesos que no pueden ejecutarse porque no tienen memoria (1 = parado, 0 no parado)
clear
i=1
t=0
mem_total=$mem_aux
if [ $manu = "S" ] 2>/dev/null || [ $manu = "s" ] 2>/dev/null;then
	while [ $t -eq 0 ];do
		j=0
		while [ $j -eq 0 ];do
			error=0
			read -p "Introduzca el nombre del proceso $i (p$i): " proc_name[$(expr $i-1)]
			SinRepetir
			if [ -z "${proc_name[$(expr $i-1)]}" ] 2> /dev/null ;then
				proc_name[$(expr $i-1)]="p$i"
				error=0
				SinRepetir
				if [ $error -eq 0 ];then
					j=1
				fi			
			elif [ $error -eq 0 ] ;then
				j=1
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
			read -p "Introduzca la ráfaga (tiempo de ejecución) de ${proc_name[$(expr $i-1)]}: " proc_exe[$(expr $i-1)]
			if [ "${proc_exe[$(expr $i-1)]}" -gt 0 ] 2> /dev/null ;then
				j=1
			else
				echo "Dato incorrecto"
			fi
		done
		j=0
		while [ $j -eq 0 ];do
			read -p "Introduzca la memoria (MB) que necesita ${proc_name[$(expr $i-1)]}: " proc_mem[$(expr $i-1)]
			if [ "${proc_mem[$(expr $i-1)]}" -le $mem_total -a "${proc_mem[$(expr $i-1)]}" -gt 0 ] 2> /dev/null ;then
				j=1
			else
				echo "Dato incorrecto"
			fi
		done
		j=0
		while [ $j -eq 0 ];do
			read -p "¿Quiere incluir más procesos [S]i,[n]o" p
			if [ -z $p ] 2> /dev/null;then
				p="s"
				j=1
			else
				SiNo $p
				if [ $? -eq 1 ];then
					j=1
				else
					j=0
				fi
			fi
		done
		if [ $p = "n" -o $p = "N" ];then
			t=1
			proc=${#proc_name[@]}
		fi	
		clear
		Informacion
		let i=i+1
	done
else
	clear
	Fichero
	i=$proc
	Informacion
fi
InformacionPrint
mem_total=$mem_aux
if [ $auto != "c" ];then
	read -p "Pulse cualquier tecla para ver la secuencia de procesos"
fi
#Declaro las ultimas variables
declare mem[$mem_aux] #Memoria de tamaño 1 MB por palabra
for (( y=0; y<$mem_aux; y++ ))
do
	mem[$y]=${Li} #Inicializo la memoria a libre
done
declare proc_waitA[$proc] #Tiempo de espera acumulado
declare proc_waitR[$proc] #Tiempo de espera real
declare proc_memI[$proc]  #Palabra inicial
declare proc_memF[$proc]  #Palabra final
for (( y=0; y<$proc; y++ ))
do
	proc_memI[$y]="-1"
done
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
position=0 #Posición del porceso que se debe ejecutar ahora
fin=0
mot=0
cola=${proc_order[0]}
#Comienza el agoritmo a funcionar
while [ $e -eq 0 ];do
	clear
	z=${proc_order[$position]}
	if [ $end -ne $proc ];then
		i=0
		while [ $i -eq 0 ]
		do
			if [ $position -eq $proc ];then #Si hemos llegado al final del vector lista
				position=0
				z=${proc_order[$position]}
				if [ $exe -eq 0 ];then
					let clock=clock+1 #Si no ha habido ninguna ejecución en la lista anterior ir al siguiente turno
					EspAcu 1
				fi
				exe=0
			fi
			if [ "${proc_exe[$z]}" -eq 0 ] || [ "${proc_arr[$z]}" -gt $clock ];then 
				#El proceso esta parado, terminado o aun no ha llegado
				let position=position+1
				z=${proc_order[$position]}
			elif [ "${proc_stop[$z]}" -eq 1 ];then
				z=${proc_order[$position]}
				if [ $cola -eq $z ];then
					if [ $mem_aux -ge ${proc_mem[$z]} ];then
						i=1
					else						
						let position=position+1
					fi
				else
					let position=position+1
				fi
				z=${proc_order[$position]}
			else
				i=1
			fi
		done
	fi
	if [ $auto != "c" ];then
		echo -e "${red}Ráfaga $clock${NC}"
	fi
	echo "" >> informe.txt
	echo "Ráfaga $clock" >> informe.txt
	AsignaMem $clock
	if [ $quantum_aux -eq $quantum ] && [ $end -ne $proc ];then #Cambio de contexto
		clock_time=$clock
		if [ $auto != "c" ];then
			echo -e "${blue}El proceso ${proc_name[$z]} entra ahora en el procesador${NC}"
		fi
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
		let proc_ret[$z]=$clock-1	#El momento de retorno será igual al momento de salida en el reloj (este aumento antes por lo que vamos hacia atras)		
		let proc_retR[$z]=proc_ret[$z]-proc_arr[$z]
		quantum_aux=0
		fin=1
		mot=1
		if [ $auto != "c" ];then
			echo "El proceso ${proc_name[$z]} termina en esta ráfaga"
		fi
		echo "El proceso ${proc_name[$z]} termina en esta ráfaga" >> informe.txt
	fi
	if [ $quantum_aux -eq 0 ] && [ $end -ne $proc ];then #Fin del uso de quantum del proceso
		if [ $mot -eq 0 ];then
			if [ $auto != "c" ];then
				echo "El proceso ${proc_name[$z]} agota su quantum en este tiempo, ráfagas restantes: ${proc_exe[$z]}"
			fi
			echo "El proceso ${proc_name[$z]} agota su quantum en este tiempo, ráfagas restantes ${proc_exe[$z]}" >> informe.txt
		else
			mot=0
		fi
		if [ $auto != "c" ];then
			echo -e "${cyan_back}|${proc_name[$z]}($clock_time,${proc_exe[$z]})|${NC}"
		fi
		echo "|${proc_name[$z]}($clock_time,${proc_exe[$z]})|" >> informe.txt
		let position=position+1
		quantum_aux=$quantum
	fi
	#Si el proceso se ha terminado
	if [ $fin -eq 1 ];then
    	let mem_aux=mem_aux+proc_mem[$z]
    	DesOcuMem ${proc_memI[$z]} ${proc_memF[$z]}
    	proc_memI[$z]="-2"
		let end=end+1
		if [ $auto != "c" ];then
			echo -e "${blue}El proceso ${proc_name[$z]} retorna al final de la ráfaga ${proc_ret[$z]}, la memoria asignada fue liberada${NC}"
		fi
		echo "El proceso ${proc_name[$z]} retorna al final de la ráfaga ${proc_ret[$z]}, la memoria asignada fue liberada" >> informe.txt
		auxiliar=1
		fin=0
	fi
	if [ $auxiliar -eq 1 ];then
		if [ $auto != "c" ];then
			echo -e "${purple}Memoria libre actual $mem_aux MB${NC}"
			echo -e "${gree}Distribución actual de la memoria${NC}"
			echo -e "${mem[@]}"
		fi
		echo "Memoria libre actual $mem_aux MB$" >> informe.txt
		echo "Distribución actual de la memoria" >> informe.txt
		for (( jk=0; jk<$mem_total; jk++ ))
		do
			if [ ${mem[$jk]} = $Li ];then
				mem_print[$jk]="Li"
			else
				mem_print[$jk]=${mem[$jk]}
			fi
		done
		echo "${mem_print[@]}" >> informe.txt
		auxiliar=0
	fi
	Estado
	if [ $auto = "a" ];then
		if [ $end -ne $proc ];then
			echo ""
			read -p "Pulse intro para continuar"
		fi
	elif [ $auto = "b" ];then
		sleep 5
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
if [ $auto != "c" ];then
	read -p "Pulsa cualquier tecla para ver resumen."
fi
#Imprimimos los resultados
clear
if [ $auto != "c" ];then
	echo " --------------------------------------------------------------------------------------------------------------- "
	echo "|    Proceso    |        Tiempo Espera Acu      |       Tiempo Espera Real      |     Salida    |  Retorno Real |"
fi
echo "Resumen final" >> informe.txt
echo " --------------------------------------------------------------------------------------------------------------- "  >> informe.txt
echo "|    Proceso    |        Tiempo Espera Acu      |       Tiempo Espera Real      |     Salida    |  Retorno Real |"  >> informe.txt
for (( y=0; y<$proc; y++ ))
do
	if [ $auto != "c" ];then
		echo " --------------------------------------------------------------------------------------------------------------- "
		echo "|	${proc_name[$y]}	|		${proc_waitA[$y]}		|		${proc_waitR[$y]}		|	${proc_ret[$y]}	|	${proc_retR[$y]}	|"
	fi
	echo " --------------------------------------------------------------------------------------------------------------- "  >> informe.txt
	echo "|	${proc_name[$y]}	|		${proc_waitA[$y]}		|		${proc_waitR[$y]}		|	${proc_ret[$y]}	|	${proc_retR[$y]}	|"  >> informe.txt
done
if [ $auto != "c" ];then
	echo " --------------------------------------------------------------------------------------------------------------- "
fi
echo " --------------------------------------------------------------------------------------------------------------- "  >> informe.txt
#Cálculo de valores medios
media 'proc_waitR[@]'
media_wait=$?
media 'proc_retR[@]'
media_ret=$?
if [ $auto != "c" ];then
	echo "Los tiempos medio se calculan con los valores reales"
	echo "Tiempo de espera medio: $media_wait"
	echo "Tiempo de retorno medio: $media_ret"
fi
echo "Los tiempos medio se calculan con los valores reales" >> informe.txt
echo "Tiempo de espera medio: $media_wait" >> informe.txt
echo "Tiempo de retorno medio: $media_ret" >> informe.txt