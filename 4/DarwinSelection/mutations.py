
import sys
path=sys.argv[1]
infile = open(path, "r")

for line in infile:
    splittedLine = line.split(" ")
    for i in range(len(splittedLine)):
        if i == 7:
            print("hola")
        elif i==8:
        print
        
    
    
infile.close()
