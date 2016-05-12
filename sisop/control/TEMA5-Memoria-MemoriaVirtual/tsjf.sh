#! /bin/bash
#shell que corre en nuestro script
#funciones

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

#AQUI LEE EL FICHERO QUE GENERa EL GESTOR DE MEMORIA

proceso=(`cat procesosEnMemoria.txt | cut -f 1 -d":"`)
memoria=(`cat procesosEnMemoria.txt | cut -f 2 -d":"`)
tiempo=(`cat procesosEnMemoria.txt | cut -f 3 -d":"`)
llegada=(`cat procesosEnMemoria.txt | cut -f 4 -d":"`)










 for ((i=0;i<${#tiempo[@]};i++))
 do   # esto me indica ${#tiempo[@]} el tamaño de mi vector

 	for ((j=i;j<${#tiempo[@]};j++))
 	do

     		a=${llegada[$i]};
            b=${llegada[$j]};    #Tiempo de llegada para comparar

            c=${tiempo[$i]};   #Tiempo de ejecucion para comparar
            d=${tiempo[$j]};

            if [ $c -gt $d ];
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

                     aux3=${memoria[$i]};
                     memoria[$i]=${memoria[$j]};  #para acomodar los nombres con sus mismos valores
                     memoria[$j]=$aux3;
             fi

             if [ $c -eq $d ];
             then
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

                     aux3=${memoria[$i]};
                     memoria[$i]=${memoria[$j]};  #para acomodar los nombres con sus mismos valores
                     memoria[$j]=$aux3;
                 fi
             fi
     	 done
	done

echo "${proceso[0]}:${memoria[0]}:${tiempo[0]}:${llegada[0]}" >> SJFordenados.txt
sed /${proceso[0]}/d procesosEnMemoria.txt > procesosEnMemoria2.txt
cat procesosEnMemoria2.txt > procesosEnMemoria.txt
