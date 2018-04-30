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
    # 25i i = 1...6
    l = range(25, 151, 25)
    
    results = ''
    perms = itertools.permutations(l)
    #for perm, i in zip(perms, range(20)):
    
    for perm in perms:
        #String de llamada al script
        args = '(defvar *ponderations* \'((0 0 0 ' + str(perm[0]) + ' ' + str(perm[1]) + ' ' + str(perm[2]) + ')(0 0 0 ' + str(perm[3]) + ' ' + str(perm[4]) + ' ' + str(perm[5]) + ')))\n'        
        #Llamamos al script y, si pasa al regular, guardamos las ponderaciones        
        res = subprocess.run(['./CreateAndExecute.sh', '0', '0', '0', str(perm[0]), str(perm[1]), str(perm[2]), '0', '0', '0', str(perm[3]), str(perm[4]), str(perm[5])], stdout=subprocess.PIPE)
        pasa = res.stdout.decode('utf-8')
        if pasa == 'PASA' or pasa == 'PASA\n':      
            results += args 
    outputFile.write(results)

main()

