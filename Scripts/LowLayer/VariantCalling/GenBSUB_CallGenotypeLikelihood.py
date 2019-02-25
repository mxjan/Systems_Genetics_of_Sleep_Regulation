#!/usr/bin/python2

# Require Multiple list of bam file with PATH associated

import sys
import fileinput

fasta = '/scratch/cluster/monthly/mjan/BXD_Franken/bam/Mus_musculus.NCBIM37.67.dna.toplevel.fa'

Franken_Brain_bamlist = 'bamlistBrain.txt'

Franken_Liver_bamlist = 'bamlistLiver.txt'

Hypo_bamlist = 'bamlistHypo.txt'

Thorens_bamlist = 'bamlistThorens.txt'

# Get All Files
Files = {}
for line in fileinput.input(Franken_Brain_bamlist):
	line = line.replace('\n','')
	if line != '':
		ls = line.split('/')
		sample = 'BXD'+ls[-1].split('.')[0].replace('nsd','').replace('sd','')
		if sample == 'BXDB61' or sample == 'BXDB62':
			sample = 'C57BL6'
		if sample == 'BXDBD':
			sample = 'B6D2F1'
		if sample == 'BXDDB1' or sample == 'BXDDB2':
			sample = 'DBA2J'
		if sample == 'BXDDB':
			sample = 'D2B6F1' 		
		if sample not in Files:
			Files[sample] = []
		Files[sample].append(line)
		
	
for line in fileinput.input(Franken_Liver_bamlist):
	line = line.replace('\n','')
	if line != '':
		ls = line.split('/')
		sample = 'BXD'+ls[-1].split('_')[1].replace('nsd','').replace('sd','').replace('L','')
		if sample == 'BXDB61' or sample == 'BXDB62':
			sample = 'C57BL6'
		if sample == 'BXDBD':
			sample = 'B6D2F1'
		if sample == 'BXDDB1' or sample == 'BXDDB2':
			sample = 'DBA2J'
		if sample == 'BXDDB':
			sample = 'D2B6F1' 
		if sample not in Files:
			Files[sample] = []
		Files[sample].append(line)

for line in fileinput.input(Hypo_bamlist):
	line = line.replace('\n','')
	if line != '':
		ls = line.split('/')
		sample = ls[-1].split('.')[0].replace('BXD00','').replace('BXD0','').replace('BXD','')
		if sample != 'C57BL6' and sample != 'B6D2F1' and sample != 'DBA2J' and sample != 'D2B6F1':
			sample = 'BXD'+sample	
		if sample not in Files:
			Files[sample] = []
		Files[sample].append(line)

for line in fileinput.input(Thorens_bamlist):
	line = line.replace('\n','')
	if line != '':
		ls = line.split('/')
		sample = ls[-1].split('.')[0].replace('BXD00','').replace('BXD0','').replace('BXD','')
		if sample != 'C57BL6' and sample != 'B6D2F1' and sample != 'DBA2J' and sample != 'D2B6F1':
			sample = 'BXD'+sample	
		if sample not in Files:
			Files[sample] = []
		Files[sample].append(line)

print '#!/bin/bash'
print 'module add UHTS/Analysis/GenomeAnalysisTK/3.3.0;'

for sample in Files:
	printed = ''
	printed += 'bsub -n 3 -q long -o '+sample+'.GenotypeLikelihood.out -e '+sample+'.GenotypeLikelihood.err -R "rusage[mem=30000]" -M 32200000 '
	printed += ' \" java -Xmx30g -jar /software/UHTS/Analysis/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar '
	printed += ' -T HaplotypeCaller -R '+fasta+' '
	for bamf in Files[sample]:
		printed += ' -I '+bamf+' '
	printed += ' --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -dontUseSoftClippedBases '
	printed += '-nct 3 -o '+sample+'.PFBrain-PFLiver-Hypo-BTBrain.gvcf '
	printed += '\"'

	print printed
	 	

	






