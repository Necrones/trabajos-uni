#!/bin/bash
declare proc_arr[5]
for (( y=0; y<5; y++ ))
do
	proc_arr[$y]=$y
done
declare proc_arr_aux[5]
"proc_arr_aux[@]"=${proc_arr[@]}
echo "${proc_arr[@]}"
echo "${proc_arr_aux[@]}"