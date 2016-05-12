#!/bin/bash
rm prioridad.temp;
rm datosEntrada.txt;
clear
echo "############################################################" 
echo "#                     Creative Commons                     #" 
echo "#                                                          #" 
echo "#                   BY - Atribución (BY)                   #" 
echo "#                 NC - No uso Comercial (NC)               #" 
echo "#                SA - Compartir Igual (SA)                 #" 
echo "############################################################" 
echo "############################################################" > informePrioridadMenor.txt
echo "#                     Creative Commons                     #" >> informePrioridadMenor.txt
echo "#                                                          #" >> informePrioridadMenor.txt
echo "#                   BY - Atribución (BY)                   #" >> informePrioridadMenor.txt
echo "#                 NC - No uso Comercial (NC)               #" >> informePrioridadMenor.txt
echo "#                SA - Compartir Igual (SA)                 #" >> informePrioridadMenor.txt
echo "############################################################" >> informePrioridadMenor.txt

echo ""
echo >> informePrioridadMenor.txt

echo "#######################################################################" >> informePrioridadMenor.txt
echo "#                                                                     #" >> informePrioridadMenor.txt
echo "#                         INFORME DE PRÁCTICA                         #" >> informePrioridadMenor.txt
echo "#                         GESTIÓN DE PROCESOS                         #" >> informePrioridadMenor.txt
echo "#             -------------------------------------------             #" >> informePrioridadMenor.txt
echo "#     Nuevos alumnos:                                                 #" >> informePrioridadMenor.txt
echo "#     Alumnos: Omar Santos Bernabé				        #" >> informePrioridadMenor.txt
echo "#     Sistemas Operativos 2º Semestre                                 #" >> informePrioridadMenor.txt
echo "#     Grado en ingeniería informática (2015-2016)                     #" >> informePrioridadMenor.txt
echo "#                                                                     #" >> informePrioridadMenor.txt
echo "#######################################################################" >> informePrioridadMenor.txt
echo "" >> informePrioridadMenor.txt




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

#función que comprueba que un nombre es correctas 
function Comprobarn {
	palabra=`echo $1 $2 | wc -w` #cuento las lineas 
	if [ $palabra -ne 1 ]  #si es distinto pido otro nombre para el proceso
	  then 
	     echo "Nombre De Proceso No Valido"
	     echo "Introduce un nombre para el proceso sin espacios"
	     valido=1;
	  else
	     valido=0;
        fi
}

# Nos permite saber si el parámetro pasado es entero positivo.
es_entero() {
    [ "$1" -eq "$1" -a "$1" -ge "0" ] > /dev/null 2>&1  # En caso de error, sentencia falsa (Compara variables como enteros)
    return $?                           				# Retorna si la sentencia anterior fue verdadera
}

#función que comprueba que los nombres introducidos para los procesos no sean iguales
function CompruebaNombre {
	correcto=0;
	for(( i=0 ; i <= ${#proceso[@]} ; i++ )){
		contador=0;
		valor=${proceso[$i]};
		for(( j=0 ; j<= ${#proceso[@]} ; j++ )){
			valor2=${proceso[$j]};
			if [ "$valor" == "$valor2" ] #si los valores del vector coinciden
				then
					contador=`expr $contador + 1`;
			fi
			if [ $contador -gt 1 ] #si el contador es mayor que uno
				then
					echo "Nombres para procesos no válidos"
					echo "Introduzca nombres distintos a los procesos"
					echo " "
					correcto=1; #Valor de la variable a 1 para un valor mal introducido					
				else
					correcto=0; #Valor de la variable a 0 para un valor introducido
			fi
		}
	}
	return $correcto
}

#función que comprueba que un nombre es correctas 
function ComprobarNombreProceso {
	palabra=`echo $1 $2 | wc -w` #cuento el número de palabras
	if [ $palabra -ne 1 ]  #si es distinto de 1
	  then
	     echo -e "${red}Nombre De Proceso No Valido${NC}"
	     exit
    fi
}
function ComprobarPalabras {
	palabra=`echo $1 $2 | wc -w` #cuento el número de palabras
	if [ $palabra -ne 1 ]  #si es distinto de 1
	  then
	     echo -e "${red} ERROR: Has introducido más de una palabra ${NC}"
	     exit
    fi
}
echo
#cabecera del algoritmo en el que nos encontramos
echo -e "\e[0;33m_________________________________________________________________________________________ \e[0m"
echo -e "\e[0;33m*				\e[1;36mAlgoritmo Prioridades(Menor) \e[0m						\e[0;33m*"			
echo -e "\e[0;33m*				\e[1;36mOmar Santos Bernabé  \e[0m 				\e[0;33m*"
echo -e "\e[0;33m*				\e[1;36mVersión Junio 2015 \e[0m					\e[0;33m*"
echo -e "\e[0;33m\_______________________________________________________________________________________/ \e[0m	"


flag=1;
while [ $flag = 1 ]
do
	# pedimos el nombre del proceso a ejecutar
	echo "Introduzca el numero de procesos a ejecutar : " 
	read npro #variable que almacena el número de procesos introducidos
	ComprobarPalabras $npro
	while [[ $npro != ?([+])+([0-9]) ]]; do
		echo -e "${red}ERROR: Introduzca un valor entero${NC}"
  		echo "Introduzca el numero de procesos a ejecutar : "
  		read npro 
	done
	while [ $npro = 0 ]; do
	  		echo -e "${red}ERROR: Número de procesos mayor que  0${NC}"
	  		echo "Introduzca el numero de procesos a ejecutar : "
	  		read npro
	done

npro=`expr $npro - 1` #decrementamos en 1 el contador
p=0;	#contador para los procesos introducidos de forma manual
pp=1;	#contador encargado del índice del nombre de los procesos y del tiempo de ejecución
suma_espera=0;
suma_respuesta=0;	
espera=0;
respuesta=0;
#vectores
proceso=();
tiempo=();
prioridad=();
#Comienzo de la lectura de datos de un fichero o por teclado
echo "" > .datos.txt
echo -n "" > .datosEntrada.txt
echo "" > prioridades.temp
	echo "| 	Proceso		|	T. Ejecución	 |	 Prioridad	 |" >> prioridades.temp
	echo "_________________________________________________________________________" >> prioridades.temp

		while [ $p -le $npro ] #mientras que contador sea menor que cantidad de procesos
		do
			if [ $p = 0	 ] #condición para preguntar la forma a leer los datos
			then

				echo "¿Desea introducir los datos de forma manual(s/n)?"
		       	read opcion	#variable que almacena la opción leída
		       	ComprobarPalabras $opcion
		       	while [ $opcion != "s" -a $opcion != "S" -a $opcion != "n" -a $opcion != "N" ]; do
					echo -e "${red} ERROR: No has introducido una opción válida ${NC}"
					echo "Vuelve a introducir una opcion"
					read opcion
				done
			fi


		if [ $opcion = "n" -o $opcion = "N" ] #si el usuario desea introducir los datos desde un fichero, es decir, datosPrederteminados.
			then
			echo "Introduzca el nombre del proceso $p:"
			nombre=`cat datosEntradaPrederminados.txt | cut -d ";" -f $pp` #delimitamos por ; y seleccionamos con el 1 lo que hay antes
			ComprobarNombreProceso $nombre #comprobamos que la entrada leída de nombre es correcta
			proceso[$p]=$nombre; 		#añadimos al vector de los procesos en la posición del índice el nombre de ese proceso
			pp=`expr $pp + 1`
			echo "Tiempo De ejecucion del proceso $p:"		
			tiemp=`cat datosEntradaPrederminados.txt | cut -d ";" -f $pp`
			tiempo[$p]=$tiemp;
			pp=`expr $pp + 1`
			echo "Prioridad del proceso $p:" 			
			priorida=`cat datosEntradaPrederminados.txt | cut -d ";" -f $pp`
			prioridad[$p]=$priorida;
#echo -e "\e[0;32m *\t${proceso[$p]}\t*\t${tiempo[$p]}\t*\t${prioridad[$p]}\t \e[0m" >> prioridadMenor.temp
			echo Proceso: $nombre Tiempo de ejecución: $tiemp Prioridad de Proceso: $priorida   >> .datosEntrada.txt
			echo "" >> informePrioridadMenor.txt
			echo Proceso: $nombre Tiempo de ejecución: $tiemp Prioridad de Proceso: $priorida   >> informePrioridadMenor.txt
			

		elif [ $opcion = "s" -o $opcion = "S" ]	#si el usuario desea introducir los datos de forma manual
				then
			echo ""
		echo "Introduzca el nombre del proceso_$p:"
		read nombre
		Comprobarn $nombre  #envio nombre a comprobar por la funcion
		while [ $valido -eq 1 ];
			do
				read nombre;
				Comprobarn $nombre  #envio nombre a comprobar por la funcion
			done
		proceso[$p]=$nombre; #añado a el vector ese nombre
		CompruebaNombre $nombre #comprueba que los nombres son distintos
		while [ $correcto -eq 1 ];
			do
				if [ -z $nombre ]
					then
						clear
						read -p "Entrada vacía no válida. Introduce un nombre:" nombre
				else
					read nombre
					Comprobarn $nombre  #envio nombre a comprobar por la funcion
					proceso[$p]=$nombre; #añado a el vector ese nombre
					CompruebaNombre $nombre #comprueba que los nombres son distintos
				fi
			done

		echo -n "|	$nombre		|"  >> prioridades.temp
		clear
		cat prioridades.temp

		echo ""
		echo "Tiempo de ejecución del proceso $p:"
		read tiemp
		ComprobarPalabras $tiemp
			until [ $tiemp -ge 0 ];
				do
					echo "No se pueden introducir tiempos de llegada negativos"
					echo "Introduce un nuevo tiempo de ejecución"
					read tiemp
				done
		
		tiempo[$p]=$tiemp;   #añado al vector ese numero

		echo -n " 	 $tiemp 		 |"  >> prioridades.temp
		clear
		cat prioridades.temp

		echo ""
		echo "Prioridad del proceso $p"
		read priorida
		ComprobarPalabras $priorida
			until [ $priorida -ge 0 ];
				do
					echo "No se pueden introducir tiempos de ejecución negativos"
					echo "Introduce un nuevo tiempo de ejecución"
					read priorida
				done
	
		
		prioridad[$p]=$priorida;   #añado al vector ese numero

		echo -n " 	 $priorida 		 |"  >> prioridades.temp
		clear
		cat prioridades.temp

		echo ""
		echo Proceso $nombre Ejecución $tiemp Prioridad $priorida   >> informePrioridadMayor.txt
		echo Proceso $nombre Ejecucion $tiemp Prioridad $priorida  >> datosEntrada.txt
		echo "" >> prioridades.temp
		echo "__________________________________________________________________________" >> prioridades.temp
		echo "" >> prioridades.temp	

	fi
	p=`expr $p + 1` #incremento el contador
	pp=`expr $pp + 1` #incremento el contador



	done
	echo ""
	cat datosEntrada.txt
	echo ""
	flag=0;
done

echo ""

#inicio del algoritmo de ordenación del PRIORIDADES
 for ((i=0;i<${#prioridad[@]}-1;i++)){   # esto me indica ${#prioridad[@]} el tamaño de mi vector
 	for ((j=i+1;j<${#prioridad[@]};j++)){
		a=${prioridad[$i]};	#Asignamos a la variable a el indice de i correspondiente al vector tiempo
     	b=${prioridad[$j]};    #Asignamos a la variable b el indice de j correspondiente al vector tiempo
     	c=${tiempo[$i]};	#Asignamos a la variables c el indice de i correspondiente al vector llegada
     	d=${tiempo[$j]};	#Asignamos a la variables d el indice de j correspondiente al vector llegada
      		if [ $a -gt $b ]; #si a es mayor que b
         	  then
            	 aux=${prioridad[$i]};			 #utilizamos una variable auxiliar para almacenar el contenido del vector tiempo en la posición i
              	 prioridad[$i]=${prioridad[$j]};	 #cambiamos el contenido del vector tiempo en la posicion i por el contenido de la posición j
             	 prioridad[$j]=$aux;			 #cambiamos el contenido del vector tiempo en la posicion j por el contenido de la variable auxiliar

		     	 aux1=${tiempo[$i]};		 #utilizamos una variable auxiliar para almacenar el contenido del vector llegada en la posición i
              	 tiempo[$i]=${tiempo[$j]}; #cambiamos el contenido del vector llegada en la posicion i por el contenido de la posición j 
             	 tiempo[$j]=$aux1;			 #cambiamos el contenido del vector llegada en la posicion j por el contenido de la variable auxiliar
				
	    	     aux2=${proceso[$i]};		 #utilizamos una variable auxiliar para almacenar el contenido del vector proceso en la posición i
            	 proceso[$i]=${proceso[$j]}; #cambiamos el contenido del vector proceso llegada en la posicion i por el contenido de la posición j 
            	 proceso[$j]=$aux2;			 #cambiamos el contenido del vector proceso llegada en la posicion j por el contenido de la variable auxiliar
         	
         	elif [ $a -eq $b -a $c -lt $d ]; #en caso de que el tiempo de ejecución de dos procesos sea igual los ordenamos en función de su tiempo de llegada
         		then
            	 aux=${prioridad[$i]};			 #utilizamos una variable auxiliar para almacenar el contenido del vector tiempo en la posición i
              	 prioridad[$i]=${prioridad[$j]};   #cambiamos el contenido del vector tiempo en la posicion i por el contenido de la posición j
             	 prioridad[$j]=$aux;			 #cambiamos el contenido del vector tiempo en la posicion j por el contenido de la variable auxiliar

		     	 aux1=${tiempo[$i]};		 #utilizamos una variable auxiliar para almacenar el contenido del vector llegada en la posición i
              	 tiempo[$i]=${tiempo[$j]}; #cambiamos el contenido del vector llegada en la posicion i por el contenido de la posición j 
             	 tiempo[$j]=$aux1;			 #cambiamos el contenido del vector llegada en la posicion j por el contenido de la variable auxiliar
				
	    	     aux2=${proceso[$i]};		 #utilizamos una variable auxiliar para almacenar el contenido del vector proceso en la posición i
            	 proceso[$i]=${proceso[$j]}; #cambiamos el contenido del vector proceso llegada en la posicion i por el contenido de la posición j 
            	 proceso[$j]=$aux2;			 #cambiamos el contenido del vector proceso llegada en la posicion j por el contenido de la variable auxiliar
            fi
    
    }
 }
#final de ejecución del algoritmo de ordenación del PRIORIDADES

#comienzo de la ejecución del calculo de los tiempos de espera y respuesta de los procesos introducidos
#imprimos los títulos de las tablas
echo -e "\e[0;33m     Proceso        Ejecución        Prioridad        Espera        Respuesta   \e[0m"
#almacenamos en el fichero datos.txt el título de la tabla sin formato de color para evitar problemas	
echo -e "     Proceso        Ejecución        Prioridad         Espera        Respuesta   " >> .datos.txt
echo "" >> informePrioridadMenor.txt
echo -e "     Proceso        Ejecución        Prioridad         Espera        Respuesta   " >> informePrioridadMenor.txt	

espera=0

for ((i=0;i<${#tiempo[@]};i++)){

	if [ ${tiempo[$i]} -eq 0 ]    #si la posición 0 = 0 
	  then 
	        espera=0;                 #valores de inicio
	        respuesta=${tiempo[0]}; 
	else 
		sleep "0.5"
		if [ $i -gt "0" ]
			then
		espera=`expr $espera + ${tiempo[$(($i-1))]}`
		fi                     #variable que almacena el tiempo de espera de ese proceso, es decir, el tiempo de respuesta anterior
		respuesta=`expr $espera + ${tiempo[$i]}`  #variable que almacena la suma del tiempo de espera, mas el contenido del vector tiempo en esa posición
		suma_espera=`expr $suma_espera + $espera`            #suma para sacar su promedio de espera
		promedio_espera=`expr $suma_espera / ${#tiempo[@]}`  #promedio del tiempo de espera

		suma_respuesta=`expr $suma_respuesta + $respuesta`   #suma para sacar su promedio de respuesta
		promedio_respuesta=`expr $suma_respuesta / ${#tiempo[@]}`  #promedio del tiempo de retorno medio
       	fi

echo -e "\e[0;32m *\t${proceso[$i]}\t*\t${tiempo[$i]}\t*\t${prioridad[$i]}\t*\t$espera\t*\t$respuesta\t* \e[0m"
#almacenamos en el fichero datos los calculo de los procesos introducidos sin formato de color para evitar problemas	 
echo -e "*\t${proceso[$i]}\t*\t${tiempo[$i]}\t*\t${prioridad[$i]}\t*\t$espera\t*\t$respuesta\t* " >> .datos.txt
echo -e "*	${proceso[$i]}	*	${tiempo[$i]}	*	${prioridad[$i]}	*	$espera	*	$respuesta	* " >> informePrioridadMenor.txt

sleep "0.7"
}

#promedios e imprimimos
echo -e "\e[0;31m \t\t* T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta \e[0m"
#almacenamos en el fichero datos.txt el calculo de los promediosn sin formato de color para evitar problemas
echo -e "\t\t* T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta " >> .datos.txt 
echo "" >> informePrioridadMenor.txt
echo -e "		* T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta " >> informePrioridadMenor.txt 
echo "" >> informePrioridadMenor.txt
#apertura del informe final
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
	gedit informePrioridadMenor.txt
fi


