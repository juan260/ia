import os, sys

inFile = open(sys.argv[1], 'r')
outFile = open(sys.argv[2], 'w')

for line in inFile:
    splittedLine = line.split(" ")
    s = "(defvar *ponderations* '((" + splittedLine[0] + " " + splittedLine[1] + " " + splittedLine[2] + \
    " " + splittedLine[3] + " " + splittedLine[4] + " " + splittedLine[5] + ") (" + splittedLine[6] + \
    " " + splittedLine[7] + " " + splittedLine[8] + " " + splittedLine[9] + " " + splittedLine[10] + \
    " " + splittedLine[11] + ")))\n(defvar *parameters* '((" + splittedLine[12] + " " + splittedLine[13] + \
    " " + splittedLine[14] + " " + splittedLine[15] + ") (" + splittedLine[16] + " " + splittedLine[17] + \
    " " + splittedLine[18] + " " + splittedLine[19][:-1] + ")))\n(defvar *peso* 1)\n"
    outFile.write(s)

