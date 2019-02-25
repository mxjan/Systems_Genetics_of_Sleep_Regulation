library(knitr)
library(rmarkdown)
library(getopt)

spec = matrix(c(
  "input","i","test","character", 
  "id"   , "l", 1, "integer",  # ID of the phenotype to score
  "condition"   , "c", "NSD", "character", # condition used [ NSD | SD ]
  "tissu"   , "t", "Cortex", "character", # tissu used [ C | L ]
  "phenotypetype", "k","S","character", # Phenotypes [ S | M ]
  "permutations", "p",10000,"integer", # Number of permutation to run
  "cores", "n",1,"integer", # Number of cores to use
  "discretization", "d",20,"integer", # discretization use for weighting
  "weighting", "w", "Hk","character", # Weighting method [ Hk | MaxEnt ]
  "QTLpermutations","q",1000,"integer" # Number of permutation to run with r/qtl
  ), byrow=TRUE, ncol=4)
opt = getopt(spec);

#knit(paste(opt$input,".Rmd",sep=""))
#markdownToHTML(paste(opt$input,".md",sep=""),paste(opt$input,".html",sep=""))

Output<-paste(gsub(".Rmd",'',opt$input),opt$id,opt$condition,opt$tissu,opt$phenotypetype,opt$weighting,opt$discretization,"html",sep=".")

render(opt$input,output_file=Output)


