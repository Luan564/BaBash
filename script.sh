#!/bin/bash

dayName=`date "+%A"`
day=`date "+%d"`	#Dia actual del mes
month=`date "+%B"`	 #Nombre completo del mes
year=`date "+%y"`	# Año
time=`date "+%T"`	 #Hora en formato 24hrs


if [ "$1" == "hola" ];
then
	echo "Hola $2 hoy es `date "+%A"` `date "+%d"` de `date "+%B"` de `date "+%y"` y son las `date "+%T"` "

elif [ "$1" == "adios" ];
then
	echo "Adios $2 hoy es $dayName $day de $month de $year y son las $time"
else
	echo "Buenas tardes?"
fi
