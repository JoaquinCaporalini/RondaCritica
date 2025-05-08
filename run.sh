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
    elif [[ "$arg" == "--papers-todos" ]]; then
        rsync -r /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/papers/* kleene:/home/jcaporalini/ronda_critica/papers/
    elif [[ "$arg" == "--papers-last" ]]; then
        last_paper=$(ls -t /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/papers | head -n 1)
        rsync -r /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/papers/"$last_paper" kleene:/home/jcaporalini/ronda_critica/papers/
        last_paper_img=$(ls -t /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/img | head -n 1)
        rsync -r /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/img/"$last_paper_img" kleene:/home/jcaporalini/ronda_critica/img/
    elif [[ "$arg" == "-x" ]]; then
        ssh kleene ./permisosRondaCritica.sh
        ssh kleene ls -l /home/jcaporalini/ronda_critica/
    elif [[ "$arg" == "-h" ]] || [[ "$arg" == "--help" ]]; then
        echo "--get o -g     Trae index.html en kleene"
        echo "--put o -p     Pone index.html de kleene"
        echo "--fotos-todos  Poner todas las fotos en kleene"
        echo "--fotos-last   Poner la última foto en kleene"
        echo "--papers-todos Poner todos los papers en kleene"
        echo "--papers-last  Poner el último paper en kleene"
        echo "-x             Ejecutando permisosRondaCritica.sh en kleene"
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
    echo "Trayendo de Kleene."
    scp kleene:/home/jcaporalini/ronda_critica/index.html /home/jcaporalini/Data/Code/Estudiante/RCC/ronda_critica/index.html
    # Agrega tu lógica para --get aquí
fi

ssh kleene ./permisosRondaCritica.sh

# pdftoppm -f 1 -l 1 -png papers/20250507/wadler.pdf tmp && mv tmp-*.png img/10.png