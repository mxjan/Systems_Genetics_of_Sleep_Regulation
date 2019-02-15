GenerateFiles<-function(Phenotypes,Mice,Output,Tissu,Condition,PhenotypesType){
	# Require Phenotype Data:
	if (PhenotypesType=="S"){Pheno<-read.table(FileSleepPhenotype,header=T)}
	if (PhenotypesType=="M" & Condition == "NSD"){Pheno<-read.table(FileMetaboliteNSDPhenotype,header=T)}
	if (PhenotypesType=="M" & Condition == "SD"){Pheno<-read.table(FileMetaboliteSDPhenotype,header=T)}

	# Require Genotype Data
	Geno<-read.table(FileGenotype,header=T)

	# Require Expression Data for eQTL
	if (Tissu=="C" & Condition == "NSD"){ExpreQTL<-read.table(FileExpressionCortexNSD)}	
	if (Tissu=="C" & Condition == "SD"){ExpreQTL<-read.table(FileExpressionCortexSD)}
	if (Tissu == "L" & Condition == "NSD"){ExpreQTL<-read.table(FileExpressionLiverNSD)}
	if (Tissu == "L" & Condition == "SD"){ExpreQTL<-read.table(FileExpressionLiverSD)}
	
	name<-Mice

	 # Selection
	Phenotypes<-c("ID",Phenotypes)
	PhenoSelect<-matrix(nrow=0,ncol=length(Phenotypes))
	for (i in Mice){
	  PhenoSelect<-rbind(PhenoSelect,Pheno[Pheno$ID %in% i,colnames(Pheno) %in% Phenotypes])
	}
	PhenoSelect$ID<-name
	write.table(PhenoSelect,file=paste(Output,'.pheno',sep=''),sep='\t',row.names = F,col.names = T,quote=F)
	
	MiceGeno<-c("Chr","Locus","cM","Mb",Mice)
	GenoSelect<-matrix(nrow=nrow(Geno),ncol=0)
	for (i in MiceGeno){
	  GenoSelect<-cbind(GenoSelect,Geno[,i,drop=F])
	}
	colnames(GenoSelect)<-c("Chr","Locus","cM","Mb",name)
	write.table(GenoSelect,file=paste(Output,'.geno',sep=''),sep='\t',row.names = F,col.names = T,quote=F)
	
	ExpreQTLSelect<-matrix(nrow=nrow(ExpreQTL),ncol=0)
	for (i in Mice){
	  ExpreQTLSelect<-cbind(ExpreQTLSelect,ExpreQTL[,i,drop=F])
	}
	colnames(ExpreQTLSelect)<-name
	write.table(ExpreQTLSelect,file=paste(Output,'.log2Expr',sep=''),sep='\t',row.names = T,col.names = T,quote=F)
  
	library(psych)
        
	#print(dim(PhenoSelect[,-1,drop=F]))
	#print(dim(ExpreQTLSelect))

	Corre<-t(corr.test(PhenoSelect[,-1,drop=F],t(ExpreQTLSelect),use="pairwise.complete.obs",method="pearson",adjust="none",alpha=1,ci=F)$p)
	colnames(Corre)<-paste(colnames(PhenoSelect)[-1],"Correlation",sep='_')
	write.table(Corre,file=paste(Output,'.corr',sep=''),sep='\t',row.names = T,col.names = T,quote=F)

	return(c(file=paste(Output,'.pheno',sep=''),paste(Output,'.geno',sep=''),paste(Output,'.log2Expr',sep='')))

}

