#!/usr/bin/python2

# transform geno file into vcf for FastQTL

import sys
import fileinput

FileIN=sys.argv[1]
FileOUT=sys.argv[2]

out = open(FileOUT,'w')
out.write("##fileformat=VCFv4.1\n")
#out.write("#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	BXD005	BXD029	BXD032	BXD043	BXD044	BXD045	BXD048	BXD098	BXD049	BXD050	BXD051	BXD055	BXD056	BXD061	BXD063	BXD064	BXD065	BXD097	BXD066	BXD067	BXD070	BXD071	BXD073	BXD103	BXD075	BXD079	BXD081	BXD083	BXD084	BXD085	BXD087	BXD089	BXD090	BXD095	BXD096	BXD100	BXD101	B61	B62	DB1	DB2\n")

for line in fileinput.input(FileIN):
	if not fileinput.isfirstline():
		line = line.replace('\n','')
		ls = line.split('\t')
		tw = []
		tw.append('chr'+ls[0])
		tw.append(str(int(float(ls[3])*1000000)))
		tw.append(ls[1])
		tw.append('A')
		tw.append("T")
		tw.append("200")
		tw.append("PASS")
		tw.append("INFO")
		tw.append("GT")
		for i in ls[4:]:
			if i == 'B':
				tw.append('0/0')
			elif i == 'D':
				tw.append('1/1')
			elif i == 'H':
				tw.append('0/1')
			elif i == 'U':
				tw.append('./.')
			else:
				print i
				sys.exit()

		#B = tw[-2]
		#D = tw[-1]
		#tw[-2] = B
		#tw[-1] = B
		#tw.append(D)		
		#tw.append(D)
	
		out.write('\t'.join(tw)+'\n')

	else:
		line = line.replace('\n','')
		ls = line.split('\t')
		out.write("#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t")
		out.write("\t".join(ls[4:])+'\n')
		header = ls
	
