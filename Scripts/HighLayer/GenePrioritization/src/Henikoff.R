HenikoffWeight<-function(ScoresMatrixDisc,Genes){

	# Compute weight using the scores for Genes (here only genes within ph-/m-QTL)
	ws<-matrix(ncol=ncol(ScoresMatrixDisc),nrow=length(Genes))
	colnames(ws)<-colnames(ScoresMatrixDisc)

	k<-1
	for (i in which(rownames(ScoresMatrixDisc) %in% Genes)){
	  x<-ScoresMatrixDisc[i,]
	  wtmp<-c()
	  for (j in table(x)[as.factor(x)]){
	    w<-1/(j*length(unique(x)))
	    wtmp<-c(wtmp,w)
	  }
	  ws[k,]<-wtmp
	  k<-k+1
	}
	weight<-apply(ws,2,sum)

	# Normalize weight
	weight<-weight/sum(weight)

	return(weight)
}

