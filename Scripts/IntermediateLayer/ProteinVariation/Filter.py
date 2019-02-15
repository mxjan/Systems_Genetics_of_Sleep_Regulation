import sys
import fileinput

Fi = sys.argv[1]
mm10Ref = sys.argv[2]
outf = sys.argv[3]

db = {}
for line in fileinput.input(mm10Ref):
	ls = line.replace("\n",'').split("\t")
	db[ls[0]] = True
	
out = open(outf,'w')
 
for line in fileinput.input(Fi):
	if fileinput.isfirstline():
		out.write(line)
	else:
		ls = line.replace("\n",'').split("\t")
		if ls[0] in db:
			out.write(line)