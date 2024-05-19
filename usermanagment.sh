#!/bin/bash


<<Awk
awk -F "," '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ; gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ;       gsub("Ú","U",$0) ; print $0  }' $1
Awk

sed -i "s/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g; s/Ñ/N/g" "$1"

#Verificar si existen los grupos "Alumnos" y "Profesores" si no ps crear
for grupo in "alumnos" "profesores"; do
    #Verificar si el grupo ya existe
    if grep -q "^$grupo:" /etc/group; then
        echo "El grupo $grupo ya existe."
    else
        #Crear el grupo si no existe
        sudo groupadd "$grupo"
        echo "El grupo $grupo ha sido creado."
    fi
done

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
        sudo useradd -m -d /home/alumnos/"$alumno" "$alumno"
        echo "$alumno:$contrasenia" | sudo chpasswd
        echo "El alumno $alumno ha sido creado."
        sudo chfn -f "$nombre" $alumno
    #    echo "$alumno->$contrasenia"
        
    fi
    # Verificar si el alumno ya está en el grupo
    if getent group "alumnos" | grep -q "\b$alumno\b"; then
        echo "El alumno $alumno ya está en el grupo Alumnos."
    else
        # Agregar el alumno al grupo si no está presente
        sudo usermod -aG "alumnos" "$alumno"
        echo "El alumno $alumno ha sido agregado al grupo Alumnos."
    fi
done


select var in Nuevo_Usuario Elminar_Usuario Eliminar_usuario2 Autodestruccion salir
do
    case $var in 
    Nuevo_Usuario)
        #Datos del Usuario
        echo -n "Nombre(s): "
        read temp
        echo -n $temp"," >> $1
        nombre="$temp"

        echo -n "Apellido Paterno: "
        read temp
        echo -n $temp"," >> $1
        nombre="$nombre $temp"

        echo -n "Apellido Materno: "
        read temp
        echo -n $temp"," >> $1
        nombre="$nombre $temp"
        
        #Generacion de Matricula
        linesTxt=$(wc -l < "$1")
        letra=$(( $linesTxt % 26 + 65 ))  # Calcular el código ASCII de la letra
        letra=$(printf \\$(printf '%03o' $letra))  # Convertir el código ASCII en la letra correspondiente
        numero=$(( $linesTxt / 26 + 1 ))  # Calcular el número de serie de la letra del alfabeto
        temp=`date "+%y%m%d"`$numero$letra

        #Comprobar que no existe la Matricula
        matriculas=$(awk -F "," '{ print $4  }' $1)
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
        echo -n $matricula"," >> $1

        #Contraseña
        sed -i "s/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g; s/Ñ/N/g" "$1"
        echo -n "CURP: "
        read temp
        temp=$(echo "$temp" | tr '[:lower:]' '[:upper:]')
        echo $temp >> $1


        #Crear/Agregar alumno
        sudo useradd -m -d /home/alumnos/"$matricula" "$matricula"
        echo "$matricula:$temp" | sudo chpasswd
        sudo chfn -f "$nombre" $matricula
        sudo usermod -aG "alumnos" "$matricula"
        echo "El alumno $matricula ha sido creado y agregado al grupo Alumnos."
    ;;

    Elminar_Usuario)
        echo -n "Ingrese la Matricula del Alumno a Eliminar: "
        read temp
        matriculas=$(awk -F "," '{ print $4 }' $1)
        i=1
        for var in $matriculas
        do
            if [ $temp == $var ];
                then
                    sed -i "${i}d" "$1"
                    sudo userdel -r "$temp"
                    echo "El alumno $temp ha sido Eliminado con exito."
                    break
            else
                i=$(($i+1))
            fi
        done

    ;;

    Eliminar_usuario2)
        echo -n "Ingrese la Matricula del Alumno a Eliminar: "
        read temp   
        if id "$temp" &>/dev/null; then
            sudo userdel -r "$temp"
            echo "El alumno $temp" se elimino de forma correcta. 
        else
            echo "El alumno $temp" NO existe.
    fi
    ;;

    Autodestruccion)
    #Eliminar usuarios previamente creados
    matriculas=$(awk -F "," '{ print $4 }' $1)
    for alumno in $matriculas; do
        if id "$alumno" &>/dev/null; then
            sudo userdel -r "$alumno"
            echo "El alumno $alumno ha sido eliminado."
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
    ;;

    salir)
        break
    ;;
    esac
done






# getent group Profesores
# getent group Alumnos
# cat /etc/group


