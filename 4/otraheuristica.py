import itertools
import subprocess
import sys, os

def main():

    numrepes = 7
    # En ppio esta tiene 13*10*10 repe
    results = ''
      
    # Puntuaciones para cuando acabas en kajala (>> 0)
    # -1 * Puntuaciones para cuando acaba en kajala
    # Esta puntuacion no deberia acercarse a 10000 (lo que se suma/resta en caso de haber
    # ganado o perdido la partida)
    maxima = 2001
    step = 150
    opciones3 = range(100, maxima, step)
    # Para cada una de las puntuaciones en caso de acabar en kajala
    # creamos otras dos listas de puntuaciones 
    # (asegurandonos de que el valor absoluto menor que maxpunct)
    for maxpunct in opciones3:
        # Puntuaciones para cuando te quedas en tu fila (en ppio >0)
        # -1 * Puntuaciones para cuando se queda en su fila
        opciones2 = range(0, maxpunct+1, int(maxpunct/10))
        # Puntuaciones para cuando acabas en su fila (en ppio <0)
        # -1 * Puntuaciones para cuando acaba en tu fila
        opciones1 = [-i for i in opciones2]
        for p1 in opciones1:
            for p2 in opciones2:
                args = str(p1) + ' ' + str(p2) + ' ' + str(maxpunct) + ' ' + str(int(maxpunct)) + ' ' + str(-1*p1) + ' ' + str(-1*p2) + ' ' + str(-1*maxpunct) + ' ' + str(int((-1*maxpunct))) +'\t\t'
                results += args
                # Llamar al script con argumentos: p1 p2 maxpunct -p1 -p2 -maxpunct
                res = subprocess.run(['./CreateAndExecute-2.sh', str(p1), str(p2), str(maxpunct), str(int(maxpunct)), str(-1*p1), str(-1*p2), str(-1*maxpunct), str(int((-1*maxpunct))), str(numrepes)], stdout=subprocess.PIPE)
                results += res.stdout.decode('utf-8')
                #print(res.stdout.decode('utf-8'))
                #results += '\n'        
    
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    outputFile.write(results)

main()
