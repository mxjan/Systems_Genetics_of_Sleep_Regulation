#!/usr/bin/python2

# Read hdf5 file from FasteQTL resutls
# Write Output file containing SNPs name associated with Genes

import h5py
import numpy
import sys

assoc = sys.argv[1]
output = sys.argv[2]

# Output
out = open(output,'w')
header = ['SNP','GeneExpr','SNPLocation','GeneLocation','beta','t','r2','p_value']
out.write('\t'.join(header)+'\n')
#

# Read hdf5 and write results
f = h5py.File(assoc,'r')

snpt = f # SNPs table

SNPIDd = f[u'preEpistasis']["SNPs"]["Names"]
GeneIDd = f[u'preEpistasis']["Phenotypes"]["Names"]
for result in f[u'Quantitative associations']:
	SNPID = SNPIDd[result[5]]
	GeneID = GeneIDd[result[6]]
	SNPL = '-'
	GeneL = '-'		
	beta = str(result[0])
	t = str(result[1])
	r2 = str(result[2])
	pval = str(result[3])
	tw = [SNPID,GeneID,SNPL,GeneL,beta,t,r2,pval]
	out.write('\t'.join(tw)+'\n')

