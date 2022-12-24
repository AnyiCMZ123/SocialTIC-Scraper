#!/bib/bash
LANG=da_DK.UTF-8

echo "Obteniendo tabla "
curl -X POST -d 'SID=' -d 'CAMARA=1' -d 'LEGISLATURA=65' -d 'PARTIDO=0' -d 'PRIN_ELECCION=1' -d 'ENTIDAD=0' -d 'buttonSubmit.x=68' -d 'buttonSubmit.y=16' http://sil.gobernacion.gob.mx/Reportes/Integracion/HCongreso/ResultIntegHCongreso.php > 01-tabla-diputados.html

echo "Obteniendo lineas con referencias"
grep -e "Referencia=" 01-tabla-diputados.html > 02-lineas-referencias-diputados.txt

echo "Lineas de referencia encontradas"
wc -l 02-lineas-referencias-diputados.txt

#echo "Limpiando todo lo que está antes entre < y &"
sed 's/<.*&//'  02-lineas-referencias-diputados.txt >  03-lineas-referencias-diputados.txt

echo "Eliminando todo lo que esta despues de los primero 18 caracteres"
sed -r 's/(.{18}).*/\1/' 03-lineas-referencias-diputados.txt > 04-referencias-diputados.txt

echo "Eliminando todo lo que no son numeros"
sed -r 's/[^0-9]*//g' 04-referencias-diputados.txt > 05-referencias-diputados.txt

echo "Eliminando carpeta de perfiles anterior"
#rm -rf ./perfiles

echo "Creando carpeta de perfiles"
mkdir -p diputados

echo "Buscando persona por persona"
for referencia in $(cat 05-referencias-diputados.txt)
do
	
	wget http://sil.gobernacion.gob.mx/Librerias/pp_PerfilLegislador.php?Referencia=${referencia} -O ./diputados/${referencia}.html
done

