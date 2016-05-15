#! /bin/bash
#shell que corre en nuestro script
#funciones

proceso=(`cat SJFordenados.txt | cut -f 1 -d":"`)
tamano=(`cat SJFordenados.txt | cut -f 2 -d":"`)
tiempo=(`cat SJFordenados.txt | cut -f 3 -d":"`)
llegada=(`cat SJFordenados.txt | cut -f 4 -d":"`)

echo -e "\e[0;34mGenerando tabla de procesos \e[0m"
	for ((i=1;i<=3;i++)){
	echo -e "\e[0;34m .  \e[0m" 	#esto solo es para dar estilo con los puntos
	sleep "0.7"
	}
echo -e "\e[0;34mTabla de procesos generada\e[0m"

echo "Generando tabla de procesos " >> resultadoSJF.txt
	for ((i=1;i<=3;i++)){
	echo " .  " >> resultadoSJF.txt
	}
echo "Tabla de procesos generada" >> resultadoSJF.txt

echo ""
echo "" >> resultadoSJF.txt

echo -e "\e[0;33m*********************************Tabla de Ejecución*********************************************\e[0m"
echo ""
echo -e "\e[0;33m      Proceso         Memoria        Llegada        Ejecución         Espera        Respuesta   \e[0m"



echo "*********************************Tabla de Ejecución*********************************************" >> resultadoSJF.txt
echo "" >> resultadoSJF.txt
echo "      Proceso         Memoria        Llegada        Ejecución         Espera        Respuesta   " >> resultadoSJF.txt



for ((i=0;i<${#tiempo[@]};i++)){
	if [[ ${tiempo[$i]} -eq 0 ]]    #si la posición 0 Tejecucion= 0 
	  then 
	         espera=0;                #valores de inicio del primero que es 0
	        respuesta=${tiempo[0]};
			 
	else 
		if [ $i -eq 0 ]
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

	 
echo -e "\e[0;32m *\t${proceso[$i]}\t*\t${tamano[$i]}\t*\t${llegada[$i]}\t*\t${tiempo[$i]}\t*\t$espera\t*\t$respuesta\t* \e[0m"
echo -e " *\t${proceso[$i]}\t*\t${tamano[$i]}\t*\t${llegada[$i]}\t*\t${tiempo[$i]}\t*\t$espera\t*\t$respuesta\t* " >> resultadoSJF.txt

sleep "0.7"
}

#promedios
echo -e "\e[0;31m * T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta \e[0m" 
echo " * T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta " >> resultadoSJF.txt 
                    
echo "" >> resultadoSJF.txt






