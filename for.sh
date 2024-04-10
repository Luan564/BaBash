#!/bin/bash

<<comentario
for animal in perro gato pato burro tigre perico
do
    echo $animal
done
comentario

#Cuando vamos a realizar operaciones utilizamos doble parentesis $(()) para des-referenciar el 1er parentesis

for secuencia in $(clear) $(seq 1 10)    #El $() Permite una llamada a sistema
do
    echo $secuencia
done

