#!/bin/bash
sed -i "s/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g; s/Ñ/N/g" "$1"

#Verificar si el grupo ya existe
if grep -q "^alumnos:" /etc/group; then
    echo "El grupo alumnos ya existe."
else
    #Crear el grupo si no existe
    sudo groupadd "alumnos"
    echo "El grupo alumnos ha sido creado."
fi

#Agregar alumnos desde el txt
matriculas=$(awk -F "," '{ print $4  }' $1)
contrasenias=$(awk -F "," '{ print $5  }' $1)
nombres=$(awk -F "," '{ print $1, $2, $3 }' $1)

i=0;
for alumno in $matriculas; do
    i=$(($i+1))
    contrasenia=$(echo "$contrasenias" | awk -v i="$i" 'NR==i')
    nombre=$(echo "$nombres" | awk -v i="$i" 'NR==i')
    
    # Verificar si el alumno ya está en el sistema
    #El &>/dev/null es para que la salida sea mas "limpia" de no utilizarlo  
    if id "$alumno" &>/dev/null; then
        echo "El alumno $alumno ya existe."
    else
        # Crear el alumno si no existe
        sudo useradd -md /home/alumnos/"$alumno" "$alumno"
        echo "$alumno:$contrasenia" | sudo chpasswd
        echo "El alumno $alumno ha sido creado."
        sudo chfn -f "$nombre" $alumno
        
    fi
    # Verificar si el alumno ya está en el grupo
    if getent group "alumnos" | grep -q "\b$alumno\b"; then
        echo "El alumno $alumno ya está en el grupo Alumnos."
    else
        # Agregar el alumno al grupo si no está presente
        sudo usermod -aG alumnos "$alumno"
        sudo chgrp alumnos /home/alumnos/"$alumno"
        echo "El alumno $alumno ha sido agregado al grupo Alumnos."
    fi
done