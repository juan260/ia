import random
import itertools
import subprocess
import sys, os, random
import numpy as np

# Recibe una lista (l) de tuplas y añade la tupla (count, line) manteniendola ordenada 
# descendentemente con respecto al primer elemento y sin dejar que supere el tamaño 30
def add(l, count, line):
    if line in list(el[1] for el in l):
        return
    print("ADDING: " + line)
    for i in range(30):
        if l[i][0] < count:
            l[i] = (count, line)
            print(l)
            return
            
# Recibe una lista de 21 argumentos para pasarselos al script y generar el jugador. El script que recibe es
# CreatePlayer1.sh o CreatePlayer2.sh
def readyPlayerSetPerm(perm, script):
    
    subprocess.run([script, str(perm[0]), str(perm[1]), str(perm[2]), str(perm[3]), str(perm[4]), \
    str(perm[5]), str(perm[6]), str(perm[7]), str(perm[8]), str(perm[9]), str(perm[10]), str(perm[11]), \
    str(perm[12]), str(perm[13]), str(perm[14]), str(perm[15]), str(perm[16]), str(perm[17]), \
    str(perm[17]), str(perm[18]), str(perm[19]), str(perm[20])], stdout=subprocess.PIPE)
  
# Ejecuta la partida  
def runGame():
    res = subprocess.run(['./StartGame.sh'], stdout=subprocess.PIPE)
    return res.stdout.decode('utf-8')

# Recibe los argumentos para crear al jugador y le introduce un factor aleatorio
def randomizeLine(line):
    splitted = line.split(" ")
    ret = list()
    for el in splitted:
        ret.append(str(random.randint(-3, 3) + int(el)))
    return ' '.join(ret)  
    
def main():
    
    outputName = 'salida_' + sys.argv[2]
    outputFile = open(outputName, 'w')
    l = list((0, 0) for i in range(30))
    infile = open(sys.argv[1], 'r')
    lines = infile.readlines()
    infile.close()
    posibilidades = list()
    results = list()
    # 
    
    for line1 in lines:
        for i in range(1, 500, 5):
            posibilidades.append(randomizeLine(line1) + ' ' + str(i))
    
    while True:
        
        for p1 in posibilidades:
            readyPlayerSetPerm(p1.split(" "), './CreatePlayer1.sh')
            res = 0.0
            for p2 in posibilidades:
                readyPlayerSetPerm(p2.split(" "), './CreatePlayer2.sh')
                res += float(runGame()) 
            print(res)
            add(l, res, p1)
        
    
        print("RESULTS: ")
        for el in l:
            outputFile.write(str(el[1]) + '\t\t' + el[0] + '\n')
            print(el)
        
        posibilidades = list()
        for el in l:
            for i in np.arange(-1, 1, 0.1):
                posibilidades.append(randomizeLine(' '.join(el[1])) + ' ' + str(i))
    
main()


