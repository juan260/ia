#!/bin/sh
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
#OUTPUT=$(expr $OUTPUT)
echo $OUTPUT

