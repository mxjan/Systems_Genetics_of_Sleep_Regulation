#!/usr/bin/python2


import fileinput
import sys
import os

path='/scratch/cluster/monthly/fburdet/BXD_Franken/fastq'

# split in 5 bsub
by = 0

namelist =[]
for f in os.listdir(path):
	if 'fastq.gz' in f:
		name = f.split('_')[0]
		if name not in namelist:
			namelist.append(f.split('_')[0])

print "#!/bin/bash\n"

for name in namelist:
	print "bsub  \"./Clean_fastq.sh "+name+"\""



