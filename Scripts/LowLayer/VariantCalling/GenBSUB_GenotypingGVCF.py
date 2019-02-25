#!/usr/bin/python2

import fileinput
import sys

gvcfl = sys.argv[1]

printed = ''
printed += 'bsub -e Genotyping.err -o Genotyping.out '
printed += ' -n 20 -R \"rusage[mem=30000]\" -M 31200000 '
printed += ' \"java -Xmx30g -jar /software/UHTS/Analysis/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar '
printed += ' -T GenotypeGVCFs -R /scratch/cluster/monthly/mjan/BXD_Franken/bam/Mus_musculus.NCBIM37.67.dna.toplevel.fa '
printed += ' -nt 20 '
for line in fileinput.input(gvcfl):
	line = line.replace('\n','')
	printed += ' --variant '+line+' '
printed += ' -o BXD.Genotype.vcf \"'

print printed
