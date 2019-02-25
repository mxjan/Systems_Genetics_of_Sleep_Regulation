# SEE ALSO Whole Brain and Brain Regional Coexpression Network Interactions Associated with Predisposition to Alcohol Consumption 2013 for similar example

library(qvalue)
cisthreshold<-1
DataDir<-"~/PhD/"
# Load Phenotype
load(paste(DataDir,"Rdata/SleepPhenotype2.Rdata",sep=''))
source(paste(DataDir,"Scripts/BXDpcor_V1.0.1.R",sep=''))

# Load data expression
CNSD<-read.table(paste(DataDir,"GeneExpression/NormalizedExpression/htseq-count_summary.txt.NSD.CPMnormalizedWITHNSDSD.txt",sep=''),header=T,row.names=1)
CNSD<-CNSD[,rownames(traitData)]
CSD<-read.table(paste(DataDir,"GeneExpression/NormalizedExpression/htseq-count_summary.txt.SD.CPMnormalizedWITHNSDSD.txt",sep=''),header=T,row.names=1)
CSD<-CSD[,rownames(traitData)]
LNSD<-read.table(paste(DataDir,"GeneExpression/NormalizedExpression/htseq-count_summary.Liver.txt.NSD.CPMnormalizedWITHNSDSD.txt",sep=''),header=T,row.names=1)
LNSD<-LNSD[,rownames(traitData)]
LSD<-read.table(paste(DataDir,"GeneExpression/NormalizedExpression/htseq-count_summary.Liver.txt.SD.CPMnormalizedWITHNSDSD.txt",sep=''),header=T,row.names=1)
LSD<-LSD[,rownames(traitData)]


# Read cis-eQTL
# Correction for multiple test using qvalue R packages as suggested by Ongen et al.
eQTLCorrection<-function(t){
  t<-t[! duplicated(t[,1]),] # remove duplicated rownames (1)
  qt<-qvalue(t$V10)
  qt<-as.matrix(qt$qvalues)
  rownames(qt)<-t$V1
  qt[is.na(qt)]<-1
  qt<-as.data.frame(qt)
  qt[,2]<-t[,6]
  qt<-qt[qt[,1]<=cisthreshold,,drop=F]
  return(qt)
}

cisCNSD<-read.table(paste(DataDir,"Rdata/ciseQTL.Cortex.NSD.txt",sep=''))
qcisCNSD<-eQTLCorrection(cisCNSD)

cisCSD<-read.table(paste(DataDir,"Rdata/ciseQTL.Cortex.SD.txt",sep=''))
qcisCSD<-eQTLCorrection(cisCSD)

cisLNSD<-read.table(paste(DataDir,"Rdata/ciseQTL.Liver.NSD.txt",sep=''))
qcisLNSD<-eQTLCorrection(cisLNSD)

cisLSD<-read.table(paste(DataDir,"Rdata/ciseQTL.Liver.SD.txt",sep=''))
qcisLSD<-eQTLCorrection(cisLSD)

####################
formatData<-function(Expr,cis){
  Strains<-colnames(Expr)
  GenotypeMatrix<-read.table(paste(DataDir,"Rdata/Genotype.FormatedName.geno",sep=''),header=T)
  Genepos<-read.table(paste(DataDir,"Rdata/RefSeqMiddlePosition.table",sep=''),header=T)
  Genepos[,1]<-gsub("chr",'',Genepos[,1])
  Genepos<-Genepos[as.character(rownames(Expr)),]
  cisv<-cis[,2]
  names(cisv)<-rownames(cis)
  cisv<-as.character(cisv[rownames(Expr)])
  names(cisv)<-as.character(rownames(Expr))
  
  Notincis<-c()
  
  for (gene in names(cisv[is.na(cisv)])){
    if (gene %in% rownames(cis)){
      chr<-Genepos[gene,1]
      pos<-Genepos[gene,2]
      tmpGM<-GenotypeMatrix[GenotypeMatrix[,1]==chr,]
      tmpGM[,4]<-abs(pos-tmpGM[,4])
      cisv[gene]<-as.character(tmpGM[which(tmpGM[,4]==min(tmpGM[,4])),2])
    }else {Notincis<-c(Notincis,gene)}
  }
  cisvfinal<-cisv[-which(names(cisv) %in% Notincis)]
  Exprfinal<-Expr[-which(rownames(Expr) %in% Notincis),]
  return(list(Exprfinal,cisvfinal))
}

form<-formatData(LSD,qcisLSD)
LSDformated<-form[[1]]
cisLSDformated<-form[[2]]

form<-formatData(CSD,qcisCSD)
CSDformated<-form[[1]]
cisCSDformated<-form[[2]]

form<-formatData(LNSD,qcisLNSD)
LNSDformated<-form[[1]]
cisLNSDformated<-form[[2]]

form<-formatData(CNSD,qcisCNSD)
CNSDformated<-form[[1]]
cisCNSDformated<-form[[2]]

#s<-sample(seq(1,nrow(LSDformated)),100)
#LSDformated1<-LSDformated[s,]
#cisLDSformated1<-cisLDSformated[s]


GenotypeMatrix<-read.table(paste(DataDir,"Rdata/Genotype.FormatedName.geno",sep=''),header=T)
Nmarker<-as.character(GenotypeMatrix$Locus)
GenotypeMatrix<-GenotypeMatrix[,colnames(LSDformated)]
rownames(GenotypeMatrix)<-Nmarker

rm(cisCNSD,cisCSD,cisLNSD,cisLSD,CNSD,CSD,form,LNSD,LSD,qcisCNSD,qcisCSD,qcisLSD,qcisLNSD,traitData)
invisible(gc())

# Use only a sample of data for testing
#s<-sample(seq(1,nrow(LSDformated)),50)
#LSDformated1<-LSDformated[s,]
#cisLSDformated1<-cisLSDformated[s]

#t<-BXDpcor(LSDformated1,cisLSDformated1,LSDformated1,cisLSDformated1,GenotypeMatrix,CORES=20,method="spearman")
#save(t,file="/scratch/cluster/monthly/mjan/pcor_Sample50_spearman__LiverSD_LiverSD.Rdata")

t<-BXDpcor(CNSDformated,cisCNSDformated,CNSDformated,cisCNSDformated,GenotypeMatrix,CORES=30,method="pearson")
#t<-c("a")

save(t,file="/scratch/beegfs/monthly/mjan/pcor_pearson_additiveonly_CortexNSD_CortexNSD.Rdata")

# Controls
#Expr1<-as.numeric(LSDformated["Acot11",])
#Expr2<-as.numeric(LSDformated["Asrgl1",])
#g1<-as.factor(as.character(GenotypeMatrix[as.character(cisLSDformated["Acot11"]),]))
#g2<-as.factor(as.character(GenotypeMatrix[as.character(cisLSDformated["Asrgl1"]),]))
#cor(lm(Expr1~g1*g2)$residuals,lm(Expr2~g1*g2)$residuals)

# bsub -o test.out -e err.out -n 30 -R "rusage[mem=10000]" -M 15000000 "Rscript GetPartialCorrelationForBXD.R"
# bpeek 756775 | grep -P '14634' | wc -l ; date
