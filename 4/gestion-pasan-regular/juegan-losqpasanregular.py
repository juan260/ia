import random
import itertools
import subprocess
import sys, os
import fileinput

def main():
    
    inputPond = sys.argv[1]
    
    ponderations = []
    with open(inputPond, 'r') as f:
        for line in f:
            ponderations.append(line)

    outputName = 'juego_' + sys.argv[1]
    outputFile = open(outputName, 'w')

    results = ''
    i = 0
    for ponderation in ponderations:
        ponderation = ponderation[:-1]
        results += ponderation
        results += '\t'
        #print(ponderation) 
        res = subprocess.run(args = ['./losquepasanregular.sh', ponderation], stdout=subprocess.PIPE)
        results += res.stdout.decode('utf-8')
    

        if i%100 == 0:
            outputFile.write(results)
            results = ''

    outputFile.write(results)


main()
        

