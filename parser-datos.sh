LANG=da_DK.UTF-8

# Programa que obtiene los datos de un archivo html de un senador


extraer_nombre_completo() {
	archivo=$1
    nombre="$(grep --text -w "Nombre" -A 1 $archivo | tail -1 | cut -d ">" -f 4- | cut -d "<" -f 1)"
    printf "%s\n" "$nombre"
}

extraer_nombres() {
	archivo=$1
    nombres="$(echo "$1" | cut -d , -f 2 | cut -c 2-)"
    printf "%s\n" "$nombres"
}

extraer_apellidos() {
	archivo=$1
    apellidos="$(echo "$1" | cut -d , -f 1)"
    printf "%s\n" "$apellidos"
}

extraer_estatus() {
    archivo=$1
    estatus="$(grep --text -w "Estatus:" -A 1 $archivo | tail -1 | cut -d ">" -f 2- | cut -d "<" -f -1)"  
	 printf "%s\n" "$estatus"
}

extraer_partido() {
archivo=$1
    partido="$(grep --text -w Partido: -A 1 $archivo | tail -1  | cut -d ">" -f 2- | cut -d  "<" -f  1)"
	 printf "%s\n" "$partido"
}

extraer_periodo() {
archivo=$1
    periodo="$(grep --text -w Periodo -A 1 $archivo | tail -1 | cut -d ">" -f 2- | cut -d "<" -f -1)"  
	 printf "%s\n" "$periodo"
}

inicio() {
archivo=$1
    inicio="$(echo "$1" | sed -r 's/(.{14}).*/\1/')" 
    printf "%s\n" "$inicio"
}

final() {
archivo=$1
    final="$(echo "$1" | sed -r 's/.* al (.*)/\1/')"
    printf "%s\n" "$final"
}

extraer_nacimiento() {
archivo=$1
	nacimiento="$(grep --text -w Nacimiento -A 1 $archivo | tail -1 | cut -d ">" -f 2- | cut -d "<" -f -1)"
	printf "%s\n" "$nacimiento"
}

extraer_Principio() {
archivo=$1
    principio="$(grep --text -w Principio -A 1 $archivo | tail -1 | cut -d ">" -f 2- | cut -d "<" -f -1)"  
	 printf "%s\n" "$principio"
}

extraer_zona() {
archivo=$1
    zona="$(grep --text -w "Entidad:" $archivo | tail -1 | cut -c 30- | cut -d "<" -f 1)"  
	 printf "%s\n" "$zona"
}

extraer_toma() {
archivo=$1
    toma="$(grep -w "protesta:" -A 1 $archivo | tail -1  | cut -d ">" -f 2-| cut -d "<" -f 1)"
	 printf "%s\n" "$toma"
}


extraer_correo() {
archivo=$1
    correo="$(grep -w "Correo" -A 1 $archivo | tail -1  | cut -d ">" -f 2-| cut -d "<" -f 1)"
	 printf "%s\n" "$correo"
}

extraer_ultimogdo() {
archivo=$1
    grado="$(grep -w "de estudios:" -A 1 $archivo | cut -d ">" -f 2-| cut -d "<" -f 1 | cut -d "&" -f -1)"
     printf "%s\n" "$grado"
}

extraer_prep_academica() {
archivo=$1
    preparacion="$(grep -w "Preparaci" -A 1 $archivo | cut -d ">" -f 2-| cut -d "<" -f 1 | cut -d "&" -f -1)"
     printf "%s\n" "$preparacion"
}

extraer_suplente() {
archivo=$1
    suplente="$(grep -w "Suplente:" -A 1 $archivo | tail -1  | cut -d ">" -f 3-| cut -d "<" -f -1 | tr -d ',' )"
	 printf "%s\n" "$suplente"
} 


extraer_fb() {
archivo=$1
	fb="$(grep -w "facebook.com" $archivo | cut -d  '"' -f 2 )"
	printf "%s\n" "$fb"
}

extraer_tw() {
archivo=$1
	tw="$(grep -w "twitter.com" $archivo | cut -d  '"' -f 8)"
	printf "%s\n" "$tw"
}

extraer_ig() {
archivo=$1
    ig="$(grep -w "instagram.com" $archivo | cut -d  '"' -f 8)"
    printf "%s\n" "$ig"
}
 
# " " preparación academica 

extraer_datos() {
    archivo=$1

    nombre_completo="$(extraer_nombre_completo "$archivo")"
    estatus="$(extraer_estatus "$archivo")"
    partido="$(extraer_partido "$archivo")"
    periodo="$(extraer_periodo "$archivo")"
    inicio="$(inicio "$periodo")"
    final="$(final "$periodo")"
    nacimiento="$(extraer_nacimiento "$archivo")"
    #naci="$(nacimiento "$nacimiento")"
    principio="$(extraer_Principio "$archivo")"
    zona="$(extraer_zona "$archivo")"
    toma="$(extraer_toma "$archivo")"
    correo="$(extraer_correo "$archivo")"
    grado="$(extraer_ultimogdo "$archivo")"
    preparacion="$(extraer_prep_academica "$archivo")"
    suplente="$(extraer_suplente "$archivo")"
    fb="$(extraer_fb "$archivo")"
    tw="$(extraer_tw "$archivo")"
    ig="$(extraer_ig "$archivo")"
    
    nombres=$(extraer_nombres "$nombre_completo")
    apellidos=$(extraer_apellidos "$nombre_completo")

    csv_datos="${nombres},${apellidos},${estatus},${inicio},${final},${partido},${principio},${zona},${toma},${correo},${grado},${preparacion},${suplente},${nacimiento},${fb},${tw},${ig}"
    echo $csv_datos
    

}
 

 RUTA_SENADORES="./senadores/*.html"
 RUTA_DIPUTADOS="./diputados/*.html"
 RUTA_SENADORESM="./senadoresM/*.html"
 
 
echo "Nombre,Apellido,Estatus,Fecha de inicio,Fecha final,Partido,Principio de eleccion,Zona,Toma de protesta,Correo electronico,Ultimo grado,Preparacion Academica,Suplente,Nacimiento,Facebook,Twitter,instagram" > senadores.csv
     

for senador in $RUTA_SENADORES; do 
    
    extraer_datos $senador >> senadores.csv 
done

echo "Nombre,Apellido,Estatus,Fecha de inicio,Fecha final,Partido,Principio de eleccion,Zona,Toma de protesta,Correo electronico,Ultimo grado,Preparacion Academica,Suplente,Nacimiento,Facebook,Twitter,instagram" > diputados.csv

for diputado in $RUTA_DIPUTADOS; do 

    extraer_datos $diputado >> diputados.csv 
done

echo "Nombre,Apellido,Estatus,Fecha de inicio,Fecha final,Partido,Principio de eleccion,Zona,Toma de protesta,Correo electronico,Ultimo grado,Preparacion Academica,Suplente,Nacimiento,Facebook,Twitter,instagram" > senadores-minoria.csv

for senadorM in $RUTA_SENADORESM; do 

    extraer_datos $senadorM >> senadores-minoria.csv 
done


