import random
import itertools
import subprocess
import sys, os

def main():
   
    ponds = []
    params = []
    i = 0
    with open(sys.argv[1], 'r') as f:
        for line in f:
#            ponds.append(line)
            if i%2 == 0:
                ponds.append(line)
            else:
                params.append(line)
            i+=1

    outputName = 'test_' + sys.argv[1]
    outputFile = open(outputName, 'a')
    
    results = ''
#    for ponderation in ponds:
    for ponderation, param in zip(ponds, params):
        ponderation = ponderation[:-1]
        param = param[:-1]
        results += ponderation
        results = results + '\n' + param
        results += '\t\t\t\t'
 #       res = subprocess.run(args = ['./testfinal.sh', ponderation], stdout=subprocess.PIPE)
        res = subprocess.run(args = ['./testfinal.sh', ponderation, param], stdout=subprocess.PIPE)
        results += res.stdout.decode('utf-8')

    outputFile.write(results)
    
main()



