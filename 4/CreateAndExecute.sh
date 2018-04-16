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



#cat mancala11.1.cl > TemporalPlayer.cl
#echo "\n\n(defvar *ponderations* '($1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12))" >> TemporalPlayer.cl
replacementline=$(echo "(defvar *ponderations* '(($1 $2 $3 $4 $5 $6) ($7 $8 $9 $10 $11 $12)))")
#replacement-line=$(echo hola)
sedcommand="788s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl
#cat DefaultPlayer.cl >> TemporalPlayer.cl
#cat jugadores.cl >> TemporalPlayer.cl
#sbcl --noinform --disable-ldb --script TemporalPlayer.cl
OUTPUT=$(sbcl --noinform --disable-ldb --script TemporalPlayer.cl)

#OUTPUT=$(sbcl --script TemporalPlayer.cl)
OUTPUT=$(expr $OUTPUT)
echo $OUTPUT
#if [ "0" -gt "$OUTPUT" ]
#then
#        OUTPUT=0
#fi

#return $OUTPUT 

