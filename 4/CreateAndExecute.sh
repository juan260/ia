#!/bin/sh
echo "(defvar *ponderations* '($1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12))" > TemporalPlayer.cl
cat DefaultPlayer.cl >> TemporalPlayer.cl

