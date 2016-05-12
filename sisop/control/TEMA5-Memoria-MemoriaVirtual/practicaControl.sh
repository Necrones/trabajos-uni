

chmod +x tsjf.sh tfcfs.sh practicaControl.sh meter_datos.sh fijasma.sh dinama.sh dinamicasSJF.sh fijasSJF.sh imprimeSJF.sh ordenaProcesos.sh



function comprobarNumero() { 
es_numero='^-?[0-9]+)?$'
 
flag=0
num1=$1

while [ $flag == 0 ]
 do
  if ! [[ $num1 =~ $es_numero ]] ; then
    echo "Inserte un numero"
    read num1
    flag=0
  else
    #echo "Es un número"
   flag=1
  fi
done
}





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

echo "" > resultadoFCFS.txt
echo "" > resultadoSJF.txt

clear
echo 
echo -e "${green}*********************************************************************************************************${NC}"
echo -e "${green}					   SISTEMAS OPERATIVOS${NC}"
echo -e "${green}					PRACTICA DE CONTROL 14/15"
echo -e "${amarillo}.Daniel Santidrian Alonso"
echo -e "${amarillo}.David Zotes Gonzalez${NC}"
echo -e "${green}*********************************************************************************************************${NC}"
echo	
echo

echo "" >> resultadoFCFS.txt
echo -e "*********************************************************************************************************" >> resultadoFCFS.txt
echo -e "					   SISTEMAS OPERATIVOS" >> resultadoFCFS.txt
echo -e "					PRACTICA DE CONTROL 14/15" >> resultadoFCFS.txt
echo -e ".Daniel Santidrian Alonso" >> resultadoFCFS.txt
echo -e ".David Zotes Gonzalez" >> resultadoFCFS.txt
echo -e "*********************************************************************************************************" >> resultadoFCFS.txt
echo "" >> resultadoFCFS.txt
echo "" >> resultadoFCFS.txt

echo "" >> resultadoSJF.txt
echo -e "*********************************************************************************************************" >> resultadoSJF.txt
echo -e "					   SISTEMAS OPERATIVOS" >> resultadoSJF.txt
echo -e "					PRACTICA DE CONTROL 14/15" >> resultadoSJF.txt
echo -e ".Daniel Santidrian Alonso" >> resultadoSJF.txt
echo -e ".David Zotes Gonzalez" >> resultadoSJF.txt
echo -e "*********************************************************************************************************" >> resultadoSJF.txt
echo "" >> resultadoSJF.txt
echo "" >> resultadoSJF.txt


#pido cantidad de procesos que quiere ejecutar
echo "Introduzca el numero de procesos a ejecutar:"
echo "Introduzca el numero de procesos a ejecutar:" >> resultadoFCFS.txt
echo "Introduzca el numero de procesos a ejecutar:" >> resultadoSJF.txt
read npro
##############################
comprobarNumero $npro
npro=$num1
#######################################

#variables
p=1;              #contador
pp=2;             #contador para cortar datos del fichero

suma_espera=0;
suma_respuesta=0;	
espera=0;
respuesta=0;
suma_ejecucion=0;
tinicio=0;

#vectores
proceso=();
tamano=();
llegada=();
tiempo=();
estancia=();
	
	echo "" > datos.txt
	echo "" > datos1.txt
	echo "" > info.txt
	echo "" > info2.txt

#Leo el tamaño de la particion dinamica

tamDin=`head -2 entradaDatos.txt |tail -1`
echo "Tamano de la memoria dinamica 	$tamDin MB" >> info2.txt
echo "" >> info2.txt

#Leo el numero de particiones fijas

numPart=`head -4 entradaDatos.txt |tail -1`
echo "Numero de particiones fijas 	$numPart" >> info2.txt
echo "" >> info2.txt

#Leo el valor de cada particion y lo guardo en un vector

f=0
for ((v=6;v<=$(($numPart+5));v++)){
	part[$f]=`head -$v entradaDatos.txt |tail -1`
	f=$(($f+1))
}

#Ordeno las particiones de menor a mayor para trabajar mejor con ellas

for ((i=0;i<$numPart;i++)){
	for ((j=i;j<$numPart;j++)){

		a=${part[$i]};
		b=${part[$j]};    #asigno a unas variables 

		if [[ $a -gt $b ]];
		then
			aux=${part[$i]};
			part[$i]=${part[$j]};
			part[$j]=$aux;
						
		fi
	}
}


echo "Tamaño de las particiones 	${part[*]}" >> info2.txt
echo "" >> info2.txt

	echo -e "      Proceso         Tamano        Ejecución        Llegada" >> info.txt


b=$(($numPart+7))

while [ $p -le $npro ] #mientras que contador sea menor que cantidad de procesos (Si el contador es 0 no nos hace la pregunta)
	do
		if [ $p = 1 ]
		then

			echo "¿Desea introducir los datos de forma manual? (s/n):"
			echo "¿Desea introducir los datos de forma manual? (s/n):" >> resultadoFCFS.txt
			echo "¿Desea introducir los datos de forma manual? (s/n):" >> resultadoSJF.txt
	       	read op
	
	       	echo "$op" >> resultadoFCFS.txt
	       	echo "$op" >> resultadoSJF.txt
		fi



	if [ $op = "n" ] #Introducimos los datos por fichero 
	  then
    		
		nombre=`head -$b entradaDatos.txt|tail -1|cut -f 1 -d":"`
		#echo "${proceso[$p]}"
		#Comprobarn $nombre  #envio nombre a comprobar por la funcion
		proceso[$p]=$nombre; #añado a el vector ese nombre 

		taman=`head -$b entradaDatos.txt|tail -1|cut -f 2 -d":"`
		#echo >> datos.txt

		tamano[$p]=$taman;   #añado al vector ese numero

		llegad=`head -$b entradaDatos.txt|tail -1|cut -f 3 -d":"`
		#echo >> datos.txt

		llegada[$p]=$llegad;   #añado al vector ese numero

		tiemp=`head -$b entradaDatos.txt|tail -1|cut -f 4 -d":"`
		#echo ejecucion $tiemp >> datos.txt
	
		tiempo[$p]=$tiemp;   #añado al vector ese numero


		
		echo -e "*\t${proceso[$p]}\t*\t${tamano[$p]}\t*\t${tiempo[$p]}\t*\t${llegada[$p]}\t*" >> info.txt
		
			
	else
		echo "Introduzca el nombre del proceso_$p:"
		echo "Introduzca el nombre del proceso_$p:" >> resultadoFCFS.txt
		echo "Introduzca el nombre del proceso_$p:" >> resultadoSJF.txt
		read nombre
		echo "$nombre" >> resultadoFCFS.txt
		echo "$nombre" >> resultadoSJF.txt
		#Comprobarn $nombre  #envio nombre a comprobar por la funcion
		proceso[$p]=$nombre; #añado a el vector ese nombre 

		echo "Introduzca tamano del proceso_$p:"
		echo "Introduzca tamano del proceso_$p:" >> resultadoFCFS.txt
		echo "Introduzca tamano del proceso_$p:" >> resultadoSJF.txt
		read tamano
		###########################
		 comprobarNumero $tamano
		tamano=$num1
		############################
		echo "$tamano" >> resultadoFCFS.txt
		echo "$tamano" >> resultadoSJF.txt
		tamano[$p]=$tamano;

		echo "Tiempo de llegada:"
		echo "Tiempo de llegada:" >> resultadoFCFS.txt
		echo "Tiempo de llegada:" >> resultadoSJF.txt
		read llegad
		##############################
		comprobarNumero $llegad
		llegad=$num1
		#################################
		echo "$llegad" >> resultadoFCFS.txt
		echo "$llegad" >> resultadoSJF.txt
		llegada[$p]=$llegad;   #añado al vector ese numero

		echo "Tiempo de ejecución_$p"
		echo "Tiempo de ejecución_$p" >> resultadoFCFS.txt
		echo "Tiempo de ejecución_$p" >> resultadoSJF.txt
		read tiemp
		###########################
		comprobarNumero $tiemp
		tiemp=$num1
		###########################

	
		echo "$tiemp" >> resultadoFCFS.txt
		echo "$tiemp" >> resultadoSJF.txt
		tiempo[$p]=$tiemp;   #añado al vector ese numero


		echo ""
		echo -e "\e[0;33m*****************************************************************\e[0m"
		echo -e "*\t$nombre\t*\t$tamano\t*\t$tiemp\t*\t$llegad\t*" >> info.txt
		cat info.txt
		echo ""
		echo -e "\e[0;33m*****************************************************************\e[0m"
		echo ""


		echo "" >> resultadoFCFS.txt
		echo  "*****************************************************************" >> resultadoFCFS.txt
		cat info.txt >> resultadoFCFS.txt
		echo "" >> resultadoFCFS.txt
		echo  "*****************************************************************" >> resultadoFCFS.txt
		echo "" >> resultadoFCFS.txt

		echo "" >> resultadoSJF.txt
		echo  "*****************************************************************" >> resultadoSJF.txt
		cat info.txt >> resultadoSJF.txt
		echo "" >> resultadoSJF.txt
		echo  "*****************************************************************" >> resultadoSJF.txt
		echo "" >> resultadoSJF.txt

	fi
	

	echo "${proceso[$p]}:${tamano[$p]}:${tiempo[$p]}:${llegada[$p]}" >> datos.txt 
	p=`expr $p + 1` #incremento el contador
	b=$(($b+1))
	pp=`expr $pp + 1` #incremento el contador
	
	
done ################################ FIN WHILE #############

echo ""
echo "" >> resultadoFCFS.txt
echo "" >> resultadoSJF.txt

echo -e "\e[0;34mLeyendo Procesos \e[0m"   #doy color al texto
for ((i=1;i<=3;i++)){
	echo -e "\e[0;34m .  \e[0m"   #esto solo es para dar estilo con los puntos
	sleep "0.6"
}
echo -e "\e[0;34mProcesos Leidos \e[0m" 
echo ""


echo "Leyendo Procesos" >> resultadoFCFS.txt
for ((i=1;i<=3;i++)){
	echo " .  " >> resultadoFCFS.txt
}
echo "Procesos Leidos " >> resultadoFCFS.txt
echo "" >> resultadoFCFS.txt


echo "Leyendo Procesos" >> resultadoSJF.txt
for ((i=1;i<=3;i++)){
	echo " .  " >> resultadoSJF.txt
}
echo "Procesos Leidos " >> resultadoSJF.txt
echo "" >> resultadoSJF.txt


echo "--------------Resumen datos introducidos--------------------------"
cat info2.txt
cat info.txt
echo "------------------------------------------------------------------"
echo ""
./ordenaProcesos.sh
echo "--------------Cola a introducir en memoria------------------------"
cat datos.txt
echo "------------------------------------------------------------------"


echo "--------------Resumen datos introducidos--------------------------" >> resultadoFCFS.txt
cat info2.txt >> resultadoFCFS.txt
cat info.txt >> resultadoFCFS.txt
echo "------------------------------------------------------------------" >> resultadoFCFS.txt
echo "" >> resultadoFCFS.txt
echo "--------------Cola a introducir en memoria------------------------" >> resultadoFCFS.txt
cat datos.txt >> resultadoFCFS.txt
echo "------------------------------------------------------------------" >> resultadoFCFS.txt


echo "--------------Resumen datos introducidos--------------------------" >> resultadoSJF.txt
cat info2.txt >> resultadoSJF.txt
cat info.txt >> resultadoSJF.txt
echo "------------------------------------------------------------------" >> resultadoSJF.txt
echo "" >> resultadoSJF.txt
echo "--------------Cola a introducir en memoria------------------------" >> resultadoSJF.txt
cat datos.txt >> resultadoSJF.txt
echo "------------------------------------------------------------------" >> resultadoSJF.txt


cont2=0;
cont3=0;

echo
echo "*******************************************************************************************************"
echo
echo -e "${red}Elige una de las siguientes opciones${NC}"
echo -e "${red}***************************************${NC}"
echo
echo "1 - Asignacion contigua, particiones fijas y criterio que mejor se adapte	- FCFS"
echo "2 - Asignacion contigua, particiones dinamicas y criterio que mejor se adapte	- FCFS"
echo "3 - Asignacion contigua, particiones fijas y criterio que mejor se adapte	- SJF"
echo "4 - Asignacion contigua, particiones dinamicas y criterio que mejor se adapte	- SJF"

echo "" >> resultadoFCFS.txt
echo "*******************************************************************************************************" >> resultadoFCFS.txt
echo "" >> resultadoFCFS.txt
echo "Elige una de las siguientes opciones" >> resultadoFCFS.txt
echo "***************************************" >> resultadoFCFS.txt
echo "" >> resultadoFCFS.txt
echo "1 - Asignacion contigua, particiones fijas y criterio que mejor se adapte	- FCFS" >> resultadoFCFS.txt
echo "2 - Asignacion contigua, particiones dinamicas y criterio que mejor se adapte	- FCFS" >> resultadoFCFS.txt
echo "3 - Asignacion contigua, particiones fijas y criterio que mejor se adapte	- SJF" >> resultadoFCFS.txt
echo "4 - Asignacion contigua, particiones dinamicas y criterio que mejor se adapte	- SJF" >> resultadoFCFS.txt

echo "" >> resultadoSJF.txt
echo "*******************************************************************************************************" >> resultadoSJF.txt
echo "" >> resultadoSJF.txt
echo "Elige una de las siguientes opciones" >> resultadoSJF.txt
echo "***************************************" >> resultadoSJF.txt
echo "" >> resultadoSJF.txt
echo "1 - Asignacion contigua, particiones fijas y criterio que mejor se adapte	- FCFS" >> resultadoSJF.txt
echo "2 - Asignacion contigua, particiones dinamicas y criterio que mejor se adapte	- FCFS" >> resultadoSJF.txt
echo "3 - Asignacion contigua, particiones fijas y criterio que mejor se adapte	- SJF" >> resultadoSJF.txt
echo "4 - Asignacion contigua, particiones dinamicas y criterio que mejor se adapte	- SJF" >> resultadoSJF.txt

	while [ $cont2 -ne 1 ]
	do
	echo Introduce opcion: 
	read opcion
	##################################
	comprobarNumero $opcion
	opcion=$num1
 	###################################
	echo "$opcion" >> resultadoFCFS.txt
	echo "$opcion" >> resultadoSJF.txt
	case $opcion in
		1) 	echo "" > resultadoSJF.txt
			echo #FCFS - Asignacion contigua, particiones fijas y criterio que mejor se adapte
			echo
			#./meter_datos.sh 11
			./fijasma.sh $numPart ${part[*]}
			./tfcfs.sh
			cont2=1;
			echo;;

		2)	echo "" > resultadoSJF.txt
			echo
			echo
			#echo "$tamDin"
			./dinama.sh $tamDin
			./tfcfs.sh
			cont2=1;
			echo ;;
				
		3)	echo "" > resultadoFCFS.txt
			echo #SJF - Asignacion contigua, particiones dinamicas y criterio que mejor se adapte
			echo
			./fijasSJF.sh $numPart ${part[*]}
			./imprimeSJF.sh
			cont2=1;
			echo;;

		4) 	echo "" > resultadoFCFS.txt
			echo
			echo
			./dinamicasSJF.sh $tamDin
			./imprimeSJF.sh
			cont2=1;
			echo;;

		*)	echo "Opcion introducida no encontrada, vuelve a intentarlo"
			echo ""
			echo "Opcion introducida no encontrada, vuelve a intentarlo" >> resultadoFCFS.txt
			echo "" >> resultadoFCFS.txt
			echo "Opcion introducida no encontrada, vuelve a intentarlo" >> resultadoSJF.txt
			echo "" >> resultadoSJF.txt
			cont2=0;
		esac
	done

	echo "Presione una tecla para salir"; read;
	echo "Presione una tecla para salir" >> resultadoFCFS.txt
	echo "Presione una tecla para salir" >> resultadoSJF.txt
