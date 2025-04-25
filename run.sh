#!/bin/bash

put_flag=false
get_flag=false

# Recorre los argumentos para buscar las banderas
for arg in "$@"; do
    if [[ "$arg" == "--put" ]] || [[ "$arg" == "-p" ]]; then
        put_flag=true
    elif [[ "$arg" == "--get" ]] || [[ "$arg" == "-g" ]]; then
        get_flag=true
    elif [[ "$arg" == "--fotos-todos" ]]; then
        rsync -r /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/fotos/* kleene:/home/jcaporalini/ronda_critica/fotos/
    elif [[ "$arg" == "--fotos-last" ]]; then
        last_foto=$(ls -t /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/fotos | head -n 1)
        rsync -r /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/fotos/"$last_foto" kleene:/home/jcaporalini/ronda_critica/fotos/
    elif [[ "$arg" == "-x" ]]; then
        ssh kleene ./permisosRondaCritica.sh
        ssh kleene ls -l /home/jcaporalini/ronda_critica/
    elif [[ "$arg" == "-h" ]] || [[ "$arg" == "--help" ]]; then
        echo "--get o -g    pone index.html en kleene"
        echo "--put o -p    trae index.html de kleene"
        echo "--fotos-todos trae todas las fotos de kleene"
        echo "--fotos-last  trae la última foto de kleene"
        echo "-x            Ejecutando permisosRondaCritica.sh en kleene"
    exit 1
    fi
done

# Lógica según las banderas encontradas
if $put_flag && $get_flag; then
    echo "No podes poner y obtener al mismo tiempo"
    exit 1
elif $put_flag; then
    echo "Enviando cambios a kleene"
    scp /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/index.html kleene:/home/jcaporalini/ronda_critica/index.html
    rsync /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/img/* kleene:/home/jcaporalini/ronda_critica/img/
    # Agrega tu lógica para --put aquí
elif $get_flag; then
    echo "Trayendo de Kleen."
    scp kleene:/home/jcaporalini/ronda_critica/index.html /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/index.html
    # Agrega tu lógica para --get aquí
fi

ssh kleene ./permisosRondaCritica.sh