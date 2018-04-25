import random
import itertools
import subprocess
import sys, os

def main():
    
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    
 #   outputNameKK = 'kk_' + sys.argv[1]
 #   outputFileKK = open(outputNameKK, 'w')
    
    # Primero, vamos a poner a 0 las ponderaciones de los 3 hoyos 
    # mas lejanos al mankala (se llama asi?)
    # A los otros 6 hoyos, damos aleatoriamente las ponderaciones 
    # 25i i = 1...7
    l = range(25, 176, 25)
    
#    resultsKK = ''
    results = ''
    perms = itertools.permutations(l)
    
    for perm in perms:
        #String de llamada al script
        args = '(defvar *ponderations* \'(('+ str(perm[0]) + ' ' + str(perm[1]) + ' ' + str(perm[2]) + ' ' + str(perm[3]) + ' 0 0)(' + str(perm[4]) + ' ' + str(perm[5]) + ' ' + str(perm[6]) + ' 0 0 0)))\n'          
        #Llamamos al script y, si pasa al regular, guardamos las ponderaciones        
        res = subprocess.run(['./CreateAndExecute.sh', str(perm[0]), str(perm[1]), str(perm[2]), str(perm[3]), '0', '0', str(perm[4]), str(perm[5]), str(perm[6]), '0', '0', '0'], stdout=subprocess.PIPE)
        pasa = res.stdout.decode('utf-8')
        if pasa == 'PASA' or pasa == 'PASA\n':      
            results += args 
    
#        else:
#            resultsKK += pasa
#            resultsKK += '\t'
#            resultsKK += args 
#    
#    outputFileKK.write(resultsKK)
    outputFile.write(results)

main()



