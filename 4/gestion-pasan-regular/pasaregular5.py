import random
import itertools
import subprocess
import sys, os

def main():
    
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    
    perm = []
    results = ''
    i = 0
    while 1:    
        perm = [2*random.randint(1, 30) for i in range(12)]
        #String de llamada al script
        args = '(defvar *ponderations* \'((' + str(perm[0]) + ' ' + str(perm[1]) + ' ' + str(perm[2]) + ' ' +  str(perm[3]) + ' ' + str(perm[4]) + ' ' + str(perm[5]) + ')(' + str(perm[6]) + ' ' + str(perm[7]) + ' ' + str(perm[8]) +  ' ' + str(perm[9]) + ' ' + str(perm[10]) + ' ' + str(perm[11]) + ')))\n'        
        #Llamamos al script y, si pasa al regular, guardamos las ponderaciones        
        res = subprocess.run(['./CreateAndExecute2.sh', str(perm[0]), str(perm[1]), str(perm[2]), str(perm[3]), str(perm[4]), str(perm[5]), str(perm[6]), str(perm[7]), str(perm[8]), str(perm[9]), str(perm[10]), str(perm[11])], stdout=subprocess.PIPE)
        pasa = res.stdout.decode('utf-8')
        if pasa == 'PASA' or pasa == 'PASA\n':      
            results += args
            if i%100 == 0:
                outputFile.write(results)
                i += 1
                results = ''
    outputFile.write(results)
    
main()


