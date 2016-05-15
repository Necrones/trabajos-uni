#! /bin/bash  
#shell que corre en nuestro script



#variables
suma_espera=0;
suma_respuesta=0;	
espera=0;
respuesta=0;
suma_ejecucion=0;
tinicio=0;



proceso=(`cat datos.txt | cut -f 1 -d":"`)
tamano=(`cat datos.txt | cut -f 2 -d":"`)
tiempo=(`cat datos.txt | cut -f 3 -d":"`)
llegada=(`cat datos.txt | cut -f 4 -d":"`)


echo
echo "¿Tiempo de Espera Acumulado[A] o Real[R]?"
read opcion;

echo "" >> resultadoFCFS.txt
echo "¿Tiempo de Espera Acumulado[A] o Real[R]?" >> resultadoFCFS.txt
echo "$opcion" >> resultadoFCFS.txt

echo ""
echo -e "\e[0;34mEjecutando Procesos \e[0m"   #doy color al texto

for ((i=1;i<=5;i++)){
	echo -e "\e[0;34m .  \e[0m"   #esto solo es para dar estilo con los puntos
	sleep "0.5"
}
echo -e "\e[0;34mProcesos Terminados \e[0m" 

echo "" >> resultadoFCFS.txt
echo "Ejecutando Procesos " >> resultadoFCFS.txt

for ((i=1;i<=5;i++)){
	echo " .  " >> resultadoFCFS.txt
}
echo "Procesos Terminados " >> resultadoFCFS.txt
  
echo ""
echo ""
echo "" >> resultadoFCFS.txt
echo "" >> resultadoFCFS.txt 

echo "--------------Resumen datos en memoria--------------------------"
cat info.txt
echo "----------------------------------------------------------------"

echo "--------------Resumen datos en memoria--------------------------" >> resultadoFCFS.txt
cat info.txt >> resultadoFCFS.txt
echo "----------------------------------------------------------------" >> resultadoFCFS.txt  

echo ""
echo ""
echo "" >> resultadoFCFS.txt
echo "" >> resultadoFCFS.txt 

echo ""
echo -e "\e[0;33m*********************************Tabla de Ejecución*********************************************\e[0m"
echo ""

echo -e "\e[0;33m      Proceso         Memoria        Llegada        Ejecución         Espera        Respuesta   \e[0m"


echo "" >> resultadoFCFS.txt
echo "*********************************Tabla de Ejecución*********************************************" >> resultadoFCFS.txt
echo "" >> resultadoFCFS.txt

echo "      Proceso         Memoria        Llegada        Ejecución         Espera        Respuesta   " >> resultadoFCFS.txt


if [ $opcion == R ] || [ $opcion == r ]
then
for ((i=0;i<${#tiempo[@]};i++)){
	if [ ${tiempo[$i]} -eq 0 ]    #si la posición 0 Tejecucion= 0 
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
echo -e " *\t${proceso[$i]}\t*\t${tamano[$i]}\t*\t${llegada[$i]}\t*\t${tiempo[$i]}\t*\t$espera\t*\t$respuesta\t* " >> resultadoFCFS.txt

sleep "0.7"
}
else
for ((i=0;i<${#tiempo[@]};i++)){

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

	
     
	 
echo -e "\e[0;32m *\t${proceso[$i]}\t*\t${tamano[$i]}\t*\t${llegada[$i]}\t*\t${tiempo[$i]}\t*\t$espera\t*\t$respuesta\t* \e[0m"
echo -e " *\t${proceso[$i]}\t*\t${tamano[$i]}\t*\t${llegada[$i]}\t*\t${tiempo[$i]}\t*\t$espera\t*\t$respuesta\t* " >> resultadoFCFS.txt

sleep "0.7"
}


fi

#promedios
echo -e "\e[0;31m * T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta \e[0m"
echo -e " * T.espera medio: $promedio_espera  -  * T.retorno medio: $promedio_respuesta " >> resultadoFCFS.txt
echo " " >> resultadoFCFS.txt
         

             


