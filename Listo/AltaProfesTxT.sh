#!/bin/bash
sed -i "s/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g; s/Ñ/N/g" "$1"

#Verificar si el grupo ya existe
if grep -q "^profesores:" /etc/group; then
    echo "El grupo profesores ya existe."
else
    #Crear el grupo si no existe
    sudo groupadd "profesores"
    echo "El grupo profesores ha sido creado."
fi

#Agregar profesores desde el txt
matriculas=$(awk -F "," '{ print $4  }' $1)
contrasenias=$(awk -F "," '{ print $5  }' $1)
nombres=$(awk -F "," '{ print $1, $2, $3 }' $1)

i=0;
for profe in $matriculas; do
    i=$(($i+1))
    contrasenia=$(echo "$contrasenias" | awk -v i="$i" 'NR==i')
    nombre=$(echo "$nombres" | awk -v i="$i" 'NR==i')
    
    # Verificar si el profe ya está en el sistema
    #El &>/dev/null es para que la salida sea mas "limpia" de no utilizarlo  
    if id "$profe" &>/dev/null; then
        echo "El profe $profe ya existe."
    else
        # Crear el profe si no existe
        sudo useradd -md /home/profesores/"$profe" "$profe"
        echo "$profe:$contrasenia" | sudo chpasswd
        echo "El profe $profe ha sido creado."
        sudo chfn -f "$nombre" $profe
        
    fi
    # Verificar si el profe ya está en el grupo
    if getent group "profesores" | grep -q "\b$profe\b"; then
        echo "El profe $profe ya está en el grupo Profesores."
    else
        # Agregar el profe al grupo si no está presente
        sudo usermod -aG profesores "$profe"
        sudo chgrp profesores /home/profesores/"$profe"
        echo "El profe $profe ha sido agregado al grupo Profesores."
    fi
done