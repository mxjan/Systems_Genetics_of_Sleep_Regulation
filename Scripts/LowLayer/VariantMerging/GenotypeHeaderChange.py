#!/usr/bin/python2

import fileinput
import sys

GN1 = sys.argv[1]
GNout = sys.argv[2]

out = open(GNout,'w')

for line in fileinput.input(GN1):
	if fileinput.isfirstline():
		ls = line.replace("\n",'').split("\t")
		for i in range(0,len(ls)):
			if 'BXD' in ls[i]:
				Numb = int(ls[i].replace("BXD",''))
				if Numb < 10:
					ls[i] = "BXD00"+str(Numb)
				elif Numb < 100:
					ls[i] = "BXD0"+str(Numb)
			elif 'C57BL/6J' in ls[i]:
				ls[i] = "B61"
			elif 'DBA/2J' in ls[i]:
				ls[i] = "DB1"
		out.write("\t".join(ls)+"\n")
	else:
		out.write(line)
				