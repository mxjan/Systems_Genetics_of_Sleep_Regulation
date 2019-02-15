import fileinput
import sys

F1 = sys.argv[1]
F2 = sys.argv[2]
OutF  = sys.argv[3]

F2d = {}
for line in fileinput.input(F2):
	ls = line.replace("\n",'').split("\t")
	if ls[3] not in F2d:
		F2d[ls[3]] = {}
	F2d[ls[3]][ls[5]] = {}
	F2d[ls[3]][ls[5]]["Vtype"] = ls[4]
	F2d[ls[3]][ls[5]]["Pos"] = ls[5]
	F2d[ls[3]][ls[5]]["Ref"] = ls[6]
	F2d[ls[3]][ls[5]]["Alt"] = ls[7]
	F2d[ls[3]][ls[5]]["Chrom"] = ls[0]
	F2d[ls[3]][ls[5]]["PosGenome"] = ls[1]
	
	
out = open(OutF,'w')
	
for line in fileinput.input(F1):
	ls = line.replace("\n",'').split("\t")
	Vtype = ls[1]
	Pos = ls[2]
	Ref = ls[3]
	Alt = ls[4]
	if ls[0] in F2d and Pos in F2d[ls[0]]:
		tw = [ls[0],Vtype,Pos,Ref,Alt,F2d[ls[0]][Pos]["Chrom"],F2d[ls[0]][Pos]["PosGenome"]]
		out.write('\t'.join(tw)+'\n')