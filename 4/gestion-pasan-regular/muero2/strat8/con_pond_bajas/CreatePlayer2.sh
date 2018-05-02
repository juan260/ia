#!/bin/sh
###################################################################
## 
## Como ejecutar esta movaida:
##  ./CreateAndExecute.sh 1 2 3 4 5 6 7 8 9 10 11 12
## donde los 12 argumentos son las ponderaciones que se le da a cada
## hoyo. El resultado es un unico numero que es la diferencia entre
## mi puntuacion y la del contrario, es decir, si ha salido un 4
## querra decir que he sacado 4 puntos por encima del contrario
## Si he sacado un -5, he perdido por 5 puntos
##
###################################################################



replacementline=$(echo "(defvar *ponderations2* '(($1 $2 $3 $4 $5 $6) ($7 $8 $9 $10 $11 $12)))")
sedcommand="789s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

replacementline=$(echo "(defvar *parameters2* '(($13 $14 $15 $16) ($17 $18 $19 $20)))")
sedcommand="791s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

replacementline=$(echo "(defvar *peso2* $21)")
sedcommand="793s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl
