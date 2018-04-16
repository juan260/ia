import itertools
import subprocess
import sys, os

def main():
    
    # Primero, vamos a poner a 0 las ponderaciones de los 3 hoyos 
    # mas lejanos al mankala (se llama asi?)
    # A los otros 6 hoyos, damos aleatoriamente las ponderaciones 
    # 25i i = 1...6
    list = range(25, 151, 25)

    results = ''
    perms = itertools.permutations(list)
    for perm, i in zip(perms, range(20)):
    #for perm in perms:
        #String de llamada al script
        args = '0 0 0 ' + str(perm[0]) + ' ' + str(perm[1]) + ' ' + str(perm[2]) + ' 0 0 0 ' + str(perm[3]) + ' ' + str(perm[4]) + ' ' + str(perm[5]) 
        llamada = './CreateAndExecute.sh ' + args
        
        #Llamamos al script guardand resultado en una variable
        results += args
        results += '\t'
        res = subprocess.run(['./CreateAndExecute.sh', args], stdout=subprocess.PIPE)
        results = res.stdout.decode('utf-8')
        results += '\n'
    
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    outputFile.write(results)

#    i = 0
#    longActual = len(perms)
#    while longActual != 0:


main()
