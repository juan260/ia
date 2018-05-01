#!/bin/sh
###################################################################
## 
## Asigna en el fichero clisp *ponderations* y *parameters* a *jdr-nmx-helado*
##
##  ./ContraAleat.sh 1 2 ... 20
## 1...12 ponderaciones a la heuristica 
## 21..32 ponderaciones a la heuristica 
##
## Pone a jugar al jugador contra el aleatorio un monton de veces y 
## devuelve el winrate del helado
## 
## Lineas 1055 y 1056 SIN COMENTAR (o al menos sin comentar la que descomentamos)
## En la linea 1055 la instruccion para enfrentar jug1 contra jug2
## En la 1056 la instruccion para enfrentar jug contra aleat
###################################################################

replacementline=$(echo "(defvar *ponderations* '(($1 $2 $3 $4 $5 $6) ($7 $8 $9 $10 $11 $12)))")
sedcommand="786s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

replacementline=$(echo "(defvar *parameters* '(($13 $14 $15 $16) ($17 $18 $19 $20)))")
sedcommand="787s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

# Descomentamos la linea de evaluador y comentamos la del percentage
sed -i "1056s/;//" TemporalPlayer.cl
sed -i "1055s/^/;/" TemporalPlayer.cl

OUTPUT=$(sbcl --noinform --disable-ldb --script TemporalPlayer.cl)
echo $OUTPUT

# Descomentamos el perc pa q el prox q venga se lo encuentre descomentao
sed -i "1055s/;//" TemporalPlayer.cl

