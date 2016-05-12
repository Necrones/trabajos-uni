#! /bin/bash
#shell que corre en nuestro script
#funciones
rm sjf.temp;
rm ejemplo.txt;
clear
echo "############################################################" 
echo "#                     Creative Commons                     #" 
echo "#                                                          #" 
echo "#                   BY - Atribución (BY)                   #" 
echo "#                 NC - No uso Comercial (NC)               #" 
echo "#                SA - Compartir Igual (SA)                 #" 
echo "############################################################" 
echo "############################################################" > informeSJF.txt
echo "#                     Creative Commons                     #" >> informeSJF.txt
echo "#                                                          #" >> informeSJF.txt
echo "#                   BY - Atribución (BY)                   #" >> informeSJF.txt
echo "#                 NC - No uso Comercial (NC)               #" >> informeSJF.txt
echo "#                SA - Compartir Igual (SA)                 #" >> informeSJF.txt
echo "############################################################" >> informeSJF.txt

echo ""
echo >> informeSJF.txt

echo "#######################################################################" >> informeSJF.txt
echo "#                                                                     #" >> informeSJF.txt
echo "#                         INFORME DE PRÁCTICA                         #" >> informeSJF.txt
echo "#                         GESTIÓN DE PROCESOS                         #" >> informeSJF.txt
echo "#             -------------------------------------------             #" >> informeSJF.txt
echo "#     Nuevos alumnos:                                                 #" >> informeSJF.txt
echo "#     Alumnos: Omar Santos Bernabé				        #" >> informeSJF.txt
echo "#     Sistemas Operativos 2º Semestre                                 #" >> informeSJF.txt
echo "#     Grado en ingeniería informática (2015-2016)                     #" >> informeSJF.txt
echo "#                                                                     #" >> informeSJF.txt
echo "#######################################################################" >> informeSJF.txt
echo "" >> informeSJF.txt

echo "" > ejemplo.txt

#cabecera del algoritmo en el que nos encontramos
echo -e "\e[0;33m_________________________________________________________________________________________ \e[0m"
echo -e "\e[0;33m*				\e[1;36mAlgoritmo SJF \e[0m						\e[0;33m*"			
echo -e "\e[0;33m*				\e[1;36mOmar Santos Bernabé				\e[0;33m*"
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
pp=2;
suma_espera=0;
suma_respuesta=0;	
espera=0;
respuesta=0;
suma_ejecucion=0;
tamano=0;

#vectores
proceso=();
llegada=();
tiempo=();
espera=();
tamanoMemoria=();
	echo "" >> informeSJF.txt
	echo "" > sjf.temp
	echo "| 	Proceso		|	T. Llegada	 |	 T.ejecución	 |" >> sjf.temp
	echo "_________________________________________________________________________" >> sjf.temp
	while [ $p -le $npro ] #mientras que contador sea menor que cantidad de procesos
	do
		if [ $p = 1 ]
		then

			echo "¿Desea introducir los datos de forma manual?(s/n):"
	       		read "op"
			until [ "$op" == "n" -o "$op" == "s" ]
				do
					echo "Respuesta introducida no válida"
					echo "Introduce una respuesta que sea s/n"
					read "op"
				done
		fi

		
	if [ $op = "n" ]
	  then
    		
		echo "Introduzca el nombre del proceso_$p:"
		nombre=`cat entradaSJF.txt | cut -d"*" -f$pp | cut -d" " -f3`
		Comprobarn $nombre  #envio nombre a comprobar por la funcion
		proceso[$p]=$nombre; #añado a el vector ese nombre 

		echo "Tiempo De llegada:"
		llegad=`cat entradaSJF.txt | cut -d"*" -f$pp | cut -d" " -f5`
		#echo >> informeSJF.txt

		
		llegada[$p]=$llegad;   #añado al vector ese numero

		echo "Tiempo De Ejecución_$p"
		tiemp=`cat entradaSJF.txt | cut -d"*" -f$pp | cut -d" " -f7`
		#echo ejecucion $tiemp >> informeSJF.txt
	
		tiempo[$p]=$tiemp;   #añado al vector ese numero

		
		echo Proceso $nombre Llegada $llegad Ejecucion $tiemp    >> informeSJF.txt
		echo Proceso $nombre Llegada $llegad Ejecucion $tiemp    >> ejemplo.txt
		
			
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

		echo -n "|	$nombre		|"  >> sjf.temp
		clear
		cat sjf.temp

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

		echo -n " 	 $llegad 		 |"  >> sjf.temp
		clear
		cat sjf.temp

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

		echo -n " 	 $tiemp 		 |"  >> sjf.temp
		clear
		cat sjf.temp

		echo ""
		echo Proceso $nombre Llegada $llegad Ejecucion $tiemp   >> informeSJF.txt
		echo Proceso $nombre Llegada $llegad Ejecucion $tiemp   >> ejemplo.txt
		echo "" >> sjf.temp
		echo "__________________________________________________________________________" >> sjf.temp
		echo "" >> sjf.temp	

	fi
	p=`expr $p + 1` #incremento el contador
	pp=`expr $pp + 1` #incremento el contador

	done
	echo "" >> informeSJF.txt
	echo "" >>ejemplo.txt


for ((i=1;i<=${#llegada[@]};i++)){   # esto me indica ${#tiempo[@]} el tamaño de mi vector

 	for ((j=i;j<=${#llegada[@]};j++)){
		a=${llegada[$i]};
		t1=${tiempo[$i]};
     		b=${llegada[$j]};
		t2=${tiempo[$j]};    #asigno a unas variables 

      		if [ $a -gt $b ];
         	 then
            	     aux=${tiempo[$i]};
              	     tiempo[$i]=${tiempo[$j]};   #para buscar el mayor
             	     tiempo[$j]=$aux;

		     aux1=${llegada[$i]};
              	     llegada[$i]=${llegada[$j]};   #cambio tambien si llegada para mostrar al final 
             	     llegada[$j]=$aux1;
				
	    	     aux2=${proceso[$i]};
            	     proceso[$i]=${proceso[$j]};  #para acomodar los nombres con sus mismos valores
            	     proceso[$j]=$aux2;
		else
			if [ $a -eq $b -a $t2 -lt $t1 ]
				then
					 aux1=${llegada[$i]};
					 llegada[$i]=${llegada[$j]};   #cambio tambien si llegada para mostrar al final 
      					 llegada[$j]=$aux1;


      					 aux=${tiempo[$i]};
		              	         tiempo[$i]=${tiempo[$j]};   #para buscar el mayor
     					 tiempo[$j]=$aux;
			
					 aux2=${proceso[$i]};
      					 proceso[$i]=${proceso[$j]};  #para acomodar los nombres con sus mismos valores
	       	 			 proceso[$j]=$aux2;
			fi
         	 fi
    
     	 }
  }

for((k=1;k<=$npro;k++)){
   for((i=1;i<=${#llegada[@]};i++)){
	
	for((j=(i+1);j<=${#llegada[@]};j++)){
		     a=${llegada[$i]};
		     t=`expr $a + ${tiempo[$i]}`;
		ant=`expr $j - 1`;
		if [ $j -gt 2 ]
			then
				t=`expr $t + ${tiempo[$ant]}`
		fi
		sig=`expr $j + 1`;	
		if [ $sig -le ${#llegada[@]} ]
			then
			b=${llegada[$j]};
			tb=${tiempo[$j]};
			c=${llegada[$sig]};
			tc=${tiempo[$sig]};
			if [ $t -ge $b ]
				then
					if [ $t -ge $c ]
						then
							if [ $tc -lt $tb ]
					   		    then
								 aux1=${llegada[$j]};
								 llegada[$j]=${llegada[$sig]};   #cambio tambien si llegada para mostrar al final 
        	     	      					 llegada[$sig]=$aux1;

            		       					 aux=${tiempo[$j]};
					              	         tiempo[$j]=${tiempo[$sig]};   #para buscar el mayor
             	     						 tiempo[$sig]=$aux;
				
	    	     						 aux2=${proceso[$j]};
            	       						 proceso[$j]=${proceso[$sig]};  #para acomodar los nombres con sus mismos valores
            	        	 				 proceso[$sig]=$aux2;
								
							fi
					fi
			fi
		fi
	}
   }
   
}


echo  "     Proceso        Llegada        Ejecución         Espera        Respuesta   " >> informeSJF.txt
echo -e "\e[0;33m     Proceso        Llegada        Ejecución         Espera        Respuesta   \e[0m" >> ejemplo.txt	



for ((i=1;i<=${#tiempo[@]};i++)){

	if [ $i -eq 1 ]    #si la posición 0 = 0 
	  then 
	        espera=0;                 #valores de inicio
	        respuesta=${tiempo[$i]};
		ultimaEspera=0;
		suma_ejecucion=`expr ${llegada[$i]} + ${tiempo[$i]}`
	else 
		ant=`expr $i - 1`
		restaTiempo=`expr ${llegada[$i]} - ${llegada[$ant]}`
		restaEjecucion=`expr ${tiempo[$ant]} - $restaTiempo`
		if [ $suma_ejecucion -gt ${llegada[$i]} ]			#si la suma contiene la llegada
			then
				espera=`expr $restaEjecucion + $ultimaEspera`                     #voy sumando tiempos de espera
				suma_ejecucion=`expr ${tiempo[$i]} + $suma_ejecucion`	#Voy sumando las ejecucione spara saber en que instante estoy
			else
				espera=0
				suma_ejecucion=`expr ${llegada[$i]} + ${tiempo[$i]}`	#Voy sumando las ejecucione spara saber en que instante estoy
		fi

				respuesta=`expr $espera + ${tiempo[$i]}` 		 #voy sumando los tiempos de respuesta

				suma_espera=`expr $suma_espera + $espera`            #suma para sacar su promedio
				promedio_espera=`expr $suma_espera / ${#tiempo[@]}`  #promedio

				suma_respuesta=`expr $suma_respuesta + $respuesta`   #suma para sacar su promedio
				promedio_respuesta=`expr $suma_respuesta / ${#tiempo[@]}`  #promedio
				ultimaEspera=$espera					#espera del proceso anterior
       	fi
 
echo "*	${proceso[$i]}	*	${llegada[$i]}	*	${tiempo[$i]}	*	$espera	*	$respuesta	*" >> informeSJF.txt
echo -e "\e[0;32m *\t${proceso[$i]}\t*\t${llegada[$i]}\t*\t${tiempo[$i]}\t*\t$espera\t*\t$respuesta\t* \e[0m" >> ejemplo.txt

sleep "0.7"
}

#promedios
echo "" >> ejemplo.txt
echo "" >> informeSJF.txt
echo "* T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta " >> informeSJF.txt
echo "" >> informeSJF.txt
echo -e "\e[0;31m * T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta \e[0m" >> ejemplo.txt   
echo "" >> ejemplo.txt

cat ejemplo.txt 
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
	gedit informeSJF.txt
fi
