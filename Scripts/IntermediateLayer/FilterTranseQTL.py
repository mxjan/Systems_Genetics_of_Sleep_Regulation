#!/usr/bin/python2

import sys
import fileinput

f = sys.argv[1] # transeQTL file

# Save marker position (with chromosome and MB position)
dmark = {}
for line in fileinput.input("../../../Data/Genome/GNmm10.newgenotypes_subset_sorted.geno"):
	ls  = line.replace("\n","").split("\t")	
	if not fileinput.isfirstline():
		dmark[ls[1]] = ['chr'+ls[0],float(ls[3])]

# Save gene position
dgene = {}
for line in fileinput.input("../../../Data/Exome/GenePosition.txt"):
	ls  = line.replace("\n","").split("\t")
	if not fileinput.isfirstline():
		dgene[ls[0]] = [ls[1],float(ls[2]),float(ls[3]),float(ls[4])]

# Read transeQTL file, save in a dictionnary, with marker and p-value
dtrans = {}
for line in fileinput.input(f):
	ls  = line.replace("\n","").split("\t")
	if not fileinput.isfirstline():
		if ls[1] in dgene:
			if ls[1] not in dtrans:
				dtrans[ls[1]] = {}
			dtrans[ls[1]][ls[0]] = float(ls[-1])

# For each marker, we save the markers in the same block
# Plink file generated with the following command: 
# plink --noweb --bfile NoParentalF1Old.WGCNA2.MetaboliteFC --blocks --ld-window-kb 20000
dld = {}
for line in fileinput.input("../../../Data/IntermediateLayer/trans-eQTL/plink.blocks.det"):
	ls  = line.replace("\n","").split()
	if not fileinput.isfirstline():
		for i in ls[-1].split("|"):
			if i not in dld:
				dld[i] = {}
			for j in ls[-1].split("|"):
				if i != j:
					dld[i][j] = 1	

trans = 0

# List that will contain marker that we keep associated with the gene, with a further filtering step
selectmark2 = {}

# Work by gene
for gene in dtrans:

	# Save marker by chromosome (dict with chromosome as key and marker as value)
	tmpmark = {}
	for mark in dtrans[gene]:
		if dmark[mark][0] not in tmpmark:
			tmpmark[dmark[mark][0]] = []
		tmpmark[dmark[mark][0]].append(mark)

	# List that will contain marker that we keep associated with the gene
	selectmark = []

	# Work by chromosome
	for chro in tmpmark:

		# If there is only 1 marker per chromosome, we keep it
		if len(tmpmark[chro]) == 1:
			selectmark.append(tmpmark[chro][0])

		# Else we remove the marker in the same block and keep only the best
		else:
			# Sublist
			d = {}
			for mark in tmpmark[chro]:
				d[mark] = True

			while d != {}:
				# A list of marker that are in the same block
				mlist = []

				# Take first marker and see if other marker are in the same block
				m1=d.items()[0][0]
				del d[m1] # we remove this marker

				mlist.append(m1)

				# We remove marker from the same block
				for i in d:
					if m1 in dld and i in dld[m1]:
						mlist.append(i)
					elif i in dld and m1 in dld[i]:
						mlist.append(i)
				for i in mlist:
					if i != m1:
						del d[i]
				# We keep the marker with the best p-value
				slist = {}
				for i in mlist:
					slist[dtrans[gene][i]] = i
				selectmark.append(slist[sorted(slist)[0]])

	selectmark2[gene] = {}	
	for mark in selectmark:
		if dmark[mark][0] != dgene[gene][0]: # gene and marker on different chromosome
			selectmark2[gene][mark] = True
			trans += 1
		else:
			if abs(dmark[mark][1]- dgene[gene][1])>2: # We keep marker and gene that are at least 2 Mb distance (option used for cis eQTL window)
				selectmark2[gene][mark] = True
				trans += 1					
						
for line in fileinput.input(f):
	ls  = line.replace("\n","").split("\t")
	if not fileinput.isfirstline():
		if ls[1] in selectmark2 and ls[0] in selectmark2[ls[1]]:
			print line.replace("\n",'')
	else:	
		print line.replace("\n",'')


	
