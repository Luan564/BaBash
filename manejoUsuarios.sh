#!/bin/bash


<<Awk
awk -F "," '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ;            gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ;       gsub("Ú","U",$0) ; print $0  }' prueba.txt
Awk

sed -i "s/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g; s/Ñ/N/g" "prueba.txt"

#Verificar si existen los grupos "Alumnos" y "Profesores" si no ps crear

for grupo in "Alumnos" "Profesores"; do
    #Verificar si el grupo ya existe
    if grep -q "^$grupo:" /etc/group; then
        echo "El grupo $grupo ya existe."
    else
        #Crear el grupo si no existe
        sudo groupadd "$grupo"
        echo "El grupo $grupo ha sido creado."
    fi
done

#Agregar usuarios del doc.txt

#sudo useradd -g developers new_user 

matriculas=$(awk -F "," '{ print $4  }' prueba.txt)

for alumno in $matriculas; do
    # Verificar si el alumno ya está en el sistema
    #El &>/dev/null es para que la salida sea mas "limpia" de no utilizarlo  
    if id "$alumno" &>/dev/null; then
        echo "El alumno $alumno ya existe."
    else
        # Crear el alumno si no existe
        sudo useradd -m "$alumno"
        echo "El alumno $alumno ha sido creado."
    fi

    # Verificar si el alumno ya está en el grupo
    if getent group "Alumnos" | grep -q "\b$alumno\b"; then
        echo "El alumno $alumno ya está en el grupo Alumnos."
    else
        # Agregar el alumno al grupo si no está presente
        sudo usermod -aG "Alumnos" "$alumno"
        echo "El alumno $alumno ha sido agregado al grupo Alumnos."
    fi
done




# nombres=$(awk -F "," '{ print $1  }' prueba.txt)

# apellidoPaterno=$(awk -F "," '{ print $2  }' prueba.txt)

# apellidoMaterno=$(awk -F "," '{ print $3  }' prueba.txt)

# facultad=$(awk -F "," '{ print $5  }' prueba.txt)

# carrera=$(awk -F "," '{ print $6  }' prueba.txt)

# claves=$(awk -F "," '{ print $7 }' prueba.txt)


select var in Nuevo_Usuario Elminar_Usuario Apellido_materno Matricula Facultad Autodestruccion salir
do
    case $var in 
    Nuevo_Usuario)
        #Datos del Usuario
        echo -n "Nombre(s): "
        read temp
        echo -n $temp"," >> prueba.txt

        echo -n "Apellido Paterno: "
        read temp
        echo -n $temp"," >> prueba.txt

        echo -n "Apellido Materno: "
        read temp
        echo -n $temp"," >> prueba.txt
        
        #Generacion de Matricula
        linesTxt=$(wc -l < "prueba.txt")
        letra=$(( $linesTxt % 26 + 65 ))  # Calcular el código ASCII de la letra
        letra=$(printf \\$(printf '%03o' $letra))  # Convertir el código ASCII en la letra correspondiente
        numero=$(( $linesTxt / 26 + 1 ))  # Calcular el número de serie de la letra del alfabeto
        temp=`date "+%y%m%d"`$numero$letra

        #Comprobar que no existe la Matricula
        matriculas=$(awk -F "," '{ print $4  }' prueba.txt)
        for var in $matriculas
        do
            if [ $temp == $var ];
                then
                    letra=$(( ($linesTxt + 1) % 26 + 65 ))  # Calcular el código ASCII de la letra
                    letra=$(printf \\$(printf '%03o' $letra))  # Convertir el código ASCII en la letra correspondiente
                    numero=$(( ($linesTxt + 1) / 26 + 1 ))  # Calcular el número de serie de la letra del alfabeto
                    break
            fi
        done
        matricula=`date "+%y%m%d"`$numero$letra
        echo -n $matricula"," >> prueba.txt

        #Contraseña
        sed -i "s/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g; s/Ñ/N/g" "prueba.txt"
        echo -n "CURP: "
        read temp
        temp=$(echo "$temp" | tr '[:lower:]' '[:upper:]')
        echo $temp >> prueba.txt

        sudo useradd -m "$matricula"
        sudo usermod -aG "Alumnos" "$matricula"
        echo "El alumno $matricula ha sido creado y agregado al grupo Alumnos."
    ;;

    Elminar_Usuario)
        echo -n "Ingrese la Matricula del Alumno a Eliminar: "
        read temp
        matriculas=$(awk -F "," '{ print $4 }' prueba.txt)
        i=1
        for var in $matriculas
        do
            if [ $temp == $var ];
                then
                    sed -i "${i}d" "prueba.txt"
                    sudo userdel -r "$temp"
                    echo "El alumno $temp ha sido Eliminado con exito."
                    break
            else
                i=$(($i+1))
            fi
        done

    ;;
    Apellido_materno)

    ;;
    Matricula)

    ;;
    Facultad)

    ;;
    Autodestruccion)
    #Eliminar usuarios previamente creados
    for alumno in $matriculas; do
        if id "$alumno" &>/dev/null; then
            sudo userdel -r "$alumno"
            echo "El alumno $alumno ha sido eliminado."
        fi
    done

    #Eliminar Grupos xd
    for grupo in "Alumnos" "Profesores"; do
        #Verificar si el grupo existe
        if grep -q "^$grupo:" /etc/group; then
            #Eliminar el grupo si existe
            sudo groupdel "$grupo"
            echo "El grupo $grupo ha sido eliminado."
        else
            echo "El grupo $grupo no existe."
        fi
    done


    ;;
    salir)
        break
    ;;
    esac
done






# getent group Profesores
# getent group Alumnos
# cat /etc/group