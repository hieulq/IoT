#!/bin/bash

function init {
		light="OFF"
		fan="OFF"
		door="CLOSED"
		window="CLOSED"
		tempe=( 0 )
		humidity=( 0 )
}

function get_nums_sensors {
	nums_tempe=0
	nums_humidity=0
	while IFS='' read -r line || [[ -n "$line" ]]; do
	    # for word in $line
	    # do
	    # 	echo $word
	    # done
	    IFS=', ' read -r -a array <<< "$line"
	    name="${array[1]}"
	    echo $name
	    if [ $name == "Temperature" ]; then
	    	nums_tempe=${array[2]}
	    	echo "ahihi"
	    fi

	    if [ ${array[1]} == "Humidity" ]; then
	    	nums_humidity=${array[2]}
	    fi
	done < "$1"	
}


function generate_light {
	if [ $light == "ON" ]; then
		if [ $(( RANDOM % 10 )) -gt 7 ]; then
			light="ON"
		else
			light="OFF"
		fi
	else 
		if [ $(( RANDOM % 10 )) -gt 7 ]; then
			light="OFF"
		else
			light="ON"
		fi
	fi
}

function generate_fan {
	if [ $fan == "ON" ]; then
		if [ $(( RANDOM % 10 )) -gt 7 ]; then
			fan="ON"
		else
			fan="OFF"
		fi
	else 
		if [ $(( RANDOM % 10 )) -gt 7 ]; then
			fan="OFF"
		else
			fan="ON"
		fi
	fi
}

function generate_door {
	if [ $door == "OPEN" ]; then
		if [ $(( RANDOM % 10 )) -gt 7 ]; then
			door="OPEN"
		else
			door="CLOSED"
		fi
	else 
		if [ $(( RANDOM % 10 )) -gt 7 ]; then
			door="OPEN"
		else
			door="CLOSED"
		fi
	fi
}

function generate_window {
	if [ $window == "OPEN" ]; then
		if [ $(( RANDOM % 10 )) -gt 7 ]; then
			window="OPEN"
		else
			window="CLOSED"
		fi
	else 
		if [ $(( RANDOM % 10 )) -gt 7 ]; then
			window="OPEN"
		else
			window="CLOSED"
		fi
	fi
}

function generate_temperature { #arg1: numberic of sensor #arg2: range of sensor value
	new_value=$(( 20 + $1 * $2 + ( RANDOM % $2 ) ))
	tempe_num=$(( ( RANDOM % 2 ) ))
	old_value=${tempe[$1]}

	if [ $old_value -gt $new_value ]; then
		tempe[$i]=$(( old_value - tempe_num ))
	else
		tempe[$i]=$(( old_value + tempe_num ))
	fi
}

function generate_humidity {
	new_value=$(( 30 + $1 * $2 + ( RANDOM % $2 ) ))
	humi_num=$(( ( RANDOM % 2 ) ))
	old_value=${humidity[$1]}
	if [ $old_value -gt $new_value ]; then
		humidity[$1]=$(( old_value - humi_num ))
		echo $tempe
	else
		humidity[$1]=$(( old_value + humi_num ))
	fi
}
	
function update_config {
	get_nums_sensors ./config/myconfig.cfg
	echo $nums_tempe
	echo $nums_humidity
	if [[ $nums_tempe==0 && $nums_humidity==0 ]]; then
		echo "abc"
	fi
	range_tempe=$(( 80/ ( $nums_tempe + 1 ) )) #heat value range (20-100)
	range_humidity=$(( 70/ ( $nums_humidity + 1 ) )) #humidity range (30-100)
}
#generate initi
init
# i=1
# echo "${tempe[0]}"
# if [ ${tempe[0]} -gt 5 ]; then
# 	tempe[1]=6
# 	echo ${tempe[1]}
# 	tempe[1]=7
# 	echo ${tempe[1]}
# 	tempe[2]=$(( tempe[$i] + 1 ))
# 	echo ${tempe[2]}
# else
# 	echo "ihaha"
# fi

while true; do
	update_config
 	echo "Send a request after $1 second"
 	sleep $(( RANDOM % $1 ))

	# generate_light
	# mosquitto_pub -t /Hpcc/Light/Status -m $light
	# generate_fan
	# mosquitto_pub -t /Hpcc/Fan/Status -m $fan
	# generate_door
	# mosquitto_pub -t /Hpcc/Door/Status -m $door
	# generate_window
	# mosquitto_pub -t /Hpcc/Window/Status -m $window
	
	for (( i=0; i < $nums_tempe; i++ )); do
		echo "send $i time"
		generate_temperature $i $range_tempe
 		mosquitto_pub -h mosquitto_sub -t /Hpcc/Temperature$i -m ${tempe[$i]}
	done

	for (( i=0; i < $nums_tempe; i++ )); do
		echo "send $i time"
		generate_humidity $i $range_humidity
 		mosquitto_pub -h mosquitto_sub -t /Hpcc/Humidity$i -m ${humidity[$i]}
	done

	echo "sended"
done