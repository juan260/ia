#!/bin/sh
###################################################################
## 
## Como ejecutar esta movaida:
##  ./CreateAndExecute.sh '(defvar *ponderations* ...'
#
###################################################################



replacementline="$1"
sedcommand="788s/.*/${1}/"

sed -i "$sedcommand" TemporalPlayer.cl
echo hola
#sbcl --noinform --disable-ldb --script TemporalPlayer.cl
