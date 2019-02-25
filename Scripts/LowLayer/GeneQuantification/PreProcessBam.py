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

import sys
import fileinput
import os

listbam = sys.argv[1]

# Indexing bam
def Print_Indexing(inputbam):
	printed = '\n#INDEXING\n'
	printed += 'module add UHTS/Analysis/samtools/1.1;\n'
	printed += 'samtools index '+inputbam+'\n'
	printed += '\n'
	return printed

# Add readgroup
def Print_ReadGroupAdd(inputbam,outputbam,sample):	
	printed = '\n#ADD READ GROUP\n'
	printed += 'module add UHTS/Analysis/picard-tools/1.80;\n'
	printed += 'java -Xmx16g -jar $PICARD_PATH/AddOrReplaceReadGroups.jar '
	printed += 'I='+inputbam+' O='+outputbam+' SO=coordinate RGLB=NA RGPL=Illumina RGPU=NA RGSM='+sample+'\n'
	printed += '\n'
	return printed
	
# Mark Duplicates
def Print_MarkDuplicates(inputbam,outputbam):
	printed = '\n#Mark Duplicates\n'
	printed += 'java -Xmx16g -jar $PICARD_PATH/MarkDuplicates.jar '
	printed += 'I='+inputbam+' O='+outputbam+' CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT M=output.metrics REMOVE_DUPLICATES=true \n'
	printed += '\n'
	return printed


# Split N Cigar Reads (FOR RNA-SEQ)
def Print_SNCR(inputbam,outputbam):
	printed = '\n#SplitNCigarReads (GATK, RNA-seq data)\n'
	printed += 'module add UHTS/Analysis/GenomeAnalysisTK/3.3.0;\n'
	printed += 'java -Xmx20g -jar /software/UHTS/Analysis/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar '
	printed += ' -T SplitNCigarReads -R Mus_musculus.NCBIM37.67.dna.toplevel.fa '
	printed += ' -I '+inputbam+' -o '+outputbam+' '
	printed += ' -rf ReassignOneMappingQuality -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS\n'
	printed += '\n'
	return printed

def Print_IndelRealigner_1(inputbam,intervals):
	printed = '\n#Indel Realigner\n'
	printed += 'java -Xmx20g -jar /software/UHTS/Analysis/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar '
	printed += ' -T RealignerTargetCreator -R Mus_musculus.NCBIM37.67.dna.toplevel.fa '
	printed += ' -I '+inputbam+' -o '+intervals+' '
	printed += ' -known mgp.v2.indels.annot.reformat.clean.sorted.vcf\n'
	printed += '\n'
	return printed
	
def Print_IndelRealigner_2(inputbam,intervals,outputbam):
	printed = 'java -Xmx20g -jar /software/UHTS/Analysis/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar '
	printed += ' -T IndelRealigner -R Mus_musculus.NCBIM37.67.dna.toplevel.fa '
	printed += ' -I '+inputbam+' -o '+outputbam+' '
	printed += ' -targetIntervals '+intervals+' '
	printed += ' -known mgp.v2.indels.annot.reformat.clean.sorted.vcf\n'
	printed += '\n'
	return printed	
	
def Print_BaseRecalibrator_1(inputbam,outputtable):	
	printed = '\n#Base Recalibrator\n'
	printed += 'java -Xmx20g -jar /software/UHTS/Analysis/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar '
	printed += ' -T BaseRecalibrator -R Mus_musculus.NCBIM37.67.dna.toplevel.fa '
	printed += ' -I '+inputbam+' -o '+outputtable+' '
	printed += ' -knownSites SNP_and_INDELS.sorted.chr.clean.vcf\n'
	printed += '\n'
	return printed

def Print_BaseRecalibrator_2(inputbam,inputtable,outputtable):	
	printed = 'java -Xmx20g -jar /software/UHTS/Analysis/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar '
	printed += ' -T BaseRecalibrator -R Mus_musculus.NCBIM37.67.dna.toplevel.fa '
	printed += ' -I '+inputbam+' -o '+outputtable+' '
	printed += ' -knownSites SNP_and_INDELS.sorted.chr.clean.vcf '
	printed += ' -BQSR '+inputtable+' \n'
	printed += '\n'
	return printed

def Print_BaseRecalibrator_3(inputbam,inputtable,outputbam):	
	printed = 'java -Xmx20g -jar /software/UHTS/Analysis/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar '
	printed += ' -T PrintReads -R Mus_musculus.NCBIM37.67.dna.toplevel.fa '
	printed += ' -I '+inputbam+' -o '+outputbam+' '
	printed += ' -BQSR '+inputtable+' \n'
	printed += '\n'
	return printed

for line in fileinput.input(listbam):
	if len(line) > 1:
		line = line.replace('\n','')

		# SAMPLE
		sample = line.split('_')[1]
		
		bamname = line
		basename = line.replace('.bam','')
		bashscript = basename+'.sh'
		out = open(bashscript,'w')
		out.write('#!/bin/bash\n')
		
		# 1. Index bam file
		out.write(Print_Indexing(bamname))

		# 2. Add read group
		out.write(Print_ReadGroupAdd(bamname,basename+'addrg.bam',sample))

		# 3. Remove Duplicates
		out.write(Print_MarkDuplicates(basename+'addrg.bam',basename+'addrg.dedupped.bam'))
		
		# 4. SplitNCigarReads
		out.write(Print_SNCR(basename+'addrg.dedupped.bam',basename+'addrg.dedupped.split.bam'))
	
		# 5. Indel Realigner
		#out.write(Print_IndelRealigner_1(basename+'addrg.dedupped.split.bam',basename+'.target_intervals.list'))
		#out.write(Print_IndelRealigner_2(basename+'addrg.dedupped.split.bam',basename+'.target_intervals.list',basename+'addrg.dedupped.split.realign.bam'))

		# 6. Base Recalibrator
		#out.write(Print_BaseRecalibrator_1(basename+'addrg.dedupped.split.realign.bam',basename+'.recal_data.table'))
		#out.write(Print_BaseRecalibrator_2(basename+'addrg.dedupped.split.realign.bam',basename+'.recal_data.table',basename+'.post_recal_data.table'))
		#out.write(Print_BaseRecalibrator_3(basename+'addrg.dedupped.split.realign.bam',basename+'.post_recal_data.table',basename+'addrg.dedupped.split.realign.recal.bam'))
	
		# END - Print Bsub
		print 'bsub -q normal -e '+sample+'.PreProcessing.out -o '+sample+'.PreProcessing.err -R "rusage[mem=22000]" -M 22480000 \"bash '+bashscript+'\"'
		
		






 
