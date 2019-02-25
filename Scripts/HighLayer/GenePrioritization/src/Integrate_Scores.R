
Integrate_ph_m_QTLResult<-function(ScoresMatrix,ScoringType = "pvalue"){

	if (ScoringType == "pvalue"){
		QTLScore<-as.vector(MatrixProba)

	} else {print("NOT AVAILABLE YET")}

	ScoresMatrix<-cbind(ScoresMatrix,QTLScore)
	colnames(ScoresMatrix)[ncol(ScoresMatrix)]<-"QTLScore"
	return(ScoresMatrix)
}



Integrate_eQTLResult<-function(ScoresMatrix,ScoringType = "pvalue"){
	eQTLresults<-read.table(paste(OutputName,".ciseQTL.txt",sep=''))

	if (ScoringType == "pvalue"){
		cisVector<-as.vector(eQTLresults[,1])
		names(cisVector)<-rownames(eQTLresults)
		cisVector<-cisVector[rownames(ScoresMatrix)]	
		cisVector[is.na(cisVector)]<-1
		cisVector<-(-log10(cisVector))
		
	} else {print("NOT AVAILABLE YET")}

	ScoresMatrix<-cbind(ScoresMatrix,cisVector)
	colnames(ScoresMatrix)[ncol(ScoresMatrix)]<-"eQTLScore"
	return(ScoresMatrix)
}

Integrate_CorResult<-function(ScoresMatrix){
	Corr<-read.table(paste(OutputName,".corr",sep=''))

	CorrVector<-as.vector(Corr[,1])
	names(CorrVector)<-rownames(Corr)
	CorrVector<-CorrVector[rownames(ScoresMatrix)]
	CorrVector[is.na(CorrVector)]<-1
	CorrVector<-(-log10(CorrVector))

	ScoresMatrix<-cbind(ScoresMatrix,CorrVector)
	colnames(ScoresMatrix)[ncol(ScoresMatrix)]<-"CorrelationScore"
	return(ScoresMatrix)
	
}

Integrate_VariationResult<-function(ScoresMatrix){
	VarAnnot<-read.table(VariantAnnotationFile)

	# Variations
	VarScores<-c()
	for (i in rownames(ScoresMatrix)){
		ScoreVar<-0
		ta<-table(VarAnnot[VarAnnot$V1==i,2])
		nonsyn<-ta["nonsynonymous"]*1
		splicing<-ta["splicing"]*5
		stopgain<-ta["stopgain"]*10
		stoploss<-ta["stoploss"]*10
		frame<-ta["frameshift"]*10
		nonframe<-ta["nonframeshift"]*1
		ScoreVar<-nonsyn+splicing+stopgain+stoploss+nonframe+frame
		names(ScoreVar)<-i
		VarScores<-c(VarScores,ScoreVar)
	}
	names(VarScores)<-rownames(ScoresMatrix)
	# Add polyphen2 results
	Poly<-read.table(FilePolyphen2)
	for (i in 1:nrow(Poly)){
		na<-as.character(Poly[i,1])
		VarScores[na]<-VarScores[na]-1+as.integer(10*Poly[i,2])
	}
	VarScores[is.na(VarScores)]<-0

	ScoresMatrix<-cbind(ScoresMatrix,VarScores)
	colnames(ScoresMatrix)[ncol(ScoresMatrix)]<-"VariationScore"
	return(ScoresMatrix)

}

Integrate_DifferentialExpressionResult<-function(ScoresMatrix,ScoringType = "pvalue"){

	if (Tissu=="C"){DE<-read.table(LimmaCortex,header=T,row.names=1)}
	if (Tissu=="L"){DE<-read.table(LimmaLiver,header=T,row.names=1)}

	# For scoring we use p-value
	if (ScoringType == "pvalue"){
		DEScores<-as.vector(DE[rownames(ScoresMatrix),5])
		names(DEScores)<-rownames(ScoresMatrix)
		DEScores[is.na(DEScores)]<-1
		DEScores<-(-log10(DEScores))
	
	# For scoring we use fold-Change	
	} else if (ScoringType == "effect-size") {
		DEScores<-as.vector(DE[rownames(ScoresMatrix),1])
		DEScores[DE[rownames(ScoresMatrix),5]>0.05]<-0 # not significant change are set to 0
		names(DEScores)<-rownames(ScoresMatrix)
		DEScores[is.na(DEScores)]<-0
		DEScores<-abs(DEScores)
	}

	ScoresMatrix<-cbind(ScoresMatrix,DEScores)
	colnames(ScoresMatrix)[ncol(ScoresMatrix)]<-"DEScore"
	return(ScoresMatrix)

}
