#!/usr/bin/python2
import fileinput
import sys


# Filter Variant (.vcf file) by quality and percentage genotyped 

# Run using ./FilterRNAseqVariant.py <vcf file> <output>

####### SET OPTIONS ################

thresh = 90 # Percentage genotyped required (100 = 100 %)
threshq = 5000 # Threshold for quality SNPs

####################################

CA = sys.argv[1]
out = open(sys.argv[2],'w')


for line in fileinput.input(CA):
	ls = line.split()
	if line[0] != '#':
		if ls[6] == 'PASS': # Get only PASS variant
			ls[0] = ls[0].replace('chr','') # Replace chr1 by 1
			
			# Count genotype
			genotyped = 0.0
			for geno in ls[9:]:
				geno = geno.split(':')[0]
				if geno != './.':
					genotyped += 1.0
			if (genotyped/len(ls[9:]))*100 >= thresh:

				# Filter threshold
				if float(ls[5]) >= threshq:
					#print ls[5]
					out.write(line)

	else:
		out.write(line)
