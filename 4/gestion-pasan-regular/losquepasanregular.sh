#!/bin/sh
###################################################################
## 
## Como ejecutar esta movaida:
##  ./CreateAndExecute.sh '(defvar *ponderations* ...'
#
###################################################################


echo $1
replacementline=$1
#echo $@
sedcommand="788s/.*/${replacementline}/"
sed -i "$sedcommand" TemporalPlayer.cl
#echo "${sedcommand}"


#sed -i "$sedcommand" TemporalPlayer.cl

#OUTPUT=$(sbcl --noinform --disable-ldb --script TemporalPlayer.cl)

#echo $OUTPUT
