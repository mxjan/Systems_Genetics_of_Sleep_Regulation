ScorePlot<-function(p1,p2,PermResults,chro,scan,Main,ylim1,ylim2,SignifThresh,scorescale=1,Chromosome,Nomarker=F,byt="n"){
  gpos<-read.table(RefSeqData)
  par(mar=c(5,5,5,5))
  plot(-100,-100,xlim=c(p1,p2),ylim=c(ylim1,ylim2),xlab="",ylab="",xaxt='n',yaxt='n',bty=byt,main=Main)
  abline(h=SignifThresh,col="red",lwd=2)
  abline(h=(-log10(0.05)*scorescale),col="black",lwd=2)
  
  # get marker in interval
  nm<-names(chro[chro>=p1 & chro<=p2])
  mx<-chro[chro>=p1 & chro<=p2]
  my<-scan[as.character(nm),]$lod
  mx<-c(2,mx)
  my<-c(max(my),my)
  
  #Points scan (LOD)
  points(mx,my,type='l',col=rgb(158/255,5/255,12/255),lwd=2)
  
  # plot score
  gpost<-gpos[gpos$Chromosome==Chromosome & gpos$Start<=p2 & gpos$End>=p1,]
  gLx<-gpost$Position
  gLy<-PermResults[rownames(gpost)]*scorescale
  points(gLx,gLy,type='l',col="darkgreen",lwd=2)
  
  # plot marker and genes
  if (Nomarker==F){
    points(gLx[gLx>p1+2],rep(ylim1/2,length(gLx[gLx>p1+2])),col=rgb(0,0,0,alpha=0.5),pch=19,cex=0.5)
    segments(mx[gLx>p1+2],rep(ylim1,length(mx[gLx>p1+2])),mx[gLx>p1+2],rep(ylim1+ylim1*0.05,length(mx[gLx>p1+2])),col="blue",lwd=2)
  }
  
  # plot xaxis
  axis(1,at=seq(p1,p2,by=2),labels=seq(p1,p2,by=2))
  mtext("Position [Mb]",1,padj=3)
  
  # plot LOD axis
  axis(2,at=seq(0,ylim2,by=1),labels=seq(0,ylim2,by=1),las=2,col=rgb(158/255,5/255,12/255),col.axis=rgb(158/255,5/255,12/255))
  mtext("QTL LOD score",2,padj=-3,col=rgb(158/255,5/255,12/255))
  
  # plot score axis
  axis(4,seq(0,4*scorescale,by=1),labels=(seq(0,4,by=1/scorescale)),col="darkgreen",col.axis="darkgreen",las=2)
  
  # text
  if (Nomarker==F){
    text(p1+.5,ylim1,"Markers",col="blue")
    text(p1+.5,ylim1/2,"Genes",col=rgb(0,0,0,alpha=0.8))
  }
  mtext("-log FDR",4,padj=4,col="darkgreen")
  
  #return(rownames(gpost))
}

