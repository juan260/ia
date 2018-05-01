import random
import itertools
import subprocess
import sys, os

def add(l, count, line):
    if line in list(el[1] for el in l):
        return
    
    for i in range(20):
        if l[i][0] < count:
            l[i] = (count, line)
            print(l)
            return


def main():
    
    outputName = 'salida_' + sys.argv[2]
    outputFile = open(outputName, 'w')
    l = list((0, 0) for i in range(20))
    infile = open(sys.argv[1], 'r')
    lines = infile.readlines()
    infile.close()
    for line1 in lines:
        count = 0
        print(line1)
        for line2 in lines:
            if line1 == line2:
                count += 1

        add(l, count, line1)    
                
    print("RESULTS: ")
    for el in l:
        outputFile.write(str(el[1]))
        print(el)
    outputFile.close()
main()


