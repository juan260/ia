import fileinput
import sys, os
import subprocess
import itertools
import queue

def replaceLine(line):
    command = "sed -i 788s/.*/\"" + str(line) + "\"/ TemporalPlayer.cl"
    subprocess.run([command], stdout=subprocess.PIPE, shell=True)
    res = subprocess.run(['sbcl --noinform --disable-ldb --script TemporalPlayer.cl'], \
    stdout=subprocess.PIPE, shell=True)
    
    return float(res.stdout.decode('utf-8'))
    #return res.stdout.decode('utf-8')
    #return 0
  
cola=queue.PriorityQueue(maxsize=-1)
i=0
total=0
maxsize = sys.maxsize/2
for path in sys.argv[2:]:
    infile = open(path, "r")
    for line in infile:
        splittedLine = line.split("\t")
        if len(splittedLine)==2:
            if float(splittedLine[1]) < 12:
                continue
        
        res=replaceLine(str(line)[:-1])
        cola.put(((-1.0*res), str(line)))
        if total > maxsize or i > maxsize:
            print("overflowwww")
            maxsize=0
            i=0
        total+=res
        i+=1
        if (i%100) ==0:
            print("Average for i = " + str(i) + ": " + str(res/i))
        
        
    infile.close()
        
outfile =open(sys.argv[1], "w")
i = 0
while (i<=100) and (cola.empty() == False):
    element = cola.get()
    outfile.write(str(-1*element[0]) + ' ' + element[1])
    i+=1

outfile.close()
        
        
