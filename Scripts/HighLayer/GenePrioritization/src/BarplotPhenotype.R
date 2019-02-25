PhenotypePlot<-function(x,lines,main,xlabtext,log=F){
  names(x)<-lines
  x<-as.numeric(x)  
  if (log ==F){
    barplot(height=x[order(x)],las=1,horiz=TRUE,main=main,xlab=xlabtext)
  } else {
    barplot(height=log2(x[order(x)]),las=1,horiz=TRUE,main=main,xlab=xlabtext)
  }

}
