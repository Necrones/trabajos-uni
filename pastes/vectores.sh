#!/bin/bash
declare partitions[$numpart]
declare part_init[$numpart]
declare part_fin[$numpart]
#
#
#
AsignaMem $identificador_de_proceso
function AsignaMem() {
	local proceso
	proceso=$1
	local j
	local i
	i=0
	j=0
	while [ $j -eq 0 ];do
		if [ "${partition[$i]}" -eq 0 ];then
			if [ $(expr $(expr "${part_fin[$i]}" - "${part_init[$i]}") + 1) -ge  "${proc_mem[$proceso]}" ];then
				OcuMem "${part_init[$i]}" "${proc_mem[$proceso]}" $proceso
				partition[$i]=1
				let cola=cola+1
				j=1
			else
				let i=i+1
			fi
			if [ $i -eq $numpart ]
				j=1
			fi
		else
			let i=i+1
			if [ $i -eq $numpart ]
				j=1
			fi
		fi
	done
}

