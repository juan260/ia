#!/bin/sh
###################################################################
## 
## Asigna en el fichero clisp *ponderations* y *parameters* pa 2 jugadores
## Luego los pone a jugar y se queda con el que gane mas veces
##
##  ./CreateAndExecute.sh 1 2 3 4 ... 40
## 1...12 ponderaciones a la heuristica del jugador 1
## 21..32 ponderaciones a la heuristica del jugador 2
##
## 13..20 parametros a la heuristica del jugador 1
## 33..40 parametros a la heuristica del jugador 2
##
## Lineas 1055 y 1056 SIN COMENTAR (o al menos sin comentar la q va a ser comentada)
## En la linea 1055 la instruccion para enfrentar jug1 contra jug2
## En la 1056 la instruccion para enfrentar jug contra aleat
###################################################################



replacementline=$(echo "(defvar *ponderations1* '(($1 $2 $3 $4 $5 $6) ($7 $8 $9 $10 $11 $12)))")
sedcommand="788s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

replacementline=$(echo "(defvar *ponderations2* '(($21 $22 $23 $24 $25 $26) ($27 $28 $29 $30 $31 $32)))")
sedcommand="789s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

replacementline=$(echo "(defvar *parameters1* '(($13 $14 $15 $16) ($17 $18 $19 $20)))")
sedcommand="790s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

replacementline=$(echo "(defvar *parameters2* '(($33 $34 $35 $36) ($37 $38 $39 $40)))")
sedcommand="791s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

# Comentamos la linea de evaluador y descomentamos la del percentage
sed -i "1055s/;//" TemporalPlayer.cl
sed -i "1056s/^/;/" TemporalPlayer.cl

OUTPUT=$(sbcl --noinform --disable-ldb --script TemporalPlayer.cl)
echo $OUTPUT
# Descomentamos el eval pa q el prox q venga se lo encuentre descomentao
sed -i "1056s/;//" TemporalPlayer.cl

