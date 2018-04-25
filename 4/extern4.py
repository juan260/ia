import random
import itertools
import subprocess
import sys, os

def main():
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    
    # Primero, vamos a poner a 0 las ponderaciones de los 3 hoyos 
    # mas lejanos al mankala (se llama asi?)
    # A los otros 6 hoyos, damos aleatoriamente las ponderaciones 
    # 25i i = 1...7
    l = range(25, 176, 25)
    print(list(l))
    results = ''
    perms = itertools.permutations(l)
    #for perm, i in zip(perms, range(20)):
    for perm in perms:
        #String de llamada al script
        args = '0 0 ' + str(perm[0]) + ' ' + str(perm[1]) + ' ' + str(perm[2]) + ' ' + str(perm[3]) + ' 0 0 0 ' + str(perm[4]) + ' ' + str(perm[5]) + ' ' + str(perm[6])        
        results += args
        results += '\t'

        #Llamamos loop veces al script guardand la media de los resultados en una variable        
        loop = 10
        res = subprocess.run(['./CreateAndExecute.sh', '0', '0', str(perm[0]), str(perm[1]), str(perm[2]), str(perm[3]), '0', '0', '0', str(perm[4]), str(perm[5]), str(perm[6])], stdout=subprocess.PIPE)
        
        results += res.stdout.decode('utf-8')
        results += '\n'
        
        print(args + ' ' + res.stdout.decode('utf-8'))
    outputFile.write(results)

main()

