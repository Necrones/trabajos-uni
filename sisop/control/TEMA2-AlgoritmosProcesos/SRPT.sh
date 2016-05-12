#! /bin/bash
#shell que corre en nuestro script
#funciones
rm srpt.temp;
rm ejemplo.txt;
clear
echo "############################################################" 
echo "#                     Creative Commons                     #" 
echo "#                                                          #" 
echo "#                   BY - Atribución (BY)                   #" 
echo "#                 NC - No uso Comercial (NC)               #" 
echo "#                SA - Compartir Igual (SA)                 #" 
echo "############################################################" 
echo "############################################################" > informeSRPT.txt
echo "#                     Creative Commons                     #" >> informeSRPT.txt
echo "#                                                          #" >> informeSRPT.txt
echo "#                   BY - Atribución (BY)                   #" >> informeSRPT.txt
echo "#                 NC - No uso Comercial (NC)               #" >> informeSRPT.txt
echo "#                SA - Compartir Igual (SA)                 #" >> informeSRPT.txt
echo "############################################################" >> informeSRPT.txt

echo ""
echo >> informeSRPT.txt

echo "#######################################################################" >> informeSRPT.txt
echo "#                                                                     #" >> informeSRPT.txt
echo "#                         INFORME DE PRÁCTICA                         #" >> informeSRPT.txt
echo "#                         GESTIÓN DE PROCESOS                         #" >> informeSRPT.txt
echo "#             -------------------------------------------             #" >> informeSRPT.txt
echo "#     Nuevos alumnos:                                                 #" >> informeSRPT.txt
echo "#     Alumnos: Omar Santos Bernabé				        #" >> informeSRPT.txt
echo "#     Sistemas Operativos 2º Semestre                                 #" >> informeSRPT.txt
echo "#     Grado en ingeniería informática (2015-2016)                     #" >> informeSRPT.txt
echo "#                                                                     #" >> informeSRPT.txt
echo "#######################################################################" >> informeSRPT.txt
echo "" >> informeSRPT.txt


#cabecera del algoritmo en el que nos encontramos
echo -e "\e[0;33m_________________________________________________________________________________________ \e[0m"
echo -e "\e[0;33m*				\e[1;36mAlgoritmo SRPT \e[0m						\e[0;33m*"			
echo -e "\e[0;33m*		\e[1;36mOmar Santos Bernabé \e[0m						\e[0;33m*"
echo -e "\e[0;33m*				\e[1;36mVersión Junio 2015 \e[0m					\e[0;33m*"
echo -e "\e[0;33m\_______________________________________________________________________________________/ \e[0m	"

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

#pido cantidad de procesos que quiere ejecutar
echo "Introduzca el numero de procesos a ejecutar"
read npro
while ! es_entero $npro
	do
		read -p "Entrada no válida. Introduce un número de procesos entero:" npro	
	done


#variables
p=1;              #contador
pp=2;             #contador para cortar datos del fichero
total=0;

suma_espera=0;
suma_respuesta=0;	
espera=0;
respuesta=0;
suma_ejecucion=0;
tinicio=0;  # variable que se guarda el tiempo de inicio del proceso

#vectores
proceso=();
tamanno=();
llegada=();
tiempo=();
proceso2=(`cat ./entradaSRPT.txt | cut -f 2 -d" "`)	
llegada2=(`cat ./entradaSRPT.txt | cut -f 4 -d" "`)
tiempo2=(`cat ./entradaSRPT.txt | cut -f 6 -d" "`)
echo "" >> informeSRPT.txt
	echo "" > srpt.temp
	echo "| 	Proceso		|	T. Llegada	 |	 T.Ejecución	 |" >> srpt.temp
	echo "_________________________________________________________________________" >> srpt.temp

while [ $p -le $npro ] #mientras que contador sea menor que cantidad de procesos
	do
		if [ $p = 1 ]
		then
			
			echo "¿Desea introducir los datos por teclado? (s/n):"
	       		read op
			
	
			  while [ $op != "n" -a $op != "s" ];
	    			do
	     			 echo "opcion incorrecta"
	     			 echo "¿Desea introducir los datos por teclado? (s/n):"
	       		         read op

	    		  done
   

		fi

	

	if [ $op = "n" ]
	  then
    		# cogemos solo los procesos que vamos a ejecutar y los guardamos en nuestro vector
	
		echo "Introduzca el nombre del proceso $p:"
		nombre=${proceso2[$[$p-1]]}
		Comprobarn $nombre
		proceso[$p]=$nombre; 
		echo "Tiempo De llegada del proceso $p:"
		llegada[$p]=${llegada2[$[$p-1]]};
		echo "Tiempo De ejecución del proceso $p:" 
		tiempo[$p]=${tiempo2[$[$p-1]]}
		
		if [ $p == 1 ]
			then
				echo Proceso ${proceso[$p]} Llegada ${llegada[$p]} Ejecucion ${tiempo[$p]}   > ./ejemplo.txt
				echo Proceso ${proceso[$p]} Llegada ${llegada[$p]} Ejecucion ${tiempo[$p]}  >> ./informeSRPT.txt
			else
				echo Proceso ${proceso[$p]} Llegada ${llegada[$p]} Ejecucion ${tiempo[$p]} >> ./ejemplo.txt
				echo Proceso ${proceso[$p]} Llegada ${llegada[$p]} Ejecucion ${tiempo[$p]}   >> ./informeSRPT.txt

		fi
		
		
			
	else 
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

		echo -n "|	$nombre		|"  >> srpt.temp
		clear
		cat srpt.temp

		echo ""
		echo "Tiempo De llegada:"
		read llegad
			until [ $llegad -ge 0 ];
				do
					echo "No se pueden introducir tiempos de llegada negativos"
					echo "Introduce un nuevo tiempo de llegada"
					read llegad
				done
		
		llegada[$p]=$llegad;   #añado al vector ese numero

		echo -n " 	 $llegad 		 |"  >> srpt.temp
		clear
		cat srpt.temp

		echo ""
		echo "Tiempo De Ejecución_$p"
		read tiemp
			until [ $tiemp -ge 0 ];
				do
					echo "No se pueden introducir tiempos de ejecución negativos"
					echo "Introduce un nuevo tiempo de ejecución"
					read tiemp
				done
	
		
		tiempo[$p]=$tiemp;   #añado al vector ese numero

		echo -n " 	 $tiemp 		 |"  >> srpt.temp
		clear
		cat srpt.temp

		echo ""
		echo Proceso $nombre Llegada $llegad Ejecucion $tiemp   >> informeSRPT.txt
		echo Proceso $nombre Llegada $llegad Ejecucion $tiemp   >> ejemplo.txt
		echo "" >> srpt.temp
		echo "__________________________________________________________________________" >> srpt.temp
		echo "" >> srpt.temp	

	fi
	p=`expr $p + 1` #incremento el contador
	pp=`expr $pp + 1` #incremento el contador

	
	done
	echo "" >> informeSRPT.txt
	echo "" >> ejemplo.txt
#cat 
echo ""

echo "¿Tiempo de Espera Acumulado[A] o Real[R]?"
read opcion;
while [ $opcion != "A" -a $opcion != "a" -a $opcion != "R" -a $opcion != "r" ];
  do
  echo "opcion incorrecta"
  echo "¿Tiempo de Espera Acumulado[A] o Real[R]?"
    read opcion
done
echo ""
#algoritmo de ordenacion de los procesos que llegan antes hasta los que llegan mas tarde
for ((i=1;i<=${#llegada[@]};i++)){   # esto me indica ${#tiempo[@]} el tiempo de llegada

 	for ((j=i;j<=${#llegada[@]};j++)){
		a=${llegada[$i]};
     		b=${llegada[$j]};    #asigno a unas variables 

      		if [ $a -gt $b ];
         	 then
            	     aux=${llegada[$i]};
              	     llegada[$i]=${llegada[$j]};   #para ordenar por menor tiempo de llegada
             	     llegada[$j]=$aux;

		     aux2=${tiempo[$i]};
            	     tiempo[$i]=${tiempo[$j]};  #para ordenar los tiempos de ejecucion con sus tiempos de respuesta
            	     tiempo[$j]=$aux2;
		
	    	     aux3=${proceso[$i]};
            	     proceso[$i]=${proceso[$j]};  #para ordenar los nombres con sus mismos valores
            	     proceso[$j]=$aux3;

			
         	 fi
    
     	 }
	 	# vamos ha hacer la ordenacion dependiendo del tiempo de ejecucion y contando el ya habiendo ordenado por tiempo de llegada
		
	for ((j=i;j<=${#tiempo[@]};j++)){
		a=${tiempo[$i]};
     		b=${tiempo[$j]};    #asigno a unas variables 
		
		
		
		if [ ${llegada[$j]} -eq  0 ]
		then

      			if [ $a -gt $b ];
         	 	then
            	     		aux=${llegada[$i]};
              	     		llegada[$i]=${llegada[$j]};   #para ordenar por menor tiempo de llegada
             	     		llegada[$j]=$aux;
				
		     		aux2=${tiempo[$i]};
            	     		tiempo[$i]=${tiempo[$j]};  #para ordenar los tiempos de ejecucion con sus tiempos de respuesta
            	     		tiempo[$j]=$aux2;
		
	    	     		aux3=${proceso[$i]};
            	     		proceso[$i]=${proceso[$j]};  #para ordenar los nombres con sus mismos valores
            	     		proceso[$j]=$aux3;

			
         	 	fi
		
			
		fi
		
    
     	 }

  }
echo -e "\e[0;33m     Proceso         Llegada        Ejecución         Espera        Respuesta   \e[0m" >> ./ejemplo.txt
echo -e "     Proceso         Llegada        Ejecución         Espera        Respuesta   " >> ./informeSRPT.txt

if [ $opcion == 'R' ] || [ $opcion == 'r' ]
then
for ((i=1;i<=${#tiempo[@]};i++)){
	if [ ${tiempo[$i]} -eq 0 ]    #Si la posición 0 T.ejecucion = 0 
	  then 
	         espera=0;                #valores de inicio del primero que es 0
	        respuesta=${tiempo[0]};
			 
	  else 
		if [ $i -eq 1 ]
			then
				tinicio=${llegada[$i]};
				espera=0;
				respuesta=${tiempo[$i]};
				suma_ejecucion=`expr $respuesta + $tinicio`
			else
				espera=`expr $suma_ejecucion - ${llegada[$i]}`          #el tiempo de espera del proceso es la suma de los tiempos de ejecucion hasta el proceso anterior menos el tiempo que tarda en llegar el proceso
				suma_ejecucion=`expr $suma_ejecucion + ${tiempo[$i]}` #sumatorio de los tiempos de ejecucion	
				respuesta=`expr $suma_ejecucion - ${llegada[$i]}`  #el tiempo de respuesta (finalizacion) es el sumatorio de los tiempos de ejecucion menos el tiempo de llegada del proceso
			fi

		suma_espera=`expr $suma_espera + $espera`            #suma para sacar su promedio
		promedio_espera=`expr $suma_espera / ${#tiempo[@]}`  #promedio

		suma_respuesta=`expr $suma_respuesta + $respuesta`   #suma para sacar su promedio
		promedio_respuesta=`expr $suma_respuesta / ${#tiempo[@]}`  #promedio
			
       	fi
     
	 
echo -e "\e[0;32m *\t${proceso[$i]}\t*\t${llegada[$i]}\t*\t${tiempo[$i]}\t*\t$espera\t*\t$respuesta\t \e[0m" >> ./ejemplo.txt
echo -e " *\t${proceso[$i]}\t*\t${llegada[$i]}\t*\t${tiempo[$i]}\t*\t$espera\t*\t$respuesta\t " >> ./informeSRPT.txt


sleep "0.7"
}
else 
for ((i=1;i<=${#tiempo[@]};i++)){

	if [ ${tiempo[$i]} -eq 0 ]    #si la posición 0 = 0 
	  then 
	        espera=0;                 #valores de inicio del primero que es 0
	        respuesta=${tiempo[0]}; 
		 
	else 
		
		espera=`expr $respuesta`          #voy sumando tiempos de espera
		respuesta=`expr $respuesta + ${tiempo[$i]}`  #voy sumando los tiempos de respuesta

		suma_espera=`expr $suma_espera + $espera`            #suma para sacar su promedio
		promedio_espera=`expr $suma_espera / ${#tiempo[@]}`  #promedio

		suma_respuesta=`expr $suma_respuesta + $respuesta`   #suma para sacar su promedio
		promedio_respuesta=`expr $suma_respuesta / ${#tiempo[@]}`  #promedio
       	fi

	
     
	 
echo -e "\e[0;32m *\t${proceso[$i]}\t*\t${llegada[$i]}\t*\t${tiempo[$i]}\t*\t$espera\t*\t$respuesta\t* \e[0m" >> ./ejemplo.txt 
echo -e "*\t${proceso[$i]}\t*\t${llegada[$i]}\t*\t${tiempo[$i]}\t*\t$espera\t*\t$respuesta\t " >> ./informeSRPT.txt
sleep "0.7"
}


fi


#promedios
echo -e "\e[0;31m * T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta \e[0m" >> ./ejemplo.txt

echo -e "* T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta " >> ./informeSRPT.txt
cat ./ejemplo.txt
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
	gedit informeSRPT.txt
fi


