# Obtención automatizada de perfiles de senadores de México desde SIL

- Este es un script de shell en Bash que realiza una serie de acciones, para obtener información sobre los senadores y diputados de México desde el sitio SIL (Sistema de información legislativa) y almacenarla en archivos.

- El script utiliza herramientas de línea de comandos para automatizar la obtención de información sobre los senadores y diputados de México desde la página del SIL.

- Este script utiliza herramientas de línea de comandos en lugar de hacerlo manualmente. Esto permite obtener la información de manera más rápida y eficiente. 

- El código "parser-datos.sh" es un programa en shell que extrae datos de un archivo HTML que contiene información de cada senador y diputado.

- La informacón extraída la guarda en un archivo .csv.


## api-scrapper-senadores.sh
```
#!/bin/bash
# -*- ENCODING: UTF-8 -*-
LANG=da_DK.UTF-
```
<p>
- La línea LANG=da_DK.UTF-8 se utiliza para la la codificación de caracteres UTF-8.
</p>

```
echo "Obteniendo tabla senadores"
curl -X POST -d 'SID=' -d 'CAMARA=2' -d 'LEGISLATURA=65' -d 'PARTIDO=0' -d 'PRIN_ELECCION=1' -d 'ENTIDAD=0' -d 'buttonSubmit.x=68' -d 'buttonSubmit.y=16' http://sil.gobernacion.gob.mx/Reportes/Integracion/HCongreso/ResultIntegHCongreso.php > 01-tabla-senadores.html
```

<p>
- La quinta línea realiza una solicitud "POST" utilizando la herramienta "curl" para enviar los parámetros necesarios a la página SIL para obtener la tabla de senadores.
- La sexta línea redireccionamos la salida de la solicitud a un archivo HTML que llamamos  01-tabla-senadores.html
</p>

```
grep -e "Referencia" 01-tabla-senadores.html > 02-lineas-referencias-senadores.txt
wc -l 02-lineas-referencias-senadores.txt
```
<p>
- La séptima línea utiliza el comando "grep" para buscar en el archivo 01-tabla-senadores.html todas las líneas que contienen la palabra "Referencia".

-La octava línea cuenta el número de líneas en el archivo 02-lineas-referencias-senadores.txt que fueron generadas en la línea anterior.
</p>

```
sed 's/<.*&//'  02-lineas-referencias-senadores.txt >  03-lineas-referencias-senadores.txt
sed -r 's/(.{18}).*/\1/' 03-lineas-referencias-senadores.txt > 04-referencias-senadores.txt
sed -r 's/[^0-9]*//g' 04-referencias-senadores.txt > 05-referencias-senadores.txt
```
<p>
- Las líneas nueve a once utilizan el comando "sed" para limpiar y formatear las líneas del archivo 02-lineas-referencias-senadores.txt.
- La novena línea elimina todo lo que está antes de < y después de &
- La décima línea elimina todo lo que está después de los primeros 18 caracteres.
- La undécima línea elimina todo lo que no son números.
</p>

```
mkdir -p senadores
for referencia in $(cat 05-referencias-senadores.txt)
do
	wget http://sil.gobernacion.gob.mx/Librerias/pp_PerfilLegislador.php?Referencia=${referencia} -O ./senadores/${referencia}.html
done

```
<p>
- Esta última parte del código descarga todas las páginas web que contienen los perfiles de los senadores, y las guarda en la carpeta "senadores" con nombres de archivo basados en las referencias de los senadores.
</p>

## parser-datos.sh

