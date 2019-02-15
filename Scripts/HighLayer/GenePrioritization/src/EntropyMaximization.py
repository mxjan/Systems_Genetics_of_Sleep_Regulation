#!/usr/bin/python2

# Compute entropy maximization of sequences using gradient asendent 

# Example using 4 sequence

Seq1 = ["A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A"]
Seq2 = ["A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A"]
Seq3 = ["C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C"]
Seq4 = ["C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C","C"]
Seq5 = ["G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G","G"]

Sequences = {"Seq1":Seq1,"Seq2":Seq2,"Seq3":Seq3,"Seq4":Seq4,"Seq5":Seq5}


Seq1 = ["A","A","A","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","A"]
Seq2 = ["A","A","A","A","A","A","S","S","A","S","A","A","S","S","S","A","A","A","A","A","A","A","A"]
Seq3 = ["A","A","A","A","A","A","S","A","A","S","A","A","S","S","S","A","A","A","A","A","S","A","A"]
Seq4 = ["A","A","A","A","A","A","A","A","S","A","A","A","S","S","A","A","A","A","A","A","A","S","S"]
Seq5 = ["S","S","A","S","A","A","A","S","A","A","A","A","S","A","A","A","A","A","A","U","A","A","A"]

Sequences = {"Seq1":Seq1,"Seq2":Seq2,"Seq3":Seq3,"Seq4":Seq4,"Seq5":Seq5}

# Return the entropy with weight

import math
import sys
import fileinput

class EntropyMaximization():

	def __init__(self,Sequences):

		# input sequences
		self.Sequences = Sequences
		
		# default weights
		self.Weights = self.SetWeights()

		# learning rate of the ascendent gradient 
		self.StepFactor = float(1)

		# number of iteration
		self.NumberOfIteration = 10000

		# Compute mijn Tables
		self.Compute_mijn_Table()
		self.Compute_mnij_Table()

	def SetWeights(self):
		Weights = {}
		for i in self.Sequences:
			Weights[i] = float(10)
		return(Weights)

	def ComputeTotalWeight(self):
		return(sum([self.Weights[i] for i in self.Sequences]))

	def NumberOfPosition(self):
		return(len(self.Sequences[self.Sequences.keys()[0]]))

	def CharactersAtPositioni(self,i):
		Characters = []
		for n in self.Sequences:
			Characters.append(self.Sequences[n][i])
		Characters = list(set(Characters))
		return(Characters)
			
	def Compute_mijn_Table(self):
		self.mijnTable = {}
		for i in range(0,self.NumberOfPosition()):
			self.mijnTable[i] = {}
			for j in self.CharactersAtPositioni(i):
				self.mijnTable[i][j] = {}
				for n in self.Sequences:
					if self.Sequences[n][i] == j:
						self.mijnTable[i][j][n] = 1
					else:
						self.mijnTable[i][j][n] = 0

	def Compute_mnij_Table(self):
		self.mnijTable = {}
		for n in self.Sequences:
			self.mnijTable[n] = {}
			for i in range(0,self.NumberOfPosition()):
				self.mnijTable[n][i] = {}
				for j in self.CharactersAtPositioni(i):
					if self.Sequences[n][i] == j:
						self.mnijTable[n][i][j] = 1
					else:
						self.mnijTable[n][i][j] = 0
	
	def Compute_Weighted_Frequencies(self):
		
		W = self.ComputeTotalWeight()

		WeightedFrequencies = {}
		for i in range(0,self.NumberOfPosition()):
			WeightedFrequencies[i] = {}
			for j in self.CharactersAtPositioni(i):
				# equation 4
				WFij = 1/W * sum([self.Weights[n]*self.mijnTable[i][j][n] for n in self.Sequences])
				WeightedFrequencies[i][j] = WFij

		return(WeightedFrequencies)
	
	
	def ComputeEntropy(self):

		Entropy = []
		WFs = self.Compute_Weighted_Frequencies()
		for i in range(0,self.NumberOfPosition()):
			for j in self.CharactersAtPositioni(i):
				Entropy.append(WFs[i][j]*math.log(WFs[i][j]))

		# equation 6
		Entropy = -sum(Entropy)
		return(Entropy)
		

	def GradientFunctionOfSequence(self,n):

		W = self.ComputeTotalWeight()

		WFs = self.Compute_Weighted_Frequencies()

		# From equation 16 separated into 2 subfunction
		Part1 = 0
		for i in range(0,self.NumberOfPosition()):
			for j in self.CharactersAtPositioni(i):
				Part1 = Part1 + self.mnijTable[n][i][j]*math.log(WFs[i][j])

		Part2 = 0
		for i in range(0,self.NumberOfPosition()):
			for j in self.CharactersAtPositioni(i):
				Part2 = Part2 + WFs[i][j]*math.log(WFs[i][j])
		return( (-1/W)* ( Part1 - Part2 ) )	

				 	
	def GradientAscentFunction(self):
		
		# Print initial values
		print("Weights:", self.Weights, "Entropy:", self.ComputeEntropy())
	
		OldEntropy = self.ComputeEntropy()
		for step in range(1,self.NumberOfIteration):
			for n in self.Sequences:
				self.Weights[n] = self.Weights[n] + self.StepFactor * self.GradientFunctionOfSequence(n)	
				if (self.Weights[n]<0):
				  self.Weights[n]=0 

			# if entropy did not increase: break	
			if step % 1000 == 0:
				NewEntropy = self.ComputeEntropy()
				if NewEntropy == OldEntropy:
					break
				else:
					OldEntropy = NewEntropy

			if step % 100 == 0:
				print("Weights:", self.Weights, "Entropy:", self.ComputeEntropy())

	def NormalizeWeights(self):
		
		W = self.ComputeTotalWeight()
		for n in self.Weights:
			self.Weights[n] = self.Weights[n]/W 		

#seq1 = []
#seq2 = []
#seq3 = []
#seq4 = []
#seq5 = []

#for line in fileinput.input("/home/maxime/Link_To_Cluster/test.txt"):
#	ls = line.replace("\n",'').split()
#	if not fileinput.isfirstline():
#		seq1.append(ls[1])
#		seq2.append(ls[2])
#		seq3.append(ls[3])
#		seq4.append(ls[4])
#		seq5.append(ls[5])

Sequences = {"Seq1":Seq1,"Seq2":Seq2,"Seq3":Seq3,"Seq4":Seq4,"Seq5":Seq5}

EntMax = EntropyMaximization(Sequences)

EntMax.NumberOfIteration = 50000
EntMax.StepFactor = 10
print(EntMax.ComputeEntropy())

EntMax.GradientAscentFunction()
EntMax.NormalizeWeights(); print(EntMax.Weights); print(EntMax.ComputeEntropy())




