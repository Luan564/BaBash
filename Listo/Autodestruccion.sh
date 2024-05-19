#!/bin/bash

#Eliminar alumnos previamente creados
matriculas=$(getent group "alumnos" | cut -d':' -f4 | tr ',' ' ')
for alumno in $matriculas; do
    if id "$alumno" &>/dev/null; then
        sudo userdel -r "$alumno"
        echo "El alumno $alumno ha sido eliminado."
    fi
done

profesores=$(getent group "profesores" | cut -d':' -f4 | tr ',' ' ')
for profesor in $profesores; do
    if id "$profesor" &>/dev/null; then
        sudo userdel -r "$profesor"
        echo "El profesor $profesor ha sido eliminado."
    fi
done

#Eliminar Grupos xd
for grupo in "alumnos" "profesores"; do
    #Verificar si el grupo existe
    if grep -q "^$grupo:" /etc/group; then
        #Eliminar el grupo si existe
        sudo groupdel "$grupo"
        echo "El grupo $grupo ha sido eliminado."
    else
        echo "El grupo $grupo no existe."
    fi
done