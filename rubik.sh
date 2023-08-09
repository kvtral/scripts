#!/bin/bash

###########################################################
#       Cronometro para resolución cubo Rubik 3x3         #
#                Alvaro J. Carrillanca                    #
#                    kvtral 2023                          #
###########################################################

# Array con los movimientos válidos del cubo Rubik 3x3
movimientos=("F" "B" "R" "L" "U" "D" "F'" "B'" "R'" "L'" "U'" "D'" "F2" "B2" "R2" "L2" "U2" "D2")

# Función para obtener un número aleatorio entre 0 y el tamaño del array de movimientos
function obtener_movimiento_aleatorio() {
	local array=("$@")
	local tam=${#array[@]}
	local num=$((RANDOM % $tam))
	echo "${array[num]}"
}

# Función para generar un scramble aleatorio con una longitud dada
function generar_scramble() {
	local longitud=$1
	local scramble=""
	local ultima_letra=""

	for ((i=0; i<longitud; i++)); do
		movimiento=$(obtener_movimiento_aleatorio "${movimientos[@]}")
		primera_letra="${movimiento:0:1}" # Obtener la primera letra del movimiento generado

		# Verificar que la primera letra del movimiento generado no sea igual a la última letra generada
		while [[ "$primera_letra" == "$ultima_letra" ]]; do
			movimiento=$(obtener_movimiento_aleatorio "${movimientos[@]}")
			primera_letra="${movimiento:0:1}"
		done

		scramble="$scramble $movimiento"
		ultima_letra="${movimiento:0:1}" # Obtener la última letra del movimiento generado
	done
	echo $scramble
}

function format_time() {
	local total_centesimas=$1
	local minutos=$((total_centesimas / 6000))
	local segundos=$(( (total_centesimas / 100) % 60 ))
	local centesimas=$((total_centesimas % 100))

	printf "%02d:%02d:%02d" $minutos $segundos $centesimas
}

# Función para detener el cronómetro cuando se reciba la señal SIGINT (Ctrl+C)
function detener_cronometro() {
	echo "Cronómetro detenido."
	exit 0
}

# Función para mostrar el cronómetro en el terminal con centésimas de segundo
function mostrar_cronometro() {
	local inicio=$(date +%s.%N)
	local centesimas=0
	local detener=false

	# Función para detener el cronómetro cuando se presione la barra espaciadora
	function detener_cronometro() {
		detener=true
		echo "Cronómetro detenido."
		echo $tiempo_formateado
	}

	# Atrapa señal de detención SIGINT (Crl+C) FIXME : buscar forma de corregir que se detenga con barra espaciadora
	trap detener_cronometro SIGINT
	echo
	while true; do
		# Calcula el tiempo transcurrido en centésimas de segundo
		local tiempo_actual=$(date +%s.%N)
		local tiempo_transcurrido=$(echo "($tiempo_actual - $inicio) * 100" | bc | cut -d '.' -f 1)

		# Calcula el tiempo formateado
		local tiempo_formateado=$(format_time $tiempo_transcurrido)

		# Imprime el tiempo formateado en el mismo lugar (sobrescribe la línea anterior)
		echo -ne "Cronómetro: $tiempo_formateado\r"

		# Detener el cronómetro si es necesario TODO : buscar forma de corregir que se detenga con barra espaciadora
		if $detener; then
			exit 0
		fi

		# Pausa durante 0.01 segundos (centésima de segundo)
		sleep 0.01
	done
}

echo
scramble=$(generar_scramble 20)
echo "Scramble generado: $scramble"

# Uso: ./generar_scramble.sh <longitud_del_scramble>
# Por ejemplo, para obtener un scramble de longitud 20:
read -n 1 -s -r -p "Presiona la tecla espacio para comenzar el cronómetro..."
if [[ $REPLY == " " ]]; then
	centesimas=0
	mostrar_cronometro
fi
