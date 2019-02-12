#!/usr/bin/python3

import sys
import fileinput
import re

top = 8.0
botom = 0.0
left = 0.0
right = 0.0

In = sys.argv[1]
Out = sys.argv[2]

Out = open(Out,'w')



for line in fileinput.input(In):

	drawmatch = re.findall( r"#Draw\s+(\w+):(\w+)\s+([0-9]+\.*[0-9]*)\s+([0-9]+\.*[0-9]*)", line)

	if drawmatch:
		Type = drawmatch[0][0]
		ID = drawmatch[0][1]
		row = float(drawmatch[0][2])
		col = float(drawmatch[0][3])
		
		row += top
		row -= botom
		
		col += right
		col -= left
	
		Out.write('#Draw '+Type+':'+ID+' '+str(row)+' '+str(col)+'\n')
		
		

	else:
		Out.write(line)
		
	
