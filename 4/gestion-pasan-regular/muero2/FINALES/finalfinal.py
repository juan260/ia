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

    outputName = 'FINAL_' + sys.argv[1]
    outputFile = open(outputName, 'a')
    
    results = ''
#    for ponderation in ponds:
    for ponderation, param, peso in zip(ponds, params, pesos):
        ponderation = ponderation[:-1]
        param = param[:-1]
        peso = peso[:-1]
        results += ponderation
        results = results + '\t' + param + '\t' + peso
        results += '\t'
        res = subprocess.run(args = ['./finalfinal.sh', ponderation, param, peso], stdout=subprocess.PIPE)
         
        
        NUMERO_BOTS = 2004
        out1 = get_out('jugador3.cl')
        win_rate1 = win_rate(out1,NUMERO_BOTS)
        results = results + str(win_rate1) + '\n'
    outputFile.write(results)
    
# Devuelve objeto out que contiene toda la informacion de la partida
# esa informacion se puede extraer con otras funciones
def get_out(ejecutable):
    cmd = 'sbcl --script ' + ejecutable + ' |grep -i \'marcador\''
    # Obtener output
    out_raw = subprocess.check_output(cmd,shell=True).decode('utf-8')
    # Hacer split por marcador
    out = out_raw.lower().split('marcador')
    return out


def win_rate(out, num_bots):
    wins = 0
    n = 1 + num_bots*2

    for i in range(1,n):
        # Parseamos valores de la partida
        partida = out[i].split(' ')
        num1 = int(partida[3])
        num2 = int(partida[5])
        
        if i%2 == 1:
            # Nuestro jugador corresponde a num1
            res = num1 - num2    
        else:
            #Nuestro jugador corresponde a num2
            res = num2 - num1
        
        if res > 0:
            wins = wins+1.0
    
    
    return wins/(num_bots*2)



main()




