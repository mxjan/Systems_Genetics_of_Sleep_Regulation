#GOAL This R script detects mQTL using R/qtl packages.

#INPUT The input file is a file with the formatted genotypes and metabolites FC (intermediate phenotypes) where position is in cM (for example "results/QTL_detection/mQTL/logFC/formatted_genotypes_metaboliteslogFC.csv") and in MB (for example "results/QTL_detection/mQTL/logFC/formatted_genotypes_metaboliteslogFC.csv.MBDistance.QTLR").

#OUTPUT The output files are table and graphs.

#TODO MODIF QTL DETECTION

# load the library
library(qtl)

# create a data.frame of class qtl
QTL <- read.cross("csv",file="results/QTL_detection/mQTL/SD/formatted_genotypes_metabolitesSD.csv",genotypes=c("BB", "BD", "DD","EE","FF"),allele=c("B", "D"),estimate.map=FALSE,na.strings=c("NA","-"))
#33 individuals, 11186 markers, 126 phenotypes.
# convert the cross to recombinant inbred lines (RIL)
QTL <- convert2risib(QTL)
# jitter markers that are close (for vizalisation purposes)
QTL <- jittermap(QTL,amount=1e-6)
# calculates probability of genotype error using HMM, considering that the genotype error probability is 0.065 (~ 0.05% of difference between GeneNetwork and variant calling from RNA-seq data)
QTL <- calc.genoprob(QTL, step=1,error.prob=0.065)

# Repeat the same steps on the input file with position in MB.
QTLMB <- read.cross("csv",file="results/QTL_detection/mQTL/SD/formatted_genotypes_metabolitesSD.csv.MBDistance.QTLR",genotypes=c("BB", "BD", "DD","EE","FF"),allele=c("B", "D"),estimate.map=FALSE,na.strings=c("NA","-"))
QTLMB <- convert2risib(QTLMB)
QTLMB <- jittermap(QTLMB,amount=1e-6)
QTLMB <- calc.genoprob(QTLMB, step=1,error.prob=0.065)

# perform single QTL detection (single QTL means no epistasis)
scanMB <- scanone(QTLMB,method="em")

# create a function that detects size (in MB) of peaks
estimateMBLocation<-function(name,QTL.scan,scanMB){
  idxQTLscan<-which(rownames(QTL.scan)==name)
  before<-idxQTLscan-1
  after<-idxQTLscan+1
  MarkerBefore<-0
  MarkerAfter<-0
  while(MarkerBefore==0 | MarkerAfter==0){
    if(any(grep("^c.+\\.loc-*[0-9]+(\\.[0-9]+)*$",rownames(QTL.scan)[before]))){
      before<-before-1
    }else{MarkerBefore<-rownames(QTL.scan)[before]}
    if(any(grep("^c.+\\.loc-*[0-9]+(\\.[0-9]+)*$",rownames(QTL.scan)[after]))){
      after<-after+1
    }else{MarkerAfter<-rownames(QTL.scan)[after]}
  }
  r<-as.numeric(QTL.scan[MarkerAfter,2])-as.numeric(QTL.scan[MarkerBefore,2])
  d<-as.numeric(QTL.scan[name,2])-as.numeric(QTL.scan[MarkerBefore,2])
  pct<-d/r
  r<-as.numeric(scanMB[MarkerAfter,2])-as.numeric(scanMB[MarkerBefore,2]) 
  return(as.numeric(scanMB[MarkerBefore,2])+(r*pct))
}

# function that detects QTL reaching a certain significance threshold
QTLPeakDetection<-function(a,diff,lod,SuggThresh,SignifThresh,scanMB){
  results<-matrix(nrow=0,ncol=9)
  # Separate analysis per chromosome
  am<-matrix(ncol=3,nrow=length(a$pos))
  am[,1]<-a$chr
  am[,2]<-a$pos
  am[,3]<-a$lod
  rownames(am)<-rownames(a)
  for (chr in levels(as.factor(am[,1]))){
    # Separate peak with position difference in range of diff
    pos<-am[,2][am[,3]>=SuggThresh & am[,1]==chr]
    breaks <- cumsum(c(0, diff(pos) >diff))
    spl<-split(pos, breaks)
    if (length(spl[[1]])>0){
      for(i in spl){
        minpos <- min(i)-0.01
        maxpos <- max(i)+0.01
        l<-am[,3][am[,1]==chr & am[,2]>minpos & am[,2]<maxpos]
        lp<-am[,2][am[,1]==chr & am[,2]>minpos & am[,2]<maxpos]
        idxPeak<-which(rownames(am) == names(l)[which(l==max(l))[1]])
        idxEnd<-which(rownames(am) == names(lp)[which(lp==max(lp))[1]])
        idxStart<-which(rownames(am) == names(lp)[which(lp==min(lp))[1]])
        peakLod<-am[idxPeak,3]
	if(length(peakLod)>1){
		peakLod<-peakLod[1]
	}
        # End QTL within Lod interval
        LodEnd<-"No"
        # End QTL within Lod interval
        LodStart<-"No"
        while(LodEnd=="No" | LodStart=="No"){
          if(LodEnd == "No"){
            if((idxEnd == nrow(am))| ((am[idxEnd,3]) <= (peakLod-lod))){
	      # Control if QTL intercal reach start Chromosome
	      if (chr != am[idxEnd,1]){
		ReachEnd<-TRUE
	        LodEnd<-tail(am[,2][am[,1]==chr],1)
	      } else {
		ReachEnd<-FALSE
                LodEnd<-am[idxEnd,2]
	      }
            }else{	
              idxEnd<-idxEnd+1
            }
          }
          if(LodStart=="No"){
            if((idxStart == 1) | ((am[idxStart,3]) <= (peakLod-lod))){
              # Control if the QTL interval reach end Chromosome
	      if (chr != am[idxStart,1]){
	      ReachStart<-TRUE
              LodStart<-head(am[,2][am[,1]==chr],1)
	      } else {
	      ReachStart<-FALSE
              LodStart<-am[idxStart,2]
	      }
            }else{
              idxStart<-idxStart-1
            }
          }
        }
        rtmp<-matrix(nrow=1,ncol=9)
        rtmp[1,1]<-names(LodStart)
        rtmp[1,2]<-LodStart
        rtmp[1,3]<-names(LodEnd)
        rtmp[1,4]<-LodEnd 
        rtmp[1,5]<-chr
        rtmp[1,6]<-peakLod
        if(peakLod>=SignifThresh){
          rtmp[1,7]<-'Signif'
        }else if(peakLod>=SuggThresh){
          rtmp[1,7]<-'Sugg'
        }
	if (ReachStart == FALSE){
        if(any(grep("^c.+\\.loc-*[0-9]+(\\.[0-9]+)*$", names(LodStart)))){
          rtmp[1,8]<-estimateMBLocation(names(LodStart),QTL.scan,scanMB)
        }else{rtmp[1,8]<-scanMB[names(LodStart),2]}}else{rtmp[1,8]<-0.000001}
	if (ReachEnd == FALSE){
        if (any(grep("^c.+\\.loc-*[0-9]+(\\.[0-9]+)*$", names(LodEnd)))){
          rtmp[1,9]<-estimateMBLocation(names(LodEnd),QTL.scan,scanMB)
        }else{rtmp[1,9]<-scanMB[names(LodEnd),2]}}else{rtmp[1,9]<-350}
        results<-rbind(results,rtmp)
      }
    }
  }
  colnames(results)<-c("MarkerStart","cMStart","MarkerEnd","cMEnd","Chr","LODpeak","Signif_Sugg","MbStart","MbEnd")
  return(results)
}

# define a global option: penalty given to force to print values in fixed rather than scientific (exponential form).
options(scipen=999)
# writing output files
cat('',file="results/QTL_detection/mQTL/SD/QTLlist.txt")
cat(c("Phenotype","QTL_Chromosome","Location_in_cM","Location_bp","Suggestive_Significant_QTL","PhenotypeNumber","Lodscore","Percentile","MarkerStart","MarkerEnd"),file="results/QTL_detection/mQTL/SD/QTLlist.txt",sep='\t',append=TRUE)
cat('\n',file="results/QTL_detection/mQTL/SD/QTLlist.txt",sep='',append=TRUE)
cat('',file="results/QTL_detection/mQTL/SD/ProbaMatrix.txt")
cat(c("Pheno",''),file="results/QTL_detection/mQTL/SD/ProbaMatrix.txt",sep='\t',append=TRUE)
cat(rownames(scanMB),file="results/QTL_detection/mQTL/SD/ProbaMatrix.txt",sep='\t',append=TRUE)
cat('\n',file="results/QTL_detection/mQTL/SD/ProbaMatrix.txt",append=TRUE)
# writing Lod Score Matrix
cat('',file='results/QTL_detection/mQTL/SD/LODScoreMatrix.txt')
cat(c("Pheno",''),file="results/QTL_detection/mQTL/SD/LODScoreMatrix.txt",sep='\t',append=TRUE)
cat(rownames(scanMB),file="results/QTL_detection/mQTL/SD/LODScoreMatrix.txt",sep='\t',append=TRUE)
cat('\n',file="results/QTL_detection/mQTL/SD/LODScoreMatrix.txt",append=TRUE)


#find phenotypes of interest
##grep("PC_ae_C38_2", names(QTL$pheno))
##grep("alpha_AAA", names(QTL$pheno))
##names(QTL$pheno)[c(22,90)]
# run permutations
for (i in c(22,90)){
##for (i in 1:(length(QTL$pheno)-2)){
  print(paste("Running:",i,names(QTL$pheno[i]),sep=' '))
  name <- names(QTL$pheno[i])
  QTL.scan <- scanone(QTL,pheno.col=i,method="em",model='normal')
  QTL.scanperm <- scanone(QTL,pheno.col=i,method="em",n.perm=2000,n.cluster=10,model='normal')
  ##load(paste("results/QTL_detection/mQTL/SD/", name,".ScanScanPerm.Rdata",sep=''))
  signifthresh <- summary(QTL.scanperm,alpha=c(0.05,0.63))[[1]]
  suggthresh <- summary(QTL.scanperm,alpha=c(0.05,0.63))[[2]]
  peak <- QTLPeakDetection(QTL.scan,5,1.5,suggthresh,signifthresh,scanMB)

  # plot the QTL detection for the phenotype in pdf format
  pdf(paste("results/QTL_detection/mQTL/SD/",name,".pdf",sep=''),width=8, height=5)
  plot(QTL.scan,main=paste("GN+RNA-Seq\n",name,sep=' '),ylim=c(0,summary(QTL.scanperm,alpha=c(0.05,0.63))[1]+2))
  abline(h=summary(QTL.scanperm,alpha=c(0.05,0.63))[1],col="red")
  abline(h=summary(QTL.scanperm,alpha=c(0.05,0.63))[2],col="blue")
  dev.off() 

  pctil <- ecdf(as.vector(QTL.scanperm))
  probavector <- pctil(as.vector(QTL.scan$lod))
  cat(c(name,''), file="results/QTL_detection/mQTL/SD/ProbaMatrix.txt",sep='\t',append=TRUE)
  cat(probavector, file="results/QTL_detection/mQTL/SD/ProbaMatrix.txt",sep='\t',append=TRUE)
  cat('\n',file="results/QTL_detection/mQTL/SD/ProbaMatrix.txt",append=TRUE)

  cat(c(name,''),file="results/QTL_detection/mQTL/SD/LODScoreMatrix.txt",sep='\t',append=TRUE)
  cat(as.vector(QTL.scan$lod),file="results/QTL_detection/mQTL/SD/LODScoreMatrix.txt",sep='\t',append=TRUE)
  cat('\n',file="results/QTL_detection/mQTL/SD/LODScoreMatrix.txt",append=TRUE)

  save(QTL.scanperm,QTL.scan,file=paste("results/QTL_detection/mQTL/SD/",name,".ScanScanPerm.Rdata",sep=''))
  if (length(peak)>0){
    for(j in 1:nrow(peak)){
      cat(c(name,peak[j,5],paste(peak[j,2],'-',peak[j,4],sep=''),paste('chr',peak[j,5],':',as.numeric(peak[j,8])*1000000,'-',as.numeric(peak[j,9])*1000000,sep=''),peak[j,7],i,peak[j,6],pctil(peak[j,6]),peak[j,1],peak[j,3]),file="results/QTL_detection/mQTL/SD/QTLlist.txt",sep='\t',append=TRUE)
      cat('\n',file="results/QTL_detection/mQTL/SD/QTLlist.txt",sep='',append=TRUE)
  	 }
  }
  cat('\n',file="results/QTL_detection/mQTL/SD/QTLlist.txt",sep='',append=TRUE)

}
