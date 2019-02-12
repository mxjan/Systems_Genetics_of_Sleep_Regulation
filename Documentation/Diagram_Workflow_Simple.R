library(grid)
library(gridExtra)

PlotVia<-F


############ Rmd box
RmdTable <- function(name,x=.5,y=.5,Title){

  tablevp<-viewport(x=x,y=y,width=stringWidth(name) + unit(4, "mm"),
                    height=unit(6,"lines"))
  pushViewport(tablevp)
  #grid.roundrect(gp=gpar(col="black"))

  # Workflow name viewport
  fill <- "darkgrey"
  WFvp<-viewport(x=.5,y=unit(5.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  #grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(name,gp=gpar(font=1))
  upViewport(1)
  
  # Files name viewport
  FNvp<-viewport(x=.5,y=unit(2.5,"lines"),height = unit(4,"lines"),width = unit(3,"lines"),angle=0)
  pushViewport(FNvp)

  #grid.polygon(x=c(0,0,.75,1,1,0),y=c(1,0,0,.25,1,1),gp=gpar(col="black",fill="cornflowerblue"))
  grid.polygon(x=c(0,0,1,1,.7,0),y=c(1,0,0,.7,1,1),gp=gpar(col="black",fill="cornflowerblue"))
  grid.polygon(x=c(.7,.7,1,.7),y=c(1,.7,.7,1),gp=gpar(col="black",fill="blue"))

  grid.text(x = 0.35,y = 0.8, "Rmd",gp=gpar(font=1))

  FNvp<-viewport(x=.5,y=.4,height = unit(1.5,"lines"),width = unit(1.5,"lines"),angle=45)
  pushViewport(FNvp)
  grid.rect(gp=gpar(col="black",fill="darkolivegreen1"))


  upViewport(0)
  popViewport(0)


}

RmdGrob <- function(name,x=.5,y=.5,Title){
  grob(name=name, x=x, y=y,Title=Title, cl="Rmdbox")
}

drawDetails.Rmdbox <- function(x, ...) {
  RmdTable(x$name, x$x, x$y,x$Title)
}

xDetails.Rmdbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}

yDetails.Rmdbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}


################ DB box
DBTable <- function(name,x=.5,y=.5,Title){

  tablevp<-viewport(x=x,y=y,width=stringWidth(name) + unit(4, "mm"),
                    height=unit(5,"lines"))
  pushViewport(tablevp)
  #grid.roundrect(gp=gpar(col="black"))

  # Workflow name viewport
  fill <- "darkgrey"
  WFvp<-viewport(x=.5,y=unit(6.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  #grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(name,gp=gpar(font=1))
  upViewport(1)
  
  # Files name viewport
  FNvp<-viewport(x=.5,y=unit(3,"lines"),height = unit(4,"lines"),width = unit(3,"lines"),angle=0)
  pushViewport(FNvp)

  g = ellipseGrob(.5,.05,size=5.5,ar=2,angle=pi,
                def="npc", gp=gpar(fill="lightgrey"))
  grid.draw(g)

  grid.polygon(x=c(0,0,1,1,0),y=c(.9,.05,.05,.9,.9),gp=gpar(col="black",fill="lightgrey"))

  grid.polygon(x=c(0,0,1,1,0),y=c(.055,.045,.045,.055,.055),gp=gpar(col=rgb(0,0,0,0),fill="lightgrey"))

  #g = ellipseGrob(.5,.1,size=5,ar=2,angle=pi,
  #              def="npc", gp=gpar(fill="lightgrey",col=rgb(0,0,0,0)))
  #grid.draw(g)

  g = ellipseGrob(.5,.9,size=5.5,ar=2,angle=pi,
                def="npc", gp=gpar(fill="lightgrey"))
  grid.draw(g)

  upViewport(0)
  popViewport(0)


}

DBGrob <- function(name,x=.5,y=.5,Title){
  grob(name=name, x=x, y=y,Title=Title, cl="DBbox")
}

drawDetails.DBbox <- function(x, ...) {
  DBTable(x$name, x$x, x$y,x$Title)
}

xDetails.DBbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(5,"lines")),
        theta)
}

yDetails.DBbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=unit(5,"lines")),
        theta)
}


################ Data box
DataTable <- function(name,x=.5,y=.5,Title){

  tablevp<-viewport(x=x,y=y,width=stringWidth(name) + unit(4, "mm"),
                    height=unit(6,"lines"))
  pushViewport(tablevp)
  #grid.roundrect(gp=gpar(col="black"))

  # Workflow name viewport
  fill <- "darkgrey"
  WFvp<-viewport(x=.5,y=unit(5.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  #grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(name,gp=gpar(font=1))
  upViewport(1)
  
  # Files name viewport
  FNvp<-viewport(x=.5,y=unit(2.5,"lines"),height = unit(4,"lines"),width = unit(3,"lines"),angle=0)
  pushViewport(FNvp)

  #grid.polygon(x=c(0,0,.75,1,1,0),y=c(1,0,0,.25,1,1),gp=gpar(col="black",fill="cornflowerblue"))
  grid.polygon(x=c(0,0,1,1,.7,0),y=c(1,0,0,.7,1,1),gp=gpar(col="black",fill="cornflowerblue"))
  grid.polygon(x=c(.7,.7,1,.7),y=c(1,.7,.7,1),gp=gpar(col="black",fill="blue"))


  upViewport(0)
  popViewport(0)


}

DataGrob <- function(name,x=.5,y=.5,Title){
  grob(name=name, x=x, y=y,Title=Title, cl="Databox")
}

drawDetails.Databox <- function(x, ...) {
  DataTable(x$name, x$x, x$y,x$Title)
}

xDetails.Databox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}

yDetails.Databox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}


################ Datas box
DatasTable <- function(name,x=.5,y=.5,Title){

  tablevp<-viewport(x=x,y=y,width=stringWidth(name) + unit(4, "mm"),
                    height=unit(7,"lines"))
  pushViewport(tablevp)
  #grid.roundrect(gp=gpar(col="black"))

  # Workflow name viewport
  fill <- "darkgrey"
  WFvp<-viewport(x=.5,y=unit(6.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  #grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(name,gp=gpar(font=1))
  upViewport(1)
  
  # Files name viewport
  FNvp<-viewport(x=.5,y=unit(3,"lines"),height = unit(4,"lines"),width = unit(5,"lines"),angle=0)
  pushViewport(FNvp)

  FNvp1<-viewport(x=.7,y=unit(3,"lines"),height = unit(4,"lines"),width = unit(3,"lines"),angle=0)
  pushViewport(FNvp1)
  grid.polygon(x=c(0,0,1,1,.7,0),y=c(1,0,0,.7,1,1),gp=gpar(col="black",fill="cornflowerblue"))
  grid.polygon(x=c(.7,.7,1,.7),y=c(1,.7,.7,1),gp=gpar(col="black",fill="blue"))
  upViewport(1)

  FNvp1<-viewport(x=.5,y=unit(2.5,"lines"),height = unit(4,"lines"),width = unit(3,"lines"),angle=0)
  pushViewport(FNvp1)
  grid.polygon(x=c(0,0,1,1,.7,0),y=c(1,0,0,.7,1,1),gp=gpar(col="black",fill="cornflowerblue"))
  grid.polygon(x=c(.7,.7,1,.7),y=c(1,.7,.7,1),gp=gpar(col="black",fill="blue"))
  upViewport(1)

  FNvp1<-viewport(x=.3,y=unit(2,"lines"),height = unit(4,"lines"),width = unit(3,"lines"),angle=0)
  pushViewport(FNvp1)
  grid.polygon(x=c(0,0,1,1,.7,0),y=c(1,0,0,.7,1,1),gp=gpar(col="black",fill="cornflowerblue"))
  grid.polygon(x=c(.7,.7,1,.7),y=c(1,.7,.7,1),gp=gpar(col="black",fill="blue"))
  upViewport(1)


  upViewport(0)
  popViewport(0)


}

DatasGrob <- function(name,x=.5,y=.5,Title){
  grob(name=name, x=x, y=y,Title=Title, cl="Datasbox")
}

drawDetails.Datasbox <- function(x, ...) {
  DatasTable(x$name, x$x, x$y,x$Title)
}

xDetails.Datasbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(7,"lines")),
        theta)
}

yDetails.Datasbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=unit(7,"lines")),
        theta)
}

############ Workflow box

WorkflowTable <- function(name,x=.5,y=.5,Title){

  tablevp<-viewport(x=x,y=y,width=stringWidth(name) + unit(4, "mm"),
                    height=unit(8,"lines"))
  pushViewport(tablevp)
  #grid.roundrect(gp=gpar(col="black"))

  # Workflow name viewport
  fill <- "darkgrey"
  WFvp<-viewport(x=.5,y=unit(7.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  #grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(name,gp=gpar(font=1))
  upViewport(1)
  
  # Files name viewport
  FNvp<-viewport(x=.5,y=unit(4.5,"lines"),height = unit(3,"lines"),width = unit(3,"lines"),angle=45)
  pushViewport(FNvp)
  grid.rect(gp=gpar(col="black",fill="darkolivegreen1")) 
  upViewport(1)

  FNvp<-viewport(x=.5,y=unit(3.5,"lines"),height = unit(3,"lines"),width = unit(3,"lines"),angle=45)
  pushViewport(FNvp)
  grid.rect(gp=gpar(col="black",fill="darkolivegreen1")) 
  upViewport(1)

  FNvp<-viewport(x=.5,y=unit(2.5,"lines"),height = unit(3,"lines"),width = unit(3,"lines"),angle=45)
  pushViewport(FNvp)
  grid.rect(gp=gpar(col="black",fill="darkolivegreen1")) 
  upViewport(1)



  upViewport(0)
  popViewport(0)


}

WorkflowGrob <- function(name,x=.5,y=.5,Title){
  grob(name=name, x=x, y=y,Title=Title, cl="Workflowbox")
}

drawDetails.Workflowbox <- function(x, ...) {
  WorkflowTable(x$name, x$x, x$y,x$Title)
}

xDetails.Workflowbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(8,"lines")),
        theta)
}

yDetails.Workflowbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=unit(8,"lines")),
        theta)
}



############ Script box
ScriptTable <- function(name,x=.5,y=.5,Title){

  tablevp<-viewport(x=x,y=y,width=stringWidth(name) + unit(4, "mm"),
                    height=unit(6,"lines"))
  pushViewport(tablevp)
  #grid.roundrect(gp=gpar(col="black"))

  # Workflow name viewport
  fill <- "darkgrey"
  WFvp<-viewport(x=.5,y=unit(5.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  #grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(name,gp=gpar(font=1))
  upViewport(1)
  
  # Files name viewport
  FNvp<-viewport(x=.5,y=unit(2.5,"lines"),height = unit(3,"lines"),width = unit(3,"lines"),angle=45)
  pushViewport(FNvp)
  grid.rect(gp=gpar(col="black",fill="darkolivegreen1"))
  #grid.text('> for i in myData { ',gp=gpar(fontface=3,col="green"))  
  upViewport(0)
  popViewport(0)


}

ScriptGrob <- function(name,x=.5,y=.5,Title){
  grob(name=name, x=x, y=y,Title=Title, cl="Scriptbox")
}

drawDetails.Scriptbox <- function(x, ...) {
  ScriptTable(x$name, x$x, x$y,x$Title)
}

xDetails.Scriptbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}

yDetails.Scriptbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}

############ Plot diagram
options(stringsAsFactors=FALSE)
args <- commandArgs(trailingOnly = TRUE)
Input <- args[1]
EdgesTableFile<-args[2]
Output <- args[3]

Intable<-read.table(Input,header=F,sep="\t")

png(file=Output,width=1800,height=1800)

#Background
grid.newpage()
grid.rect(gp=gpar(col="black",fill=rgb(0,0,0,.05)))

Nlist = list()

for (i in 1:nrow(Intable)){

	N <- Intable[i,"V5"]
	Path <- Intable[i,"V6"]
	xval <- Intable[i,"V3"]
	yval <- Intable[i,"V4"]


	if (Intable[i,"V1"] == "File" | Intable[i,"V1"] == "Files"){
		if (Intable[i,"V1"] == "File"){DMF<-F}
		if (Intable[i,"V1"] == "Files"){DMF<-T}

		box<-MFGrob(N,Path,DMF=DMF,x=xval,y=yval)
	}
	else if (Intable[i,"V1"] == "Experiment"){
		box<-ProjectGrob(N,x=xval,y=yval,"Experiment")	
	}
	else if (Intable[i,"V1"] == "Data"){
		box<-DataGrob(N,x=xval,y=yval,"Data")	
	}
	else if (Intable[i,"V1"] == "Datas"){
		box<-DatasGrob(N,x=xval,y=yval,"Data")	
	}
	else if (Intable[i,"V1"] == "DB"){
		box<-DBGrob(N,x=xval,y=yval,"Data")	
	}
	else if (Intable[i,"V1"] == "Population"){
		box<-ProjectGrob(N,x=xval,y=yval,"Population")	
	}
	else if (Intable[i,"V1"] == "Script"){
		box<-ScriptGrob(N,x=xval,y=yval,"Script")
	}
	else if (Intable[i,"V1"] == "Workflow"){
		box<-WorkflowGrob(N,x=xval,y=yval,"Workflow")
	}
	else if (Intable[i,"V1"] %in% c("Group","GroupDisplay","GroupPool")){
		box<-MFGrob(N,Path,DMF=T,x=xval,y=yval)
	}
	else if (Intable[i,"V1"] == "Rmarkdown"){
		box<-RmdGrob(N,x=xval,y=yval,"RMarkdown")
	}
	else {print("ERROR, UNKNOWN TYPE IN DRAWING PARAMETERS !");print(Intable[i,"V1"]);quit()}

	grid.draw(box)		
	Nlist[[Intable[i,"V2"]]]<-box
}

Edgestable<-read.table(EdgesTableFile,header=F,sep="\t")

for (i in 1:nrow(Edgestable)){

	Obj1 <- Nlist[[Edgestable[i,"V1"]]]
	Obj2 <- Nlist[[Edgestable[i,"V2"]]]

	xvalObj1 <- Intable[which(Intable$V2 == Edgestable[i,"V1"]),"V3"]
	yvalObj1 <- Intable[which(Intable$V2 == Edgestable[i,"V1"]),"V4"]

	xvalObj2 <- Intable[which(Intable$V2 == Edgestable[i,"V2"]),"V3"]
	yvalObj2 <- Intable[which(Intable$V2 == Edgestable[i,"V2"]),"V4"]

	# Position of arrows
	if (xvalObj1>xvalObj2){curvature <- -1;posx1<-"south";posy1<-"south";posx2<-"north";posy2<-"north"}
	else if (xvalObj1<xvalObj2){curvature <- 1;posx1<-"south";posy1<-"south";posx2<-"north";posy2<-"north"}
	else {curvature <- 0;posx1<-"south";posy1<-"south";posx2<-"north";posy2<-"north"}
	if (yvalObj2 == yvalObj1){curvature <- 0
		if (xvalObj1>xvalObj2){
			posx1<-"west";posy1<-"west";posx2<-"east";posy2<-"east"
		} else {
			posx1<-"east";posy1<-"east";posx2<-"west";posy2<-"west"
		}
		
	}
	# Slightly shift them
	xshift<-xvalObj1-xvalObj2
	xshift2<-xvalObj2-xvalObj1

	# Print edges
	grid.curve(grobX(Obj1, posx1)+unit(xshift2*4,"line"),
		   grobY(Obj1, posy1),
		   grobX(Obj2, posx2)+unit(xshift*4,"line"),
		   grobY(Obj2, posy2)+unit(1,"mm"),
		   angle=90,
		   shape = 1,
		   inflect=T,
		   curvature = 0,
		   arrow=
		     arrow(type="closed",
		           angle=30,
		           length=unit(3, "mm")),
		   gp=gpar(fill="black"),square=T)

	# print connector
	if (! Edgestable[i,"V3"] %in% c("NoVia")){
		midx <- (min(c(xvalObj1,xvalObj2))+max(c(xvalObj1,xvalObj2)))/2
		midy <- (min(c(yvalObj1,yvalObj2))+max(c(yvalObj1,yvalObj2)))/2
		if (PlotVia ==T){
			grid.roundrect(x=midx,y=midy,gp=gpar(col="black",fill="white"),width=stringWidth(Edgestable[i,"V3"])+unit(4, "mm"), height=unit(1,"lines"))
			grid.text(x=midx,y=midy,Edgestable[i,"V3"],gp=gpar(fontface=2,col="black"))
		}		
	}

}


dev.off()
