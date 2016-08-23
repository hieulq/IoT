#!/bin/bash
light="ON"

number=$RANDOM
echo $(( number % 10 ))
function light {
	if [ $light == "ON" ]; then
		if [ $(( number % 10 )) -gt 7 ]; then
			echo "1"
		else
			echo "2"
		fi
	else 
		if [ $(( number % 10 )) -gt 7 ]; then
			echo "3"
		else
			echo "4"
		fi
	fi
}


light