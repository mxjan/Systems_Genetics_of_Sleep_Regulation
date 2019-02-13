#!/usr/bin/python2

import fileinput
import sys

# Combine GeneNetwork genotyped file with filtered SNPs (vcf file) from RNA-seq Data

# Run using: ./CombineGenotype <GeneNetwork text file> <RNA-seq filtered vcf file> <Output>

# Create an output.tmp file, it can be deleted when script is over
 
GN = sys.argv[1] # GeneNetwork File
CALL = sys.argv[2] # RNA-seq vcf File
outfinal = open(sys.argv[3],'w') # Output
out = open(sys.argv[3]+'.tmp','w')


GNd = {}
CALLd = {}


def formatHeader(HC):
	HCnew = []
	c = 0
	for col in HC:
		if c <= 8:
			HCnew.append(col)
		else:
			if col[3] == '0':
				col = col[0:3]+col[4:]
				if col == 'BXD05':
					col = 'BXD5'
			if col == 'C57BL6':
				col = 'C57BL/6J'
			if col == 'DBA2J':
				col = 'DBA/2J'
					
			HCnew.append(col)
		c +=1
	return HCnew


def GetListGenotypeCA(tmpcall,headerCALL,markerOrder,marker):
	headerCALL = formatHeader(headerCALL)
	line = tmpcall[marker]
	ls = line.split()
	ls[0] = ls[0].replace('chr','')
	tw=[]
	tw.append(ls[0]) # chr
	tw.append(ls[2]) # marker
	tw.append('NULL') # cM
	tw.append(str(round(float(ls[1])/1000000,6))) # pos
	nfound = []
	for mouse in markerOrder[4:]:
		if mouse not in headerCALL:
			if mouse not in nfound:
				nfound.append(mouse)
			tw.append('U')
			
		else:
			idx = headerCALL.index(mouse)
			
			if ls[idx] == './.':
				tw.append('U')
			elif '0/0' in ls[idx]:
				tw.append('B')
			elif '1/1' in ls[idx]:
				tw.append('D')
			elif '0/1' in ls[idx]:
				tw.append('H')
			else:
				p = ls[idx].split(':')[0]
				if '0' in p:
					tw.append('E')
				elif '1' in p:
					tw.append('F')
				else:
					tw.append('U')	
	return '\t'.join(tw)+'\n'



genomel=[]

c = 0
for line in fileinput.input(GN):
	ls = line.split()
	if line[0] != '@':
		if c != 0:
			if ls[0] not in genomel:
				genomel.append(ls[0])
			if ls[3] == 'B':
				print line
				print ls
				sys.exit()
			GNd[ls[1]] = [ls[0],ls[2],ls[3]]
		else:
			headerGN = ls
		c += 1

for line in fileinput.input(CALL):
	ls = line.split()
	if line[0] != '#':
		if ls[6] == 'PASS':
			ls[0] = ls[0].replace('chr','')
			CALLd[ls[2]] = [ls[0],ls[1]]
	else:
		headerCALL = ls
fileinput.close()


out.write('\t'.join(headerGN)+'\n')
for genome in genomel:
	tmp = {}
	for marker in GNd:
		if GNd[marker][0] == genome:
			tmp[marker+'_GN'] = int(float(GNd[marker][2])*1000000)
	for marker in CALLd:
		if CALLd[marker][0] == genome:
			tmp[marker+'_CA'] = int(CALLd[marker][1])
	
	tmpcall = {}
	for line in fileinput.input(CALL):
		ls = line.split()
		if line[0] != '#':
			if ls[2]+'_CA' in tmp:
				tmpcall[ls[2]] = line
	fileinput.close()

	tmpGN = {}
	c = 0
	for line in fileinput.input(GN):
		ls = line.split()
		if line[0] != '@':
			if c != 0:
				tmpGN[ls[1]] = line
			c += 1	
	fileinput.close()	

	for marker,position in sorted(tmp.items(), key=lambda x:x[1]):
		marker = marker[:-3]
		if marker in GNd:
			out.write(tmpGN[marker])
		else:
			out.write(GetListGenotypeCA(tmpcall,headerCALL,headerGN,marker))

out.close()


# Remove potential duplicates:
marker = {}
c = 0
out3 = open(sys.argv[3]+'.tmp2','w')
for line in fileinput.input(sys.argv[3]+'.tmp'): 
	ls = line.split()
	if line[0] != '@':
		if c != 0:
			if ls[1] not in marker:	
				marker[ls[1]] = True
				out3.write(line)
		else:
			out3.write(line)
		c += 1	
	else:
		out3.write(line)
fileinput.close()
out3.close()



def solvingcM(fromtocM,fromtoMB,cMstart,MBstart):
	diffcM = float(fromtocM[-1]-cMstart)
	diffMB = float(fromtoMB[-1]-MBstart)
	cMpred = []
	for d in fromtoMB:
		ratiodist = (d-MBstart)/diffMB
		cMpred.append(cMstart+(ratiodist*diffcM))
	return cMpred

# Transform NULL cM value
cM = {}
MB = {}
chrom = []
c = 0
for line in fileinput.input(sys.argv[3]+'.tmp2'): 
	ls = line.split()
	if line[0] != '@':
		if c != 0:
			if ls[0] not in cM:
				cM[ls[0]] = []
			if ls[0] not in MB:
				MB[ls[0]] = []
			if ls[0] not in chrom:
				chrom.append(ls[0])
			cM[ls[0]].append(ls[2]) 
			MB[ls[0]].append(ls[3])
		c += 1	
fileinput.close()

cMsolved = {}
for ch in chrom:
	cMsolved[ch] = []
	fromtocM = []
	fromtoMB = []	
	cMstart = 0.0
	MBstart = 0.0
	idx = 0
	while idx != len(cM[ch]):
		for centim in cM[ch][idx:]:
			if centim == 'NULL':
				fromtocM.append('NULL')
				fromtoMB.append(float(MB[ch][idx]))
			else:
				fromtocM.append(float(centim))
				fromtoMB.append(float(MB[ch][idx]))
				if len(fromtocM) != 1:	
					cMsolved[ch].extend(solvingcM(fromtocM,fromtoMB,cMstart,MBstart))
				else:
					cMsolved[ch].extend(fromtocM)
				cMstart = fromtocM[-1]
				MBstart = fromtoMB[-1]
				fromtocM = []
				fromtoMB = []	

	
				
			idx += 1
	if fromtocM != []:
		for i in range(0,len(fromtocM)):
			fromtocM[i] = cMstart
		cMsolved[ch].extend(fromtocM)
	print len(cMsolved[ch]),len(cM[ch])
			
	

c = 0
cc = 0
ch = ''
fileinput.close()
for line in fileinput.input(sys.argv[3]+'.tmp2'): 
	ls = line.split()
	if ls[1] == 'rs261826403':
		print line
	if line[0] != '@':
		if c != 0:
			if ls[0] != ch:
				cc =0
				ch = ls[0]
			ls[2] = str(cMsolved[ls[0]][cc])
			outfinal.write('\t'.join(ls)+'\n')
			cc += 1			
		else:
			outfinal.write(line)
		c += 1	
	else:	
		outfinal.write(line)
	
	

