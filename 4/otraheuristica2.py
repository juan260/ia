import itertools
import subprocess
import sys, os

def main():

    # En ppio, este tiene 4^6 = 4096 ejecs
    results = ''
      
    # Puntuaciones para cuando acabas en kajala (>> 0)
    # Esta puntuacion no deberia acercarse a 10000 (lo que se suma/resta en caso de haber
    # ganado o perdido la partida)
    maxima = 1101
    step = 250
    opciones3 = range(100, maxima, step1)

    # Para cada una de las puntuaciones en caso de acabar en kajala
    # creamos otras dos listas de puntuaciones 
    # (asegurandonos de que el valor absoluto menor que maxpunct)
    for maxpunct in opciones3:
        # Puntuaciones para cuando te quedas en tu fila (en ppio >0)
        opciones2 = range(0, maxpunct+1, maxpunct/4)
        # Puntuaciones para cuando acabas en su fila (en ppio <0)
        opciones1 = [-i for i in opciones2]
        for p1 in opciones1:
            for p2 in opciones2:
                for maxpunct2 in opciones3:
                    # Puntuaciones para cuando acaba en tu fila (en ppio >0)
                    opciones4 = range(0, maxpunct2+1, maxpunct2/4)
                    # Puntuaciones para cuando no llega a tu fila (en ppio <0)
                    opciones5 = [-i for i in opciones4]
                    for p4 in opciones4:
                        for p5 in opciones5:
                            # Llamar al script con argumentos: p1 p2 maxpunct p4 p5 -maxpunct2
                            #res = subprocess...
                            #results += res
                            #results += '\n'        
    
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    outputFile.write(results)

main()

