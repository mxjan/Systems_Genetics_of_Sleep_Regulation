#!/usr/bin/python2

# From Maxime

#GOAL: Merge the gene counts from the different samples into one summary count file

# Working directory is where are the counts files.

import sys
import fileinput

# input: file listing count files (.count) to merge.
countl  = sys.argv[1]
# output: name of summary file
output = sys.argv[2]
out = open(output,'w')

data = {}
for line in fileinput.input(countl):
	line = line.replace('\n','')
	sample = line.replace('.count','')
	
	for liner in open(line,'r').readlines():
		liner = liner.replace('\n','')
		ls = liner.split()
		if ls[0] != '__no_feature' and ls[0] != '__ambiguous' and ls[0] != '__too_low_aQual' and ls[0] != '__not_aligned' and ls[0] != '__alignment_not_unique':
			if ls[0] not in data:
				data[ls[0]] = {}
			data[ls[0]][sample] = ls[1]

out.write('ID')
sampsort = sorted(data[data.keys()[0]])
for i in sampsort:	
	out.write('\t'+i)
out.write('\n')
for gene in sorted(data):
	out.write(gene)	
	for i in sampsort:
		out.write('\t'+data[gene][i])
	out.write('\n')
	



	
