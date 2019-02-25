
MinMaxNormalization<-function(Scores,maxvalue){
	Scores<-(Scores - min(Scores)) / (maxvalue - min(Scores))
}


Rescale_ph_m_QTLResult<-function(ScoresMatrixRescaled,RescaleType="interval"){
	idxcol<-which(colnames(ScoresMatrixRescaled) == "QTLScore")
	QTLRescaled<-ScoresMatrixRescaled[,idxcol]

	if (RescaleType == "interval"){
		# Winsorization of all QTL results for all ph/m-QTL at 0.99, See ScoringView_QTLNorm.html, constant value
		QTLWINSORIZATION<-1.5  #1.638272
		QTLRescaled[QTLRescaled>QTLWINSORIZATION]<-QTLWINSORIZATION
	
		# min max normalization
		QTLRescaled<-MinMaxNormalization(QTLRescaled,maxvalue=QTLWINSORIZATION)
		
	} 
	#	else if (RescaleType == "rank"){
	#	QTLRescaled[QTLRescaled>=(-log10(0.63))]<-rank(QTLRescaled[QTLRescaled>=(-log10(0.63))])
	#	QTLRescaled[QTLRescaled<(-log10(0.63))]<-0

		# rank in of  6 12  4 12  4  1  1  8  6  7  9  8 will give: 3 7 2 7 2 1 1 5 3 4 6 5
	#	rankorder<-seq(1,length(unique(rank(QTLRescaled))))
	#	names(rankorder)<-as.character(sort(unique(rank(QTLRescaled))))
	#	QTLRescaled<-as.vector(rankorder[as.character(rank(QTLRescaled))])
	
	#	QTLRescaled<-MinMaxNormalization(QTLRescaled,maxvalue=max(QTLRescaled))
	#}

	ScoresMatrixRescaled[,idxcol]<-QTLRescaled
	return(ScoresMatrixRescaled)
}

Rescale_eQTLResult<-function(ScoresMatrixRescaled,RescaleType="interval"){

	idxcol<-which(colnames(ScoresMatrixRescaled) == "eQTLScore")
	eQTLRescaled<-ScoresMatrixRescaled[,idxcol]

	if (RescaleType == "interval"){
		#EQTLWINSORIZATION<-quantile(eQTLRescaled[eQTLRescaled>=(-log10(0.05))],prob=0.999) # default is 0.99, V8: 0.9995
		EQTLWINSORIZATION<-quantile(eQTLRescaled,prob=0.999) 
		eQTLRescaled[eQTLRescaled>EQTLWINSORIZATION]<-EQTLWINSORIZATION

		# min max normalization
		eQTLRescaled<-MinMaxNormalization(eQTLRescaled,maxvalue=EQTLWINSORIZATION)

	} else if (RescaleType == "rank"){
		eQTLRescaled[eQTLRescaled>=(-log10(0.05))]<-rank(eQTLRescaled[eQTLRescaled>=(-log10(0.05))])
		eQTLRescaled[eQTLRescaled<(-log10(0.05))]<-0
		eQTLRescaled<-MinMaxNormalization(eQTLRescaled,maxvalue=max(eQTLRescaled))
	}

	ScoresMatrixRescaled[,idxcol]<-eQTLRescaled
	return(ScoresMatrixRescaled)
}

Rescale_CorrResult<-function(ScoresMatrixRescaled,RescaleType="interval"){

	idxcol<-which(colnames(ScoresMatrixRescaled) == "CorrelationScore")
	CorRescaled<-ScoresMatrixRescaled[,idxcol]

	if (RescaleType == "interval"){
		CORWINSORIZATION<-5.0 # Is equivalent to a winsorization of 0.999 using correlation of all gene with all phenotypes, default: 5.5, V8: Depend on tissu
		CorRescaled[CorRescaled>CORWINSORIZATION]<-CORWINSORIZATION

		# min max normalization
		CorRescaled<-MinMaxNormalization(CorRescaled,maxvalue=CORWINSORIZATION)

	} else if (RescaleType == "rank"){
		CorRescaled[CorRescaled>=(-log10(0.05))]<-rank(CorRescaled[CorRescaled>=(-log10(0.05))])
		CorRescaled[CorRescaled<(-log10(0.05))]<-0
		CorRescaled<-MinMaxNormalization(CorRescaled,maxvalue=max(CorRescaled))
	}

	ScoresMatrixRescaled[,idxcol]<-CorRescaled
	return(ScoresMatrixRescaled)
}


Rescale_VarResult<-function(ScoresMatrixRescaled,RescaleType="interval"){

	idxcol<-which(colnames(ScoresMatrixRescaled) == "VariationScore")
	VarRescaled<-ScoresMatrixRescaled[,idxcol]

	if (RescaleType == "interval"){
		VARWINSORIZATION<-quantile(VarRescaled[VarRescaled>0],prob=0.95) # default: 0.999, V8: Max is 15	
		VarRescaled[VarRescaled>VARWINSORIZATION]<-VARWINSORIZATION

		# min max normalization
		VarRescaled<-MinMaxNormalization(VarRescaled,maxvalue=VARWINSORIZATION)

	} else if (RescaleType == "rank"){
		VarRescaled[VarRescaled>=1]<-rank(VarRescaled[VarRescaled>=1],ties.method="random")
		VarRescaled<-MinMaxNormalization(VarRescaled,maxvalue=max(VarRescaled))
	}

	ScoresMatrixRescaled[,idxcol]<-VarRescaled
	return(ScoresMatrixRescaled)
}

Rescale_DEResult<-function(ScoresMatrixRescaled,RescaleType="interval"){

	idxcol<-which(colnames(ScoresMatrixRescaled) == "DEScore")
	DERescaled<-ScoresMatrixRescaled[,idxcol]

	if (RescaleType == "interval"){
		#DEWINSORIZATION<-quantile(DERescaled[DERescaled>0],prob=0.995) #  default: 0.999, V8 = 0.995	
		DEWINSORIZATION<-quantile(DERescaled,prob=0.995)
		DERescaled[DERescaled>DEWINSORIZATION]<-DEWINSORIZATION

		# min max normalization
		DERescaled<-MinMaxNormalization(DERescaled,maxvalue=DEWINSORIZATION)

	} else if (RescaleType == "rank") {
		DERescaled[DERescaled>0]<-rank(DERescaled[DERescaled>0])
		DERescaled<-MinMaxNormalization(DERescaled,maxvalue=max(DERescaled))
	}

	ScoresMatrixRescaled[,idxcol]<-DERescaled
	return(ScoresMatrixRescaled)
}


