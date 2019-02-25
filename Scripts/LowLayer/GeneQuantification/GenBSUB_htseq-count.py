#!/usr/bin/python2

# Generate a bash script for each bam, print bsub for each bash script

import sys
import fileinput
import os

listbam = sys.argv[1]
gtff = sys.argv[2]

print '#!/bin/bash'
print 'module add UHTS/Analysis/samtools/1.1;'
print 'module add UHTS/Analysis/HTSeq/0.5.4p3;'

for line in fileinput.input(listbam):
	if len(line) > 1:
		line = line.replace('\n','')

		# SAMPLE
		sample = line.split('.')[0]
		bamname = line

		printed = ''
		printed += 'bsub -o '+sample+'.htseqcount.out -e '+sample+'htseqcount.err '
		printed += ' -R \"rusage[mem=2500]\" -M 2560000 '
		printed += ' \"samtools view -h '+bamname+' '
		printed += ' | htseq-count -q -s reverse -t exon -m union - '+gtff+' '
		printed += ' 2> '+sample+'htseqcount.err 1>'+sample+'.count \"'
		print printed
		
