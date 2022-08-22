#!/bin/bash       

################################
# Validacion de estado de ping #
# Autor: Alvaro Carrillanca    #
################################

#Configuración de uso, indicamos la cantidad de paquetes que enviamos al ping, y el limite de latencia permitido
HOST="xx.xxx.xxx.xxx"
QPAQUETES=5
RANGO_LATENCIA=100

# Guardamos la cantidad de paquetes recibidos de lo que enviamos, el primer grep cortamos un caracter y received"
# con el cut encontramos el espacio y dejamos sólo el número
CANTIDAD=$(ping  -q -c $QPAQUETES $HOST | grep -o '. received' | cut -d ' ' -f 1) 

# Guardamos la cantidad de paquetes recibidos de lo que enviamos, el primer grep cortamos un caracter y received"
# con el cut encontramos el espacio y dejamos sólo el número
LATENCIA=$(ping  -q -c $QPAQUETES $HOST | grep "rtt" | cut -d "/" -f 5 | cut -d '.' -f 1)

#Si la cantidad de paquetes recibidos son iguales a los enviados y latencia en menor a limite de aceptación
if [ $CANTIDAD -eq $QPAQUETES ] && [ $LATENCIA -lt $RANGO_LATENCIA ];  then 
    echo "OK"
#Si se reciben más de 0 paquetes y menos a los enviados o la latencia en mayor al limite aceptado, lanza warning    
elif [ $CANTIDAD -gt 0 ] && [ $CANTIDAD -lt 5 ] || [ $LATENCIA -gt $RANGO_LATENCIA ]; then
    echo "WARNING: Intermitencia o latencia alta"
# Si los paquetes recibidos es 0, Error de conexion    
elif [ $CANTIDAD -eq 0 ] ; then
    echo "ERROR: Error de conexion con el host"
fi
