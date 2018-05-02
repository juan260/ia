import random
import itertools
import subprocess
import sys, os

def main():
   
    ponds = []
    params = []
    pesos = []
    i = 0
    with open(sys.argv[1], 'r') as f:
        for line in f:
#            ponds.append(line)
            if i%3 == 0:
                ponds.append(line)
            elif i%3 == 1:
                params.append(line)
            else:
                pesos.append(line) 
            i+=1

    outputName = 'test_' + sys.argv[1]
    outputFile = open(outputName, 'a')
    
    results = ''
#    for ponderation in ponds:
    for ponderation, param, peso in zip(ponds, params, pesos):
        ponderation = ponderation[:-1]
        param = param[:-1]
        peso = peso[:-1]
        results += ponderation
        results = results + '\n' + param + '\n' + peso
        results += '\t\t\t\t'
 #      res = subprocess.run(args = ['./testfinal.sh', ponderation], stdout=subprocess.PIPE)
 #       res = subprocess.run(args = ['./testfinal.sh', ponderation, param], stdout=subprocess.PIPE)
        res = subprocess.run(args = ['./testfinal.sh', ponderation, param, peso], stdout=subprocess.PIPE)
        results += res.stdout.decode('utf-8')

    outputFile.write(results)
    
main()



