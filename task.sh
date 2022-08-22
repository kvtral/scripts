#!/bin/bash

function conflict() {

    url="$2svc_wfm.php?action=list_conflicting_tasks&realtime=1"
    Q=$(curl -d $3 $url | grep '"id":' -o | grep '"id":' -c)

    echo "<tr> <td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'> <span style='font-weight : bold'>$1</span> </td> <td style='border: 1px solid #dddddd; text-align: left; padding: 8px;'>  <a href='$2wfm_conflicting_tasks.php' target='_blank'> $Q tareas </a> </td> </tr>" >> conflicting_task.html

}

echo "<html><body><br>" > conflicting_task.html
echo "<table><tr><th colspan='2'> Tareas en Conflicto</th>" >> conflicting_task.html

while read -r line
    do
        conflict $line
    done < empresas.txt

echo "</table></html></body>" >> conflicting_task.html

FECHA=$(date +%d-%m-%Y" "%H:%M)
cat conflicting_task.html | mail -s "$(echo -e "Revisión Tareas en Conflicto [$FECHA]\nContent-Type: text/html")" direccion@correo.com
