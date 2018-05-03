import random
import itertools
import subprocess
import sys, os

def main():
    
    outputName = 'strat8_Rodri_neg_alto_' + sys.argv[1]
    outputFile = open(outputName, 'a')
    outputSuperName =  'SUPER_' + outputName
    outputSuperFile = open(outputSuperName, 'a')

    perm = []
    results = ''
    k = 0
    random.seed()
    while 1:    
        perm = [str(30*random.randint(-10, 10)) for i in range(20)]
        perm.append(str(30*random.randint(0,10)))
                
        #String de llamada al script
        pond = '(defvar *ponderations* \'(('
        for i in range(6):
            pond = pond + perm[i] + ' '
        pond += ')('
        for i in range(6, 11):
            pond = pond + perm[i] + ' '
        pond = pond + perm[11] + ')))'
        param = '(defvar *parameters* \'(('
        for i in range(12,16):
            param = param + perm[i] + ' '
        param = param + ')('
        for i in range(16,19):
            param = param + perm[i] + ' '
        param = param + perm[19] + ')))'
        peso = '(defvar *peso* ' + perm[20] + ')\t\t\t\t\t\t'

        #Llamamos al script y, si pasa al regular, guardamos las ponderaciones        
        res = subprocess.run(['./pasaregular8.sh', pond, param, peso], stdout = subprocess.PIPE)
        
         
        NUMERO_BOTS = 204
        out1 = get_out('jugador.cl')
        win_rate1 = win_rate(out1,NUMERO_BOTS)
        if win_rate1 > 0.85:
            results = pond + '\t' + param + '\t' + peso + '\t' + str(win_rate1) + '\n'
            if win_rate1 > 0.9:
                outputSuperFile.write(results)
                print('\t\t Hemos conseguido uno de ' + str(win_rate1))
            
            else:
                outputFile.write(results)

        if k%1000 == 0:
            print(k)
            outputFile.flush()
            outputSuperFile.flush()
        k += 1   
    outputFile.write(results)
    outputSuperFile.write(results)
    
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




