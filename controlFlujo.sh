#!/bin/bash

echo "Ingresa tres valores..."
echo "Ingresa el 1er valor:"
read a
echo "Ingresa el 2do valor:"
read b
echo "Ingresa el 3er valor:"
read c

if [[ $a -gt $b && $b -gt $c ]]
    then
    echo "$a > $b > $c"

elif [[ $a -gt $c && $c -gt $b ]]
    then
    echo "$a > $c > $b"

elif [[ $b -gt $a && $a -gt $c ]]
    then
    echo "$b > $a > $c"

elif [[ $b -gt $c && $c -gt $a ]]
    then
    echo "$b > $c > $a"
   
elif [[ $c -gt $a && $a -gt $b ]]
    then
    echo "$c > $a > $b"

elif [[ $c -gt $b && $b -gt $a ]]
    then
    echo "$c > $b > $a"



elif [[ $a -gt $b && $b -eq $c ]]
    then
    echo "$a > $b = $c"

elif [[ $b -gt $a && $a -eq $c ]]
    then
    echo "$b > $a = $c"

elif [[ $c -gt $a && $a -eq $b ]]
    then
    echo "$c > $a = $b"

elif [[ $a -eq $b && $b -eq $c ]]
    then
    echo "$a = $b = $c"

elif [[ $a -eq $b && $b -gt $c ]]
    then
    echo "$a = $b > $c"
   
elif [[ $b -eq $c && $c -gt $a ]]
    then
    echo "$b = $c > $a"

elif [[ $a -eq $c && $c -gt $b ]]
    then
    echo "$a = $c > $b  "

fi