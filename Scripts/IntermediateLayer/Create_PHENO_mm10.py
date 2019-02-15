#!/usr/bin/python2

import fileinput
import sys
import math

exprf = sys.argv[1]
pedf = sys.argv[2]
output = sys.argv[3]

logtransform = False

mIDl = []
for line in fileinput.input(pedf):
	ls = line.split()
	mIDl.append(ls[0])
print mIDl
expr = {}
genel = []
l = 0
for line in fileinput.input(exprf):
	ls = line.split('\t')
	if l == 0:
		for i in range(1,len(ls)):
			ls[i] = ls[i].replace('\n','')
			##if len(ls[i]) > 3 and ls[i][3] == '0':	
			##	ls[i]=ls[i][0:3]+ls[i][4:]
			##	if ls[i] == 'BXD05':
			##		ls[i] ='BXD5'
			#if ls[i] == 'C57BL6':
			#	ls[i] = 'C57BL/6J'
			#if ls[i] == 'DBA2J':
			#	ls[i] = 'DBA/2J'
		header = ls	
		for i in header[1:]:
			expr[i] = {}
	else:
		for i,j in enumerate(header):
			if i != 0:
				if logtransform == True:
					if float(ls[i]) == 0:
						expr[header[i]][ls[0]] = 0.0
					else:
						expr[header[i]][ls[0]] = math.log(float(ls[i]))
						
				else:
					expr[header[i]][ls[0]] = float(ls[i])
		genel.append(ls[0])

	l += 1


out = open(output,'w')

towrite = []
towrite.append("fid")
towrite.append("iid")
#for i,j in enumerate(genel):
#	towrite.append(str(i))
for i in genel:
	towrite.append(str(i))
out.write(' '.join(towrite)+'\n')

for mouse in mIDl:
	if mouse in expr:
		towrite = []
		towrite.append(mouse)
		towrite.append("1")
		for gene in genel:
			towrite.append(str(expr[mouse][gene]))
		print str(expr[mouse][gene])
		out.write(' '.join(towrite)+'\n')


