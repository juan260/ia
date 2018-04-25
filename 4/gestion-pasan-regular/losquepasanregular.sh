#!/bin/sh
###################################################################
## 
## Como ejecutar esta movaida:
##  ./CreateAndExecute.sh '(defvar *ponderations* ...'
#
###################################################################



replacementline=$1
sedcommand="788s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl

OUTPUT=$(sbcl --noinform --disable-ldb --script TemporalPlayer.cl)

#echo $OUTPUT
