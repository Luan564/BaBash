#!/bin/bash

case $1 in
    1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0)
    echo "Es un digito"
    ;;
    a | e | i | o | u)
    echo "Es una vocal"
    ;;
    z|x|c|v|b|n|m|l|k|j|h|g|f|d|s|q|w|r|t|y|p|ñ)
    echo "Es una consonante"
    ;;
    *)
    echo "Es un caracter especial"
    ;;

esac