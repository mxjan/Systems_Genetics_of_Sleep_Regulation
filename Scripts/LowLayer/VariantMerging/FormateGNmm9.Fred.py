#!/usr/bin/python2

# Format XLS Genotype GeneNetwork into same format found in GeneNetwork (require for other script to work)

# Require XLS transformed in tab-delimited txt file

# Run using ./FormatGNmm9.Fred.py <tab-del.txt> <output>

import sys
import fileinput

inputf = sys.argv[1]
out = open(sys.argv[2],'w')
fg = {}

h ="""@name:BXD
@type:riset
@mat:B
@pat:D
@het:H
@unk:U
"""
out.write(h)

c = 0
for line in fileinput.input(inputf):
	ls = line.split('\t')
	if line[0] != '@':
		if c != 0 and len(ls) > 2:
			if ls[4] != '':
				tw =[]
				tw.append(ls[1])
				tw.append(ls[3])
				tw.append(ls[4])
				tw.append(ls[5])
				for i in ls[9:]:
					if i == '-1':
						tw.append('B')
					elif i == '1':
						tw.append('D')
					elif i == '0':
						tw.append('H')
					else:
						tw.append('U')
				tw.append("B")
				tw.append("D")
				out.write('\t'.join(tw)+'\n')
			
		else:
			if len(ls) > 2:
				ls[-1] = ls[-1].replace('\n','')
				out.write('Chr	Locus	cM	Mb	'+'\t'.join(ls[9:])+'\tC57BL/6J\tDBA/2J'+'\n')
		c += 1
