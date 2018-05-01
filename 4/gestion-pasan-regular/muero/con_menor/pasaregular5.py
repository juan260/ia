import random
import itertools
import subprocess
import sys, os

def main():
    
    outputName = 'pond_ganas_' + sys.argv[1]
    outputFile = open(outputName, 'a')
    
    perm = []
    results = ''
    k = 0
    random.seed()
    while 1:    
        perm = [30*random.randint(1, 10) for i in range(12)]
        
        #String de llamada al script
        args = '(defvar *ponderations* \'((' + str(perm[0]) + ' ' + str(perm[1]) + ' ' + str(perm[2]) +  ' ' + str(perm[3]) + ' ' + str(perm[4]) + ' ' + str(perm[5]) + ')(' + str(perm[6]) + ' ' + str(perm[7]) + ' ' + str(perm[8]) + ' ' +  str(perm[9]) + ' ' + str(perm[10]) + ' ' + str(perm[11]) + ')))\t\t'        
        
        #Llamamos al script y, si pasa al regular, guardamos las ponderaciones        
        res = subprocess.run(['./CreateAndExecute2.sh', str(perm[0]), str(perm[1]), str(perm[2]), str(perm[3]), str(perm[4]), str(perm[5]), str(perm[6]), str(perm[7]), str(perm[8]), str(perm[9]), str(perm[10]), str(perm[11])], stdout=subprocess.PIPE)
        perc = res.stdout.decode('utf-8')
        if float(perc) > 0.63:
            results = args
            results += perc
            outputFile.write(results)
            print('\t\t Hemos conseguido uno de ' + perc)

        if k%1000 == 0:
            print(k)
        k += 1   
    outputFile.write(results)
    
main()


