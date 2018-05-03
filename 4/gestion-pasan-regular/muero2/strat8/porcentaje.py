import subprocess
import sys



def main():
    
    NUMERO_BOTS = 804
    out1 = get_out('jugador.cl')
    win_rate1 = win_rate(out1,NUMERO_BOTS)
    print('EL JUGADOR TIENE WIN RATE:', win_rate1) 
   
"""
    FUNCIONES AUXILIARES
"""


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



if __name__ == "__main__":
    main()
