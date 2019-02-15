#!/usr/bin/python2

# create bed file (UCSC format) for fastQTL
import sys
import fileinput

FileIN=sys.argv[1]
FileGeno=sys.argv[2]
FileOUT=sys.argv[3]

orderchr = []
order = []
data = {}
for line in fileinput.input("/home/mjan/PhD/Rdata/RefSeq_20140129.gtf"):

	line = line.replace("\n","")
	ls = line.split()
	Chr = ls[0]
	if Chr not in orderchr:
		orderchr.append(Chr)
	Start = int(ls[3])
	End = int(ls[4])
	Gene = ls[9].replace("\"",'').replace(";",'')
	if ls[2] == 'exon':
		if Gene not in data:
			data[Gene] = {"Start":10000000000,"End":0,"Chr":Chr}
			order.append(Gene)
		elif data[Gene]["Chr"] != Chr:	
			data[Gene] = {"Start":10000000000,"End":0,"Chr":Chr}
			order.remove(Gene)
			order.append(Gene)	
		if Start < data[Gene]["Start"]:
			data[Gene]["Start"] = Start
		if End > data[Gene]["End"]:
			data[Gene]["End"] = End

##Chr	start	end	ID	
out = open(FileOUT,'w')
#out.write("#Chr	start	end	ID	BXD043	BXD044	BXD045	BXD048	BXD098	BXD049	BXD050	BXD051	BXD055	BXD056	BXD061	BXD064	BXD065	BXD097	BXD066	BXD067	BXD070	BXD071	BXD073	BXD103	BXD075	BXD079	BXD081	BXD083	BXD084	BXD085	BXD087	BXD089	BXD090	BXD095	BXD096	BXD100	BXD101\n")
#dataSet = "BXD043	BXD044	BXD045	BXD048	BXD098	BXD049	BXD050	BXD051	BXD055	BXD056	BXD061	BXD064	BXD065	BXD097	BXD066	BXD067	BXD070	BXD071	BXD073	BXD103	BXD075	BXD079	BXD081	BXD083	BXD084	BXD085	BXD087	BXD089	BXD090	BXD095	BXD096	BXD100	BXD101".split("\t")

# Keep same order as genotype file
for line in fileinput.input(FileGeno):
	if fileinput.isfirstline():
		line = line.replace('\n','')
		ls = line.split('\t')
		dataSet = ls[4:]
	else:
		break
fileinput.close()

out.write("#Chr\tstart\tend\tID\t")
out.write("\t".join(dataSet)+'\n')
	
dataexpr = {}
c = 0
for line in fileinput.input(FileIN):
	if c== 0:
		header = line.replace('\n','').split('\t')
	else:
		ls = line.replace('\n','').split('\t')
		d = {}
		#print line
		#print ls,len(ls)
		#print header,len(header)
		for i in range(0,len(header)):
			d[header[i]] = ls[i+1]	
		#out.write(data[ls[0]]["Chr"]+'\t'+str(data[ls[0]]["Start"])+'\t'+str(data[ls[0]]["End"])+'\t'+ls[0])
		#for i in dataSet:
		#	out.write('\t'+d[i])
		
		#out.write("\n")
		#print ls
		#print ls[0]
		#sys.exit()
		dataexpr[ls[0]] = d
	
	c += 1	

datachr = {}
for i in orderchr:
	datachr[i]={}
	for j in order:
		if data[j]["Chr"] == i:
			meanPosition = data[j]["Start"]+((data[j]["End"]-data[j]["Start"])/2)
			datachr[i][j] = data[j]["Start"]	

for i in orderchr:
	for gene in sorted(datachr[i].items(),key=lambda x: x[1]):	
		gene = gene[0]
		if gene in dataexpr:
			if data[gene]["Chr"] != 'chrY' and '_random' not in data[gene]["Chr"]:
				out.write(data[gene]["Chr"]+'\t'+str(data[gene]["Start"])+'\t'+str(data[gene]["End"])+'\t'+gene)
				for i in dataSet:
					out.write('\t'+dataexpr[gene][i])
				out.write("\n")
