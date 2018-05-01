#!/bin/sh
###################################################################
## 
## Como ejecutar esta movaida:
##  ./CreateAndExecute2.sh 1 2 3 4 5 6 7 8 9 10 11 12...20
## donde los 12 argumentos son las ponderaciones que se le da a cada
## hoyo. del 13 al 20, son los *parameters* del .cl
##
###################################################################



replacementline=$(echo "(defvar *ponderations* '(($1 $2 $3 $4 $5 $6) ($7 $8 $9 $10 $11 $12)))")
sedcommand="786s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

replacementline=$(echo "(defvar *parameters* '(($13 $14 $15 $16) ($17 $18 $19 $20)))")
sedcommand="787s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

OUTPUT=$(sbcl --noinform --disable-ldb --script TemporalPlayer.cl)
echo $OUTPUT


