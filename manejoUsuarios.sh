#!/bin/bash


<<Awk
awk -F "_" '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ;            gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ;       gsub("Ú","U",$0) ; print $0  }' prueba.txt
Awk

nombres=$(awk -F "_" '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ; gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ; gsub("Ú","U",$0) ; print $1  }' prueba.txt)

apellidoPaterno=$(awk -F "_" '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ; gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ; gsub("Ú","U",$0) ; print $2  }' prueba.txt)

apellidoMaterno=$(awk -F "_" '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ; gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ; gsub("Ú","U",$0) ; print $3  }' prueba.txt)

matricula=$(awk -F "_" '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ; gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ; gsub("Ú","U",$0) ; print $4  }' prueba.txt)

facultad=$(awk -F "_" '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ; gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ; gsub("Ú","U",$0) ; print $5  }' prueba.txt)

carrera=$(awk -F "_" '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ; gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ; gsub("Ú","U",$0) ; print $6  }' prueba.txt)

# echo "Nombres     Apellido Paterno    Apellido Materno    Matricula   Facultad    Carrera"
# echo "$nombres"

select var in Nombre Apellido_paterno Apellido_materno Matricula Facultad Carrera salir
do
    case $var in 
    # Lista_Completa)
    #     echo "Nombres Apellido Paterno Apellido Materno Matricula Facultad Carrera"
    #     awk -F "_" '{ gsub("á","a",$0) ; gsub("é","e",$0) ; gsub("í","i",$0) ; gsub("ó","o",$0) ; gsub("ú","u",$0) ; gsub("ñ","n",$0) ; gsub("Ñ","N",$0) ; gsub("Á","A",$0) ; gsub("É","E",$0) ; gsub("Í","I",$0) ; gsub("Ó","O",$0) ; gsub("Ú","U",$0) ; print $1,$2,$3,$4,$5,$6  }' prueba.txt
    # ;;
    Nombre)
        echo "--Nombre--"
        echo "$nombres"
    ;;
    Apellido_paterno)
        echo "--Apellido paterno--"
        echo "$apellidoPaterno"
    ;;
    Apellido_materno)
        echo "--Apellido materno--"
        echo "$apellidoMaterno"
    ;;
    Matricula)
        echo "--Matricula--"
        echo "$matricula"
    ;;
    Facultad)
        echo "--Facultad--"
        echo "$facultad"
    ;;
    Carrera)
        echo "--Carrera--"
        echo "$carrera"
    ;;
    salir)
        break
    ;;
    esac
done


