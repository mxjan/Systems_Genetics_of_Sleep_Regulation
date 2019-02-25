#!/usr/bin/python2

# importing needed libraries
import fileinput
import sys

#GOAL Format Genotyped file (GeneNetwork Format) and phenotype in a format convenient for QTL/R analysis.

#INPUT Genotype and phenotype files. Require a phenotype file (tab-delimited) with a header and row name in 1st column (example BXD_trait.txt)

#USAGE FormatFileQTLR.py <genotyped file> <Phenotype file> <output>

# arguments
genof = sys.argv[1] # From GeneNetwork
phenof = sys.argv[2] # from ?
output = sys.argv[3]


pheno = {}
l = 0
for line in fileinput.input(phenof):
	ls = line.split()
	if l == 0:
		header_pheno = ls[1:]
	else:
		# Format Mouse_ID, change BXD089 into BXD89
		#if ls[0][3] == '0':	
		#	ls[0]=ls[0][0:3]+ls[0][4:]
		#	if ls[0] == 'BXD05':
		#		ls[0] ='BXD5'
		#if ls[0] == 'C57BL6':
		#	ls[0] = 'C57BL/6J'
		#if ls[0] == 'DBA2':
		#	ls[0] = 'DBA/2J'
		pheno[ls[0]]=[]
		#print ls[0]
		for i in ls[1:]:
			pheno[ls[0]].append(i)
	l += 1

# Read Genotype file
geno = {}
l = 0
ID = 0
passed = {} # use to remove duplicates
for line in fileinput.input(genof):
	#print line
	if line[0] != '@':
		ls = line.split()
		if l == 0:
			header_geno = ls
		else:
			if ls[1] not in passed:
				passed[ls[1]] = True
				geno[ID] = {}
				for i in range(0,len(header_geno)):
					geno[ID][header_geno[i]] = ls[i]
				ID += 1
		l += 1

# Prepare output file
out = open(output,'w')
out2=open(output+'.MBDistance.QTLR','w')
# Write Header:
LocusList=[geno[key]['Locus'] for key in sorted(geno.keys())]
out.write(','.join(header_pheno)+','+'sex,Mouse_ID,'+','.join(LocusList)+'\n')
out2.write(','.join(header_pheno)+','+'sex,Mouse_ID,'+','.join(LocusList)+'\n')
ChromoList=[geno[key]['Chr'] for key in sorted(geno.keys())]
out.write(','*(len(header_pheno)+2)+','.join(ChromoList)+'\n')
out2.write(','*(len(header_pheno)+2)+','.join(ChromoList)+'\n')
cMList=[geno[key]['cM'] for key in sorted(geno.keys())]
out.write(','*(len(header_pheno)+2)+','.join(cMList)+'\n')
cMList=[str((float(geno[key]['Mb']))) for key in sorted(geno.keys())]
#out.write(','*(len(header_pheno)+2)+','.join(cMList)+'\n')
out2.write(','*(len(header_pheno)+2)+','.join(cMList)+'\n')

# Write Data
for mouse_ID in pheno:
	to_write = []
	# Add Pheno Data
	for phenoData in pheno[mouse_ID]:
		to_write.append(phenoData)
	# Add Sex
	to_write.append('1')
	# Add ID
	to_write.append(mouse_ID)
	# Add Genotype
	if mouse_ID in geno[geno.keys()[0]]:
		for key in sorted(geno.keys()):
			if geno[key][mouse_ID] == 'B':
				to_write.append('BB')
			elif geno[key][mouse_ID] == 'D':
				to_write.append('DD')
			elif geno[key][mouse_ID] == 'H':
				to_write.append('BD')
			elif geno[key][mouse_ID] == 'E':
				to_write.append('EE')
			elif geno[key][mouse_ID] == 'F':
				to_write.append('FF')	
			elif geno[key][mouse_ID] == 'U':
				to_write.append('-')
			else:
				print geno[key][mouse_ID]	
		out.write(','.join(to_write)+'\n')
		out2.write(','.join(to_write)+'\n')
			
	else:
		print "mouse:",mouse_ID,"Not in genotype Data"
		
	

		
	
	
	

		
