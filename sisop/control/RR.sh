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
	echo " ----------------------------------------------- "
	echo "|    Proceso    |    Llegada    |     Ráfaga    |"
	for (( y=0; y<$i; y++))
	do
		l=${proc_order[$y]}
		echo " ----------------------------------------------- "
		echo "|	${proc_name[$l]}	|	${proc_arr[$l]}	|	${proc_exe[$l]}	|"
	done
	echo " ----------------------------------------------- "
}
#Función InformacionPrint guarda en un fichero la informacion
function InformacionPrint {
	echo "Los datos de los procesos son los siguientes" >> informe.txt
	echo " ----------------------------------------------- "  >> informe.txt
	echo "|    Proceso    |    Llegada    |     Ráfaga    |"  >> informe.txt
		for (( y=0; y<$proc; y++))
	do
		l=${proc_order[$y]}
		echo " ----------------------------------------------- "  >> informe.txt
		echo "|	${proc_name[$l]}	|	${proc_arr[$l]}	|	${proc_exe[$l]}	|"  >> informe.txt
	done
	echo " ----------------------------------------------- "  >> informe.txt
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
		if [ "${proc_stop[$y]}" -eq 0 ] 2> /dev/null ;then
			media=$(expr $media + ${array[$y]})
			let tot=tot+1
		fi
	done
	media=$(expr $media / $tot)
	return $media
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
	if [ $auto != "c" ];then
		echo ""	
		echo -e "${coffe}Al final de la ejecución de este tiempo los datos son:${NC}"
		echo " ------------------------------------------------------------------------------- "
		echo "|    Procesos   |     Tiempo esp acumulado      |      Ejecución restante       |"
	fi
	echo "" >> informe.txt
	echo "Al final de la ejecución de este tiempo los datos son:" >> informe.txt
	echo " ------------------------------------------------------------------------------- " >> informe.txt
	echo "|    Procesos   |     Tiempo esp acumulado      |      Ejecución restante       |" >> informe.txt
	for (( p=0; p<$proc;p++ ))
	do
		pp=${proc_order[$p]}
		if [ ${proc_exe[$pp]} -eq 0 ];then
			restante="END"
		else
			restante=${proc_exe[$pp]}
		fi
		if [ $auto != "c" ];then
			echo " ------------------------------------------------------------------------------- "
			echo "|	${proc_name[$pp]}	|		${proc_waitA[$pp]}		|		$restante		|"
		fi
		echo " ------------------------------------------------------------------------------- " >>informe.txt
		echo "|	${proc_name[$pp]}	|		${proc_waitA[$pp]}		|		$restante		|" >>informe.txt
	done
	if [ $auto != "c" ];then
		echo " ------------------------------------------------------------------------------- "
	fi
	echo " ------------------------------------------------------------------------------- " >>informe.txt
}
##Comienzo del programa
clear
#Header
echo " -------------------------------------------------------------------------------------------------- "
echo "|		Práctica de Control - Sistemas Operativos - Grado en Ingeniería Informática	   |"
echo "|                                               					       	   |"
echo "|					      Round Robin 				    	   |"
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
echo "|						   Round Robin 			    	   |"  >> informe.txt
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
proc_order={} #Orden de la lista
proc_stop={} #Procesos que no pueden ejecutarse porque no tienen memoria (1 = parado, 0 no parado)
clear
i=1
t=0
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
			read -p "¿Quiere incluir más procesos [S]i,[n]o " p
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
if [ $auto != "c" ];then
	read -p "Pulse cualquier tecla para ver la secuencia de procesos"
fi
#Declaro las ultimas variables
declare proc_waitA[$proc] #Tiempo de espera acumulado
declare proc_waitR[$proc] #Tiempo de espera real
min=${proc_order[0]}
clock=${proc_arr[$min]}	#Ráfaga actual
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
				#El proceso esta terminado o aun no ha llegado
				let position=position+1
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
				let clock=clock+quantum
				clock_time=$quantum #Cuanto tiempo se ha estado ejecutando en este turno
				EspAcu 0				
				let exe=exe+1			
 			fi
 		fi
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