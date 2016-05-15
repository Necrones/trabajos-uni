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

#@date 31/05/2015
#@version 2.0
#Sinopsis: script que recibe desde un fichero una lista de 
#procesos con el formato "Nombre del proceso:Tamaño de memoria:Tiempo de estancia"
#ordenados segun el criterio SJF y devuelve una tabla de procesos con el orden en el que los procesos han ocupado 
#la memoria. El tipo de particiones utilizado es particiones variables.
#El tamaño de memoria debe ser mayor de 22 y menor de 81 para que el problema tenga sentido. En este caso usamos 50.
#Para una mejor visualización recomiendo ensanchar la pantalla del terminal donde se ejecute.

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

echo "" > procesosEnMemoria.txt
echo "" > SJFordenados.txt

clear




#Guardo los valores de proceso, memoria y tiempo del archivo agrupados en tres arrays
proceso=(`cat datos.txt | cut -f 1 -d":"`)
memoria=(`cat datos.txt | cut -f 2 -d":"`)
estancia=(`cat datos.txt | cut -f 3 -d":"`)
llegada=(`cat datos.txt | cut -f 4 -d":"`)


m=2
p=0
cont=0

#Declaro la posición inicial en el vector que almacena las posiciones iniciales
vec_ini=( 0 )
#Declaro la posición final en el vector que almacena las posiciones finales. La recibo de un parámetro que indica el tamaño de memoria.
vec_fin=( $(($1-1)) )
#Declaro el estado de la partición correspondiente que comienza en la misma posición del vector inicial y acaba en la misma posición del vector final
vec_est=( "Li" )
#Declaro una variable que cuenta los procesos que han sido asignados a memoria.
pr_asignado=0
#Defino el contenido del vector que se va a mostrar en la ejecución y va ir siendo modificado, el tamaño de este es igual al de la memoria que estamos utilizando.
for (( i=0 ; i<$1 ; i++ ))
do
	sal[$i]="Li"
done
#Guardo el tamaño de los vectores en tres variables para poder aumentarles o reducirles según sea necesario.
temp_ini=${#vec_ini[@]}
temp_fin=${#vec_fin[@]}
temp_est=${#vec_est[@]}

cont=0

############################## PUEBA COLORES #################################
function colorear(){
echo ""
for ((s=0 ; $s < ${#sal[@]} ; s++))
do

	#echo Toma s tonta: $s
	if [[ (${sal[$s]} == "Li") ]]
		then
			 echo -e -n "${blanco}Li ${NC}"
	fi

	if [[ (${sal[$s]} == "T1") ]]
		then 
			echo -e -n "${amarillo}T1 ${NC}"
	fi

	if [[ (${sal[$s]} == "T2") ]]
		then 
			echo -e -n "${red}T2 ${NC}"
	fi

	if [[ (${sal[$s]} == "T3") ]]
		then 
			echo -e -n "${cyan}T3 ${NC}"
	fi

	if [[ (${sal[$s]} == "T4") ]]
		then
			 echo -e -n "${morado}T4 ${NC}"
	fi

	if [[ (${sal[$s]} == "T5") ]]
		then 
			echo -e -n "${azul}T5 ${NC}"
	fi

	if [[ (${sal[$s]} == "T6") ]]
		then 
			echo -e -n "${green}T6 ${NC}"
	fi
	if [[ (${sal[$s]} == "T7") ]]
		then 
			echo -e -n "${amarillo}T7 ${NC}"
	fi
	if [[ (${sal[$s]} == "T8") ]]
		then 
			echo -e -n "${red}T8 ${NC}"
	fi

	cont=`expr $cont + 1`
		if [[ $cont == 20 ]]
		then
		cont=0
		echo  ""
		echo  ""
		fi

done
echo "   - $tiempo" 

}


function colorearNC(){
echo "" >> resultadoSJF.txt
for ((s=0 ; $s < ${#sal[@]} ; s++))
do

	#echo Toma s tonta: $s
	if [[ (${sal[$s]} == "Li") ]]
		then
			 echo -n "Li " >> resultadoSJF.txt
	fi

	if [[ (${sal[$s]} == "T1") ]]
		then 
			echo -n "T1 " >> resultadoSJF.txt
	fi

	if [[ (${sal[$s]} == "T2") ]]
		then 
			echo -n "T2 " >> resultadoSJF.txt
	fi

	if [[ (${sal[$s]} == "T3") ]]
		then 
			echo -n "T3 " >> resultadoSJF.txt
	fi

	if [[ (${sal[$s]} == "T4") ]]
		then
			 echo -n "T4 " >> resultadoSJF.txt
	fi

	if [[ (${sal[$s]} == "T5") ]]
		then 
			echo -n "T5 " >> resultadoSJF.txt
	fi

	if [[ (${sal[$s]} == "T6") ]]
		then 
			echo -n "T6 " >> resultadoSJF.txt
	fi
	if [[ (${sal[$s]} == "T7") ]]
		then 
			echo -n "T7 " >> resultadoSJF.txt
	fi
	if [[ (${sal[$s]} == "T8") ]]
		then 
			echo -n "T8 " >> resultadoSJF.txt
	fi
done
echo "   - $tiempo" >> resultadoSJF.txt

}

###############################################################################


#Creo una variable tiempo
tiempo=0

echo
echo ---------------------------------------------------------
echo T - Memoria = $1 MB
echo ---------------------------------------------------------
echo
echo
echo DATOS:
echo ---------------------------------------------------------
	cat datos.txt
echo ---------------------------------------------------------

echo "" >> resultadoSJF.txt
echo "---------------------------------------------------------" >> resultadoSJF.txt
echo "T - Memoria = $1MB" >> resultadoSJF.txt
echo "---------------------------------------------------------" >> resultadoSJF.txt
echo "" >> resultadoSJF.txt
echo "" >> resultadoSJF.txt
echo "DATOS:" >> resultadoSJF.txt
echo "---------------------------------------------------------" >> resultadoSJF.txt
	cat datos.txt >> resultadoSJF.txt
echo "---------------------------------------------------------" >> resultadoSJF.txt
 


for ((s=0 ; $s < ${#memoria[@]} ; s++))
do
	
if [[ ${memoria[$s]} -gt $1 ]] 

	then
	echo
	echo
	echo -e "${red}ERROR - La memoria es muy pequeña${NC}"
	echo

	echo "" >> resultadoSJF.txt
	echo "" >> resultadoSJF.txt
	echo "ERROR - La memoria es muy pequeña" >> resultadoSJF.txt
	echo "" >> resultadoSJF.txt

	break
else


for ((i=0 ; $pr_asignado<${#proceso[@]} ; i++))
do
	if [[ $pr_asignado -ne $i ]]
	then
		tiempo=$(($tiempo+1))
		#########################################################
		#echo Punto 5
		cont=0
		colorear
		colorearNC
		#########################################################

		for (( j=0 ; j<${#vec_est[@]} ; j++ ))
		do
#echo for restar estancias $j
			if [[ ${vec_est[$j]} -gt 0 ]]
			then
				vec_est[$j]=$((${vec_est[$j]}-1))
				if [[ ${vec_est[$j]} -eq 0 ]]
				then
					vec_est[$j]="Li"
				fi
			fi		

			if [[ ${vec_est[$j]} == "Li" ]]
			then
				for (( k=${vec_ini[$j]} ; k<=${vec_fin[$j]} ; k++ ))
				do
					sal[$k]="Li"
				done
			fi

			if [[ ${vec_est[$j]} -lt 0 ]]
			then
				vec_est[$j]=""
			fi
		done

		var_est=$((${#vec_est[@]}-1))
	
		for (( k=0 ; k<$var_est ; k++ ))
		do

			if [[ (${vec_est[$k]} == "Li") && (${vec_est[$(($k+1))]} == "Li") ]]
			then

				for (( l=$(($k+1)) ; l<$(($var_est+1)) ; l++ ))
				do
					vec_est[$l]=${vec_est[$(($l+1))]}
					vec_ini[$l]=${vec_ini[$(($l+1))]}
					vec_fin[$(($l-1))]=${vec_fin[$l]}
				done

			vec_est[$(($temp_est+1))]=""
			temp_est=$(($temp_est-1))
			vec_ini[$temp_ini]=""
			temp_ini=$(($temp_ini-1))
			vec_fin[$temp_fin]=""
			temp_fin=$(($temp_fin-1))
			k=$(($k-1))	

			fi
		done

		i=$(($i-1)) #Dismunuyo un valor de i para que el proceso que antes no ha entrado vuelva a intentarlo.
	fi


	for (( j=0 ; j<$temp_est && $pr_asignado==$i; j++))	#Bucle para recorrer cada una de las particiones creadas.
	do

		if [[ ${vec_est[$j]} -eq "Li" ]]	#Evalúa si la partición está libre.
		then

			if [[ $((${vec_fin[$j]}-${vec_ini[$j]})) -ge $((${memoria[$i]}-1)) ]]	#Evalúa la partición si la partición libre es igual que el proceso a introducir.
			then

				

				for (( k=$temp_ini ; k>$(($j+1)) ; k-- ))	#Avanzamos los valores de cada posición del vector a la posición siguiente de dicho vector.
				do
					vec_ini[$(($k+1))]=${vec_ini[$k]}
				done
				vec_ini[$(($j+1))]=$((${vec_ini[$j]}+${memoria[$i]}))

				for (( k=$temp_fin ; k>$j ; k-- ))	#Avanzamos los valores de cada posición del vector a la posición siguiente de dicho vector.
				do
					vec_fin[$k]=${vec_fin[$(($k-1))]}
				done
				vec_fin[$j]=$((${vec_ini[$j]}+${memoria[$i]}-1))

				for (( k=$temp_est ; k>$j ; k-- ))	#Avanzamos los valores de cada posición del vector a la posición siguiente de dicho vector.
				do
					vec_est[$k]=${vec_est[$(($k-1))]}
				done
				vec_est[$j]=${estancia[$i]}

				for (( k=${vec_ini[$j]} ; k<=${vec_fin[$j]} ; k++ ))
				do
					sal[$k]=${proceso[$i]}
				done


				pr_asignado=$(($pr_asignado+1))	#Aumento el número de procesos asignados.
				temp_ini=$(($temp_ini+1))
				temp_fin=$(($temp_fin+1))
				temp_est=$(($temp_est+1))
###################################################
echo ""
echo -e "${azul}-------------------------------------------------------------"
echo -n -e "${azul}Proceso que llega al sistema ->  "
head -$m datos.txt |tail -1

echo "" >> resultadoSJF.txt
echo "-------------------------------------------------------------" >> resultadoSJF.txt
echo -n "Proceso que llega al sistema ->  " >> resultadoSJF.txt
head -$m datos.txt |tail -1 >> resultadoSJF.txt


echo ""
echo -n -e "${azul}Procesos pendientes de llegar ->  "
for ((q=$(($m+1));q<$((${#proceso[@]}+2));q++)){
echo -n ` head -$q datos.txt|tail -1|cut -f 1 -d":" `
echo -n "  "
}
echo ""
echo -e "${azul}-------------------------------------------------------------"


echo "" >> resultadoSJF.txt
echo -n "Procesos pendientes de llegar ->  " >> resultadoSJF.txt
for ((q=$(($m+1));q<$((${#proceso[@]}+2));q++)){
echo -n ` head -$q datos.txt|tail -1|cut -f 1 -d":" ` >> resultadoSJF.txt
echo -n "  " >> resultadoSJF.txt
}
echo "" >> resultadoSJF.txt
echo "-------------------------------------------------------------" >> resultadoSJF.txt

colorear
colorearNC
################################################
				#echo "Soy la i y valgo $i"
				#echo "$((${#proceso[@]}-1))"
				m=$(($m+1))

			else
				cont=$(($cont+1))
				#echo "contador $p"
				#echo "Hola soy ${proceso[$i]} y no quepo"
				#echo el siguiente no entra
				for ((h=$p; h<i; h++)){
					
					p=$(($p+1))
					echo "${proceso[$h]}:${memoria[$h]}:${estancia[$h]}:${llegada[$h]}" >> procesosEnMemoria.txt
				}
				./tsjf.sh
				#echo "contador $p"
			fi
		fi
	done

	#echo "Imprime proceso asignado $pr_asignado"
	#echo "Imprime p $p"
	#echo "Imprime cont $cont"
	

		for ((h=$p; h<i; h++)){
		p=$(($p+1))
		echo "${proceso[$h]}:${memoria[$h]}:${estancia[$h]}:${llegada[$h]}" >> procesosEnMemoria.txt
		}
	

	if [ "$i" -eq $((${#proceso[@]}-1)) -a $pr_asignado -gt $p ]
		then
		
		echo "${proceso[$i]}:${memoria[$i]}:${estancia[$i]}:${llegada[$i]}" >> procesosEnMemoria.txt

		for ((g=$cont; g<${#proceso[@]} ; g++)){
			
		./tsjf.sh
		}
	fi

done


#########################################################
#echo Punto 1
colorear
colorearNC
########################################################


while [[ ${vec_est[*]} != "Li" ]]
do

	tiempo=$(($tiempo+1))
	###########################################################
	#echo Punto 2
	colorear
	colorearNC
	###########################################################

	for (( j=0 ; j<${#vec_est[@]} ; j++ ))
	do

		if [[ ${vec_est[$j]} -gt 0 ]]
		then
			vec_est[$j]=$((${vec_est[$j]}-1))
			if [[ ${vec_est[$j]} -eq 0 ]]
			then

				vec_est[$j]="Li"

			fi
		fi
		

		if [[ ${vec_est[$j]} == "Li" ]]
		then

			for (( k=${vec_ini[$j]} ; k<=${vec_fin[$j]} ; k++ ))
			do
				sal[$k]="Li"
			done
		fi

		if [[ ${vec_est[$j]} -lt 0 ]]
		then
			vec_est[$j]=""
		fi
	done

	temp_est=$((${#vec_est[@]}-1))

	for (( k=0 ; k<$temp_est ; k++ ))
	do
		if [[ (${vec_est[$k]} == "Li") && (${vec_est[$(($k+1))]} == "Li") ]]
		then
			for (( l=$(($k+1)) ; l<$(($temp_est+1)) ; l++ ))
			do
				vec_est[$l]=${vec_est[$(($l+1))]}
				vec_ini[$l]=${vec_ini[$(($l+1))]}
				vec_fin[$(($l-1))]=${vec_fin[$l]}
			done

		vec_est[$(($temp_est+1))]=""
		vec_ini[$temp_ini]=""
		vec_fin[$temp_fin]=""
		k=$(($k-1))	

		fi
	done
done

tiempo=$(($tiempo+1))

################################################
echo ""
echo -e "${red}-------------------------------------------------------------"
echo -e "${red}Finalizan todos los procesos"
echo -e "${red}-------------------------------------------------------------"

echo "" >> resultadoSJF.txt
echo "-------------------------------------------------------------" >> resultadoSJF.txt
echo "$Finalizan todos los procesos" >> resultadoSJF.txt
echo "-------------------------------------------------------------" >> resultadoSJF.txt
colorear
colorearNC
################################################



echo
echo
echo -e " 			${morado}LEYENDA ${NC} ";
echo -e "			      _ En vertical ${red} | ${NC} a la derecha. Espacio que ocupa la partición en el tiempo. ";
echo -e "		 	      _ En horizontal ${red}_${NC} Tamaño que ocupa la partición en memoria.";
echo -e "			      _ ${red}Px${NC} Proceso, siendo x el número de proceso";
echo -e "			      _ Li ${red}->${NC} Espacio libre en la partición.";

echo "" >> resultadoSJF.txt
echo "" >> resultadoSJF.txt
echo " 			LEYENDA  " >> resultadoSJF.txt
echo "			      _ En vertical  |  a la derecha. Espacio que ocupa la partición en el tiempo. " >> resultadoSJF.txt
echo "		 	      _ En horizontal _ Tamaño que ocupa la partición en memoria." >> resultadoSJF.txt
echo "			      _ Px Proceso, siendo x el número de proceso" >> resultadoSJF.txt
echo "			      _ Li -> Espacio libre en la partición." >> resultadoSJF.txt

fi
done
