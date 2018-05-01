import random
import itertools
import subprocess
import sys, os


def main():
    outputName = 'salida5_' + sys.argv[1]
    outputFile = open(outputName, 'w')
#    outputNamebuenos = 'salida5_buenos_'
#    outputFilebuenos = open(outputNamebuenos, 'w')

    njug = 2**13
    njug_mequedo = 16
    ntimes = 20
    random.seed()
    #Genero njug jugadores (lista de strings)
    jugadores = [readyPlayer() for i in range(njug)]

    # while len(lista) != 16
    #Pongo a jugar a cada jugador i con i+1, 30 veces. Retiro al malo.    
    len_jugadores = len(jugadores)    
    while len_jugadores > njug_mequedo:
        print('Vamos por ', str(len_jugadores))
        jugadores = torneo(jugadores, len_jugadores)
        len_jugadores = len(jugadores)
    
    # Clasifico segun porcentaje contra el aleatorio a los que me quedan
    results = ''
    for i in range(len_jugadores):
        results += contra_aleat(jugadores[i])

    # Escribimos y ordenamos resultado
    outputFile.write(results)
    #command = 'LC_ALL=C sort -n -k 13 ' + outputName + ' -o ' + outputName
    #os.system(command)


def contra_aleat(jugador):
    
    args = ''
    for i in range(12):
        args = args + jugador[i] + ' '
    args += '\t\t'

    res = subprocess.run(['./ContraAleat.sh', jugador[0], jugador[1], jugador[2], jugador[3], jugador[4],jugador[5], jugador[6],jugador[7], jugador[8],jugador[9], jugador[10], jugador[11], jugador[12], jugador[13], jugador[14],jugador[15], jugador[16],jugador[17], jugador[18],jugador[19] ], stdout = subprocess.PIPE)
    args += res.stdout.decode('utf-8') 
    return args

def torneo(jugadores, len_jugadores):
    malos = []
    cortes = [2*i for i in range(int(len_jugadores/2))]
    for corte in cortes:
        args1 = jugadores[corte]
        args2 = jugadores[corte + 1]
        
        # Juega jugador1 contra jugador2
        res = subprocess.run(['./CreatePlayers.sh', args1[0], args1[1], args1[2], args1[3], args1[4], args1[5], args1[6], args1[7], args1[8], args1[9], args1[10],  args1[11], args1[12], args1[13], args1[14], args1[15], args1[16], args1[17], args1[18], args1[19], args2[0], args2[1], args2[2], args2[3], args2[4], args2[5], args2[6], args2[7], args2[8], args2[9], args2[10],  args2[11], args2[12], args2[13], args2[14], args2[15], args2[16], args2[17], args2[18], args2[19] ] , stdout = subprocess.PIPE)

        perc = float(res.stdout.decode('utf-8'))        
        # Si perc > 0.5, jugador 1 (args1) ha ganado mas veces: retiramos a jugador 2
        if perc > 0.5:
            malos.append(args2)
        else:
            malos.append(args1)
    for malo in malos: 
        jugadores.remove(malo)          
        
    return jugadores

            
def readyPlayer():
    nparams = 20
    perm = [str(10*random.randint(1,10)) for i in range(nparams)]
    return perm
    
main()


