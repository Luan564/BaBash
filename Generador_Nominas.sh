#!/bin/bash
C_dir (){
        if [ ! -d "Quincenas" ]; then
        	mkdir Quincenas
        fi
}

if [ -n "$CRON_VAR" ]; then

	ultimo=$(ls ./RC| wc -l)
	Directorio=Quincena_$ultimo
	actual=$(pwd)
	C_dir

	cd Quincenas
	mkdir $Directorio
	cd $Directorio

	actQuin=$(pwd)

	cat $actual/RC/RC_$ultimo.csv > tmp.txt
	nombre=( $(awk -F';' '{printf "%s ", $1} END {print ""}' tmp.txt) )
	id=( $(awk -F';' '{printf "%s ", $2} END {print ""}' tmp.txt) )
	salario=( $(awk -F';' '{printf "%s ", $3} END {print ""}' tmp.txt) )
	tiempo=( $(awk -F';' '{printf "%s ", $4} END {print ""}' tmp.txt) )
	bono=( $(awk -F';' '{printf "%s ", $5} END {print ""}' tmp.txt) )

	for (( i = 0; i < 10; i++ ));
	do
        	arch=${nombre[i]}_"$ultimo"_${id[i]}
	        touch $arch.txt

        	tiempo=$(echo "scale=2; ${tiempo[i]}/60" | bc)
	        descuento=$(echo "scale=2; $tiempo * ${salario[i]} / 100" | bc)
        	extra=$(echo "scale=2; ${bono[i]} * ${salario[i]} / 100" | bc)
	        total=$(echo "scale=2; ${salario[i]} + $extra - $descuento" | bc)
        	echo -e "Nombre: ${nombre[i]}" >> $arch.txt
	        echo -e "Id: ${id[i]}" >> $arch.txt
        	echo -e "Tiempo: $tiempo" >> $arch.txt
	        echo -e "Porcentaje: ${bono[i]}" >> $arch.txt
		echo -e "SubTotalRetardo: $descuento" >> $arch.txt
		echo -e "SubTotalPorcentaje: $extra" >> $arch.txt
		echo -e "Sueldo: ${salario[i]}" >> $arch.txt
        	echo -e "Total: $total" >> $arch.txt

	done
	rm tmp.txt
else
	C_dir

	actual=$(pwd)
	cd Quincenas

	opciones=" Nominas Detalles Contenido Salir "
    	act=$(pwd)
    	contra="136912"
    	read -p "Ingresa tu contraseña: " -s password

    	if [ "$password" -ne "$contra" ]; then
		echo "contraseña incorrecta..."

    	else
	    	echo "Contraseña correcta..."
	    	select opt in $opciones
	    	do
		    	if [ "$opt" = "Nominas" ]; then
				tree ./
		    	elif [ "$opt" = "Detalles" ]; then
				read -p "Ingresa el numero de la nomina: " Nomina

				if [ $(ls | grep Quincena_"$Nomina") ]; then
					tree ./Quincena_$Nomina
				else
					echo "No existe esa Nomina..."
				fi
				cd "$actual"/Quincenas
		    	elif [ "$opt" = "Contenido" ]; then
				read -p "Ingresa el numero de la nomina: " Nomina

                                if [ $(ls | grep Quincena_"$Nomina") ]; then
                                        cd ./Quincena_$Nomina
					read -p "Ingresa empleado(ten cuidado con las mayusculas): " BuscarNombre
					if [ $(ls | grep $BuscarNombre) ]; then
						cat $(echo $(ls | grep $BuscarNombre))
					else
						echo "No se encontro empleado.."

					fi
                                else
                                        echo "No existe esa Nomina..."
                                fi
				cd "$actual"/Quincenas

		    	elif [ "$opt" = "Salir" ]; then
			    	exit
		    	else
			    	echo "Opcion invalida"

		    	fi

	    	done
    	fi
fi
