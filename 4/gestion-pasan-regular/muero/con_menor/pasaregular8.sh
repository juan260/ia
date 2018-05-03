#!/bin/sh
###################################################################
## 
## Como ejecutar esta movaida:
##  ./testfinal '(defvar *ponderations* ...' '(defvar *params... '
## Este segundo argjumento solo en casp de que la heuristica lo requiera
#
###################################################################

sedcommand="10s/.*/${1}/"
sed -i "$sedcommand" jugador.cl

sedcommand="12s/.*/${2}/"
sed -i "$sedcommand" jugador.cl


