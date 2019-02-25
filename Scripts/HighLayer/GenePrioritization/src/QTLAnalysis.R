
QTLScan<-function(Input){
	sink("/dev/null") 
	
	# Read file
	QTL<-read.cross("csv",file=Input,genotypes=c("BB", "BD", "DD","EE","FF"),allele=c("B", "D"),estimate.map=FALSE,na.strings=c("NA","-"))

	# We use the RISIB model
	QTL<-convert2risib(QTL)

	# close marker are separated
	QTL<-jittermap(QTL,amount=1e-6)

	# We use a 5% error probability
	QTL <- calc.genoprob(QTL, step=1,error.prob=0.05)

	sink()
	return(QTL)
}

LODScorePerGene<-function(){

	x<-read.table(paste(OutputName,'.LODScoreMatrix.txt',sep=''),header=FALSE,skip=1,row.names=1)
	colnames(x)<-rownames(QTL.scan)
	Allgenes<-read.table(RefSeqData,header=TRUE,row.names=1)
	MatrixProba<-matrix(ncol=0,nrow=nrow(x))
	rownames(MatrixProba)<-rownames(x)
	for (Chr in levels(scanMB$chr)){
		marker<-rownames(scanMB[scanMB$chr==Chr,])
		genes<-Allgenes[Allgenes$Chromosome==paste('chr',Chr,sep=''),]
		markerfilt<-c()
		for (i in marker){
			if(any(grep("^c.+\\.loc-*[0-9]+(\\.[0-9]+)*$", i))){
		}else{
			markerfilt<-c(markerfilt,i)
		}
		}
		PositionMb<-scanMB[markerfilt,]$pos
		PositioncM<-QTL.scan[markerfilt,]$pos
		ap<-approxfun(y=PositioncM,x=PositionMb)
		genes$cM<-ap(genes$Position)
		genes$cM[genes$Position < 30 & is.na(genes$cM)==TRUE]<-0
		genes$cM[genes$Position > 30 & is.na(genes$cM)==TRUE]<-max(genes$cM,na.rm=TRUE)

		marker<-rownames(QTL.scan[QTL.scan$chr==Chr,])
		MatrixProbaTmp<-matrix(ncol=length(genes$cM),nrow=nrow(x))
		for (i in 1:nrow(MatrixProbaTmp)){
			MarkerPostion<-QTL.scan[marker,]$pos
			Proba<-x[i,marker]
			apr<-approxfun(y=Proba,x=MarkerPostion)
			MatrixProbaTmp[i,]<-apr(genes$cM)
			MatrixProbaTmp[i,is.na(MatrixProbaTmp[i,] == TRUE)]<-0
		}
		rownames(MatrixProbaTmp)<-rownames(x)
		colnames(MatrixProbaTmp)<-rownames(genes)
		MatrixProba<-cbind(MatrixProba,MatrixProbaTmp)
	}
	return(MatrixProba)

}

CreateLODMatrix<-function(){
	cat('',file=paste(OutputName,'.LODScoreMatrix.txt',sep=''))
	cat(c("Pheno",''),file=paste(OutputName,'.LODScoreMatrix.txt',sep=''),sep='\t',append=TRUE)
	cat(rownames(scanMB),file=paste(OutputName,'.LODScoreMatrix.txt',sep=''),sep='\t',append=TRUE)
	cat('\n',file=paste(OutputName,'.LODScoreMatrix.txt',sep=''),append=TRUE)

	#print(paste("Running:",i,names(QTL$pheno[i]),sep=' '))
	name<-names(QTL$pheno[1])
	QTL.scan <<- scanone(QTL,pheno.col=1,method="em",model='normal')
	cat(c(name,''),file=paste(OutputName,'.LODScoreMatrix.txt',sep=''),sep='\t',append=TRUE)
	cat(as.vector(QTL.scan$lod),file=paste(OutputName,'.LODScoreMatrix.txt',sep=''),sep='\t',append=TRUE)
	cat('\n',file=paste(OutputName,'.LODScoreMatrix.txt',sep=''),append=TRUE)
}

QTLAnalysis<-function(PhenotypeData,GenotypeData,OutputName){	

	
	# Run QTL analysis using r/qtl
	# 1.1 Create QTLR file, for both cM and MB distance
	system(paste(FormatQTLR,GenotypeData,PhenotypeData,paste(OutputName,'.QTLR',sep='')))
  
	# 1.2 Run r/qtl and create LOD score matrix file
	QTL<<-QTLScan(paste(OutputName,'.QTLR',sep=''))
	QTLMB<<-QTLScan(paste(OutputName,'.QTLR.MBDistance.QTLR',sep=''))
	scanMB<<-scanone(QTLMB,method="em")
	
	# Lod Score Matrix
	CreateLODMatrix()

	# The LOD score Matrix need to be converted into gene position instead of marker position
	MatrixProba<-LODScorePerGene()


	# Control for LOD score is cis-eQTL is present: 	
	# if the LOD score of marker is > 0.5 LOD, the LOD attributed to the gene is the one of the marker
	# Control for LOD score is strong variation are present 
	# If strong variations are present, the LOD of gene is addaped to fit the marker (best marker selected)
	

	# read cis-eQTL analysis
	eQTLresults<-read.table(paste(OutputName,".ciseQTL.txt",sep=''))
	qciseQTL<-as.matrix(eQTLresults[,1])
	rownames(qciseQTL)<-rownames(eQTLresults)
	colnames(qciseQTL)<-paste(OutputName,".ciseQTL.txt",sep='')

	print("LOD score modification")	
	print(paste("Gene","LOD gene (mid position)","LOD marker (ciseQTL)"))

	# eQTL
	LODImproveByeQTL<-c(1)
	LODDecreaseByeQTL<-c(1)
	names(LODImproveByeQTL)<-"NotAGene"
	names(LODDecreaseByeQTL)<-"NotAGene"
	for (g in colnames(MatrixProba)){
	  if (g %in% rownames(qciseQTL) && !is.na(qciseQTL[g,]) && qciseQTL[g,] <= 0.05){
	    marker<-as.character(eQTLresults[rownames(eQTLresults)==g,2])
	    LODmarker<-QTL.scan[marker,3]
	    LODgene<-MatrixProba[1,g]
	    if ((LODmarker-LODgene)>=0.5 & LODmarker>=2){
	      print(paste("Cis-eQTL LOD increase",g,LODgene,LODmarker))
	      LODImproveByeQTL<-c(LODImproveByeQTL,LODmarker)
	      names(LODImproveByeQTL)[length(LODImproveByeQTL)]<-g
	    } else if ((LODmarker-LODgene)<=-0.5 & LODgene>=2){
	      print(paste("Cis-eQTL LOD decrease",g,LODgene,LODmarker))
	      LODDecreaseByeQTL<-c(LODDecreaseByeQTL,LODmarker)
	      names(LODDecreaseByeQTL)[length(LODDecreaseByeQTL)]<-g
	    }
	  }
	}

	# Variations
	# Control for LOD score is strong variation are present 
	# If strong variations are present, the LOD of gene is addaped to fit the marker (best marker selected)
	LODImproveByVar<-c(1)
	LODDecreaseByVar<-c(1)
	names(LODImproveByVar)<-"NotAGene"
	names(LODDecreaseByVar)<-"NotAGene"
	x<-read.table(VariantAnnotationFile)
	y<-read.table(FilePolyphen2)
	for (Chr in unique(x$V6)){
	  marker<-rownames(QTL.scan[QTL.scan$chr==Chr,])
	  markerfilt<-c()
	  for (i in marker){
	    if(any(grep("^c.+\\.loc-*[0-9]+(\\.[0-9]+)*$", i))){
	    }else{
	      markerfilt<-c(markerfilt,i)
	    }
	  }		
	  PositionMb<-scanMB[markerfilt,]$pos
	  ap2<-approxfun(y=QTL.scan[markerfilt,]$lod,x=PositionMb)
	  for (g in unique(x[x$V6==Chr,1])){
	    for (id in which(x$V1==g)){
	      Var<-x[id,2]
	      if (Var %in% c("splicing","stopgain",'stoploss',"frameshift")){
		if (g %in% colnames(MatrixProba)){
		  LODmarker<-ap2(x[id,7]/1000000)
		  LODgene<-MatrixProba[1,g]
		  if (! is.na(LODmarker) & (LODmarker-LODgene)>=0.5 & LODmarker>=2){
		    if (g %in% names(LODImproveByVar)){
			if (LODImproveByVar[g] < LODmarker){
				LODImproveByVar[g]<-LODmarker
			}

		    } else {
		      print(paste("Mutation LOD increase",g,LODgene,LODmarker))
		      LODImproveByVar<-c(LODImproveByVar,LODmarker)
		      names(LODImproveByVar)[length(LODImproveByVar)]<-g
		      #MatrixProba[1,g]<-LODmarker
		    }
		  } else if (! is.na(LODmarker) & (LODmarker-LODgene)<=-0.5 & LODgene>=2){
		    if (! g %in% names(LODDecreaseByVar)){
		      print(paste("Mutation LOD decrease",g,LODgene,LODmarker))
		      LODDecreaseByVar<-c(LODDecreaseByVar,LODmarker)
		      names(LODDecreaseByVar)[length(LODDecreaseByVar)]<-g
		    }
		  }	
		}
	      } else if (g %in% y$V1){
		Pos <- x[id,7]
		if (Pos %in% y[y$V1==as.character(x[id,1]),7]){
		  LODmarker<-ap2(x[id,7]/1000000)	
		  LODgene<-MatrixProba[1,g]	
		  if (! is.na(LODmarker) & (LODmarker-LODgene)>=0.5 & LODmarker>=2){
		    if (g %in% names(LODImproveByVar)){
			if (LODImproveByVar[g] < LODmarker){
				LODImproveByVar[g]<-LODmarker
			}

		    } else {
		      print(paste("Mutation LOD increase",g,LODgene,LODmarker))
		      LODImproveByVar<-c(LODImproveByVar,LODmarker)
		      names(LODImproveByVar)[length(LODImproveByVar)]<-g
		      #MatrixProba[1,g]<-LODmarker
		    }
		  }else if (! is.na(LODmarker) & (LODmarker-LODgene)<=-0.5 & LODgene>=2){
		    if (! g %in% names(LODDecreaseByVar)){
		      print(paste("Mutation LOD decrease",g,LODgene,LODmarker))
		      LODDecreaseByVar<-c(LODDecreaseByVar,LODmarker)
		      names(LODDecreaseByVar)[length(LODDecreaseByVar)]<-g
		    }
		  }					
		}
	      }	
	    }
	  }
	  
	}

	# Apply modification
	print("Modifications applied:")
	for (i in 1:length(LODImproveByeQTL)){
		g<-names(LODImproveByeQTL)[i]
		if (g %in% colnames(MatrixProba)){
			if (! g %in% names(LODImproveByVar) & ! g %in% names(LODDecreaseByVar)){
				print(paste(g,"eQTLI_only","LOD_Increase",MatrixProba[1,g],LODImproveByeQTL[i]))
				MatrixProba[1,g]<-LODImproveByeQTL[i]	
			} else if (g %in% names(LODImproveByVar) & g %in% names(LODDecreaseByVar)){
				print(paste(g,"eQTLI&VarI_D","LOD_Increase",MatrixProba[1,g],max(LODImproveByeQTL[i],LODImproveByVar[i])))
				MatrixProba[1,g]<-max(LODImproveByeQTL[i],LODImproveByVar[i])
			} else if (g %in% names(LODImproveByVar)){
				print(paste(g,"eQTLI&VarI","LOD_Increase",MatrixProba[1,g],max(LODImproveByeQTL[i],LODImproveByVar[i])))
				MatrixProba[1,g]<-max(LODImproveByeQTL[i],LODImproveByVar[i])
			} else if (g %in% names(LODDecreaseByVar)){
				print(paste(g,"eQTLI&VarD","LOD_Increase",MatrixProba[1,g],LODImproveByeQTL[i]))
				MatrixProba[1,g]<-LODImproveByeQTL[i]
			} else {print ("ERROR !!!!!!!!!!!!!!!!!!!!!!!!!")}
		}
	}
	for (i in 1:length(LODDecreaseByeQTL)){
		g<-names(LODDecreaseByeQTL)[i]
		if (g %in% colnames(MatrixProba)){
			if (! g %in% names(LODImproveByVar) & ! g %in% names(LODDecreaseByVar)){
				print(paste(g,"eQTLD_only","LOD_Decrease",MatrixProba[1,g],LODDecreaseByeQTL[i]))
				MatrixProba[1,g]<-LODDecreaseByeQTL[i]	
			} else if (g %in% names(LODImproveByVar) & g %in% names(LODDecreaseByVar)){
				print(paste(g,"eQTLD&VarI_D","LOD_Increase",MatrixProba[1,g],LODImproveByVar[i]))
				MatrixProba[1,g]<-LODImproveByVar[i]
			} else if (g %in% names(LODImproveByVar)){
				print(paste(g,"eQTLD&VarI","LOD_Increase",MatrixProba[1,g],LODImproveByVar[i]))
				MatrixProba[1,g]<-LODImproveByVar[i]
			} else if (g %in% names(LODDecreaseByVar)){
				print(paste(g,"eQTLD&VarD","LOD_Decrease",MatrixProba[1,g],max(LODDecreaseByeQTL[i],LODDecreaseByVar[i])))
				MatrixProba[1,g]<-max(LODDecreaseByeQTL[i],LODDecreaseByVar[i])
			} else {print ("ERROR !!!!!!!!!!!!!!!!!!!!!!!!!")}
		}		
	}
	for (i in 1:length(LODImproveByVar)){
		g<-names(LODImproveByVar)[i]
		if (g %in% colnames(MatrixProba)){
			if (! g %in% names(LODImproveByeQTL) & ! g %in% names(LODDecreaseByeQTL)){
				print(paste(g,"VarI_only","LOD_Increase",MatrixProba[1,g],LODImproveByVar[i]))
				MatrixProba[1,g]<-LODImproveByVar[i]
			}
		}
	}
	for (i in 1:length(LODDecreaseByVar)){
		g<-names(LODDecreaseByVar)[i]
		if (g %in% colnames(MatrixProba)){
			if (! g %in% names(LODImproveByeQTL) & ! g %in% names(LODDecreaseByeQTL) & ! g %in% names(LODImproveByVar)){
				print(paste(g,"VarD_only","LOD_Decrease",MatrixProba[1,g],LODDecreaseByVar[i]))
				MatrixProba[1,g]<-LODDecreaseByVar[i]
			}
		}
	}

	sink("/dev/null")
	QTL.scanperm<-scanone(QTL,pheno.col=1,method="em",n.perm=QTLPerm,n.cluster=CORES,model='normal')
	sink()

	pctil<-ecdf(as.vector(QTL.scanperm[,1]))
	l=length(QTL.scanperm)
	qvalcomput<-function(x){
		c<-QTLPerm-(pctil(x)*QTLPerm)+1
		if (c>QTLPerm){c<-QTLPerm}
		return(-log10(c/l))
	}
	
	qval<-unlist(mclapply(as.list(MatrixProba[1,]),qvalcomput,mc.cores=CORES))
	names(qval)<-colnames(MatrixProba)
	
	MatrixProba[1,]<-qval

	save(MatrixProba,file=paste(OutputName,'.LODScoreMatrix.Rdata',sep='')) 

	##print(head(QTL))
	return(list(QTL,QTLMB,QTL.scan,scanMB,QTL.scanperm))

}
