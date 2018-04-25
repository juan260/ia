import random
import itertools
import subprocess
import sys, os

def main():
    
    inputPond = sys.argv[1]
    
    ponderations = []
    with open(inputPond, 'r') as f:
        for line in f:
            ponderations.append(line)

    outputName = 'pasan_' + sys.argv[1]
    outputFile = open(outputName, 'w')

    results = ''
    i = 0
    for ponderation in ponderations:
        results += ponderation
        results += '\t'
        #print(ponderation) 
        res = subprocess.run(['./losquepasanregular.sh', "HOLA?"], stdout=subprocess.PIPE)
        results += res.stdout.decode('utf-8')
        results += '\n'
    

        if i%100 == 0:
            outputFile.write(results)
            results = ''

    outputFile.write(results)


main()
        

