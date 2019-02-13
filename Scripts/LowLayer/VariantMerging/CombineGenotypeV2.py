#!/usr/bin/python2

import fileinput
import sys

# Combine GeneNetwork genotyped file with filtered SNPs (vcf file) from RNA-seq Data

# Combine Genetically Different Region (Detect Genetically identical SNPs, keep best qualilty SNPs)

# Run using: ./CombineGenotype <GeneNetwork text file> <RNA-seq filtered vcf file> <Output>

MissingGenotypeThresh = 4
GroupSizeThresh = 3

 
GN = sys.argv[1] # GeneNetwork File
CALL = sys.argv[2] # RNA-seq vcf File
CombinedFile = sys.argv[3]

GNd = {}
CALLd = {}

c = 0
for line in fileinput.input(GN):
	line = line.replace("\n",'')
	ls = line.split()
	if line[0] != '@':
		if c != 0:
			GNd[ls[1]] = True
		c += 1



for line in fileinput.input(CALL):
	line = line.replace("\n",'')
	ls = line.split()
	if line[0] != '#':
		if ls[6] == 'PASS':
			CALLd[ls[2]] = float(ls[5])





def AnalyzeGroup(stack,prevGN,nextGN,CALLd):
	grouptmp = {}
	group = []
	if prevGN != 0 and nextGN != 0:

		prevGNgen = prevGN.split("\t")[4:]
		nextGNgen = nextGN.split("\t")[4:]

		for line in stack:
			gen = line.split("\t")[4:]
			grouptmp[line.split("\t")[1]] = gen
		while len(grouptmp) >= 2:
			keys = grouptmp.keys()
			g = [grouptmp[keys[0]],keys[0]]
			for marker in keys[1:]:
				if grouptmp[keys[0]] == grouptmp[marker]:
					g.append(marker)
			for marker in g[1:]:
				del grouptmp[marker]
			group.append(g)
		if len(grouptmp) == 1:
				group.append([grouptmp.keys()[0]])	
	
		markerkeep = []
		
		while group != []:
			if len(group[0]) < GroupSizeThresh:
				del group[0]
			else:
				gen = group[0][0]
				if gen != prevGNgen and gen != nextGNgen and gen.count("B") > 2 and gen.count("D") > 2:
					markerqual = {}
					for marker in group[0][1:]:
						markerqual[marker] = CALLd[marker]
					markerk = max(markerqual.iterkeys(), key=lambda k: markerqual[k])
					markerkeep.append(markerk)
					
				del group[0]
		ret = []
		for line in stack:
			marker = line.split()[1]
			if marker in markerkeep:
				ret.append(line)
		print prevGN
		for i in ret:
			print i	

	elif prevGN != 0 and nextGN != 0:
	
		nextGNgen = nextGN.split("\t")[4:]

		for line in stack:
			gen = line.split("\t")[4:]
			grouptmp[line.split("\t")[1]] = gen
		while len(grouptmp) >= 2:
			keys = grouptmp.keys()
			g = [grouptmp[keys[0]],keys[0]]
			for marker in keys[1:]:
				if grouptmp[keys[0]] == grouptmp[marker]:
					g.append(marker)
			for marker in g[1:]:
				del grouptmp[marker]
			group.append(g)
		if len(grouptmp) == 1:
				group.append([grouptmp.keys()[0]])	
	
		markerkeep = []
		
		while group != []:
			if len(group[0]) < GroupSizeThresh:
				del group[0]
			else:
				gen = group[0][0]
				if gen != nextGNgen and gen.count("B") > 2 and gen.count("D") > 2:
					markerqual = {}
					for marker in group[0][1:]:
						markerqual[marker] = CALLd[marker]
					markerk = max(markerqual.iterkeys(), key=lambda k: markerqual[k])
					markerkeep.append(markerk)
					
				del group[0]
		ret = []
		for line in stack:
			marker = line.split()[1]
			if marker in markerkeep:
				ret.append(line)
		for i in ret:
			print i			
	
	elif nextGN != 0 and prevGN != 0:
	
		prevGNgen = prevGN.split("\t")[4:]

		for line in stack:
			gen = line.split("\t")[4:]
			grouptmp[line.split("\t")[1]] = gen
		while len(grouptmp) >= 2:
			keys = grouptmp.keys()
			g = [grouptmp[keys[0]],keys[0]]
			for marker in keys[1:]:
				if grouptmp[keys[0]] == grouptmp[marker]:
					g.append(marker)
			for marker in g[1:]:
				del grouptmp[marker]
			group.append(g)
		if len(grouptmp) == 1:
				group.append([grouptmp.keys()[0]])	
	
		markerkeep = []
		
		while group != []:
			if len(group[0]) < GroupSizeThresh:
				del group[0]
			else:
				gen = group[0][0]
				if gen != prevGNgen and gen.count("B") > 2 and gen.count("D") > 2:
					markerqual = {}
					for marker in group[0][1:]:
						markerqual[marker] = CALLd[marker]
					markerk = max(markerqual.iterkeys(), key=lambda k: markerqual[k])
					markerkeep.append(markerk)
					
				del group[0]
		ret = []
		for line in stack:
			marker = line.split()[1]
			if marker in markerkeep:
				ret.append(line)
		print prevGN
		for i in ret:
			print i			
		 
		
	

c = 0
a = 0
stack = []
prevGN = 0
seqstrains = 'B6D2F1	BXD100	BXD101	BXD103	BXD29	BXD29t	BXD32	BXD43	BXD44	BXD45	BXD48	BXD49	BXD5	BXD50	BXD51	BXD55	BXD56	BXD61	BXD63	BXD64	BXD65	BXD66	BXD67	BXD70	BXD71	BXD73	BXD75	BXD79	BXD81	BXD83	BXD84	BXD85	BXD87	BXD89	BXD90	BXD95	BXD96	BXD97	BXD98	C57BL/6J	D2B6F1	DBA/2J'.split('\t')

for line in fileinput.input(CombinedFile):
	if c > 0:
		line = line.replace('\n','')

		# Remove Unsequence strains
		ls = line.split()
		for i in reversed(toremove):		
			del ls[i]
		line = '\t'.join(ls)
		
		if ls[1] in GNd:
			nextGN = line
			if stack != []:
				AnalyzeGroup(stack,prevGN,nextGN,CALLd)
			else:
				print prevGN
			stack = []
			prevGN = line
		else:
			stack.append(line)
		
		a += 1
	else:
		ls = line.split()
		headerGN = ls[4:]
		toremove = []
		for i in range (0,len(headerGN)):
			if headerGN[i] not in seqstrains:
				toremove.append(i+4)
		for i in reversed(toremove):		
			del ls[i]
		line = '\t'.join(ls)
		print line
	c +=1


AnalyzeGroup(stack,prevGN,0,CALLd)







