# Written by Maxime Jan Maxime.Jan@sib.swiss

# README

# Function in R to compute partial correlation on BXD gene expression

# Here we take into account the eQTL effect (or genetic effect confounding factor) to compute co-expression data
# Our model is the residuals correlation of two linear model of gene expression explained by the effect of 2 genomic region (the local region or cis-eQTL) and the local region of the partenair genes
# The correlation can be run in parallel (Highly recommended if the number of gene is big !) using the library(parallel)

# The arguments to passed are the following: a gene expression table, a genotype table and a vector containing gene-marker relation (cis-eQTL or closest marker to the gene)

# V1.0.1 Use FastLmPure instead of FastLm (speedup a little)
# The packages RcppEigen is used with the FastLmPure function for faster lm computation

# TO DO: Create package, profiling code, optimize, if still slow -> move part to C using Rcpp functions

#################################### THE FUNCTIONS ###################################
# The Core model function to get residuals value from expression data (numeric vector) and genotype vector (factor)


CorResiduals<-function(ExprData1,ExprData2,Geno1,Geno2){
	mm<-model.matrix(~Geno1*Geno2)
	return(cor(fastLmPure(mm,ExprData1)$residuals,fastLmPure(mm,ExprData2)$residuals))
}


# Parallelized function to lunch model computation for each column of the p.correlation matrix give 1 gene (row)
GetCorList<-function(gene1,ExprList1,ciseQTL1,ExprList2,ciseQTL2,Genolist){
	#print("RUN 1 ROW !")
	print(paste(gene1,which(names(ExprList1)==gene1),length(ExprList1)))
	ExprData1<-ExprList1[[gene1]]
	Geno1<-Genolist[[ciseQTL1[gene1]]]
	names2<-names(ExprList2)
	Genolistsorted<-Genolist[ciseQTL2[names2]]
	CorList<-c()
	for (i in seq(1,length(names2))){
		CorList<-c(CorList,CorResiduals(ExprData1,ExprList2[[i]],Geno1,Genolistsorted[[i]]))
	}
	names(CorList)<-names(ExprList2)
	return(CorList)
}


# Function to run model by row using parallelized function
pCorMatrixCompute<-function(ExprList1,ciseQTL1,ExprList2,ciseQTL2,Genolist,CORES=1){
	GeneList<-names(ExprList1)
	if (CORES > 1){
		invisible(gc())
		CorLists<-mclapply(GeneList,GetCorList,ExprList1,ciseQTL1,ExprList2,ciseQTL2,Genolist,mc.cores=CORES,mc.preschedule=T)
	} else {
		CorLists<-lapply(GeneList,GetCorList,ExprList1,ciseQTL1,ExprList2,ciseQTL2,Genolist)
	}
	CorVectors<-matrix(unlist(CorLists),nrow=length(GeneList),byrow=T)
	rownames(CorVectors)<-GeneList
	colnames(CorVectors)<-names(ExprList2)
	return(CorVectors)
}


# 2 Functions to transform tables into numeric list and factor list
Genolist<-function(x,GenotypeMatrix){
	return(unlist(as.factor(as.character(GenotypeMatrix[x,]))))
}
Exprlist<-function(x,ExprMatrix,method="pearson"){
	if (method == "pearson"){
		return(unlist(as.numeric(ExprMatrix[x,])))
	}
	if (method == "spearman"){
		return(unlist(as.numeric(rank(ExprMatrix[x,]))))
	}
}



# Main function, return a co-expression matrix
BXDpcor<-function(ExprTable1,ciseQTL1,ExprTable2,ciseQTL2,GenoTable,method="pearson",CORES=1){
	library(parallel)
	library(reshape2)
	library(matrixStats)
	library(RcppEigen)
	
	# Get list of genotypes factor per marker 
	if (CORES > 1){
		Genolist<-mclapply(seq(1,nrow(GenoTable)),Genolist,GenoTable,mc.cores=CORES)
	} else {
		Genolist<-lapply(seq(1,nrow(GenoTable)),Genolist,GenoTable)
	}
	names(Genolist)<-rownames(GenoTable)
	# Get list of numeric expression per gene
	if (CORES > 1){
		ExprList1<-mclapply(seq(1,nrow(ExprTable1)),Exprlist,ExprTable1,mc.cores=CORES,method=method)
	} else {
		ExprList1<-lapply(seq(1,nrow(ExprTable1)),Exprlist,ExprTable1,method=method)
	}
	names(ExprList1)<-rownames(ExprTable1)
	if (CORES > 1){
		ExprList2<-mclapply(seq(1,nrow(ExprTable2)),Exprlist,ExprTable2,mc.cores=CORES,method=method)
	} else {
		ExprList2<-lapply(seq(1,nrow(ExprTable2)),Exprlist,ExprTable2,method=method)
	}
	names(ExprList2)<-rownames(ExprTable2)
	pCorMatrix<-pCorMatrixCompute(ExprList1,ciseQTL1,ExprList2,ciseQTL2,Genolist,CORES)
	return(pCorMatrix)
}



