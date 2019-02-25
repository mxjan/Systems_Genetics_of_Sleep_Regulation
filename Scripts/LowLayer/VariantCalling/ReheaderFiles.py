#!/usr/bin/python2

# require a bam file of list without path (only bam name), execute script generated in same directory as bam file
# example list:

"""
2pass_L05nsd_Aligned.sortedByCoord.out.bam
2pass_L05sd_Aligned.sortedByCoord.out.bam
2pass_L100nsd_Aligned.sortedByCoord.out.bam
2pass_L100sd_Aligned.sortedByCoord.out.bam
2pass_L101nsd_Aligned.sortedByCoord.out.bam
2pass_L101sd_Aligned.sortedByCoord.out.bam
2pass_L103nsd_Aligned.sortedByCoord.out.bam
2pass_L103sd_Aligned.sortedByCoord.out.bam
2pass_L29nsd_Aligned.sortedByCoord.out.bam
2pass_L29sd_Aligned.sortedByCoord.out.bam
2pass_L29tnsd_Aligned.sortedByCoord.out.bam
2pass_L29tsd_Aligned.sortedByCoord.out.bam
2pass_L32nsd_Aligned.sortedByCoord.out.bam
2pass_L32sd_Aligned.sortedByCoord.out.bam
"""

# Generate a bash script for each bam, print bsub for each bash script
# CHANGE FASTA AND HEADER PATH 
# CHANGE SAMPLE DETECTION IN SampleName()

import sys
import fileinput
import os

listbam = sys.argv[1]
fasta = '/scratch/cluster/monthly/mjan/BXD_Franken/bam/Mus_musculus.NCBIM37.67.dna.toplevel.fa'
header = 'FrankenLiverHeader'

def SampleName(inputbam):

	# Thorens
	#sample = 'BXD'+inputbam.split('.')[0].replace('BXD00','').replace('BXD0','').replace('BXD','')
	
	# Franken Brain
	#sample = 'BXD'+inputbam.split('.')[0].replace('nsd','').replace('sd','')

	# Franken Liver
	sample = 'BXD'+inputbam.split('_')[1].replace('nsd','').replace('sd','').replace('L','')

	# Hypo
	#sample = 'BXD'+inputbam.split('.')[0].replace('BXD00','').replace('BXD0','').replace('BXD','')

	if 'B6D2F1' in sample or 'C57BL6' in sample or 'D2B6F1' in sample or 'DBA2J' in sample:		
		sample = sample.replace('BXD','')

	if sample == 'BXD05':
		sample = 'BXD5'
	if sample == 'BXDB61' or sample == 'BXDB62':
		sample = 'C57BL6'
	if sample == 'BXDBD':
		sample = 'B6D2F1'
	if sample == 'BXDDB1' or sample == 'BXDDB2':
		sample = 'DBA2J'
	if sample == 'BXDDB':
		sample = 'D2B6F1'
	

	return sample

def Print_Indexing(inputbam):
	printed = '\n#INDEXING\n'
	printed += 'samtools index '+inputbam+'\n'
	printed += '\n'
	return printed

def Print_Reheader(inputbam,header,outputbam):
	# Change Sample in header
	sample = SampleName(inputbam)
	out = open(header+'.'+sample,'w')
	for line in open(header,'r').readlines():
		if 'SM:' in line:
			line = line.replace('\n','')	
			ls = line.split('\t')
			for i in range(0,len(ls)):
				if 'SM:' in ls[i]:
					ls[i] = 'SM:'+sample
			out.write('\t'.join(ls)+'\n')
					
		else:
			out.write(line)
	printed = '\n#ReHeader\n'	
	printed += 'module add UHTS/Analysis/samtools/1.1;\n'
	printed += 'samtools reheader '+header+'.'+sample+' '+inputbam+' > '+outputbam+' \n'
	return printed 

def Print_Reorder(inputbam,fasta,outputbam):
	printed = '\n#ReOrdering\n'
	printed += 'module add UHTS/Analysis/picard-tools/1.80;\n'
	printed += 'java -Xmx1g -jar $PICARD_PATH/ReorderSam.jar '
	printed += 'I='+inputbam+' O='+outputbam+' R='+fasta+' '
	printed += '\n'
	return printed



for line in fileinput.input(listbam):
	if len(line) > 1:
		line = line.replace('\n','')

		# SAMPLE
		sample = line.split('.')[0].replace("Aligned",'')
		
		bamname = line
		basename = line.replace('.bam','')
		bashscript = basename+'.sh'
		out = open(bashscript,'w')
		out.write('#!/bin/bash\n')

		# 1. Indexing
		#out.write(Print_Indexing(bamname))

		# 2. Reheader
		out.write(Print_Reheader(bamname,header,basename+'.reheader.bam'))

		# 3. Indexing
		out.write(Print_Indexing(basename+'.reheader.bam'))
	
		# 4. Reorder
		#out.write(Print_Reorder(basename+'.reheader.bam',fasta,sample+'.BXD_Hypo.reheader.reorder.bam'))

		# 5. Indexing
		#out.write(Print_Indexing(sample+'.BXD_Hypo.reheader.reorder.bam'))

		print 'bsub -e '+sample+'.Reheader.out -o '+sample+'.Reheader.err \"bash '+bashscript+'\"'


		

