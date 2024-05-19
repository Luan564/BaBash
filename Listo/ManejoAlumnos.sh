#!/bin/bash

#Verificar si el grupo ya existe
if grep -q "^alumnos:" /etc/group; then
    echo "El grupo alumnos ya existe."
else
    #Crear el grupo si no existe
    sudo groupadd "alumnos"
    echo "El grupo alumnos ha sido creado."
fi

select var in Nuevo_Usuario Eliminar_Usuario Editar salir
do
    case $var in 
    Nuevo_Usuario)
        #Datos del Usuario
        echo -n "Nombre(s): "
        read temp
        nombre="$temp"

        echo -n "Apellido Paterno: "
        read temp
        nombre="$nombre $temp"

        echo -n "Apellido Materno: "
        read temp
        nombre="$nombre $temp"
        
        #Generacion de Matricula
        usuarios=$(getent group "alumnos" | cut -d':' -f4)
        num_usuarios=$(echo "$usuarios" | tr ',' '\n' | wc -l)
        letra=$(( $num_usuarios % 26 + 65 ))  # Calcular el código ASCII de la letra
        letra=$(printf \\$(printf '%03o' $letra))  # Convertir el código ASCII en la letra correspondiente
        numero=$(( $num_usuarios / 26 + 1 ))  # Calcular el número de serie de la letra del alfabeto
        temp=`date "+%y%m%d"`$numero$letra

        #Comprobar que no existe la Matricula
        matriculas=$(getent group alumnos)
        for var in $matriculas
        do
            if [ $temp == $var ];
                then
                    letra=$(( ($num_usuarios + 1) % 26 + 65 ))  # Calcular el código ASCII de la letra
                    letra=$(printf \\$(printf '%03o' $letra))  # Convertir el código ASCII en la letra correspondiente
                    numero=$(( ($num_usuarios + 1) / 26 + 1 ))  # Calcular el número de serie de la letra del alfabeto
                    break
            fi
        done
        matricula=`date "+%y%m%d"`$numero$letra

        #Contraseña
        #sed -i "s/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g; s/Ñ/N/g" "$1"
        echo -n "CURP: "
        read temp
        temp=$(echo "$temp" | tr '[:lower:]' '[:upper:]')

        #Crear/Agregar alumno
        sudo useradd -m -d /home/alumnos/"$matricula" "$matricula"
        echo "$matricula:$temp" | sudo chpasswd
        sudo chfn -f "$nombre" $matricula
        sudo usermod -aG "alumnos" "$matricula"
        echo "El alumno $matricula ha sido creado y agregado al grupo Alumnos."
    ;;

    Eliminar_Usuario)
        echo -n "Ingrese la Matricula del Alumno a Eliminar: "
        read temp
        if id "$temp" &>/dev/null; then
            sudo userdel -r "$temp"
            echo "El alumno $temp" se elimino de forma correcta. 
        else
            echo "El alumno $temp" NO existe.
        fi
    ;;

    Editar)
        select var in Nombre Contraseña
        do
            case $var in
            Nombre)
                echo -n "Ingrese la Matricula del Alumno a Editar: "
                read temp
                if id "$temp" &>/dev/null; then
                    echo -n "Ingrese el nombre completo: "
                    read nombre
                    sudo chfn -f "$nombre" $temp
                    echo "El alumno $temp" se modifico de forma correcta.
                else
                    echo "El alumno $temp" NO existe.
                fi
                break
            ;;
            Contraseña)
                echo -n "Ingrese la Matricula del Alumno a Editar: "
                read temp
                if id "$temp" &>/dev/null; then
                    echo -n "Ingrese la Nueva contraseña: "
                    read contrasenia
                    echo "$temp:$contrasenia" | sudo chpasswd
                    echo "El alumno $temp" se modifico de forma correcta.
                else
                    echo "El alumno $temp" NO existe.
                fi
                break
            ;;
            esac
        done
    ;;
    salir)
        break
    ;;
    esac
done