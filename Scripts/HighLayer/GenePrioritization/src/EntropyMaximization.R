# Paper: https://pdfs.semanticscholar.org/394e/dece35cd52215f6aa1ef83860912a6406dd4.pdf
# Maximum Entropy Weighting of Aligned Sequences of Proteins or DNA; Anders Krogh 1995

# Set default weights
SetWeights <- function(Sequences){
	# default is 10
	Weights <- lapply(Sequences,function(x){return(10)})
	return(Weights)
}

# Sum of weights
ComputeTotalWeight <- function(Weights){
	#W <- do.call(sum, Weights)
	W <- sum(unlist(Weights))
	return(W)
}

# Number of position (i) in our sequences
NumberOfPosition <- function(Sequences){
	# name of 1 element in Sequences
	name<-names(Sequences)[[1]]
	I <- length(Sequences[[name]])
	return(I)

}

# Return possible character at a given position (j)
CharactersAtPositioni <- function(i,Sequences){

	Characters <- lapply(Sequences,function(x,i){return(x[[i]])},i)

	# Get only unique characters
	Characters<- unique(unlist(Characters))

	# Be sure we have character
	Characters<-as.character(Characters)
	return(Characters)
}

# Presence (1) or absence (0) of a character at position i
IsCharacterAtPositioni <- function(Sequence,j,i){
	if (Sequence[[i]] == j) { return(1) }
	else (return(0))
}

Compute_mijn_Table <- function(Sequences){
	
	mijnTable<-list()	
	for (i in 1:NumberOfPosition(Sequences)){
		mijnTable[[i]]<-list()
		Characters <- CharactersAtPositioni(i,Sequences)
		for (j in Characters){
			mijnTable[[i]][[j]]<-list()
			for (n in names(Sequences)){
				mijnTable[[i]][[j]][[n]]<-IsCharacterAtPositioni(Sequences[[n]],j,i)
			}
		}
	}
	return(mijnTable)
}


Compute_mnij_Table <- function(Sequences){
	
	mnijTable<-list()
	for (n in names(Sequences)){	
		mnijTable[[n]]<-list()
		for (i in 1:NumberOfPosition(Sequences)){
			Characters <- CharactersAtPositioni(i,Sequences)
			mnijTable[[n]][[i]]<-list()
			for (j in Characters){
				mnijTable[[n]][[i]][[j]]<-IsCharacterAtPositioni(Sequences[[n]],j,i)
			}
		}
	}
	return(mnijTable)
}

# Weighted frequencies of sequences
Compute_Weighted_Frequencies<-function(Sequences,Weights,mijnTable){
	
	# Total weight
	W <- ComputeTotalWeight(Weights)

	GetWeightedFrequency_ijn<-function(n,j,i,Weights,mijnTable,Sequences){	
		WFijn = Weights[[n]]*mijnTable[[i]][[j]][[n]]
		return(WFijn)	
	}

	GetWeightedFrequency_ij<-function(j,i,Weights,mijnTable,Sequences,W){
		# For all sequences
		WFijns<-lapply(as.list(names(Sequences)),GetWeightedFrequency_ijn,j,i,Weights,mijnTable,Sequences)
		WFij <- (1/W) * sum(unlist(WFijns))
		#names(WFij)<-names(Sequences)
		return(WFij)
	}

	GetWeightedFrequency_i<-function(i,Weights,mijnTable,Sequences,W){
		Characters <- CharactersAtPositioni(i,Sequences)
		WFi<-lapply(as.list(Characters),GetWeightedFrequency_ij,i,Weights,mijnTable,Sequences,W)
		names(WFi)<-Characters
		return(WFi)
	}

 	# Create a list of weighted frequencies per position and character
	WeightedFrequencies <- lapply(as.list(1:NumberOfPosition(Sequences)),GetWeightedFrequency_i,Weights,mijnTable,Sequences,W)

	return(WeightedFrequencies)

}


# Compute global entropy using weights
ComputeEntropy<-function(Sequences,Weights,mijnTable){

	# Weighted frequency
	WFs <- Compute_Weighted_Frequencies(Sequences,Weights,mijnTable)
	
	# get a vector
	WFsv<-unlist(WFs)

	# Get weighted entropy
	Entropy <- -sum(WFsv*log(WFsv))

	return(Entropy)

}


# Gradient function per Sequence function
GradientFunctionOfSequence<-function(n,Weights,mnijTable,mijnTable,Sequences){

	# Total weight
	W <- ComputeTotalWeight(Weights)

	# Weighted frequency
	WFs = Compute_Weighted_Frequencies(Sequences,Weights,mijnTable)

	# get a vector
	WFsv<-unlist(WFs)

	mijv<-unlist(mnijTable[[n]])


	# From equation 16 separated into 2 subfunction
	#Part1<-sum(mijv*log(WFsv))
	#Part2<-sum(WFsv*log(WFsv))

	#return( (-1/W) * (Part1 - Part2) )
	
	# Get derivative of entropy, Eq. 18
	
	# Prob 
	Psn<-prod(unlist(WFs)^unlist(mnijTable[[n]]))
	
	# Compute S
	Psnall<-c()
	for (n2 in names(Weights)){
	   Psnall<-c(Psnall,prod(unlist(WFs)^unlist(mnijTable[[n2]])))
	}
	
	S <- -(1/W) * sum(unlist(Weights)*log(Psnall))
	
	# return derivative
	dSdwn<- -(W^-1) * (log(Psn) + S)
	
	return(dSdwn)
	

}

# Gradien Ascent function
GradientAscentFunction<-function(Sequences,Weights,mijnTable,mnijTable,NumberOfIteration,StepFactor){

	OldEntropy<-ComputeEntropy(Sequences,Weights,mijnTable)
	cat(paste("Entropy with uniform weight:",OldEntropy,"\n"))
	
	for (step in 1:NumberOfIteration){
		for (n in names(Sequences)){
			Weights[[n]] = Weights[[n]] + StepFactor * GradientFunctionOfSequence(n,Weights,mnijTable,mijnTable,Sequences)
			if (Weights[[n]]<=0){Weights[[n]]<-0}
		}
				
		if (step %% 100 == 0){
		
			#for (n in names(Sequences)){
		   #   cat(paste(n,Weights[[n]],"\n"))
		   #   cat("\n\n")
		   #}  
		
			NewEntropy <- ComputeEntropy(Sequences,Weights,mijnTable)
			if (NewEntropy == OldEntropy){
				cat(paste(OldEntropy,NewEntropy,"\n"))
				break
			} else {
				cat(paste("Old Entropy:",OldEntropy,"New Entropy",NewEntropy,"\n"))
				OldEntropy <- NewEntropy
			}
		}
	}

	return(Weights)
}

# Weights scaled to 1
NormalizeWeights<-function(Weights){

	W <- ComputeTotalWeight(Weights)
	
	for (n in names(Weights)){
		Weights[[n]] <- Weights[[n]]/W
	}
	return(Weights)
}


				 	
# Compute entropy maximization of sequences using gradient asendent 
EntropyMaximization<-function(Sequences,NumberOfIteration=10000,StepFactor=1){

	# * ---- Before calculation ---- *
	
	# Set default weight
	Weights <- SetWeights(Sequences)

	# Compute some table (n=sequence,j=character,i=position)
	mijnTable <- Compute_mijn_Table(Sequences)
	mnijTable <- Compute_mnij_Table(Sequences)

	# be sure to have character
	names(Sequences)<-as.character(names(Sequences))

	# Compute gradient ascent to maximize entropy
	Weights <- GradientAscentFunction(Sequences,Weights,mijnTable,mnijTable,NumberOfIteration,StepFactor)

	# Normalize weights
	Weights <- NormalizeWeights(Weights)

	# Get a vector of weight
	Weights<-unlist(Weights)

	return(Weights)

}



