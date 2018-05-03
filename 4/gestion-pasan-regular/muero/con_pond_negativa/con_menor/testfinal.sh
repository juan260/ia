#!/bin/sh
###################################################################
## 
## Como ejecutar esta movaida:
##  ./testfinal '(defvar *ponderations* ...' '(defvar *params... '
## Este segundo argjumento solo en casp de que la heuristica lo requiera
#
###################################################################



#replacementline="$1"
#sedcommand="788s/.*/${1}/"

#sed -i "$sedcommand" TemporalPlayer.cl


# DESCOMENTAR ESTO Y COMENTAR LO ANTERIOR EN CASO DE QUE SEA UN FICHERP EN FORMATO DE LOS DE STRAT,
# QUE TIENENE EN LA LINEA EN 785 *PESO* 786 *PONDERATIONS* Y EN 787 *PARAMETERS*

sedcommand="10s/.*/${1}/"
sed -i "$sedcommand" jugador2.cl


sedcommand="12s/.*/${2}/"
sed -i "$sedcommand" jugador2.cl


