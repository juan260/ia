import random
import itertools
import subprocess
import sys, os

def readyPlayer(script):
    perm = [4*random.randint(-50, 50) for i in range(20)]
    perm.append(random.randint(10, 500))
    args = str(perm[0]) + ' ' + str(perm[1]) + ' ' + str(perm[2]) +  ' ' + str(perm[3]) + ' ' \
    + str(perm[4]) + ' ' + str(perm[5]) + ' ' + str(perm[6]) + ' ' + str(perm[7]) + ' ' \
    + str(perm[8]) + ' ' +  str(perm[9]) + ' ' + str(perm[10]) + ' ' + str(perm[11]) + ' ' \
    + str(perm[12]) + ' ' + str(perm[13]) + ' ' + str(perm[14]) + ' ' + str(perm[15]) + ' ' \
    + str(perm[16]) + ' ' + str(perm[17]) + ' ' + str(perm[18]) + ' ' + str(perm[19]) + ' ' + str(perm[20]) + '\t\t'
    
    readyPlayerSetPerm(perm, script)       

    
    return args, perm
    
def readyPlayerSetPerm(perm, script):
    
    subprocess.run([script, str(perm[0]), str(perm[1]), str(perm[2]), str(perm[3]), str(perm[4]), \
    str(perm[5]), str(perm[6]), str(perm[7]), str(perm[8]), str(perm[9]), str(perm[10]), str(perm[11]), \
    str(perm[12]), str(perm[13]), str(perm[14]), str(perm[15]), str(perm[16]), str(perm[17]), \
    str(perm[17]), str(perm[18]), str(perm[19]), str(perm[20])], stdout=subprocess.PIPE)
    
def runGame():
    res = subprocess.run(['./StartGame.sh'], stdout=subprocess.PIPE)
    return res.stdout.decode('utf-8')
    
def main():
    
    outputName = 'salida_' + sys.argv[1]
    outputFile = open(outputName, 'w')
    outputNamebuenos = 'salida_buenos_' + sys.argv[1]
    outputFilebuenos = open(outputNamebuenos, 'w')
    
    perc = '0'
    k = 0
    i=0
    #ready player 1
    arg1=readyPlayer('./CreatePlayer1.sh')
    outputFile = open(outputName, 'w')
    outputFile.write(str(arg1)) 
    outputFile.close()
    while 1:    
        
        #ready player 2
        arg2, perm=readyPlayer('./CreatePlayer2.sh')
        perc = runGame()
        if float(perc) < -10:
            arg1=arg2
            readyPlayerSetPerm(perm, './CreatePlayer1.sh')
            outputFile = open(outputName, 'w')
            outputFile.write(str(arg1)) 
            outputFile.close()
            i=0
        if k%100 == 0:
            print(str(k) + '    ' + str(arg1))
        if (i % 40) == 0:
            outputFilebuenos.write(str(arg1))
        i+=1
        k += 1   
    
main()


