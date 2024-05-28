#!/bin/bash

#Verificar si el grupo ya existe
if grep -q "^profesores:" /etc/group; then
    echo "El grupo profesores ya existe."
else
    #Crear el grupo si no existe
    sudo groupadd "profesores"
    echo "El grupo profesores ha sido creado."
fi

select var in Nuevo_Usuario Eliminar_Usuario Editar Buscar salir
do
    case $var in 
    Nuevo_Usuario)
        #Datos del Usuario
        echo -n "Nombre(s): "
        read temp
        mat_temp="$(echo "$temp" | cut -c 1)"
        nombre="$temp"

        echo -n "Apellido Paterno: "
        read temp
        mat_temp="$mat_temp$temp"
        nombre="$nombre $temp"

        echo -n "Apellido Materno: "
        read temp
        mat_temp="$mat_temp$(echo "$temp" | cut -c 1)"
        nombre="$nombre $temp"
        
        #Generacion de Matricula
        mat_temp=$(echo "$mat_temp" | tr '[:lower:]' '[:upper:]')
                    echo "$mat_temp"
                    echo "$temp"


        #Comprobar que no existe la Matricula
        matriculas=$(getent group profesores)
        for var in $matriculas
        do
            i=1;
            while [ $mat_temp == $var ]
            do
            i=$(($i+1))
            mat_temp="${mat_temp:0:${#mat_temp}-1}"
            mat_temp="$mat_temp$(echo "$temp" | cut -c $i)"
            done
        done
        matricula=$(echo "$mat_temp" | tr '[:lower:]' '[:upper:]')

        #Contraseña
        echo -n "CURP: "
        read temp
        temp=$(echo "$temp" | tr '[:lower:]' '[:upper:]')

        #Crear/Agregar Profesor
        sudo useradd -m -d /home/profesores/"$matricula" "$matricula"
        echo "$matricula:$temp" | sudo chpasswd
        sudo chfn -f "$nombre" $matricula
        sudo usermod -aG "profesores" "$matricula"
        sudo chgrp profesores /home/profesores/"$matricula"
        echo "El Profesor $matricula ha sido creado y agregado al grupo Profesores."
    ;;

    Eliminar_Usuario)
        echo -n "Ingrese el User del profesor a Eliminar: "
        read temp
        if id "$temp" &>/dev/null; then
            sudo userdel -r "$temp"
            echo "El Profesor $temp" se elimino de forma correcta. 
        else
            echo "El Profesor $temp" NO existe.
        fi
    ;;

    Editar)
        select var in Nombre Contraseña
        do
            case $var in
            Nombre)
                echo -n "Ingrese el user del profesor a Editar: "
                read temp
                if id "$temp" &>/dev/null; then
                    echo -n "Ingrese el nombre completo: "
                    read nombre
                    sudo chfn -f "$nombre" $temp
                    echo "El Profesor $temp" se modifico de forma correcta.
                else
                    echo "El Profesor $temp" NO existe.
                fi
                break
            ;;
            Contraseña)
                echo -n "Ingrese el user del profesor a Editar: "
                read temp
                if id "$temp" &>/dev/null; then
                    echo -n "Ingrese la Nueva contraseña: "
                    read contrasenia
                    echo "$temp:$contrasenia" | sudo chpasswd
                    echo "La contraseña del Profesor $temp" se modifico de forma correcta.
                else
                    echo "El Profesor $temp" NO existe.
                fi
                break
            ;;
            esac
        done
    ;;
    Buscar)
    echo -n "Ingresa el user del Profesor: "
    read temp
    finger $temp
    ;;
    salir)
        break
    ;;
    esac
done