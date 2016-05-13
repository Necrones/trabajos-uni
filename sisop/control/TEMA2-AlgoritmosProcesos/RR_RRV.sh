#!/bin/bash
###############################################################################################################################################################
# Script realizado por Mario Juez Gil. Sistemas Operativos, Grado en ingeniería informática UBU 2012-2013 						      #
#                                                                                                                                                             #
# Funcionamiento del script:                                                                                                                                  #
#	Parte importante del script se basa en la comprobación de las lecturas, especial importancia tienen:                                                 #
#		- Lectura de quantum 			 -> Deberá ser entero y mayor que 0                                                                  #
#		- Lectura del número de procesos -> Deberá ser entero y mayor que 0                                                                         #
#		- Lectura de ráfagas			 -> Deberán ser enteras y mayores que 0                                                              #
#		- Lectura de momento de E/S 	 -> Deberá ser desde 1 hasta la ráfaga total - 1 (E/S en el primer o último momento no tiene sentido)      #
#		- Lectura de duración E/S 		 -> Deberá ser entero y mayor que 0                                                                  #
#                                                                                                                                                             #
#	El script deberá contemplar la opción de Round Robin (Sin E/S), y Round Robin Virtual (Con E/S)                                                     #
#	Se usará el mismo algoritmo para ambos casos, ya que en RRV se puede dar el caso de que el proceso no tenga situación de E/S                        #
#	Para resolver el problema he usado los Arrays de bash:                                                                                                #
#		PROCESOS[indice] 	-> Almacena la ráfaga del proceso                                                                                    #
#		QT_PROC[indice]	 	-> Almacena el quantum sin usar del proceso (útil cuando un proceso se bloquea por E/S)                              #
#		PROC_ENAUX[indice] 	-> [ Si / No ] Nos dice si el proceso actual está en la cola auxiliar (bloqueado por E/S)                            #
#		T_ENTRADA[indice]	-> Tiempo de llegada en el sistema del proceso                                                                        #
#		EN_ESPERA[indice]	-> [ Si / No ] Proceso en espera por tiempo de llegada                                                                #
#		MOMENTO[indice]		-> Momento en el cual el proceso se bloqueará por una situación de E/S                                              #
#		DURACION[indice]	-> Duración de la situación de E/S                                                                                  #
#		FIN_ES[indice]		-> Almacena cuando va a terminar la E/S de un proceso, teniendo en cuenta su posicion en la cola FIFO                 #
#		AUX[indice]			-> Cola FIFO auxiliar para los procesos bloqueados por E/S. Almacena indices de procesos.                     #
###############################################################################################################################################################
#
echo "############################################################"
echo "#                     Creative Commons                     #"
echo "#                                                          #"
echo "#                   BY - Atribución (BY)                   #"
echo "#                 NC - No uso Comercial (NC)               #"
echo "#                SA - Compartir Igual (SA)                 #"
echo "############################################################"

echo "############################################################" > informeRR.txt
echo "#                     Creative Commons                     #" >> informeRR.txt
echo "#                                                          #" >> informeRR.txt
echo "#                   BY - Atribución (BY)                   #" >> informeRR.txt
echo "#                 NC - No uso Comercial (NC)               #" >> informeRR.txt
echo "#                SA - Compartir Igual (SA)                 #" >> informeRR.txt
echo "############################################################" >> informeRR.txt



#Variable Global
min=9999
tamano=();
# Nos permite saber si el parámetro pasado es entero positivo.
es_entero() {
    [ "$1" -eq "$1" -a "$1" -ge "0" ] > /dev/null 2>&1  # En caso de error, sentencia falsa (Compara variables como enteros)
    return $?                           				# Retorna si la sentencia anterior fue verdadera
}

# Nos permite saber si el parámetro pasado es entero mayor que 0.
mayor_cero() {
    [ "$1" -eq "$1" -a "$1" -gt "0" ] > /dev/null 2>&1  # En caso de error, sentencia falsa (Compara variables como enteros)
    return $?                           				# Retorna si la sentencia anterior fue verdadera
}

# Comprobación para saber si el momento de E/S introducido es válido.
comprueba_momentos() {
	
	if mayor_cero $momento
		then
		if [ "$momento" -gt "$momentofinal" ]
			then
			return 1 	# Si el momento introducido es mayor la finalización del proceso (1 - falso)
		else
			return 0	# Si el momento introducido es entero y menor que la finalización del proceso (0 - verdadero)
		fi
	else
		return 1 		# Si el momento introducido no es entero (1 - falso)
	fi
}

# Escribe la cabecera del informe para la tabla de procesos
escribe_cabecera_informe() {

	echo "		>> Procesos y sus datos:" >> informeRR.txt
	
	if [ $opcion = "a" ]
		then
		echo "		--------------------------" >> informeRR.txt
		echo "		  PRO| LLEGADA | RAFAGA  " >> informeRR.txt
		echo "		--------------------------" >> informeRR.txt
	else
		echo "		-----------------------------------------" >> informeRR.txt
		echo "		  PRO | LLEGADA | RAFAGA | E/S | TP_E/S  " >> informeRR.txt
		echo "		-----------------------------------------" >> informeRR.txt
	fi

}

# Función que calcula el número de espacios en base a las cifras para una tabla equilibrada
calcula_espacios(){

	cifras=`expr 1000`
	dato=$1
	if [ $1 -eq '0' ]
		then
		dato=`expr $dato + 1`
	fi
	while [ $dato -lt $cifras ]
	do
		fila=${fila}" "	
		cifras=$((cifras / 10))
	done

}

# Escribe las filas del enunciado con los datos introducidos
escribe_enunciado(){
	p=`expr 0`
	if [ $opcion = "a" ] # Enunciado para Round Robin
		then
		while [ $p -lt $num_proc ]
		do
			proc_list=`expr $p + 1`
			fila="$proc_list"
			calcula_espacios $proc_list
			fila=${fila}"| ${T_ENTRADA[$p]}    "
			calcula_espacios ${T_ENTRADA[$p]}
			fila=${fila}"| ${PROCESOS[$p]}"
			echo "		  $fila" >> informeRR.txt
			echo "		--------------------------" >> informeRR.txt
			p=`expr $p + 1`
		done
	else # Enunciado para Round Robin Virtual
		while [ $p -lt $num_proc ]
		do
			proc_list=`expr $p + 1`
			fila="$proc_list"

			calcula_espacios $proc_list
			fila=${fila}"| ${T_ENTRADA[$p]}    "

			calcula_espacios ${T_ENTRADA[$p]}
			fila=${fila}"| ${PROCESOS[$p]}   "

			calcula_espacios ${PROCESOS[$p]}
			if [ -z ${MOMENTO[$p]} ]
				then
				fila=${fila}"| N/A | N/A"
			else
				fila=${fila}"| ${MOMENTO[$p]}"

				calcula_espacios ${MOMENTO[$p]}
				fila=${fila}"| ${DURACION[$p]}"
			fi
			echo "		  $fila" >> informeRR.txt
			echo "		-----------------------------------------" >> informeRR.txt
			p=`expr $p + 1`
		done
	fi

}

# Lee los datos desde un fichero
lectura_fichero() {
	procesos_ejecutables=`expr 0`
	act=`expr 0` # identificador de la linea actual para diferenciar el array al que pertenece el dato
	num_proc=`expr 0`
	if [ $opcion = "a" ] #RR
	then
		# Recorrido del fichero linea a linea
		while read line
		do
			if [ $act -eq '0' ] # Primer dato -> Tiempo de llegada
			then
				T_ENTRADA[$num_proc]=`expr $line`
			fi
			if [ $act -eq '1' ] # Segundo dato -> Proceso en espera
			then
				EN_ESPERA[$num_proc]=$line
				if [ ${EN_ESPERA[$num_proc]} = "No" ]
				then
				procesos_ejecutables=`expr $procesos_ejecutables + 1`
				fi
			fi
			if [ $act -eq '2' ] # Tercer dato(Último) -> Ráfaga de CPU
			then
				PROCESOS[$num_proc]=`expr $line`
				QT_PROC[$num_proc]=$quantum 	# Almacenará el quantum restante del proceso (en caso de E/S)
				PROC_ENAUX[$num_proc]="No" 	# Por defecto ningún proceso estará en la cola auxiliar FIFO de E/S
				num_proc=`expr $num_proc + 1`
#				act=`expr 0` # Al ser el último dato, el siguiente será el primero del próximo proceso.
#			else
#				act=`expr $act + 1` 				
			fi
			if [ $act -eq '3' ] # Tercer dato(Último) -> Ráfaga de CPU
			  then
			    tamano[$num_proc]=`expr $line`
			    act=`expr 0`
			  else
			    act=`expr $act + 1`
			fi
		done < $fich
	else #RRV
	while read line
		do
			if [ $act -eq '0' ] # Primer dato -> Tiempo de llegada
			then
				T_ENTRADA[$num_proc]=`expr $line`
			fi
			if [ $act -eq '1' ] # Segundo dato -> Proceso en espera
			then
				EN_ESPERA[$num_proc]=$line
				if [ ${EN_ESPERA[$num_proc]} = "No" ]
				then
				procesos_ejecutables=`expr $procesos_ejecutables + 1`
				fi
			fi
			if [ $act -eq '2' ] # Tercer dato -> Ráfaga de CPU
			then
				PROCESOS[$num_proc]=`expr $line`
				QT_PROC[$num_proc]=$quantum 	# Almacenará el quantum restante del proceso (en caso de E/S)
				PROC_ENAUX[$num_proc]="No" 	# Por defecto ningún proceso estará en la cola auxiliar FIFO de E/S
			fi
			if [ $act -eq '3' ] # Cuarto dato -> Momento de bloqueo por E/S
			then
				MOMENTO[$num_proc]=$line
			fi
			if [ $act -eq '4' ] # Quinto dato (Último) -> Duración de la E/S
			then
				DURACION[$num_proc]=$line
				num_proc=`expr $num_proc + 1`
				act=`expr 0`
			else
				act=`expr $act + 1` 				
			fi		
		done < $fich
	fi
}

# Lee los datos concretos de los procesos por pantalla.
lectura_datprocesos() {

	procesos_ejecutables=`expr 0`

	# COMENZAMOS A LEER RAFAGAS DE LOS PROCESOS
	i=`expr 0`
	while [ $i -lt $num_proc ]
	do
        proc=`expr $i + 1`    # PROCESO ACTUAL
        
        # LECTURA DE RAFAGA
        read -p "Introduce el momento de llegada a CPU del proceso $proc:" entrada
        
        if [ -z $entrada ] # Si la entrada está vacía, valor por defecto 0
        	then
        	entrada=`expr 0`
        else
	        # COMPROBACIÓN DE LECTURA
	        while ! es_entero $entrada
	        do
	        	clear
	        	echo "Entrada no válida"
	        	read -p "Introduce el momento de llegada a CPU del proceso $proc:" entrada
	        	if [ -z $entrada ] # Si la entrada está vacía, valor por defecto 0
	        		then
	        		entrada=`expr 0`
	        	fi
	        done
	    fi
	    #Almacenamiento de valores en sus arrays
	    if [ $entrada -ne '0' ]
	    	then
	    	T_ENTRADA[$i]="$entrada"
	    	EN_ESPERA[$i]="Si"
	    else
	    	T_ENTRADA[$i]="$entrada"
	    	EN_ESPERA[$i]="No"
	    	procesos_ejecutables=`expr $procesos_ejecutables + 1`
	    fi
	    #Almacenamiento de datos en un archivo temporal
	    echo ${T_ENTRADA[$i]} >> archivo.temp
	    echo ${EN_ESPERA[$i]} >> archivo.temp

        # LECTURA DE RAFAGA
        read -p "Introduce la ráfaga de CPU del proceso $proc:" rafaga
 	# LECTURA DEL TAMAÑO DE MEMORIA
#read -p "Introduce el tamaño de memoria del proceso $proc:" tamano[$proc]
        # COMPROBACIÓN DE LECTURA
        while ! mayor_cero $rafaga
        do
        	clear
        	echo "Entrada no válida"
        	read -p "Introduce la ráfaga de CPU del proceso $proc:" rafaga
        done

        #Almacenamiento de datos en un archivo temporal
        echo $rafaga >> archivo.temp
        # GUARDAMOS LA RAFAGA EN EL PROCESO
        PROCESOS[$i]=$rafaga  # Almacenará la ráfaga del proceso
        QT_PROC[$i]=$quantum 	# Almacenará el quantum restante del proceso (en caso de E/S)
		PROC_ENAUX[$i]="No" 	# Por defecto ningún proceso estará en la cola auxiliar FIFO de E/S

		if [ $opcion = "b" ]
			then

			read -p "¿Es un proceso de E/S? (s/n): " tipo

			# COMPROBACIÓN DE LECTURA
			if [ -z $tipo ]
				then
				tipo="n"
				momento="N/A"
			fi
			
			while [ $tipo != "s" -a $tipo != "n" ]
			do
				clear
				echo "Entrada no válida"
				read -p "¿Es un proceso de E/S? (s/n): " tipo
				if [ -z $tipo ]
					then
					tipo="n"
					momento="N/A"
				fi
			done			
			
			if [ $tipo = "s" ]
				then
				momentofinal=`expr $rafaga - 1`
				read -p "¿En que momento se produce la situación de E/S? (1 - $momentofinal): " momento
				# COMPROBACIÓN DE LA LECTURA
				while ! comprueba_momentos
				do
					clear
					echo "Entrada no válida"
					read -p "¿En que momento se produce la situación de E/S? (1 - $momentofinal): " momento
				done
				MOMENTO[$i]="$momento"

				read -p "¿Cual es la duración de la situación de espera? " duracion
				# COMPROBACIÓN DE LA LECTURA
				while ! mayor_cero $duracion
				do
					clear
					echo "Entrada no válida"
					read -p "¿Cual es la duración de la situación de espera? " duracion
				done
				DURACION[$i]="$duracion"
			else
				tipo="n"
				momento="N/A"
			fi

			#Almacenamiento de datos en un archivo temporal
			echo ${MOMENTO[$i]} >> archivo.temp
			echo ${DURACION[$i]} >> archivo.temp

		fi
		if [ $entrada -lt $min ]
			then
				min=$entrada
				pos=$i
		fi
		i=`expr $i + 1`
	done
	if [ $procesos_ejecutables -eq 0 ]
		then
			EN_ESPERA[$pos]="No"
		   	procesos_ejecutables=`expr $procesos_ejecutables + 1`
	fi
}

# Comprobará si hay algún proceso cuyo tiempo de llegada sea menor o igual que el tiempo transcurrido
toca_entrada() {
	if [ $tiempo_transcurrido -gt '0' ]
		then
		e=`expr 0`
		entradamenor="$e"
		while [ $e -lt $num_proc ] # Recorre todos los procesos
		do
			if [ "${EN_ESPERA[$e]}" == "Si" ] # Si está en espera
				then
				# Comparamos con el proceso de tiempo de llegada menor y actualizamos.
				if [ "${EN_ESPERA[$entradamenor]}" == "No" ] 
					then
					entradamenor="$e"
					tocaentrada=`expr 0`
				else
					if [ "${T_ENTRADA[$entradamenor]}" -ge ${T_ENTRADA[$e]} ]
						then
						entradamenor="$e"
					fi
				fi		
			fi
			e=`expr $e + 1`
		done
		# Si el proceso de menor tiempo de llegada no se encuentra en espera, ya están todos los procesos en ejecución.
		if [ "${EN_ESPERA[$entradamenor]}" == "No" ]
			then
			entradamenor="N"
		fi
	else
		entradamenor="N"
	fi	
}

# Escritura de la cabecera de la tabla de solución
cabecera_solucion() {

	echo "" >> informeRR.txt
	echo "		>> Tiempo de ejecución de los procesos:" >> informeRR.txt
	echo "		----------------" >> informeRR.txt
	echo "		  PRO | TIEMPO  " >> informeRR.txt
	echo "		----------------" >> informeRR.txt

}

# Lectura de los datos (quantum y nro procesos/fichero) y diseño de informe.
lee_datos() {

	# Lectura del quantum.
	read -p "Introduce el quantum de ejecución:" quantum

	while ! mayor_cero $quantum
	do
		clear
		echo "Entrada no válida"
		read -p "Introduce el quantum de ejecución:" quantum
	done
	echo "		>> Quantum de tiempo: $quantum" >> informeRR.txt

	# Lectura de fichero
	read -p "¿Desea introducir los datos desde un fichero? (s,n):" dat_fich
	# COMPROBACIÓN DE LECTURA
	if [ -z $dat_fich ] # Si la lectura está vacía, valor por defecto n
		then
		dat_fich="n"
	fi
	
	while [ $dat_fich != "s" -a $dat_fich != "n" ] # Lectura erronea
	do
		clear
		echo "Entrada no válida"
		read -p "¿Desea introducir los datos desde un fichero? (s,n):" dat_fich
			if [ -z $dat_fich ]
			then
				dat_fich="n"
			fi
	done

	if [ $dat_fich = "s" ] # Si se quiere leer de fichero
	then
		clear
		if [ $opcion = "a" ] #RR
		then
			ls | grep .rr$ > listado.temp
		else # RRV
			ls | grep .rrv$ > listado.temp
		fi
		# Muestra listados con ficheros
		cat listado.temp
		read -p "Introduce uno de los ficheros del listado:" fich
		while [ ! -f $fich ] # Si el fichero no existe, lectura erronea
		do
			clear
			cat listado.temp
			read -p "Entrada no válida, vuelve a intentarlo. Introduce uno de los ficheros del listado:" fich
		done
		lectura_fichero # Leemos los datos del fichero
		rm -r listado.temp # Borra el temporal
	else
		# Lectura del número de procesos
		read -p "Introduce el número de procesos:" num_proc

		while ! mayor_cero $num_proc
		do
			clear
			echo "Entrada no válida"
			read -p "Introduce el número de procesos:" num_proc
		done
		# Leemos los datos concretos de los procesos.
		lectura_datprocesos

	fi
	echo "		>> $num_proc procesos." >> informeRR.txt

	# Una vez leido quantum y los datos de los procesos, escritura de la cabecera del informe.
	escribe_cabecera_informe
	# Escritura del enunciado
	escribe_enunciado
	# Escribe la cabecera de la tabla solución
	cabecera_solucion

}

# Operación a realizar en caso de que el proceso no vaya a terminar antes de consumir el quantum
# O para cuando la situación de E/S no se dé antes de consumir el quantum
op_mayorquantum() {

	PROCESOS[$proc_actual]=`expr ${PROCESOS[$proc_actual]} - ${QT_PROC[$proc_actual]}` 	# Restamos QUANTUM a lo que quedaba de proceso
	tiempo_transcurrido=`expr $tiempo_transcurrido + ${QT_PROC[$proc_actual]}`			# Aumentamos el tiempo transcurrido

	# Mostramos mensaje por pantalla
	echo "Tiempo restante del proceso $proc: ${PROCESOS[$proc_actual]}"
	echo "Tiempo empleado hasta el momento: $tiempo_transcurrido"

	echo "			* Sale de ejecutarse P$proc (Quantum consumido: ${QT_PROC[$proc_actual]}). " >> log.temp
	echo "				- Ráfaga restante de P$proc: ${PROCESOS[$proc_actual]}" >> log.temp
	echo "				- Tiempo empleado hasta el momento: $tiempo_transcurrido" >> log.temp
	echo "" >> log.temp
	QT_PROC[$proc_actual]=$quantum

}
# Escribe las filas solución del informe
escribe_datos_informe(){
	tiempo_final=`expr $tiempo_transcurrido - ${T_ENTRADA[$proc_actual]}`
	# Escritura del proceso terminado en la tabla del informe
	if [ $proc -lt '10' ]
		then
		echo "		  $proc   | $tiempo_final"	>> informeRR.txt
	else
		echo "		  $proc  | $tiempo_final"	>> informeRR.txt
	fi
	echo "		----------------" >> informeRR.txt


}

# Reestructuración de la cola auxiliar cuando sale el primer elemento
reestructura_aux(){

	# Tiempo restante para labores de E/S del resto de procesos de la cola
	tiempo_restante=`expr $tiempo_transcurrido - ${FIN_ES[0]}`

	# Si había mas de un proceso en la cola auxiliar, se reestructura:
	procesos_enaux=`expr $procesos_colaauxiliar - 1`
	indice=`expr 0`
	if [ $procesos_enaux -ne '0' ]
		then
		while [ $indice -lt $procesos_enaux ]
		do
			sig=`expr $indice + 1`
			if [ $tiempo_restante -lt ${FIN_ES[$sig]} ]
				then
				FIN_ES[$sig]=`expr ${FIN_ES[$sig]}`
			else
				tiempo_restante=`expr $tiempo_restante - ${FIN_ES[$sig]}`
				FIN_ES[$sig]=`expr 0`
			fi
			AUX[$indice]=${AUX[$sig]}
			FIN_ES[$indice]=${FIN_ES[$sig]}
			indice=`expr $indice + 1`
		done
	fi
	# Al sacar un proceso de la cola FIFO, borramos la ultima entrada y decrementamos un proceso en cola.
	unset -v AUX[$indice]
	unset -v FIN_ES[$indice]
	procesos_colaauxiliar=`expr $procesos_colaauxiliar - 1`

}

##### FUNCIÓN PRINCIPAL // ALGORITMO #####
algoritmo() {
	
	tiempo_transcurrido=`expr 0` 	# Tiempo de ejecución de los procesos
	procesos_terminados=`expr 0` 	# Numero de procesos terminados
	procesos_colaauxiliar=`expr 0` 	# Número de procesos en la cola auxiliar
	cadena="| "					 	# Cadena que guarda el gráfico de la solución
	contador=0


	# Mientras los procesos terminados < procesos totales
	while [ $procesos_terminados -lt $num_proc ]
	do
        proc_actual=`expr 0`					# Inicialmente se ejecuta el P0

        while [ $proc_actual -lt $num_proc ]	# Recorremos los procesos
        do
			proc_temporal=$proc_actual			# Proceso que tocaría en caso de RRV

			# Actualizamos el siguiente proceso que entra en el sistema por tiempo de llegada
			toca_entrada

			# En el caso de que solo haya procesos en la cola auxiliar o esperando a entrar
			if [ $procesos_ejecutables -eq '0' -a ${procesos_colaauxiliar} -ge '1' ]
			then
				if [ $tiempo_transcurrido -le ${FIN_ES[0]} ] # Si el tiempo actual es menor que el de finalización de la E/S
				then
					tiempo_transcurrido=${FIN_ES[0]}
				fi
				PROC_ENAUX[${AUX[0]}]="No" # El proceso sale de la cola auxiliar
				procesos_ejecutables=`expr $procesos_ejecutables + 1`	# El proceso es ejecutable

				proc=`expr ${AUX[0]} + 1` # Diseño para el informe (P0)
				echo "			* P$proc desbloqueado (Se ejecutará a continuación). " >> log.temp
				echo "				- Momento de finalización de E/S: ${FIN_ES[0]}" >> log.temp
				echo "" >> log.temp
				
				reestructura_aux
				
			elif [ $procesos_ejecutables -eq '0' ]
				then
				if [ "$entradamenor" != "N" ]
					then
						if [ $tiempo_transcurrido -lt ${T_ENTRADA[$entradamenor]} ]
							then
							tiempo_transcurrido=${T_ENTRADA[$entradamenor]}
						fi
						EN_ESPERA[$entradamenor]="No"
						procesos_ejecutables=`expr $procesos_ejecutables + 1`
				fi
			fi

			# Si el proceso aún no ha terminado (rafaga > 0) y Si no se encuentra en la cola auxiliar:
			if [ ${PROCESOS[$proc_actual]} -ne '0' -a ${PROC_ENAUX[$proc_actual]} = "No" ]
				then

					# Si hay algún proceso en cola auxiliar
					if [ ${procesos_colaauxiliar} -ge '1' ]
						then
							# Si el momento previsto para la finalización de E/S <= que el actual, entra dicho proceso.
							if [ ${FIN_ES[0]} -le $tiempo_transcurrido ]
								then
								# Entra primer proceso de la cola auxiliar
								proc_actual=${AUX[0]}
								
								# El proceso deja de estar en la cola auxiliar
								PROC_ENAUX[$proc_actual]="No"
								procesos_ejecutables=`expr $procesos_ejecutables + 1`

								proc=`expr ${AUX[0]} + 1`
								echo "			* P$proc desbloqueado (Se ejecutará a continuación). " >> log.temp
								echo "				- Momento de finalización de E/S: ${FIN_ES[0]}" >> log.temp
								echo "" >> log.temp

								reestructura_aux

							fi # Si el proceso ha terminado su bloqueo por E/S

					fi	# Si hay procesos en cola auxiliar

					# Comprobamos si el proceso en espera por momento de llegada puede entrar a la cola de ejecución
					if [ "$entradamenor" != "N" ]
					then
						if [ ${T_ENTRADA[$entradamenor]} -le $tiempo_transcurrido ]
							then
							EN_ESPERA[$entradamenor]="No"
							procesos_ejecutables=`expr $procesos_ejecutables + 1`
						fi
					fi
					# Si el proceso actual no se encuentra en espera -> Se puede ejecutar
					if [ ${EN_ESPERA[$proc_actual]} == "No" ]
						then
						proc=`expr $proc_actual + 1`	# Para no tener P0 (motivos de diseño)

						# Información por pantalla:
						clear
						#Si el contador es igual a 0, es decir, que nos encontramos en la primera pasada del bucle
						if [ $contador -eq 0 ]
							then	
								tiempoSinCero=`expr $tiempo_transcurrido + ${T_ENTRADA[$pos]}`
								echo "Ejecutando P$proc:"
								cadena=${cadena}"P$proc ($tiempoSinCero, " # Aumentamos la cadena
								contado=`expr $contador + 1`
								echo "	* Entra a ejecutarse P$proc en el momento $tiempoSinCero" >> log.temp		

						else		#Ejecución del resto de pasadas a partir de la primera

								echo "Ejecutando P$proc:"
								cadena=${cadena}"P$proc ($tiempo_transcurrido, " # Aumentamos la cadena
						echo "			* Entra a ejecutarse P$proc en el momento $tiempo_transcurrido" >> log.temp
						fi
						
				        if [ -z ${MOMENTO[$proc_actual]} ] # Si el proceso actual no tiene situación de E/S
				        	then							
							if [ ${PROCESOS[$proc_actual]} -le ${QT_PROC[$proc_actual]} ] # Si proceso < ó = QUANTUM -> El proceso va a terminar
								then
								tiempo_transcurrido=`expr $tiempo_transcurrido + ${PROCESOS[$proc_actual]}` # Tiempo transcurrido + tiempo proceso que termina
								PROCESOS[$proc_actual]=`expr 0` 											# El proceso termina -> Ráfaga a 0
								procesos_terminados=`expr $procesos_terminados + 1` 						# Un proceso terminado más
								procesos_ejecutables=`expr $procesos_ejecutables - 1`

								# Mostramos mensaje por pantalla					
								echo "Proceso $proc terminado."
								echo "Tiempo de ejecución del proceso $proc: $tiempo_transcurrido"

								echo "			* Termina su ejecución P$proc con un tiempo final: $tiempo_transcurrido" >> log.temp
								echo "" >> log.temp
								escribe_datos_informe

							else
								op_mayorquantum
							fi
						else # Proceso con situación de E/S (RRV)
							if [ ${MOMENTO[$proc_actual]} -le ${QT_PROC[$proc_actual]} ] #Si el momento de entrada a E/S < QUANTUM
								then
								# El proceso se saca, y se pone en la cola auxiliar
								AUX[$procesos_colaauxiliar]=$proc_actual
								PROC_ENAUX[$proc_actual]="Si"
								procesos_ejecutables=`expr $procesos_ejecutables - 1`
								QT_PROC[$proc_actual]=`expr ${QT_PROC[$proc_actual]} - ${MOMENTO[$proc_actual]}` #Quantum restante

								# Se aumenta el tiempo transcurrido hasta el momento de E/S
								tiempo_transcurrido=`expr $tiempo_transcurrido + ${MOMENTO[$proc_actual]}`

								# Se calcula en que momento va a terminar la E/S
								if [ $procesos_colaauxiliar -eq '0' ]
									then
									# Si es el primer proceso de la cola auxiliar -> La E/S se producirá a partir de ahora.
									FIN_ES[$procesos_colaauxiliar]=`expr $tiempo_transcurrido + ${DURACION[$proc_actual]}`
								else
									# La E/S empezará cuando termine la anterior.
									indice_anterior=`expr $procesos_colaauxiliar - 1`
									FIN_ES[$procesos_colaauxiliar]=`expr ${FIN_ES[$indice_anterior]} + ${DURACION[$proc_actual]}`
								fi

								# Se quita el tiempo ejecutado del proceso
								PROCESOS[$proc_actual]=`expr ${PROCESOS[$proc_actual]} - ${MOMENTO[$proc_actual]}`

								# Aumento el número de procesos de la cola auxiliar
								procesos_colaauxiliar=`expr $procesos_colaauxiliar + 1`

								# Mostramos mensaje por pantalla					
								echo "Proceso $proc en espera."
								echo "Tiempo empleado hasta el momento: $tiempo_transcurrido"

								# Actualizamos log
								echo "			* P$proc bloqueado (Momento ${MOMENTO[$proc_actual]} del quantum). " >> log.temp
								echo "				- Ráfaga restante de P$proc: ${PROCESOS[$proc_actual]}" >> log.temp
								echo "				- Tiempo empleado hasta el momento: $tiempo_transcurrido" >> log.temp
								echo "" >> log.temp

								# Se quita el momento de E/S para el proceso (lo que resta no tendrá E/S)
								unset -v MOMENTO[$proc_actual]
							else
								# Realizaremos las operaciones como si fuese RR normal.
								op_mayorquantum
								# Decrementamos un quantum el momento de entrada a E/S
								MOMENTO[$proc_actual]=`expr ${MOMENTO[$proc_actual]} - ${QT_PROC[$proc_actual]}`
							fi
						fi
						
						cadena=${cadena}"${PROCESOS[$proc_actual]}) | "
						# Mostramos la cadena de procesos que han entrado hasta el momento por pantalla
						echo $cadena
						sleep 1s # Demora de un segundo para poder leerlo

					fi	
		fi
			# Si el actual = temporal -> no se terminó de ejecutar ningun proceso de la cola auxiliar
			if [ "$proc_actual" -eq "$proc_temporal" ]
				then
            	proc_actual=`expr $proc_actual + 1` # Aumento del índice del proceso ejecutandose actualmente
            else
				proc_actual=$proc_temporal # El siguiente proceso será el que tocaba ahora
			fi

        done # Bucle de procesos
    done # Bucle de cola

}

# Inicio del script:
clear
echo "#######################################################################" >> informeRR.txt
echo "#                                                                     #" >> informeRR.txt
echo "#                         INFORME DE PRÁCTICA                        #" >> informeRR.txt
echo "#                         GESTIÓN DE PROCESOS                        #" >> informeRR.txt
echo "#             -------------------------------------------             #" >> informeRR.txt
echo "#     Antiguo alumno:                                          #" >> informeRR.txt
echo "#     Alumno: Mario Juez Gil                                          #" >> informeRR.txt
echo "#     Sistemas Operativos 2º Semestre                                #" >> informeRR.txt
echo "#     Grado en ingeniería informática (2012-2013)                   #" >> informeRR.txt
echo "#             -------------------------------------------             #" >> informeRR.txt
echo "#     Nuevos alumnos:                                          #" >> informeRR.txt
echo "#     Alumnos: Omar Santos Bernabé                                     #" >> informeRR.txt
echo "#     Sistemas Operativos 2º Semestre                                #" >> informeRR.txt
echo "#     Grado en ingeniería informática (2015-2016)                   #" >> informeRR.txt
echo "#                                                                     #" >> informeRR.txt
echo "#######################################################################" >> informeRR.txt
echo "" >> informeRR.txt

#cabecera del algoritmo en el que nos encontramos
echo -e "\e[0;33m_________________________________________________________________________________________ \e[0m"
echo -e "\e[0;33m*				\e[1;36mAlgoritmo Round-Robin \e[0m						\e[0;33m*"			
echo -e "\e[0;33m*					\e[1;36mOmar Santos Bernabé			\e[0;33m*"
echo -e "\e[0;33m*				\e[1;36mVersión Junio 2015 \e[0m					\e[0;33m*"
echo -e "\e[0;33m\_______________________________________________________________________________________/ \e[0m	"



echo "  Selecciona una de las dos opciones (a,b):"
echo "  [a] ROUND ROBIN"
echo "  [b] ROUND ROBIN VIRTUAL"
read -p "  Su selección es:" opcion
while [ -z "${opcion}" -o \( "${opcion}" != "a" -a "${opcion}" != "b" \) ]
do
	clear
	echo "(Selección vacía o errónea)"
	echo "  [a] ROUND ROBIN"
	echo "  [b] ROUND ROBIN VIRTUAL"
	read -p "  Vuelva a seleccionar una de las dos opciones (a,b):" opcion
done
if [ $opcion = "a" ]
	then
	clear
	echo "	> ROUND ROBIN" >> informeRR.txt
elif [ $opcion = "b" ]
	then
	clear
	echo "	> ROUND ROBIN VIRTUAL" >> informeRR.txt
fi

lee_datos
algoritmo

# Almacenamos la solución en el informe
echo "		>> Tiempo total de ejecución de los $num_proc procesos: $tiempo_transcurrido" >> informeRR.txt
echo "" >> informeRR.txt
echo "		>> Gráfico de entrada de procesos:" >> informeRR.txt
echo "		$cadena " >> informeRR.txt
echo "" >> informeRR.txt
echo "		>> Log de entrada y salida:" >> informeRR.txt
cat log.temp >> informeRR.txt
rm log.temp
echo "Tiempo total de ejecución de los $num_proc procesos: $tiempo_transcurrido"

read -p "¿Quieres abrir el informe? ([s],n): " datos
if [ -z "${datos}" ]
	then
	datos="s"
fi
while [ "${datos}" != "s" -a "${datos}" != "n" ]
do
	read -p "Entrada no válida, vuelve a intentarlo. ¿Quieres abrir el informe? ([s],n): " datos
	if [ -z "${datos}" ]
		then
		datos="s"
	fi
done
if [ $datos = "s" ]
	then
	gedit informeRR.txt
fi


