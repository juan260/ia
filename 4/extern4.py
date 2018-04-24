import random
import itertools
import subprocess
import sys, os

def main():
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    
    # Primero, vamos a poner a 0 las ponderaciones de los 3 hoyos 
    # mas lejanos al mankala (se llama asi?)
    # A los otros 6 hoyos, damos aleatoriamente las ponderaciones 
    # 25i i = 1...6
    l = range(25, 176, 25)
    print(list(l))
    results = ''
    perms = itertools.permutations(l)
    #for perm, i in zip(perms, range(20)):
    for perm in perms:
        #String de llamada al script
        args = '0 0 ' + str(perm[0]) + ' ' + str(perm[1]) + ' ' + str(perm[2]) + ' ' + str(perm[3]) + ' 0 0 0 ' + str(perm[4]) + ' ' + str(perm[5]) + ' ' + str(perm[6])        
        results += args
        results += '\t'

        #Llamamos loop veces al script guardand la media de los resultados en una variable        
        loop = 10
        res = subprocess.run(['./CreateAndExecute.sh', '0', '0', str(perm[0]), str(perm[1]), str(perm[2]), str(perm[3]), '0', '0', '0', str(perm[4]), str(perm[5]), str(perm[6])], stdout=subprocess.PIPE)
        
        results += res.stdout.decode('utf-8')
        results += '\n'
    
    outputFile.write(results)
'''
    perms = list(itertools.permutations(l))
    i = 0
    longActual = len(perms)
    while longActual != 0:
        # Jugador 1: primero de la lista. Extraemos.
        perm1 = perms[0]
        perms = perms[1:]
        longActual -=1
        
        # Jugador 2: oponente aleatorio de la lista. Extraemos. 
        randOpo = random.randint(0, longActual)       
        perm2 = perms[randOpo]
        del(perms[randOpo])
        longActual -= 1

        # Construimos args del script con las ponderaciones de perm1 y perm2
        args11 = ''
        args12 = ''
        args21 = ''
        args22 = ''
        for i in range(3):
            args11 = args11 + str(perm1[i]) + ' '
            args12 = args12 + str(perm1[3 + i]) + ' '
            args21 = args21 + str(perm2[]) + ' '
            args22 = args22 + str(perm2[3 + i]) + ' '
        args11 = args11[:-1]
        args12 = args12[:-1]
        args21 = args21[:-1]  
        args22 = args22[:-1]

        args = '0 0 0 ' + args11 + '0 0 0 ' + args12 + '0 0 0 ' + args21 + '0 0 0 ' + args22      
        
        # Ejecutamos script y escribimos resultado
        res = subprocess.run(['./CreateAndExecute.sh', args], stdout=subprocess.PIPE)
        results = results + args[:24] + '\t' + args[25:] + '\t' + res.stdout.decode('utf-8') + '\n'
        
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    outputFile.write(results)


'''
main()

