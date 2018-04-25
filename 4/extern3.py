import random
import itertools
import subprocess
import sys, os

def main():
    
    # Primero, vamos a poner a 0 las ponderaciones de los 3 hoyos 
    # mas lejanos al mankala (se llama asi?)
    # A los otros 6 hoyos, damos aleatoriamente las ponderaciones 
    # 25i i = 1...6
    l = range(25, 151, 25)

    results = ''
    perms = itertools.permutations(l)
    #for perm, i in zip(perms, range(20)):
    for perm in perms:
        #String de llamada al script
        args = str(perm[0]) + ' ' + str(perm[1]) + ' ' + str(perm[2]) + ' 0 0 0 ' + str(perm[3]) + ' ' + str(perm[4]) + ' ' + str(perm[5]) + '0 0 0 '          
        results += args
        results += '\t'

        #Llamamos loop veces al script guardand la media de los resultados en una variable        
        loop = 10
        res = subprocess.run(['./CreateAndExecute.sh', str(perm[0]), str(perm[1]), str(perm[2]), '0', '0', '0', str(perm[3]), str(perm[4]), str(perm[5]), '0', '0', '0'], stdout=subprocess.PIPE)
        fl_res = float(res.stdout.decode('utf-8'))
        media = fl_res/loop
        
        results += str(media)
        results += '\n'
    
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    outputFile.write(results)

main()

