import itertools
import subprocess
import sys, os

def main():
    
    numrepes = 4
    # En ppio, este tiene 4^6 = 4096 ejecs
    results = ''
      
    # Puntuaciones para cuando acabas en kajala (>> 0)
    # Esta puntuacion no deberia acercarse a 10000 (lo que se suma/resta en caso de haber
    # ganado o perdido la partida)
    maxima = 1101
    step = 250
    opciones3 = range(100, maxima, step)

    # Para cada una de las puntuaciones en caso de acabar en kajala
    # creamos otras dos listas de puntuaciones 
    # (asegurandonos de que el valor absoluto menor que maxpunct)
    for maxpunct in opciones3:
        # Puntuaciones para cuando te quedas en tu fila (en ppio >0)
        opciones2 = range(0, maxpunct+1, int(maxpunct/4))
        # Puntuaciones para cuando acabas en su fila (en ppio <0)
        opciones1 = [-i for i in opciones2]
        for p1 in opciones1:
            for p2 in opciones2:
                for maxpunct2 in opciones3:
                    # Puntuaciones para cuando acaba en tu fila (en ppio >0)
                    opciones4 = range(0, maxpunct2+1, int(maxpunct2/4))
                    # Puntuaciones para cuando no llega a tu fila (en ppio <0)
                    opciones5 = [-i for i in opciones4]
                    for p4 in opciones4:
                        for p5 in opciones5:
                            args = str(p1) + '\t' + str(p2) + '\t' + str(maxpunct) + '\t' + str(p4) + '\t' + str(p5) + '\t' + str(-1*maxpunct2) + '\t\t'
                            results += args
                            # Llamar al script con argumentos: p1 p2 maxpunct p4 p5 -maxpunct2
                            res = subprocess.run(['./CreateAndExecute-2.sh', str(p1), str(p2), str(maxpunct), str(p4), str(p5), str(-1*maxpunct2), str(numrepes)], stdout=subprocess.PIPE)
                            results += res.stdout.decode('utf-8')
                            #results += '\n'        
    
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    outputFile.write(results)

main()

