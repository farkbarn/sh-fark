#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Version: 0.0.1
#Author: Frank Barrera
#Tw: farkbarn
#email: frankbarrerag@gmail.com
#Tipe-License: GPLv3
#Url-License: http://www.gnu.org/copyleft/gpl.html
#Description: Script para ordenar el directorio año>mes>día y mantener ordenado los archivos
#             en este caso los pdf's generados en proceso de producción de el diario "El Informador, C.A."

## VALORES
str_dircre='Creando el directorio '
str_dirmv='Directorio movido '
str_direxi='El directorio ya existe, se omite la creación de '
str_dirsav='Guardando directorio anterior'
str_mesexi='Ya esta organizado el mes de '
str_mesorg='Esta organizado el directorio '
tip_docval='*.pdf'	#Tipo de documento valido, se especifica que documento es aceptado para almacenar
					#todo tocumento que no sea de esta extensión será borrado de forma automática
base_dir='./'		#se toma como base de directorio el ./ para ejecutar el script a partir de ese directorio

# YEAR
year_x=$(date -d "tomorrow" +'%Y') #año en 4 digitos
# AÑO
month_x=$(date -d "tomorrow" +'%B') # mes en texto
# MAÑANA - DIA DE TRABAJO A REALIZAR
year=$(date -d "tomorrow" +'%y')
month=$(date -d "tomorrow" +'%m')
day=$(date -d "tomorrow" +'%d')
dia=$(date -d "tomorrow" +'%A')
fecha=$day-$month-$year
# HOY - DIA DE TRABAJO REALIZADO
year_t=$(date -d "today" +'%y')
month_t=$(date -d "today" +'%m')
day_t=$(date -d "today" +'%d')
dia_t=$(date -d "today" +'%A')
fecha_t=$day_t-$month_t-$year_t
# CONTROL
fal_mes=true;	# FALTA MES
fal_dia=true;	# FALTA DIA
dir_ord=false;	# FALTA ORDENAR

## LOGICA
## CREANDO DIRECTORIO DE TRABAJO
# CREANDO AÑO
if [[ -d "$base_dir""$year_x" ]]; then
	echo $str_direxi \'$year_x\'
	if [[ -d "$base_dir""$year_x"/"${month_x^^}" ]]; then
		echo $str_mesexi \'${month_x^^}\'
		fal_mes=false;
	fi
else
	mkdir "$base_dir""$year_x"
	echo  $str_dircre \'$year_x\'
fi
# CREANDO MES
if $fal_mes; then
	if [[ -d "$base_dir""${month_x^^}" ]]; then
		echo $str_direxi \'${month_x^^}\'
	else
		mkdir "$base_dir""${month_x^^}"
		echo $str_dircre \'${month_x^^}\'
	fi
	mv "$base_dir""${month_x^^}" "$year_x"/
	echo $str_mesorg \'${month_x^^}\'
fi
# CREANDO DIA
if [[ -d "$base_dir""PARA ${dia^^} $fecha" ]]; then
	echo $str_direxi \'"PARA ${dia^^} $fecha"\'
else
	mkdir "$base_dir""PARA ${dia^^} $fecha"
	echo  $str_dircre \'"PARA ${dia^^} $fecha"\'
fi
# MOVIENDO DIRECTORIO DIA DE TRABAJO
if [[ -d "$base_dir""PARA ${dia_t^^} $fecha_t" ]]; then #si el dir esta en la raiz
	if [[ -d "$base_dir""$year_x"/"${month_x^^}"/"PARA ${dia_t^^} $fecha_t" ]]; then #si el dir esta en su lugar
		echo 'directorio '"$base_dir""PARA ${dia_t^^} $fecha_t"' duplicado' #existe una duplicidad de dir
	else
		mv "$base_dir""PARA ${dia_t^^} $fecha_t" ./"$year_x"/"${month_x^^}"/ #si no existe se mueve para ordenar
		echo $str_mesorg \'"$year_x"\/"${month_x^^}"\/"PARA ${dia_t^^} $fecha_t"\'
	fi
	$dir_ord=true;
	echo 'el directorio' "$base_dir""PARA ${dia_t^^} $fecha_t" 'ya esta ordenado'
else
	if [[ -d "$base_dir""$year_x"/"${month_x^^}"/"PARA ${dia_t^^} $fecha_t" ]]; then #Si no esta en la raiz se revisa si existe en el orden
		echo 'el directorio' "$base_dir""PARA ${dia_t^^} $fecha_t" ' ya esta ordenado' #Si esta pues ya esta ordenado no hay problema
	else
		echo 'el directorio' "$base_dir""PARA ${dia_t^^} $fecha_t" ' ha sido borrado o nunca se creó' # se debe auditar para ver quien borro el directorio o que sucedió
	fi
fi

exit