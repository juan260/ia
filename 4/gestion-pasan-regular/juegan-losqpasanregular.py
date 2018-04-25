import random
import itertools
import subprocess
import sys, os

def main():
    
    inputPond = sys.argv[1]
    
    ponderations = []
    with open(inputPond, 'r') as f:
        for line in f:
            ponerations.append(line)

    outputName = 'pasan_' + sys.argv[1]
    outputFile = open(outputName, 'w')

    for ponderation in ponderations:
        
    
