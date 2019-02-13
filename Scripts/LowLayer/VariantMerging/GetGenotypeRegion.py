#!/usr/bin/python2

import fileinput
import sys

GN =  sys.argv[1]
Call = sys.argv[2]
Mix = sys.argv[3]
Chr = sys.argv[4] # was 10


StartPos = 0 # In Mb # was 101.0
EndPos = 1000.0 # In Mb # was 106.0
RangeThresh = 2 # in Mb # was 2



GNd = {}
Calld = {}
c = 0
for line in fileinput.input(GN):
	line = line.replace("\n",'')
	ls = line.split()
	if line[0] != '@':
		if c != 0:
			GNd[ls[1]] = True
		c += 1

c = 0

for line in fileinput.input(Call):
	line = line.replace("\n",'')
	ls = line.split()
	if line[0] != '#':
		if ls[6] == 'PASS':
			Calld[ls[2]] = True
	else:
		headerCall = ls


dint = {}
order = []
for line in fileinput.input(Mix):
	line  = line.replace('\n','')
	ls = line.split()
	if c > 0:
		#print float(ls[3])
		if ls[0] == Chr and float(ls[3]) >= StartPos and float(ls[3]) <= EndPos:
			dint[ls[1]] = {}
			dint[ls[1]]["Mb"] = float(ls[3])
			order.append(ls[1])
			idx = 0
			for i in header:
				dint[ls[1]][i] = ls[idx] 
				idx += 1
			if ls[1] in GNd and ls[1] not in Calld:
				dint[ls[1]]["from"] = 'G'
			else:
				dint[ls[1]]["from"] = 'V'
		
		

	else:
		header = ls
	c += 1

 #or i == 'C57BL/6J' or i == 'DBA/2J'
print 'Strain',
for j in order:
	print dint[j]["from"],
#print "Distance",
print '\n',

for i in ["C57BL/6J","DBA/2J"]:
	print i,
	for j in order:
			if i == 'C57BL/6J':
				if dint[j][i] == 'B':
					if dint[j]["from"] == 'G':
						print "\033[1;34m"+dint[j][i]+"\033[0m",
					else:
						print "\033[1;32m"+dint[j][i]+"\033[0m",
				elif dint[j][i] == 'H':
					if dint[j]["from"] == 'G':
						print "\033[1;35m"+dint[j][i]+"\033[0m",
					else:
						print "\033[2;35m"+dint[j][i]+"\033[0m",
				else:
					print "\033[1;31m"+dint[j][i]+"\033[0m",
			if i == 'DBA/2J':
				if dint[j][i] == 'D':
					if dint[j]["from"] == 'G':
						print "\033[1;34m"+dint[j][i]+"\033[0m",
					else:
						print "\033[1;32m"+dint[j][i]+"\033[0m",
				elif dint[j][i] == 'H':
					if dint[j]["from"] == 'G':
						print "\033[1;35m"+dint[j][i]+"\033[0m",
					else:
						print "\033[2;35m"+dint[j][i]+"\033[0m",
				else:
					print "\033[1;31m"+dint[j][i]+"\033[0m",
	#print dint[j]["Mb"],
	print '\n',


print '\n'		



for i in sorted(dint[dint.keys()[0]]):
	BadGN = []
	if 'BXD' in i and i in headerCall:
		idx = 0
		print i,
		for j in order:
			if dint[j]["from"] == 'G' and idx > 4 and idx < (len(order) - 4):
				actual = dint[order[idx]][i]
				same = False	
				fpost = 0
				fpre = 0
				for k in [1,2,3,4,5,6,7,8,9,10]:
					idx2 = idx-k
					idx3 = idx+k	
					if idx2 != 0  and dint[order[idx2]]["from"] == 'V' and (dint[order[idx2]][i] == 'B' or dint[order[idx2]][i] == 'D'): 
							if abs(float(dint[order[idx]]["Mb"]) - float(dint[order[idx2]]["Mb"]))<= RangeThresh:
								if actual == dint[order[idx2]][i]:
									same = True
								fpre += 1
					if idx3 < len(order) and dint[order[idx3]]["from"] == 'V' and (dint[order[idx3]][i] == 'B' or dint[order[idx3]][i] == 'D'):
							if abs(float(dint[order[idx]]["Mb"]) - float(dint[order[idx3]]["Mb"]))<= RangeThresh:
								if actual == dint[order[idx3]][i]:
									same = True
								fpost += 1
				if fpost == 0 or fpre == 0:
					same = True
				
					
			else:
				same = True
			if dint[j][i] == 'B':
				intensity = "1"
			elif dint[j][i] == 'D':
				#intensity = "1;7"
				intensity = "1"
			else:
				intensity = "1"
			if same == True:
				if dint[j]["from"] == 'G':
					if dint[j][i] != 'H':
						print "\033["+intensity+";34m"+dint[j][i]+"\033[0m",
					else:
						print "\033[1;35m"+dint[j][i]+"\033[0m",
				else:
					if dint[j][i] != 'H':
						print "\033["+intensity+";32m"+dint[j][i]+"\033[0m",
					else:	
						print "\033[2;35m"+dint[j][i]+"\033[0m",
			elif same == False:
				if actual == 'H':
					if dint[j]["from"] == 'G':
						print "\033[1;35m"+dint[j][i]+"\033[0m",
					else:
						print "\033[2;35m"+dint[j][i]+"\033[0m",
				else:
					print "\033["+intensity+";31m"+dint[j][i]+"\033[0m",
					BadGN.append(j)
								
			#print dint[j][i],
			idx += 1
		print '\n\n',
		for j in BadGN:
			outp = '\t'.join([i,Chr,j,dint[j]["Mb"],dint[j][i]])+'\n'
			sys.stderr.write(outp)
		print '\n'
	
	





