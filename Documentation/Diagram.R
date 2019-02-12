





















library(diagram)
demo("flowchart")

# pos=c(1,2,1)
# 4 elements will be arranged in three equidistant rows; on the first row one
# element, on the second row two elements and on the third row one element.

par(mar = c(1, 1, 1, 1))
openplotmat()

elpos <- coordinates(c(1,2,1,2))

fromto <- matrix(ncol = 2, byrow = TRUE,
                    data = c(2,4,3,4))


nr <- nrow(fromto)

arrpos <- matrix(ncol = 2, nrow = nr)
for (i in 1:nr){
   arrpos[i, ] <- straightarrow (to = elpos[fromto[i, 2], ],
                                 from = elpos[fromto[i, 1], ],
                                 lwd = 2, arr.pos = 0.5, arr.length = 0.5)
}

 textellipse(elpos[1,], 0.1, lab = "start", box.col = "green",
               shadow.col = "darkgreen", shadow.size = 0.005, cex = 1.5)
 textrect (elpos[2,], 0.15, 0.05,lab = "found term?", box.col = "blue",
             shadow.col = "darkblue", shadow.size = 0.005, cex = 1.5)
 textrect (elpos[4,], 0.15, 0.05,lab = "related?", box.col = "blue",
             shadow.col = "darkblue", shadow.size = 0.005, cex = 1.5)
 textellipse(elpos[3,], 0.1, 0.1, lab = c("other","term"), box.col = "orange",
              shadow.col = "red", shadow.size = 0.005, cex = 1.5)
 
 
  textellipse(elpos[3,], 0.1, 0.1, lab = c("other","term"), box.col = "orange",
                shadow.col = "red", shadow.size = 0.005, cex = 1.5)
  textellipse(elpos[7,], 0.1, 0.1, lab = c("make","a link"),box.col = "orange",
               shadow.col = "red", shadow.size = 0.005, cex = 1.5)
  textellipse(elpos[8,], 0.1, 0.1, lab = c("new","article"),box.col = "orange",
                shadow.col = "red", shadow.size = 0.005, cex = 1.5)
  #
    dd <- c(0.0, 0.025)
  text(arrpos[2, 1] + 0.05, arrpos[2, 2], "yes")
  text(arrpos[3, 1] - 0.05, arrpos[3, 2], "no")
  text(arrpos[4, 1] + 0.05, arrpos[4, 2] + 0.05, "yes")
  text(arrpos[5, 1] - 0.05, arrpos[5, 2] + 0.05, "no")
  
  
  
#######
  
library(grid)
grid.newpage()
grid.roundrect(width=.25)
grid.text("ISBN")


pushViewport(viewport(width=.25,height=.25))
grid.roundrect()
grid.text("ISBN",
            x=unit(2, "mm"),
            y=unit(1.5, "lines"),
            just="left")
grid.text("title",
            x=unit(2, "mm"),
            y=unit(0.5, "lines"),
            just="left")
popViewport()

grid.newpage()
labels <- c("ISBN", "title")
vp <-
  viewport(width=max(stringWidth(labels))+
             unit(4, "mm"),
           height=unit(length(labels),
                       "lines"))
pushViewport(vp)
 grid.roundrect()
grid.text(labels,
            x=unit(2, "mm"),
            y=unit(2:1 - 0.5, "lines"),just="left")
 popViewport()

 
pushViewport(viewport(width=.25,height=.25))
grid.roundrect(gp=gpar(fill="grey"))
grid.clip(y=unit(1, "lines"),
             just="bottom")
grid.roundrect(gp=gpar(fill="white"))
popViewport()



grid.newpage()
vp <- viewport(width=0.5, height=0.5)
pushViewport(vp)
grid.rect(gp=gpar(col="blue"))
grid.text("Quarter of the device",
          y=unit(1, "npc") - unit(1, "lines"), gp=gpar(col="blue"))
pushViewport(vp)
grid.rect(gp=gpar(col="red"))
grid.text("Quarter of the parent viewport",
          y=unit(1, "npc") - unit(1, "lines"), gp=gpar(col="red"))
popViewport(2)



?pdf
# push several viewports then navigate amongst them
grid.newpage()
grid.rect(gp=gpar(col="black",fill="grey"))
grid.text("Top-level viewport",
          y=unit(1, "npc") - unit(1, "lines"), gp=gpar(col="grey"))
pushViewport(viewport(x=.5,y=.5,width=0.5, height=0.5, name="A"))
grid.rect(gp=gpar(col="blue"))

grid.text("1. Push Viewport A",
          y=unit(1, "npc") - unit(1, "lines"), gp=gpar(col="blue"))

pushViewport(viewport(x=0.1, width=0.3, height=0.6,
                      just="left", name="B"))
grid.rect(gp=gpar(col="red"))
grid.text("2. Push Viewport B (in A)",
          y=unit(1, "npc") - unit(1, "lines"), gp=gpar(col="red"))

upViewport(1)

grid.text("3. Up from B to A",
          y=unit(1, "npc") - unit(2, "lines"), gp=gpar(col="blue"))
if (interactive()) Sys.sleep(1.0)



pushViewport(viewport(x=0.5, width=0.4, height=0.8,
                      just="left", name="C"))
grid.rect(gp=gpar(col="green"))
grid.text("4. Push Viewport C (in A)",
          y=unit(1, "npc") - unit(1, "lines"), gp=gpar(col="green"))
pushViewport(viewport(width=0.8, height=0.6, name="D"))
grid.rect()
grid.text("5. Push Viewport D (in C)",
          y=unit(1, "npc") - unit(1, "lines"))

upViewport(0)
grid.text("6. Up from D to top-level",
          y=unit(1, "npc") - unit(2, "lines"), gp=gpar(col="black"))


downViewport("D")
grid.text("7. Down from top-level to D",
          y=unit(1, "npc") - unit(2, "lines"))

seekViewport("B")
grid.text("8. Seek from D to B",
          y=unit(1, "npc") - unit(2, "lines"), gp=gpar(col="red"))

pushViewport(viewport(width=0.9, height=0.5, name="A"))
grid.rect()
grid.text("9. Push Viewport A (in B)",
          y=unit(1, "npc") - unit(1, "lines"))


seekViewport("A)"
grid.text("10. Seek from B to A (in ROOT)",
          y=unit(1, "npc") - unit(3, "lines"), gp=gpar(col="blue"))


seekViewport(vpPath("B", "A"))
grid.text("11. Seek from\nA (in ROOT)\nto A (in B)")
popViewport(0)




tableBox <- function(labels, x=.5, y=.5) {
  nlabel <- length(labels)
  tablevp <-
    viewport(x=x, y=y,
             width=max(stringWidth(labels)) +
               unit(4, "mm"),
             height=unit(nlabel, "lines"))
  pushViewport(tablevp)
  grid.roundrect()
  if (nlabel > 1) {
    for (i in 1:(nlabel - 1)) {
      fill <- c("white", "grey")[i %% 2 + 1]
      grid.clip(y=unit(i, "lines"), just="bottom")
      grid.roundrect(gp=gpar(fill=fill))
    }
  }
  grid.clip()
  grid.text(labels,
            x=unit(2, "mm"), y=unit(nlabel:1 - .5, "lines"),
            just="left")
  popViewport()
}

boxGrob <- function(labels, x=.5, y=.5) {
  grob(labels=labels, x=x, y=y, cl="box")
}

box1 <- boxGrob(c("ISBN", "title",
                  "author", "pub"),
                x=0.3)

drawDetails.box <- function(x, ...) {
  tableBox(x$labels, x$x, x$y)
}
3/4
xDetails.box <- function(x, theta) {
  nlines <- length(x$labels)
  height <- unit(nlines, "lines")
  width <- unit(4, "mm") + max(stringWidth(x$labels))
  grobX(roundrectGrob(x=x$x, y=x$y, width=width, height=height),
        theta)
}
yDetails.box <- function(x, theta) {
  nlines <- length(x$labels)
  height <- unit(nlines, "lines")
  width <- unit(4, "mm") + max(stringWidth(x$labels))
  grobY(rectGrob(x=x$x, y=x$y, width=width, height=height),
        theta)
}




grid.newpage()

box1 <- boxGrob(c("File", "Example.txt"),
                y=0.1,x=0.1)
grid.draw(box1)

box2 <- boxGrob(c("Script", "Example.py"),
                y=0.7,x=0.8)
grid.draw(box2)


grid.curve(grobX(box2, "west"),
           grobY(box2, "south") +
             unit(0.5, "lines"),
           grobX(box1, "east"),
           grobY(box1, "north") -
             unit(0.5, "lines"),
           inflect=T,
           arrow=
             arrow(type="closed",
                   angle=30,
                   length=unit(3, "mm")),
           gp=gpar(fill="black"))


