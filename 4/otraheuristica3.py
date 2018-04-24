import itertools
import subprocess
import sys, os

def main():
    
    numrepes = 4
    
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    
    # En ppio, este tiene 8^4 = 4096 ejecs
    results = ''
      
    # Puntuaciones para cuando acabas en kajala (>> 0)
    # Esta puntuacion no deberia acercarse a 10000 (lo que se suma/resta en caso de haber
    # ganado o perdido la partida)
    maxima = 1101
    minima = -maxima 
    num_steps = 8
    step = int((maxima - minima)/num_steps)
    opciones = range(minima, maxima+1, step)

    for p1 in opciones:
        for p2 in opciones:
            for p4 in opciones:
                for p5 in opciones:
                    args = str(p1) + '\t' + str(p2) + '\t' + str(maxima) + '\t' + str(p4) + '\t' + str(p5) + '\t' + str(minima) + '\t\t'
                    results += args
                    # Llamar al script con argumentos: p1 p2 maxpunct p4 p5 -maxpunct2
                    res = subprocess.run(['./CreateAndExecute-2.sh', str(p1), str(p2), str(maxima), str(p4), str(p5), str(minima), str(numrepes)], stdout=subprocess.PIPE)
                    results += res.stdout.decode('utf-8')

    outputFile.write(results)

main()


