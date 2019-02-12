library(grid)

############################## Multiple/Mono file plot

MFTable <- function(WFname,Fnames,DMF,x=.5,y=.5){

  Names<-c(WFname,Fnames)
  tablevp<-viewport(x=x,y=y,width=max(stringWidth(Names)) + unit(4, "mm"),
                    height=unit(6,"lines"))
  pushViewport(tablevp)
  grid.rect(gp=gpar(col="black"))
  
  # Workflow name viewport
  fill <- "grey"
  WFvp<-viewport(x=.5,y=unit(5.5,"lines"),height = unit(1,"lines"),name="WFvp")
  pushViewport(WFvp)
  grid.rect(gp=gpar(col="black",fill=fill))
  grid.text(WFname)
  upViewport(1)
  
  # Files name viewport
  FNvp<-viewport(x=.5,y=unit(4.5,"lines"),height = unit(1,"lines"),name="FNvp")
  pushViewport(FNvp)
  grid.text(Fnames,gp=gpar(fontface=3))
  upViewport(1)
  
  # Draw multipleFile
  DFvp<-viewport(x=.5,y=unit(2,"lines"),height = unit(4,"lines"),name="DrawMFvp")
  pushViewport(DFvp)
  grid.rect(gp=gpar(col="black",fill="white"))


  fheight <- unit(3,"lines")
  fwidth <- unit(2,"lines")

  sepfacv <- 0.05 
  sepfach <- 0.07

  if (DMF == T){

    pushViewport(viewport(x=.525-sepfach*2,y=.525-sepfacv*2,width = fwidth,height=fheight))
    grid.rect(gp=gpar(col="black",fill="grey"))
    upViewport(1)

    pushViewport(viewport(x=.525-sepfach,y=.525-sepfacv,width = fwidth,height=fheight))
    grid.rect(gp=gpar(col="black",fill="grey"))
    upViewport(1)

    pushViewport(viewport(x=.525,y=.525,width = fwidth,height=fheight))
    grid.rect(gp=gpar(col="black",fill="grey"))
    upViewport(1)

    pushViewport(viewport(x=.525+sepfach,y=.525+sepfacv,width = fwidth,height=fheight))
    grid.rect(gp=gpar(col="black",fill="grey"))
    upViewport(1)

  } else {
    pushViewport(viewport(x=.5,y=.5,width = fwidth,height=fheight))
    grid.rect(gp=gpar(col="black",fill="grey"))
    upViewport(1)
  }

  popViewport(0)

}

MFGrob <- function(WFname,Fnames,DMF=F,x=.5,y=.5){
  grob(WFname=WFname,Fnames=Fnames,DMF=DMF, x=x, y=y, cl="MFbox")
}

drawDetails.MFbox <- function(x, ...) {
  MFTable(x$WFname,x$Fnames,x$DMF, x$x, x$y)
}

xDetails.MFbox <- function(x, theta) {
  Names<-c(x$WFname,x$Fnames)
  width <- unit(4, "mm") + max(stringWidth(Names))
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}
yDetails.MFbox <- function(x, theta) {
  Names<-c(x$WFname,x$Fnames)
  width <- unit(4, "mm") + max(stringWidth(Names))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}


################################# Project Box

ProjectTable <- function(name,x=.5,y=.5,Title){

  width <- max(stringWidth(c(name,Title)))
  tablevp<-viewport(x=x,y=y,width=width + unit(10, "mm"),
                    height=unit(3,"lines"))
  pushViewport(tablevp)
  grid.roundrect(gp=gpar(col="black",fill="white"))


  tablevp<-viewport(x=.5,y=.75,width=width + unit(10, "mm"),
                    height=unit(1.5,"lines"))
  pushViewport(tablevp)
  grid.text(Title,gp=gpar(fontface=2,col="black"))
  upViewport(1)

  tablevp<-viewport(x=.5,y=.25,width=width + unit(10, "mm"),
                    height=unit(1.5,"lines"))
  pushViewport(tablevp)
  grid.roundrect(gp=gpar(col="black",fill="black"))
  grid.text(name,gp=gpar(fontface=2,col="white"))
  upViewport(0)
  popViewport(0)
}

ProjectGrob <- function(name,x=.5,y=.5,Title){
  grob(name=name, x=x, y=y,Title=Title, cl="Projectbox")
}

drawDetails.Projectbox <- function(x, ...) {
  ProjectTable(x$name, x$x, x$y,x$Title)
}

xDetails.Projectbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(3,"lines")),
        theta)
}

yDetails.Projectbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=unit(3,"lines")),
        theta)
}


############ Workflow box

WorkflowTable <- function(name,x=.5,y=.5,Title){

  tablevp<-viewport(x=x,y=y,width=stringWidth(name) + unit(4, "mm"),
                    height=unit(6,"lines"))
  pushViewport(tablevp)
  grid.roundrect(gp=gpar(col="black"))

  # Workflow
  fill <- "white"
  WFvp<-viewport(x=.5,y=unit(5.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(Title,gp=gpar(font=2))
  upViewport(1)

  # Workflow name viewport
  fill <- "darkgrey"
  WFvp<-viewport(x=.5,y=unit(4.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(name)
  upViewport(1)
  
  # Files name viewport
  FNvp<-viewport(x=.5,y=unit(3.5,"lines"),height = unit(1,"lines"))
  pushViewport(FNvp)
  grid.roundrect(gp=gpar(col="black",fill="black"))
  grid.text('> Command 1',gp=gpar(fontface=3,col="green"))
  upViewport(1)
  
  # Draw multipleFile
  FNvp<-viewport(x=.5,y=unit(2.5,"lines"),height = unit(1,"lines"))
  pushViewport(FNvp)
  grid.roundrect(gp=gpar(col="black",fill="black"))
  grid.text('> Command 2',gp=gpar(fontface=3,col="green"))
  upViewport(1)

  FNvp<-viewport(x=.5,y=unit(1.5,"lines"),height = unit(1,"lines"))
  pushViewport(FNvp)
  grid.roundrect(gp=gpar(col="black",fill="black"))
  grid.text('> Command 3',gp=gpar(fontface=3,col="green"))
   upViewport(1)

  FNvp<-viewport(x=.5,y=unit(.5,"lines"),height = unit(1,"lines"))
  pushViewport(FNvp)
  grid.roundrect(gp=gpar(col="black",fill="black"))
  grid.text('> Command N',gp=gpar(fontface=3,col="green"))
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
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}

yDetails.Workflowbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}


############ Script box

ScriptTable <- function(name,x=.5,y=.5,Title){

  tablevp<-viewport(x=x,y=y,width=stringWidth(name) + unit(4, "mm"),
                    height=unit(4,"lines"))
  pushViewport(tablevp)
  grid.roundrect(gp=gpar(col="black"))

  # Workflow
  fill <- "white"
  WFvp<-viewport(x=.5,y=unit(3.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(Title,gp=gpar(font=2))
  upViewport(1)

  # Workflow name viewport
  fill <- "darkgrey"
  WFvp<-viewport(x=.5,y=unit(2.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(name)
  upViewport(1)
  
  # Files name viewport
  FNvp<-viewport(x=.5,y=unit(1.5,"lines"),height = unit(1,"lines"))
  pushViewport(FNvp)
  grid.roundrect(gp=gpar(col="black",fill="black"))
  grid.text('> for i in myData { ',gp=gpar(fontface=3,col="green"))
  upViewport(1)
  
  # Draw multipleFile
  FNvp<-viewport(x=.5,y=unit(.5,"lines"),height = unit(1,"lines"))
  pushViewport(FNvp)
  grid.roundrect(gp=gpar(col="black",fill="black"))
  grid.text('...  do some stuff ...',gp=gpar(fontface=3,col="green"))
  upViewport(1)


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
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(4,"lines")),
        theta)
}

yDetails.Scriptbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=unit(4,"lines")),
        theta)
}


############ Rmarkdown box

RmarkdownTable <- function(name,x=.5,y=.5,Title){

  globalwidth <- stringWidth(name) + unit(6, "mm")
  tablevp<-viewport(x=x,y=y,width=globalwidth,
                    height=unit(6,"lines"))
  pushViewport(tablevp)
  grid.roundrect(gp=gpar(col="black"))

  # Rmarkdown Title
  fill <- "lightblue"
  WFvp<-viewport(x=.5,y=unit(5.5,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  grid.roundrect(gp=gpar(col="black",fill=fill))
  grid.text(name,gp=gpar(font=2))
  upViewport(1)

  # Workflow name viewport
  fill <- "lightgrey"
  WFvp<-viewport(x=.5,y=unit(4.2,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  grid.roundrect(gp=gpar(col="black",fill=fill),width=globalwidth-unit(8, "mm"))
  grid.text('> Some R code ... ',gp=gpar(fontface=3,col="black"))
  upViewport(1)

  #A figure
  FNvp<-viewport(x=.5,y=unit(2.5,"lines"),height = unit(2,"lines"))
  pushViewport(FNvp)
  FNvp2<-viewport(x=.5,y=.5,height = unit(2,"lines"),width=globalwidth-unit(20, "mm"))
  pushViewport(FNvp2)
  grid.roundrect(gp=gpar(col="black",fill="white"))
  grid.lines(x=unit(c(.3, .5,.9), "npc"),y = unit(c(.3, .4,.8), "npc"),gp=gpar(col="red"))
  grid.lines(x=unit(c(.4, .4,.9), "npc"),y = unit(c(.3, .5,.6), "npc"),gp=gpar(col="blue"))
  grid.lines(x=unit(c(.2, .9), "npc"),y = unit(c(.2,.2), "npc"))
  grid.lines(x=unit(c(.2,.2), "npc"),y = unit(c(.2,.9), "npc"))
  upViewport(1)
  upViewport(1)

  fill <- "white"
  WFvp<-viewport(x=.5,y=unit(0.8,"lines"),height = unit(1,"lines"))
  pushViewport(WFvp)
  grid.text(' My nice figure is ... ',gp=gpar(fontface=1,col="black"))
  
  
  upViewport(0)
  popViewport(0)


}

RmarkGrob <- function(name,x=.5,y=.5,Title){
  grob(name=name, x=x, y=y,Title=Title, cl="Rmarkdownbox")
}

drawDetails.Rmarkdownbox <- function(x, ...) {
  RmarkdownTable(x$name, x$x, x$y,x$Title)
}

xDetails.Rmarkdownbox <- function(x, theta) {
  width <- unit(4, "mm") + max(stringWidth(c(x$name,x$Title)))
  grobX(rectGrob(x=x$x, y=x$y, width=width, height=unit(6,"lines")),
        theta)
}

yDetails.Rmarkdownbox <- function(x, theta) {
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
grid.rect(gp=gpar(col="black",fill=rgb(0,0,0,.1)))

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
		box<-ProjectGrob(N,x=xval,y=yval,"Data")	
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
		box<-RmarkGrob(N,x=xval,y=yval,"RMarkdown")
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
		grid.roundrect(x=midx,y=midy,gp=gpar(col="black",fill="white"),width=stringWidth(Edgestable[i,"V3"])+unit(4, "mm"), height=unit(1,"lines"))
		grid.text(x=midx,y=midy,Edgestable[i,"V3"],gp=gpar(fontface=2,col="black"))
		
	}

}


dev.off()
quit()

# Background
grid.newpage()
grid.rect(gp=gpar(col="black",fill=rgb(0,0,0,.1)))

# Project
Pbox<-ProjectGrob("Systems genetics of sleep homeostasis",x=.5,y=.9)
grid.draw(Pbox)

# File Generate
Fboxbase1<-MFGrob("RNA-sequencing Liver","./*.fastq",DMF=T,x=.1,y=.8)
grid.draw(Fboxbase1)

grid.curve(grobX(Pbox, "south"),
           grobY(Pbox, "south"),
           grobX(Fboxbase1, "north"),
           grobY(Fboxbase1, "north"),
	   angle=90,
	   shape = 0,
           inflect=T,
	   curvature = -1,
           arrow=
             arrow(type="closed",
                   angle=30,
                   length=unit(3, "mm")),
           gp=gpar(fill="black"),square=T)

Fboxbase1<-MFGrob("RNA-sequencing Cortex","./*.fastq",DMF=T,x=.3,y=.8)
grid.draw(Fboxbase1)

grid.curve(grobX(Pbox, "south"),
           grobY(Pbox, "south"),
           grobX(Fboxbase1, "north"),
           grobY(Fboxbase1, "north"),
	   angle=90,
	   shape = 0,
           inflect=T,
	   curvature = -1,
           arrow=
             arrow(type="closed",
                   angle=30,
                   length=unit(3, "mm")),
           gp=gpar(fill="black"),square=T)


Fboxbase1<-MFGrob("           LC-MS           ","./.txt",DMF=T,x=.7,y=.8)
grid.draw(Fboxbase1)

grid.curve(grobX(Pbox, "south"),
           grobY(Pbox, "south"),
           grobX(Fboxbase1, "north"),
           grobY(Fboxbase1, "north"),
	   angle=90,
	   shape = 0,
           inflect=T,
	   curvature = 1,
           arrow=
             arrow(type="closed",
                   angle=30,
                   length=unit(3, "mm")),
           gp=gpar(fill="black"),square=T)

Fboxbase1<-MFGrob("  EEG/EMG recording  ","./*b.txt",DMF=T,x=.9,y=.8)
grid.draw(Fboxbase1)

grid.curve(grobX(Pbox, "south"),
           grobY(Pbox, "south"),
           grobX(Fboxbase1, "north"),
           grobY(Fboxbase1, "north"),
	   angle=90,
	   shape = 0,
           inflect=T,
	   curvature = 1,
           arrow=
             arrow(type="closed",
                   angle=30,
                   length=unit(3, "mm")),
           gp=gpar(fill="black"),square=T)

# Workflow

Fbox1 <- MFGrob("Alignment workflow","Test*.bam",DMF=T,x=.3,y=.3)
grid.draw(Fbox1)

Fbox2 <- MFGrob("Normalization","Test.vcf",x=.7,y=.7)
grid.draw(Fbox2)



grid.curve(grobX(Fbox2, "south"),
           grobY(Fbox2, "south"),
           grobX(Fbox1, "east"),
           grobY(Fbox1, "north"),
           inflect=T,
           arrow=
             arrow(type="closed",
                   angle=30,
                   length=unit(3, "mm")),
           gp=gpar(fill="black"))


dev.off()
