# Cohen's pooled standard deviation
CohensPooledSD<-function(SD1,SD2,n1,n2){
	PooledSD <- sqrt( ((n1-1)*SD1^2 - (n2-1)*SD2^2) / (n1+n2-2) )
	return(PooledSD)

}

# Cohen's D calculation from vector of values
CohensD<-function(Dataset1,Dataset2){

	# Mean value calculation
	Mean1<-mean(Dataset1,na.rm=T)
	Mean2<-mean(Dataset2,na.rm=T)
	
	# SD calculation
	SD1<-sd(Dataset1,na.rm=T)
	SD2<-sd(Dataset2,na.rm=T)

	# Size sample
	n1<-length(Dataset1)
	n2<-length(Dataset2)

	# Pooled SD calculation
	if (n1 > 1 & n2 > 1){
		PooledSD<-CohensPooledSD(SD1,SD2,n1,n2)
	} else {
		if (n1 > n2){PooledSD<-SD1}
		if (n2 > n1){PooledSD<-SD2}
	}
	
	# Cohen's D calculation
	CohensD<- (Mean1 - Mean2) / PooledSD

	return(CohensD)

}
