#!/usr/bin/python3

import fileinput
import sys

FileIN=sys.argv[1]
FileGeno = sys.argv[2]
FileOUT=sys.argv[3]

orderchr = [] # order of chromosome
order = []
data = {} # contain gene position


for line in fileinput.input("../../Data/Exome/GenePosition.txt"):
	if  not fileinput.isfirstline():
		ls = line.replace("\n",'').split("\t")
	
		data[ls[0]] = {"End":ls[4],"Start":ls[3],"Chromosome":ls[1]}



# Get order samples and chromsomes
for line in fileinput.input(FileGeno):
	ls = line.replace("\n",'').split("\t")
	if fileinput.isfirstline():
		dataSet  = ls[4:]
	else:
		if 'chr'+ls[0] not in orderchr:
			orderchr.append('chr'+ls[0])
			
print(orderchr)
print(dataSet)

dataexpr = {}
for line in fileinput.input(FileIN):
	ls = line.replace("\n",'').split("\t")
	if fileinput.isfirstline():
		header = ls
		
	else:
	
		d = {}
		for i in range(0,len(header)):
			d[header[i]] = ls[i+1]
		dataexpr[ls[0]] = d
		
print(dataexpr["Acot11"])

# Some Controls
def ItemsInList(l1,l2,namesL2):
	for i in l1:
		if i not in l2:
			print('item: '+i+' is not in '+namesL2)
	
ItemsInList(header,dataSet,"samples genotypes")
ItemsInList(dataSet,header,"samples gene expression")
ItemsInList(dataexpr.keys(),data.keys(),"gene position")

# Order gene
geneOrder = []
for i in orderchr:
	
	geneP = {}
	for gene in data:
		if data[gene]["Chromosome"] == i:
			geneP[gene] = float(data[gene]["Start"])
	genesorted = sorted(geneP.items(), key=lambda x: x[1])
	for j in genesorted:
		geneOrder.append(j[0])
		

out = open(FileOUT,'w')
out.write("#Chr\tstart\tend\tID\t")
out.write("\t".join(dataSet)+'\n')

orderSamples = []
for i in dataSet:
	if i in header:
		orderSamples.append(i)


for j in geneOrder:
	if j in data and j in dataexpr:
		out.write(data[j]["Chromosome"]+'\t'+str(float(data[j]["Start"])*1000000)+"\t"+str(float(data[j]["End"])*1000000)+"\t"+j)
		for k in orderSamples:
			out.write("\t"+dataexpr[j][k])
		out.write("\n")
				