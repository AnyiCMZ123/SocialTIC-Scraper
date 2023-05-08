# Obtención automatizada de perfiles de senadores de México desde SIL

- Este es un script de shell en Bash que realiza una serie de acciones, para obtener información sobre los senadores y diputados de México desde el sitio SIL (Sistema de información legislativa) y almacenarla en archivos.

- El script utiliza herramientas de línea de comandos para automatizar la obtención de información sobre los senadores y diputados de México desde la página del SIL.

- Este script utiliza herramientas de línea de comandos en lugar de hacerlo manualmente. Esto permite obtener la información de manera más rápida y eficiente. 

- El código "parser-datos.sh" es un programa en shell que extrae datos de un archivo HTML que contiene información de cada senador y diputado.

- La informacón extraída la guarda en un archivo .csv.


###  api-scrapper-senadores.sh
<p>
Este programa obtiene la tabla de senadores para posteriormente obtener cada perfil de cada senador por separado en un archivo HTML.
</p>

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

- La octava línea cuenta el número de líneas en el archivo 02-lineas-referencias-senadores.txt que fueron generadas en la línea anterior.
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

### parser-datos.sh
<p>
 El script de shell que extrae información de los archivos HTML que contiene datos de un senador o diputado. El script define varias funciones, cada una de las cuales extrae información específica del archivo.
 
 Las funciones incluyen:
</p>

- **extraer_nombre_completo():** extrae el nombre completo del senador o diputado del archivo.
- **extraer_nombres():** extrae el primer y segundo nombre del senador o diputado del archivo.
- **extraer_apellidos():** extrae los apellidos del senador o diputado del archivo.
- **extraer_estatus():** extrae el estatus (en funciones, fuera de funciones) del senador o diputado del archivo.
- **extraer_partido():** extrae el partido del senador o diputado del archivo.
- **extraer_periodo():** extrae el período durante el cual el senador o diputado ha estado en el cargo.
- **inicio():** extrae la fecha de inicio del período del senador o diputado.
- **final():** extrae la fecha de finalización del período del senador o diputado.
- **extraer_nacimiento():** extrae la fecha de nacimiento del senador o diputado.
- **extraer_Principio():** extrae el principio por el cual el senador o diputado ha sido elegido.
- **extraer_zona():** extrae la entidad a la que pertenece el senador o diputado.
- **extraer_toma():** extrae la fecha en que el senador o diputado protestó por primera vez su cargo.
- **extraer_correo():** extrae el correo electrónico del senador o diputado.
- **extraer_ultimogdo():** extrae el último grado de estudios del senador o diputado.
- **extraer_prep_academica():** extrae la preparación académica del senador o diputado.
- **extraer_suplente():** extrae el nombre del suplente del senador o diputado.
- **extraer_fb():** extrae el perfil de Facebook del senador o diputado.
- **extraer_tw():** extrae el perfil de Twitter del senador o diputado.
- **extraer_ig():** extrae el perfil de Instagram del senador o diputado.

<p>La función "extraer_datos()" utiliza todas las funciones anteriores para extraer toda la información disponible del archivo HTML.
Posteriormente toda esta información extraída se almacena en tres archivos .csv para una finalidad de análisis.
</p>

<p>
Los encabezados y datos quedan ordendos de la siguiente manera:
</p> 

**Nombre, Apellido, Estatus, Fecha de inicio, Fecha final, Partido, Principio de eleccion, Zona, Toma de protesta, Correo electronico, Ultimo grado, Preparacion Academica, Suplente, Nacimiento, Facebook, Twitter, instagram.**

[![scrapp.png](https://i.postimg.cc/XqTQd87P/scrapp.png)](https://postimg.cc/1VrGZDF0)

