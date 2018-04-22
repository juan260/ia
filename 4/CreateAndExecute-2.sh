#!/bin/sh
###################################################################
## 
## Como ejecutar esta movaida:
##  ./CreateAndExecute2.sh 1 2 3 4 5 6 7 8 9 10 11 12
## donde los 12 argumentos son las ponderaciones que se le da a cada
## hoyo. El resultado es un unico numero que es la diferencia entre
## mi puntuacion y la del contrario, es decir, si ha salido un 4
## querra decir que he sacado 4 puntos por encima del contrario
## Si he sacado un -5, he perdido por 5 puntos
##
###################################################################



replacementline=$(echo "(defvar *parameters* '(($1 $2 $3 $4 $5 $6) ($7 $8 $9 $10 $11 $12)))")
sedcommand="825s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl
#cat DefaultPlayer.cl >> TemporalPlayer.cl
#cat jugadores.cl >> TemporalPlayer.cl
#sbcl --noinform --disable-ldb --script TemporalPlayer.cl
OUTPUT=$(sbcl --noinform --disable-ldb --script TemporalPlayer.cl)
WINSREG=$(echo $OUTPUT | cut -d ' ' -f 1,2,3)

WINSREG=$(expr $WINSREG)
if [ $WINSREG -gt 0 ]
then
    OUTPUT=$(expr $OUTPUT - $WINSREG)
    echo $OUTPUT
else
    echo "-1000"
fi

#OUTPUT=$(sbcl --script TemporalPlayer.cl)
#OUTPUT=$(expr $OUTPUT)
#echo $WINSREG


