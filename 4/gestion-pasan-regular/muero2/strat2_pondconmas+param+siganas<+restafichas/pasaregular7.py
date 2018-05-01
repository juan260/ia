import random
import itertools
import subprocess
import sys, os

def main():
    
    outputName = 'pond_param_ganas_suma_' + sys.argv[1]
    outputFile = open(outputName, 'a')
    
    perm = []
    results = ''
    k = 0
    random.seed()
    while 1:    
        perm = [str(30*random.randint(1, 10)) for i in range(20)]
                
        #String de llamada al script
        args = '(defvar *ponderations* \'(('
        for i in range(6):
            args = args + perm[i] + ' '
        args += ')('
        for i in range(6, 11):
            args = args + perm[i] + ' '
        args = args + perm[11] + ')))\n(defvar *parameters* \'(('
        for i in range(12,16):
            args = args + perm[i] + ' '
        args = args + ')('
        for i in range(16,19):
            args = args + perm[i] + ' '
        args = args + perm[19] + ')))\t\t\t\t\t'

        #Llamamos al script y, si pasa al regular, guardamos las ponderaciones        
        res = subprocess.run(['./CreateAndExecute2.sh', perm[0], perm[1], perm[2], perm[3], perm[4],perm[5], perm[6],perm[7], perm[8],perm[9], perm[10], perm[11], perm[12], perm[13], perm[14],perm[15], perm[16],perm[17], perm[18],perm[19] ], stdout = subprocess.PIPE)
        
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


