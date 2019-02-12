#!/usr/bin/python3


import fileinput
import sys
import os
import time
import re
import subprocess
import numpy as np
from copy import deepcopy

# Every information that can be found within a Data object
# Information can be not unique
class Information:

	# Type can be text, list, sequence, dict, or object, path
	def __init__(self,information_type,information_name):
	
		self.information_name = information_name
		self.information_type = information_type

		#Available format
		Datatype = {"text":str(),"list":list(),"sequence":list(),"dict":dict(),"path":str(),"longtext":str()}

		if self.information_type not in Datatype:
			sys.stderr.write("Information type not available\n")
			exit(1)

		# If we have text
		self.information = Datatype[self.information_type]
	
		if self.information_type == "dict":
			self.key = ''
			self.value = ''

	def SetPathType(self,method=None,where = ""):
		if self.information_type != "path":
			sys.stderr.write("Search path for a none path object\n")
			exit(1)			
		if PathType == "search":
			if os.path.isfile(path):
				self.pathtype == "File"
			elif os.path.isdir(path):
				self.pathtype == "Directory"
			else:
				self.pathtype == "Unknown"
		else:
			self.pathtype = where
			
	
	def SetInformation(self,information):
		self.information = information
	
	def AddInformation(self,information=None):
		
		if self.information_type == "text":
			information = information.replace("\n",'')
			self.information += information
		elif self.information_type == "list" or self.information_type == "sequence":
			self.information.append(information)
		elif self.information_type == "dict":
			self.information[self.key] = self.value
		elif self.information_type == "path":
			self.information += information
		elif self.information_type == "longtext":
			self.information += information+'\n'

	def ResetKeyValue(self):
		self.key = ''
		self.value = ''		

	def IsInformation(self):
	
		if self.information_type == "text" or self.information_type == "longtext":
			if self.information == '':
				return(False)
			else:
				return(True)
		else:
			if len(self.information) == 0:
				return(False)
			else:
				return(True)
		

# A data object can be a file, script, workflow or experiment
# A data object is part of a group (its own or with other data object)
# A data object ID (when ID is set) must be unique
class Data:

	def __init__(self,DataType):

		self.data_type = DataType
		
		self.information_content = {}

	# Add an information object to information_content
	def AddContent(self,information_object):

		if information_object.information_name not in self.information_content:
			self.information_content[information_object.information_name] = []
		self.information_content[information_object.information_name].append(information_object)


	# Set ID of the object based on the information_content
	def SetID(self,information_type):
		if information_type not in self.information_content:
			sys.stderr.write("You set ID for an unknown information: "+information_type+" \n")
			exit(1)	

		if len(self.information_content[information_type]) > 1:
			sys.stderr.write("A single data object contain multiple ID \n")
			for i in self.information_content:
				for j in self.information_content[i]:
					print(j.information)
			exit(1)	
			
		else:
			self.id = self.information_content[information_type][0].information
			return(self.id)

	def IsGroupAssigned(self,information_type):
		if information_type in self.information_content:
			if len(self.information_content[information_type]) > 1:
				sys.stderr.write("You Assign multiple group to a Data")
				exit(1)
			return(True)
		else:
			return(False)

	def GetGroupAssigned(self,information_type):
		if self.IsGroupAssigned(information_type):
			return(self.information_content[information_type][0].information)
		else:
			return(None)

	def ReplaceWithLink(self,text,Links,information_type):

		editedtext = text
		globalmatch = re.findall( r"\$<\s*.*?\s*\[\s*.*?\s*\]>", text )
		if globalmatch:
			for match in globalmatch:
				detailedmatch = re.findall( r"\$<\s*(.*?)\s*\[\s*(.*?)\s*\]>", match)
				TextToWrite = detailedmatch[0][0]
				Linkage = detailedmatch[0][1]
				if Linkage not in Links:
					sys.stderr.write("\""+Linkage+'\" is not defined in the Links\n')
					exit(1)
				else:
					if Linkage not in self.connections[information_type]:
						self.connections[information_type].append(Linkage)
					Linkage = Links[Linkage]
					Linkage = Linkage.replace(".md#",'.html#')
					#print(Linkage)
				LinkInText = "["+TextToWrite+"]("+Linkage+")"
				editedtext = editedtext.replace(match,LinkInText)
		return(editedtext)

	def EditLink(self,Links):


		# Save the connection found
		self.connections = {}

		for information_type in self.information_content:
			self.connections[information_type] = []

			for information_object in self.information_content[information_type]:
				if information_object.information_type == 'text' or information_object.information_type == 'longtext':
					Text = information_object.information
					NewText	 = self.ReplaceWithLink(Text,Links,information_type)
					information_object.SetInformation(NewText)

				if information_object.information_type == 'list' or information_object.information_type == 'sequence':
					Newlist = []
					for Text in information_object.information:
						NewText	 = self.ReplaceWithLink(Text,Links,information_type)
						Newlist.append(NewText)	
					information_object.SetInformation(Newlist)

				if information_object.information_type == 'dict':
					Newdict = {}
					for Key in information_object.information:
						Text = information_object.information[Key]
						NewText	 = self.ReplaceWithLink(Text,Links,information_type)
						Newdict[Key] = NewText
					information_object.SetInformation(Newdict)

				if information_object.information_type == 'path':
					Text = information_object.information
					NewText	 = self.ReplaceWithLink(Text,Links,information_type)
					information_object.SetInformation(NewText)
	
class Group:

	def __init__(self):
		
		self.group_id = ''
		self.group_name = ''
		self.group_content = []

	# Add an object of class data
	def AddDataToGroup(self,data):
		self.group_content.append(data)

	def SetID(self,ID):
		self.group_id = ID

	def SetGroupName(self,Name):
		self.group_name = Name



def find_path(graph, start, end, path=[]):
	path = path + [start]
	if start == end:
    		return path
	if start not in graph:
    		return None
	for node in graph[start]:
   		if node not in path:
        		newpath = find_path(graph, node, end, path)
        		if newpath: return newpath
	return None



def find_all_paths(graph, start, end, path=[]):
	path = path + [start]
	if start == end:
		return [path]
	if start not in graph:
		return []
	paths = []
	for node in graph[start]:
		if node not in path:
			newpaths = find_all_paths(graph, node, end, path)
			for newpath in newpaths:
				paths.append(newpath)
	return paths


def find_shortest_path(graph, start, end, path=[]):
	path = path + [start]
	if start == end:
		return path
	if start not in graph:
		return None
	shortest = None
	for node in graph[start]:
		if node not in path:
			newpath = find_shortest_path(graph, node, end, path)
		if newpath:
			if not shortest or len(newpath) < len(shortest):
				shortest = newpath
	return shortest

def LenNodesFilt(x,Nodes):
	xx = deepcopy(x)
	ToRem = []
	for i in xx:
		if i not in Nodes:
			ToRem.append(i)
	for i in ToRem:
		xx.remove(i)
	return(len(xx))


# Main class to read file, generate markdown and generate workflow figure
class MetaSysGen:

	# Initiate Metadata creation using Project name
	def __init__(self,ProjectName="Default"):

		# Global name to display on markdown
		self.project_name = ProjectName
		
		# Data
		self.data_pool = []

		# path of png generated
		self.png_path = ''

		# Information type format
		self.information_format = {}
		self.information_dict_key = {}
		
	def SetInformationFormat(self,InformationName,InformationType,Key=None,Value=None):
		self.information_format[InformationName] = InformationType
		if InformationType == 'dict':
			self.information_dict_key[InformationName] = {Key:'key',Value:'value'}

	def SetDataID(self,information_type):
		self.Data_list_by_id = {}
		for Data in self.data_pool:
			DataID = Data.SetID(information_type)
			self.Data_list_by_id[DataID] = Data

	def WriteLineFile(self):
		# Return file and line number
		Line = '(line = '+str(self.lineNumber)+'; File = '+self.File+')\n'
		return(Line)

	def ReadFile(self,File):

		# Control if information format was set before
		if self.information_format == {}:
			sys.stderr.write("You must set information format before reading file (SetInformationFormat()) \n")
			exit(1)			
	
		# Information to display if an error occurs
		self.lineNumber = 1
		self.File = File

		for line in fileinput.input(File):
		

			# match file format
			BlockStartPattern = re.compile(r'^#(.+)')			
			BlockStart = BlockStartPattern.match(line)

			SubBlockStartPattern = re.compile(r'^\t#(.+)')
			SubBlockStart = SubBlockStartPattern.match(line)

			SubBlockDataPattern = re.compile(r'^\t(?!#|\t)(.+)')
			SubBlockData = SubBlockDataPattern.match(line)

			SubSubBlockDataStartPatter = re.compile(r'^\t\t#(.+)')
			SubSubBlockStart = SubSubBlockDataStartPatter.match(line)

			SubSubBlockDataPattern = re.compile(r'^\t\t(?!#)(.+)')
			SubSubBlockData = SubSubBlockDataPattern.match(line)

			# Detect a Data object
			if BlockStart:

				try:
					data_object.AddContent(information_object)
				except:
					pass

				try:
					self.data_pool.append(data_object)
				except:
					pass

				# Create a Data object, try to add Data object to the pool if this is a new Data object
				BlockName = re.match(r"\s*(\w+)\s*",BlockStart.group(1)).group(1)

				data_object = Data(BlockName)
				try:
					del information_object
				except:
					pass

			# Detect an information	
			if SubBlockStart:

				try:
					data_object.AddContent(information_object)
				except:
					pass

				# Information
				SubBlockName = re.match(r"\s*(\w+)\s*",SubBlockStart.group(1)).group(1)
			
				if SubBlockName not in self.information_format:
					sys.stderr.write(" You did not Set the information format for:"+SubBlockName+" \n")
					self.WriteLineFile()
					exit(1)	
				
				information_type = self.information_format[SubBlockName]
				information_object = Information(information_type,SubBlockName)

			if SubSubBlockStart:
				SubSubBlockName = SubSubBlockStart.group(1).replace(" ",'')
		
			if SubBlockData:
				SubBlockInformation = SubBlockData.group(1)
				information_object.AddInformation(SubBlockInformation)

			if SubSubBlockData:

				SubSubBlockInformation = SubSubBlockData.group(1)
				if self.information_dict_key[SubBlockName][SubSubBlockName] == 'key':
					information_object.key = SubSubBlockInformation
				elif self.information_dict_key[SubBlockName][SubSubBlockName] == 'value':
					information_object.value = SubSubBlockInformation
				else:
					sys.stderr.write("Error in the script for dict information")
					sys.exit(1)

				if information_object.key != '' and information_object.value != '':
					information_object.AddInformation()
				

			self.lineNumber += 1


		try:
			data_object.AddContent(information_object)
		except:
			pass

		try:
			self.data_pool.append(data_object)
		except:
			pass

	def DisplayDataPool(self):
		for i in self.data_pool:
			print("\n\n")
			for j in i.information_content:
				info_objs = i.information_content[j]
				for info_obj in info_objs: 
					print(info_obj.information,info_obj.information_name,info_obj.information_type)

	def SetOrderType(self,Order):
		self.OrderType = Order

	def SetOrderInfo(self,Order):
		self.OrderInfo = Order

	def GroupDataBy(self,information_type):

		self.group_balise = information_type

		self.GroupedData = {}
		for ID in self.Data_list_by_id:	
			Data = self.Data_list_by_id[ID]
			GroupAssigned = Data.GetGroupAssigned(information_type)
			if GroupAssigned != None:
				GroupAssigned = GroupAssigned
				if GroupAssigned not in self.GroupedData:
					self.GroupedData[GroupAssigned] = []
				self.GroupedData[GroupAssigned].append(ID)

	def DisplayGroupName(self):
		for Group in self.GroupedData:
			print(Group)

	def SetExtendedGroupName(self,GID,ExtendedName):
	
		

		try:
			self.GroupedData
		except:
			sys.stderr.write("Run GroupDataBy() first !")
			exit(1)

		try:
			self.ExtendedGroupName

		except:
			self.ExtendedGroupName = {}
			for ID in self.GroupedData:
				self.ExtendedGroupName[ID] = ID
			
		self.ExtendedGroupName[GID] = ExtendedName
		#self.GroupedData[ExtendedName] = self.GroupedData.pop(GID)

	def FormatedLink(self,Link):
		Link = Link.lower()
		Link = Link.replace(".",'')
		Link = Link.replace(";",'')
		Link = Link.replace(" ",'-')
		Link = Link.replace("/",'')
		return(Link) 

	def LinkData(self,Path,DataDisplay):

		self.LinkedDataDic = {}
		for ID in self.Data_list_by_id:
			Name = self.Data_list_by_id[ID].information_content[DataDisplay][0].information
			Link = self.FormatedLink(Name)
			self.LinkedDataDic[ID] = Path+'#'+Link

		# Used extended group ID if found
		try:
			self.ExtendedGroupName
			for GID in self.GroupedData:
				Link = self.FormatedLink(self.ExtendedGroupName[GID])	
				self.LinkedDataDic[GID] = Path+'#'+Link
			
		except:
			for GID in self.GroupedData:
				Link = self.FormatedLink(GID)
				self.LinkedDataDic[GID] = Path+'#'+Link

	def EditDataWithLink(self):

		for ID in self.Data_list_by_id:
			Data = self.Data_list_by_id[ID]
			Data.EditLink(self.LinkedDataDic)	

	def OrderDataByType(self):

		OrderedData = {}
		for ID in self.Data_list_by_id:
			Data = self.Data_list_by_id[ID]
			DataType = Data.data_type
			if DataType not in OrderedData:
				OrderedData[DataType] = []
			OrderedData[DataType].append(ID)	
		return(OrderedData)


	def PrintData(self,Data_obj,F,NameSize):

		try:
			self.OrderInfo
		except:
			sys.stderr.write("Run SetOrderInfo() before markdown generation\n")
			exit(1)

		

		for i in sorted(self.OrderInfo):
			information_ID = self.OrderInfo[i]
			if i == 1:
				if information_ID not in Data_obj.information_content:
					sys.stderr.write("First information must be present in all data\n")
					exit(1)		
				information_obj = Data_obj.information_content[information_ID][0]
				if information_obj.information_type != 'text':
					sys.stderr.write("First information must be text\n")
					exit(1)
				F.write('#'*NameSize+' '+information_obj.information+'\n\n')	
			else:
				if information_ID in Data_obj.information_content:
					F.write('#### '+information_ID+'\n\n')
					for information_obj in Data_obj.information_content[information_ID]:
						if information_obj.information_type == 'text' or information_obj.information_type == 'longtext':
							F.write(information_obj.information+'\n\n')
						elif information_obj.information_type == 'path':
							F.write(information_obj.information+'\n\n')
						elif information_obj.information_type == 'list':
							F.write('; '.join(information_obj.information)+'\n\n')	
						elif information_obj.information_type == 'sequence':
							F.write('>')
							for info in information_obj.information:
								F.write(info+' <br>\n')
							F.write("\n")
						elif information_obj.information_type == 'dict':	
							for info in information_obj.information:
								#F.write(info+': '+information_obj.information[info]+'\n\n')
								F.write(information_obj.information[info]+': '+info+'\n\n')
										
	def SetConnectors(self,Connectors):
		self.connectors = Connectors


	def Graph_Remove(self,Graph,IDToRemove):
		TempGraph = deepcopy(Graph)
		for ID in Graph:
			if ID == IDToRemove:
				del TempGraph[ID]
			else:
				for ID2 in Graph[ID]:
					if ID2 == IDToRemove:
						TempGraph[ID].remove(IDToRemove)	
		return(TempGraph)		
	

	def Draw_Project_Workflow(self,parametersFile,NodesFile,EdgesFile,PNGFile,GraphGroupExtension = True):

		try:
			self.connectors
		except:
			sys.stderr.write("Run SetConnectors before generating markdown if you want the workflow png\n")
			exit(1)

		self.DrawParam = {'DrawMatrix':{'nrow':0,'ncol':0}}



		# Read file and get nodes
		Nodes = []

		for line in fileinput.input(parametersFile):
			line = line.replace("\n",'')
			
			matrixmatch = re.findall( r"#DrawMatrix\s+([0-9]+\.*[0-9]*)\s+([0-9]+\.*[0-9]*)", line)
			drawmatch = re.findall( r"#Draw\s+(\w+):(\w+)\s+([0-9]+\.*[0-9]*)\s+([0-9]+\.*[0-9]*)", line)

			if matrixmatch:
				self.DrawParam['DrawMatrix']['nrow'] = matrixmatch[0][0]
				self.DrawParam['DrawMatrix']['ncol'] = matrixmatch[0][1]
			
			elif drawmatch:
				Type = drawmatch[0][0]
				ID = drawmatch[0][1]
				row = drawmatch[0][2]
				col = drawmatch[0][3]
				if Type not in self.DrawParam:
					self.DrawParam[Type] = {}
				self.DrawParam[Type][ID] = {'col':col,'row':row,'Isdefined':False}
			else:
				if re.match(r'.+',line):
					sys.stderr.write("The line: \""+line+"\" was not parsed\n")
			
	

		# Control that all ID are define in the data read
		sys.stderr.write("PNG generation...\n")
		sys.stderr.write("Control if all ID are defined...")
		for Type in self.DrawParam:
			if Type != "DrawMatrix":
				for ID in self.DrawParam[Type]:	
					if ID in self.Data_list_by_id:			
						self.DrawParam[Type][ID]['Isdefined'] = True
						Nodes.append(ID)
					elif ID in self.GroupedData:
						self.DrawParam[Type][ID]['Isdefined'] = True
						Nodes.append(ID)
				# Print undefined data and stop script
				if self.DrawParam[Type][ID]['Isdefined'] == False:
					sys.stderr.write(ID+" is not defined in your data ! "+'\n')
					sys.exit(1)

		sys.stderr.write("OK\n\n")
	


		# Get graph using only connectors
		self.Graph = {}

		# Directly defined connection
		for ID1 in self.Data_list_by_id:	
			for connection_type in self.Data_list_by_id[ID1].connections:
				if connection_type in self.connectors['In']:
					for ID2 in self.Data_list_by_id[ID1].connections[connection_type]:
						if ID2 not in self.Graph:
							self.Graph[ID2] = []
						self.Graph[ID2].append(ID1)

				if connection_type in self.connectors['Out']:
					for ID2 in self.Data_list_by_id[ID1].connections[connection_type]:
						if ID1 not in self.Graph:
							self.Graph[ID1] = []
						self.Graph[ID1].append(ID2)


		#print(self.Graph)

		# Extend connection linking group to Data within group
		# Groups inherit the connection of its Data
		# Data inherit the connection of the group

		self.GExt_Graph = deepcopy(self.Graph)

		if GraphGroupExtension:
			
			DataInGroup = {}
			for i in self.GroupedData:
				for j in self.GroupedData[i]:
					DataInGroup[j] = i
			#DataInGroup = [j for i in self.GroupedData.values() for j in i]

			for ID1 in self.Graph:

				# If nodes is a group -> Data inherit its connection 'to'
				if ID1 in self.GroupedData:
					for ID_in_group in self.GroupedData[ID1]:
						if ID_in_group in self.GExt_Graph:
							for ID2 in self.Graph[ID1]:
								if ID2 not in self.GExt_Graph[ID_in_group]:
									self.GExt_Graph[ID_in_group].append(ID2)


				# If nodes is a data in a group -> Group inherit its connection 'to'
				elif ID1 in DataInGroup:
					GID = DataInGroup[ID1]
					if GID in self.Graph:
						for ID2 in self.Graph[ID1]:
							if ID2 not in self.GExt_Graph[GID]:
								self.GExt_Graph[GID].append(ID2)
									
	
				# Same but for connection 'from'
				for ID2 in self.Graph[ID1]:

					# If nodes is a group -> Data inherit its connection 'from'
					if ID2 in self.GroupedData:
						for ID_in_group in self.GroupedData[ID2]:
							if ID_in_group not in self.GExt_Graph[ID1]:
								self.GExt_Graph[ID1].append(ID_in_group)

					# If nodes is a Data -> group inherit its connection 'from'
					if ID2 in DataInGroup:
						GID = DataInGroup[ID2]
						if GID not in self.GExt_Graph[ID1]:
							self.GExt_Graph[ID1].append(GID)
			
			
		del self.Graph


		# Remove group if data are draw
		#for ID in self.DrawParam:
		Remove = []
		DrawID = [i for ID in self.DrawParam for i in self.DrawParam[ID]]
		for GID in self.GroupedData:

			if len(list(set(self.GroupedData[GID]) & set(DrawID))) >= 1:
				if GID in DrawID:
					sys.stderr.write("Draw either files or group, but not both !")
					exit(1)

				self.GExt_Graph = self.Graph_Remove(self.GExt_Graph,GID)

		#print(self.GExt_Graph)

		# Get all path and we decompose our graph into the longest possible path
		self.Graph_All_Path = {}
		for ID1 in Nodes:
			Path = {'From':str(),'To':str(),'Via':str()}
			for ID2 in Nodes:
				if ID1 != ID2:	
					all_paths = find_all_paths(self.GExt_Graph,ID1,ID2)
					len_all_paths = [LenNodesFilt(x,Nodes) for x in all_paths]
										
					for i in range(0,len(all_paths)):
						maxlen = max(len_all_paths)
						path_to_process = all_paths[i]
						#if LenNodesFilt(path_to_process,Nodes) >= maxlen:
						if LenNodesFilt(path_to_process,Nodes) >= 1:
							start = path_to_process[0]
							path_to_process.remove(start)
							Via = []
				
							while len(path_to_process) > 0:
								tonodes = path_to_process[0]
								if tonodes in Nodes:
									if start not in self.Graph_All_Path:
										self.Graph_All_Path[start] = {}
									if tonodes not in self.Graph_All_Path[start]:
										self.Graph_All_Path[start][tonodes] = []
										if Via != []:
											self.Graph_All_Path[start][tonodes] = Via
											Via = []
									else:
										if Via != []:
											for i in Via:
												if i not in self.Graph_All_Path[start][tonodes]:
													self.Graph_All_Path[start][tonodes].append(i)
											Via = []

									path_to_process.remove(tonodes)
									start = tonodes
								else:
									Via.append(tonodes)
									path_to_process.remove(tonodes)
																
														
		# Write File

		# Edges
		F = open(EdgesFile,'w')
		for ID in self.Graph_All_Path:
			for ID2 in self.Graph_All_Path[ID]:
				ToWrite = [ID,ID2]
				if len(self.Graph_All_Path[ID][ID2]) > 0:
					Via_Files = []
					for Via in self.Graph_All_Path[ID][ID2]:
						if Via in self.ExtendedGroupName:
							Via_Files.append(self.ExtendedGroupName[Via])
						else:
							Via_Files.append(Via)

					ToWrite.append(';'.join(Via_Files))
				else:
					ToWrite.append('NoVia')
				F.write('\t'.join(ToWrite)+'\n')
		F.close()

		F = open(NodesFile,'w')


		# Expand GroupDisplay					
	
		colfactor = int(self.DrawParam["DrawMatrix"]['ncol'])+1
		rowfactor = int(self.DrawParam["DrawMatrix"]['nrow'])+1

		for Type in self.DrawParam:
			if Type != 'DrawMatrix':
				for ID in self.DrawParam[Type]:
					col = self.DrawParam[Type][ID]['col']
					row = self.DrawParam[Type][ID]['row']

					if ID not in self.GroupedData:
						Data_obj = self.Data_list_by_id[ID]
						information_ID = self.OrderInfo[1]
						information_obj = Data_obj.information_content[information_ID][0]
						Name = information_obj.information

					elif ID in self.GroupedData:
						
						Name = self.ExtendedGroupName[ID]

					#Path = self.IDconnection[ID].path
					Path = 'Path in description'
					
					col = str(float(col)/colfactor)
					row = str(float(row)/rowfactor)

					F.write('\t'.join([Type,ID,col,row,Name,Path])+'\n')
			

		F.close()
		return_code = subprocess.call("Rscript Diagram_Workflow_Simple.R "+NodesFile+' '+EdgesFile+' '+PNGFile, shell=True)
		#return_code = subprocess.call("Rscript Diagram_Workflow.R "+NodesFile+' '+EdgesFile+' '+PNGFile, shell=True)
				
	
	def AddYAML(self,YAML):
		self.YAML = YAML

	def GenerateMarkdown(self,Output,DataDisplay,DrawparamFile=None):

		# A single markdown file will be generated
		F = open(Output,'w') 	

		# Write YAML
		try:
			self.YAML
			F.write(self.YAML)
		except:
			pass
		
		# Get a dict with link for md file
		self.LinkData(Output,DataDisplay)

		# Edit all link found in the information object
		# Each Data object get a connection attribute which link it to other object
		self.EditDataWithLink()


		# Draw workflow if param given
		RparamFileNodes = "MyDiagramInput_Nodes.txt"
		RparamFileEdges = "MyDiagramInput_Edges.txt"
		PNGGenerated = "MyDiagram.png"

		if DrawparamFile != None:
			self.Draw_Project_Workflow(DrawparamFile,NodesFile = RparamFileNodes,EdgesFile = RparamFileEdges, PNGFile = PNGGenerated)
		
		F.write("![alt text]("+PNGGenerated+")")
		F.write("\n\n")
		 
		# ID by type
		OrderedData = self.OrderDataByType()

		try:
			self.OrderType
		except:
			sys.stderr.write("Error, Run SetOrderType first\n")	
			exit(1)


		for i in sorted(self.OrderType):

			Type = self.OrderType[i]

			if Type not in OrderedData:
				sys.stderr.write(str(Type)+" in your ordered list is not defined\n")
				exit(1)
			DataIDs = OrderedData[Type]


			F.write('# '+Type+'\n\n')


			# pool by groups
			try:
				gb = self.group_balise
			except:
				gb = None

			DataByGroup = {'NoGroup':[]}

			for ID in DataIDs:	
				GroupAssigned = self.Data_list_by_id[ID].GetGroupAssigned(gb)
				if GroupAssigned != None:
					GroupAssigned = GroupAssigned
					if GroupAssigned not in DataByGroup:
						DataByGroup[GroupAssigned] = []			
					DataByGroup[GroupAssigned].append(ID)
				else:
					DataByGroup["NoGroup"].append(ID)
						
			
			if len(DataByGroup) > 1:
				Process = [k for k in DataByGroup]
				Process.remove("NoGroup")
				
				for groupname in Process:
					GroupNameExt = self.ExtendedGroupName[groupname]
					F.write('## '+GroupNameExt+'\n\n')
					NameSize = 3
					for ID in DataByGroup[groupname]:
						Data_obj = self.Data_list_by_id[ID]				
						self.PrintData(Data_obj,F,NameSize)

			NameSize = 2
			for ID in DataByGroup["NoGroup"]:
				Data_obj = self.Data_list_by_id[ID]				
				self.PrintData(Data_obj,F,NameSize)

		F.close()
		
		return_code = subprocess.call("R -e \'library(\"rmarkdown\");library(\"knitr\");rmarkdown::render(\""+Output+"\")\'", shell=True)	
		

	def DataIDDisplay(self,ID_Balise,Name_Balise,Group_Balise=None):	
		sys.stdout.write('\n')
		for i in self.data_pool:
			#sys.stdout.write('\n')
			for j in i.information_content:
				info_objs = i.information_content[j]
				if j == ID_Balise:
					sys.stdout.write('\n'+info_objs[0].information+'\n | ')
			for j in i.information_content:
				info_objs = i.information_content[j]
				if j == Name_Balise:
					sys.stdout.write(info_objs[0].information)
			if Group_Balise != None:
				Gfound =False
				for j in i.information_content:
					info_objs = i.information_content[j]
					if j == Group_Balise:
						Gfound = True
						sys.stdout.write('\n | '+info_objs[0].information+'\n')
				if Gfound == False:
					sys.stdout.write('\n')
			else:
				sys.stdout.write('\n')
		sys.stdout.write('\n')
				
			

######## BXD project

Meta = MetaSysGen()

# Set information type
Meta.SetInformationFormat('Name','text')
Meta.SetInformationFormat('ID','text')
Meta.SetInformationFormat('Description','longtext')
Meta.SetInformationFormat('Group','text')
Meta.SetInformationFormat('Path','path')
Meta.SetInformationFormat('Input','list')
Meta.SetInformationFormat('Output','list')
Meta.SetInformationFormat('Link','dict','Link','Description')
Meta.SetInformationFormat('CS','sequence')
Meta.SetInformationFormat('Authors','list')
Meta.SetInformationFormat('Arguments','text')
Meta.SetInformationFormat('Version','text')

# Read Data
Meta.ReadFile("Authors.txt")
Meta.ReadFile("EEGAnalysis.txt")

Meta.ReadFile("Project.txt")
Meta.ReadFile("Experiment.txt")

Meta.ReadFile("Design.txt")

Meta.ReadFile("Processing_ScriptsAndWorkflow.txt")
Meta.ReadFile("Processing_Files.txt")
Meta.ReadFile("Processing_References.txt")

Meta.ReadFile("BXDPaperFigures.txt")



# ID of each Data object is define by the balise:
Meta.SetDataID('ID')
# Set group balise. If you have not group balise, use the same balise for ID
Meta.GroupDataBy('Group')

# Change group name
Meta.SetExtendedGroupName("NormCounts","Normalized Counts")
Meta.SetExtendedGroupName("PBXD","Project BXD")
Meta.SetExtendedGroupName("fqFiles","Fastq Files")
Meta.SetExtendedGroupName("RawCounts","Transcript raw counts")
Meta.SetExtendedGroupName("PBXDmol","Molecular data")
Meta.SetExtendedGroupName("BamFiles","Bam Files")
Meta.SetExtendedGroupName("PredictedFiles","States Predicted Files")
Meta.SetExtendedGroupName("MetaboFile","Metabolite Files")
Meta.SetExtendedGroupName("pcorMatrix","Partial Correlation Matrix")

# Set order of information (printed in markdown)
Meta.SetOrderType({1:"Project",2:"Author",3:"File",4:"Workflow",5:"Script",6:"Population",7:"Tissu",8:"Condition",9:"Rmarkdown",10:"Experiment"})

# Title must be 1, and must be text
Meta.SetOrderInfo({1:"Name",2:"Description",3:"Path",4:"Input",5:"Output",6:"CS",7:"Arguments",8:"Version",9:"Authors",10:"Link"})

# Generate the markdown

# Set connector for in -> nodes -> out/in -> nodes
Meta.SetConnectors({'In':['Input','CS'],'Out':['Output']})

#Add YAML
YAML = """\n---
title: "BXD MetaData"
output: 
  html_document:
    toc: true
    toc_float: true
    theme: spacelab
    df_print: paged
    rows.print: 6
---\n"""

Meta.AddYAML(YAML)

Meta.GenerateMarkdown("README.md",DataDisplay = "Name",DrawparamFile = "DrawParamSimple.txt")
#Meta.GenerateMarkdown("Test.md",DataDisplay = "Name",DrawparamFile = "DrawParamNew.txt")

print("Display ID")
Meta.DataIDDisplay("ID","Name","Group")



