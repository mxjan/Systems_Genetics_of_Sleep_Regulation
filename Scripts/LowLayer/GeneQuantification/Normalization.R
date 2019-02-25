library(edgeR)
nsdsd<-read.table("htseq-count_summary.txt",sep='\t',header=TRUE, stringsAsFactors=FALSE, row.names=1)
#nsdsd <- do.call(rbind,lapply(1:nrow(all_counts),function(i,all_counts) if(as.vector(rowMeans(all_counts[i,]))>10) all_counts[i,] else NULL,all_counts))
nsdsd <- DGEList(nsdsd)
#nrow(nsdsd)
keepnsdsd<-rowSums(cpm(nsdsd)>0.5)>=20
nsdsd<-nsdsd[keepnsdsd,]
nsdsd = calcNormFactors(nsdsd)
nsdsd <- estimateCommonDisp(nsdsd, verbose=TRUE)
nsd<-nsdsd[,c(seq(1,88,by=2))]
colnames(nsd)<-c("BXD005","BXD100","BXD101","BXD103","BXD029","BXD29t","BXD032","BXD043","BXD044","BXD045","BXD048","BXD049","BXD050","BXD051","BXD055","BXD056","BXD061","BXD063","BXD064","BXD065","BXD066","BXD067","BXD070","BXD071","BXD073","BXD075","BXD079","BXD081","BXD083","BXD084","BXD085","BXD087","BXD089","BXD090","BXD095","BXD096","BXD097","BXD098","B61","B62","BD","DB1","DB2","DB")
sd<-nsdsd[,c(seq(2,88,by=2))]
colnames(sd)<-c("BXD005","BXD100","BXD101","BXD103","BXD029","BXD29t","BXD032","BXD043","BXD044","BXD045","BXD048","BXD049","BXD050","BXD051","BXD055","BXD056","BXD061","BXD063","BXD064","BXD065","BXD066","BXD067","BXD070","BXD071","BXD073","BXD075","BXD079","BXD081","BXD083","BXD084","BXD085","BXD087","BXD089","BXD090","BXD095","BXD096","BXD097","BXD098","B61","B62","BD","DB1","DB2","DB")
write.table(cpm(nsd,normalized.lib.sizes=TRUE),file="htseq-count_summary.txt.NSD.CPMnormalizedWITHNSDSD.txt",sep='\t',row.names=TRUE,quote = FALSE)
write.table(cpm(sd,normalized.lib.sizes=TRUE),file="htseq-count_summary.txt.SD.CPMnormalizedWITHNSDSD.txt",sep='\t',row.names=TRUE,quote = FALSE)

