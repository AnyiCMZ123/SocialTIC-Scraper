#!/bib/bash
# -*- ENCODING: UTF-8 -*-
LANG=da_DK.UTF-8

echo "Obteniendo tabla senadores"
curl -X POST -d 'SID=' -d 'CAMARA=2' -d 'LEGISLATURA=65' -d 'PARTIDO=0' -d 'PRIN_ELECCION=2' -d 'ENTIDAD=0' -d 'buttonSubmit.x=68' -d 'buttonSubmit.y=16' http://sil.gobernacion.gob.mx/Reportes/Integracion/HCongreso/ResultIntegHCongreso.php > 01-tabla-senadores-minoria.html

#echo "Obteniendo lineas con referencias"
#LC_NAME="da_DK.UTF-8" 
grep -e "Referencia" 01-tabla-senadores-minoria.html > 02-lineas-referencias-senadores-minoria.txt
#grep da la palabra que tiene entre comillas

#echo "Lineas de referencia encontradas"
wc -l 02-lineas-referencias-senadores-minoria.txt
#wc cuenta palabras 

#echo "Limpiando todo lo que está antes entre < y &"
sed 's/<.*&//'  02-lineas-referencias-senadores-minoria.txt >  03-lineas-referencias-senadores-minoria.txt

#echo "Eliminando todo lo que esta despues de los primero 18 caracteres"
sed -r 's/(.{18}).*/\1/' 03-lineas-referencias-senadores-minoria.txt > 04-referencias-senadores-minoria.txt

#echo "Eliminando todo lo que no son numeros"
sed -r 's/[^0-9]*//g' 04-referencias-senadores-minoria.txt > 05-referencias-senadores-minoria.txt

#echo "Eliminando carpeta de perfiles anterior"
#rm -rf ./perfiles

#echo "Creando carpeta de perfiles"
mkdir -p senadoresM

#echo "Buscando persona por persona"
for referencia in $(cat 05-referencias-senadores-minoria.txt)
do
	wget http://sil.gobernacion.gob.mx/Librerias/pp_PerfilLegislador.php?Referencia=${referencia} -O ./senadoresM/${referencia}.html
done
