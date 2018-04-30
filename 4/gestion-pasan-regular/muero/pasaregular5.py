import random
import itertools
import subprocess
import sys, os

def main():
    
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    outputNamekk = 'salida_kk'
    outputFilekk = open(outputNamekk, 'w')
    
    perm = []
    results = ''
    resultskk = ''
    i = 0
    j = 0
    k = 0
    while 1:    
        perm = [3*random.randint(1, 30) for i in range(12)]
        #String de llamada al script
        args = '(defvar *ponderations* \'((' + str(perm[0]) + ' ' + str(perm[1]) + ' ' + str(perm[2]) +  ' ' + str(perm[3]) + ' ' + str(perm[4]) + ' ' + str(perm[5]) + ')(' + str(perm[6]) + ' ' + str(perm[7]) + ' ' + str(perm[8]) + ' ' +  str(perm[9]) + ' ' + str(perm[10]) + ' ' + str(perm[11]) + ')))\t\t'        
        #Llamamos al script y, si pasa al regular, guardamos las ponderaciones        
        res = subprocess.run(['./CreateAndExecute2.sh', str(perm[0]), str(perm[1]), str(perm[2]), str(perm[3]), str(perm[4]), str(perm[5]), str(perm[6]), str(perm[7]), str(perm[8]), str(perm[9]), str(perm[10]), str(perm[11])], stdout=subprocess.PIPE)
        perc = res.stdout.decode('utf-8')
        if float(perc) > 0.6:
            results = args
            results += perc
            outputFile.write(results)

        if k%1000 == 0:
            print(k)
#        if pasa == 'PASA\n':      
#            results += args
#        
#            if i%50 == 0:
#                outputFile.write(results)
#                results = ''
#            i += 1
#        else:
#            resultskk += args
#            if j%50 == 0:
#                outputFilekk.write(resultskk)
#                resultskk = ''
#            j += 1
        k += 1   
    outputFile.write(results)
    
main()


