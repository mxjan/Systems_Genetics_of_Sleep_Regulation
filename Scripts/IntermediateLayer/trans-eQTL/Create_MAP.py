#!/usr/bin/python2

import fileinput
import sys

genof = sys.argv[1]
output = sys.argv[2]

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
out = open(output,'w')


for ID in sorted(geno):
	towrite =[]
	towrite.append(geno[ID]['Chr'])
	towrite.append(geno[ID]['Locus'])
	towrite.append('0')
	towrite.append(geno[ID]['Mb'])
	out.write('\t'.join(towrite)+'\n')
