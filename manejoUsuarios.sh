#!/bin/bash


<<Awk
awk -F "_" '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ;            gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ;       gsub("Ú","U",$0) ; print $0  }' prueba.txt
Awk

sed -i "s/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g; s/Ñ/N/g" "prueba.txt"



# nombres=$(awk -F "_" '{ print $1  }' prueba.txt)

# apellidoPaterno=$(awk -F "_" '{ print $2  }' prueba.txt)

# apellidoMaterno=$(awk -F "_" '{ print $3  }' prueba.txt)

# matricula=$(awk -F "_" '{ print $4  }' prueba.txt)

# facultad=$(awk -F "_" '{ print $5  }' prueba.txt)

# carrera=$(awk -F "_" '{ print $6  }' prueba.txt)

# claves=$(awk -F "_" '{ print $7 }' prueba.txt)


select var in Nuevo_Usuario Elminar_Usuario Apellido_materno Matricula Facultad Carrera salir
do
    case $var in 
    Nuevo_Usuario)
        #Datos del Usuario
        echo -n "Nombre(s): "
        read name
        echo -n $name"_" >> prueba.txt

        echo -n "Apellido Paterno: "
        read LstName
        echo -n $LstName"_" >> prueba.txt

        echo -n "Apellido Materno: "
        read MlstName
        echo -n $MlstName"_" >> prueba.txt
        
        #Generacion de Matricula
        linesTxt=$(wc -l < "prueba.txt")
        letra=$(( $linesTxt % 26 + 65 ))  # Calcular el código ASCII de la letra
        letra=$(printf \\$(printf '%03o' $letra))  # Convertir el código ASCII en la letra correspondiente
        numero=$(( $linesTxt / 26 + 1 ))  # Calcular el número de serie de la letra del alfabeto
        temp=`date "+%y%m%d"`$numero$letra

        #Comprobar que no existe la Matricula
        matriculas=$(awk -F "_" '{ print $4  }' prueba.txt)
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
        temp=`date "+%y%m%d"`$numero$letra
        echo -n $temp"_" >> prueba.txt

        #Datos Escolares
        echo -n "Facultad: "
        read temp
        echo -n $temp"_" >> prueba.txt

        echo -n "Carrera: "
        read temp
        echo -n $temp"_" >> prueba.txt

        #Generar contraseña
        sed -i "s/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g; s/Ñ/N/g" "prueba.txt"

        con=`date "+%y"`
        tra=$(echo "$LstName" | cut -c1-2)
        tra=$(echo "$tra" | tr '[:lower:]' '[:upper:]')
        se=$(echo "$MlstName" | cut -c1)
        se=$(echo "$se" | tr '[:lower:]' '[:upper:]')
        ni=$(echo "$name" | cut -c1)                    #cut sirve para obtener "x" letras de una cadena
        ni=$(echo "$ni" | tr '[:lower:]' '[:upper:]')   #Convertir minusculas a Mayusculas
        a=$numero$letra

        contrasenia=$con$tra$se$ni$a
        echo $contrasenia >> prueba.txt

    ;;

    Elminar_Usuario)
        echo -n "Ingrese la Matricula del Usuario a Eliminar: "
        read temp
        matriculas=$(awk -F "_" '{ print $4 }' prueba.txt)
        i=1
        for var in $matriculas
        do
            if [ $temp == $var ];
                then
                    sed -i "${i}d" "prueba.txt"
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
    Carrera)

    ;;
    salir)
        break
    ;;
    esac
done


