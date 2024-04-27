#!/bin/bash

<<si
var=$1
while [ $var -ge 1 ]
do
    echo $var
    var=$(($var-1))     #cuando quiera utilizar operaciones aritmeticas
    #let var=$var-1
done
si


select vuelta in suma resta division multiplicacion salir
do
    case $vuelta in 
    suma)
        ans=$(($1+$2))
        echo "$1 + $2 = $ans"
    ;;
    resta)
        ans=$(($1-$2))
        echo "$1 - $2 = $ans"
    ;;
    division)
        ans=$(($1/$2))
        echo "$1 / $2 = $ans"
    ;;
    multiplicacion)
        ans=$(($1*$2))
        echo "$1 * $2 = $ans"
    ;;
    salir)
        break
    ;;
    suma)
    break
    ;;

    esac
done
