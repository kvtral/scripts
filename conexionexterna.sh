#!/bin/bash
echo "<html><body>" > informe.html

# Nos conectamos al servidor mediante sshpass que nos permite ejecutar comandos en la misma linea sin "tener que ingresar"
# En el for colocamos las direcciones a validar y el puerto 
# ejecutamos nc (netcat) con -z para sólo validar el ingreso, en caso de ser exitoso, guarda OK o ERROR en el archivo temporal
sshpass -p password ssh user@server ';
echo -e "";
echo -e "[ Realizando pruebas en SERVIDOR-01-PROD ..... ]";

for tlnt in "direccion.google.com 80" "otraweb.org 80" "api.dealgunaweb.org 80" "paginadeprueba.com 22"
    do
        nc -zv $tlnt 2>&1 | grep -q "succeeded"
        if [ $? -eq 0 ] ; then
            echo -e "<tr><td><h3> >> - Conexión Telnet a $(echo $tlnt | cut  -d " " -f 1) por puerto ${tlnt: -2}</h3></td><td><h3>  OK </span></h3></td></tr>" 
        else
            echo -e "<tr><td><h3> >> - Conexión Telnet a $(echo $tlnt | cut  -d " " -f 1) por puerto ${tlnt: -2}</h3></td><td><h3>  ERROR </span></h3></td></tr>" 
        fi
    done;
' > tmp.txt

#formateo del texto para pasarlo a html y enviarlo por correo

sed -i 's%\( OK \)%<span style="border-radius: 25px; background : rgb(14, 85, 31);color: #fff">\( OK \)</span>%g' "tmp.txt"
sed -i 's%\( WARNING \)%<span style="border-radius: 25px; background : rgb(104, 17, 17);color: orange">\( WARNING \)%g' "tmp.txt"
sed -i 's%\( ERROR \)%<span style="border-radius: 25px; background : rgb(104, 17, 17);color: #fff">\( ERROR \)</span>%g' "tmp.txt"
while read -r line
    do
        if [[ $line == *"<h3>"* ]]; then        
            echo $line >> informe.html
        fi
done < tmp.txt

rm -rf tmp.txt
