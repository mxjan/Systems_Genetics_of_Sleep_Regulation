#!/usr/bin/python2

import fileinput
import sys

GN = sys.argv[1]
MarkerToRemove = sys.argv[2]
output = sys.argv[3]
out = open(output,'w')
dc = {}

for line in fileinput.input(MarkerToRemove):
	line = line.replace("\n",'')
	ls = line.split()
	if ls[2] not in dc:
		dc[ls[2]] = {}
	dc[ls[2]][ls[0]] = True

a = 0
c = 0
for line in fileinput.input(GN):
	ls = line.replace('\n','').split()
	if line[0] != '@':
		if c != 0:
			if ls[1] in dc:
				idx = 0
				for i in header:		
					if i in dc[ls[1]]:
						a += 1
						ls[idx] = 'U'
					idx += 1
				out.write('\t'.join(ls)+'\n')
				
			else:
				out.write(line)
		else:
			header = ls	
			out.write(line)		
		c += 1
		
	else:
		out.write(line)
print a

