#!/bin/sh
###################################################################
## 
## Como ejecutar esta movaida:
##  ./testfinal '(defvar *ponderations* ...' '(defvar *params... '
## Este segundo argjumento solo en casp de que la heuristica lo requiera
#
###################################################################



replacementline="$1"
sedcommand="788s/.*/${1}/"

sed -i "$sedcommand" TemporalPlayer.cl


# DESCOMENTAR ESTO Y COMENTAR LO ANTERIOR EN CASO DE QUE SEA UN FICHERP EN FORMATO DE LOS DE STRAT,
# QUE TIENENE EN LA LINEA 786 *PONDERATIONS* Y EN 787 *PARAMETERS*

#replacementline="$2"7#sedcommand="788s/.*/${2}/"
#sedcommand="787s/.*/${2}/"
#sed -i "$sedcommand" TemporalPlayer.cl

#replacementline="$1"
#sedcommand="786s/.*/${1}/"
#sed -i "$sedcommand" TemporalPlayer.cl


OUTPUT=$(sbcl --noinform --disable-ldb --script TemporalPlayer.cl)

echo $OUTPUT

