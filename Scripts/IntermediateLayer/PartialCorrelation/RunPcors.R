library(RcppEigen)
library(parallel)
load("pcorInputData.Rdata")
source("BXDpcor.R")


#t<-BXDpcor(CSDformated[seq(1,100),],cisCSDformated[seq(1,100)],LSDformated[seq(1,100),],cisLSDformated[seq(1,100)],GenotypeMatrix,CORES=10,method="spearman")
t<-BXDpcor(CSDformated,cisCSDformated,LSDformated,cisLSDformated,GenotypeMatrix,CORES=10,method="spearman")
save(t,file="pcor_spearman_CortexSD_LiverSD.Rdata")

#t<-BXDpcor(CNSDformated[seq(1,100),],cisCNSDformated[seq(1,100)],LNSDformated[seq(1,100),],cisLNSDformated[seq(1,100)],GenotypeMatrix,CORES=10,method="spearman")
t<-BXDpcor(CNSDformated,cisCNSDformated,LNSDformated,cisLNSDformated,GenotypeMatrix,CORES=10,method="spearman")
save(t,file="pcor_spearman_CortexNSD_LiverNSD.Rdata")

t<-BXDpcor(CSDformated,cisCSDformated,CSDformated,cisCSDformated,GenotypeMatrix,CORES=10,method="spearman")
save(t,file="pcor_spearman_CortexSD_CortexSD.Rdata")

t<-BXDpcor(LSDformated,cisLSDformated,LSDformated,cisLSDformated,GenotypeMatrix,CORES=10,method="spearman")
save(t,file="pcor_spearman_LiverSD_LiverSD.Rdata")