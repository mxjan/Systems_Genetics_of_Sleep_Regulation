#!/usr/bin/python2

import fileinput
import sys

phenof = sys.argv[1]
genof = sys.argv[2]
output = sys.argv[3]

pheno = {}
l = 0
for line in fileinput.input(phenof):
	ls = line.split()
	if l == 0:
		header_pheno = ls[1:]
	else:
		# Format Mouse_ID, change BXD089 into BXD89
		##if ls[0][3] == '0':	
		##	ls[0]=ls[0][0:3]+ls[0][4:]
		##	if ls[0] == 'BXD05':
		##		ls[0] ='BXD5'
		##if ls[0] == 'C57BL6':
		##	ls[0] = 'C57BL/6J'
		##if ls[0] == 'DBA2J':
		##	ls[0] = 'DBA/2J'
		pheno[ls[0]]=[]
		for i in ls[1:]:
			pheno[ls[0]].append(i)
	l += 1

# Read Genotype file
geno = {}
l = 0
ID = 0
for line in fileinput.input(genof):
	if line[0] != '@':
		ls = line.split()
		if l == 0:
			header_geno = ls
		else:
			geno[ID] = {}
			for i in range(0,len(header_geno)):
				geno[ID][header_geno[i]] = ls[i]
			ID += 1
		l += 1

fam = ""
ID = '1'
IDfather = '0'
IDmother = '0'
SexCode = '1'



out = open(output,'w')
for mouse in sorted(pheno):
	if mouse in geno[geno.keys()[0]]:
		out.write(mouse+'\t'+ID+'\t'+IDfather+'\t'+IDmother+'\t'+SexCode+'\t1\t')
		towrite = []
		for IDgen in sorted(geno):
			if geno[IDgen][mouse] == 'B':
				towrite.append('1\t1')
			elif geno[IDgen][mouse] == 'D':
				towrite.append('2\t2')
			elif geno[IDgen][mouse] == 'U':
				towrite.append('0\t0')
			elif geno[IDgen][mouse] == 'E':
				towrite.append('0\t0')
			elif geno[IDgen][mouse] == 'F':
				towrite.append('0\t0')
			elif geno[IDgen][mouse] == 'H':
				towrite.append('1\t2')
			else:
				print "error", geno[IDgen][mouse]	
				sys.exit() 					
			
		out.write('\t'.join(towrite)+'\n')

	else:
		print mouse,geno.keys(),pheno	

	









