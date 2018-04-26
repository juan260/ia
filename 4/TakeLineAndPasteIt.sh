#!/bin/sh
######
# Hola este script coge todas las lineas de un fichero y las añade a una copia de temporal player
# seguidas de una ejecucion :D
######


awk '{system("cat TemporalPlayer.cl > hugeTemporalPlayer.cl")
        system("echo \"" $0 "\" >> hugeTemporalPlayer.cl"); 
      system("cat FileToDump >> hugeTemporalPlayer.cl");
      print(system("sbcl --noinform --disable-ldb --script hugeTemporalPlayer.cl"))}' $1 > $2
