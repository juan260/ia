#!/bin/sh
###################################################################
## 
## Como ejecutar esta movaida:
##  ./CreateAndExecute.sh '(defvar *ponderations* ...'
#
###################################################################



replacementline="$1"
sedcommand="788s/.*/${1}/"

sed -i "$sedcommand" TemporalPlayerb.cl

OUTPUT=$(sbcl --noinform --disable-ldb --script TemporalPlayerb.cl)

echo $OUTPUT
