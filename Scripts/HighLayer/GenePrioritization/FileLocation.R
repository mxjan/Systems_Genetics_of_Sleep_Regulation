# Set all files location
# using reproduced files for cise-QTL detection and DE.

# DIRECTORIES

# Working directory
WD <- "/Home/ngobet2/scripts/Scoring/V9/"

# Data location directory
DATADIR <- "/Home/mjan/PhD/Rdata/"
DATADIR2 <- "/scratch/beegfs/monthly/SleepRegulation/BXD/results/"

# Temporary file directory
TMPDIR <- paste(WD,"tmp/",sep="")

# sub-scripts directory
SCRIPTDIR <- paste(WD,"src/",sep="")



# INPUT FILES

# Script python
FormatQTLR <- paste(SCRIPTDIR,'FormatFileQTLR.py',sep="")

# Text files containing expression data
FileExpressionCortexNSD <- paste(DATADIR,"htseq-count_summary.txt.NSD.log2CPMnormalizedWITHNSDSD.txt",sep="")
FileExpressionCortexSD <- paste(DATADIR,"htseq-count_summary.txt.SD.log2CPMnormalizedWITHNSDSD.txt",sep="")
FileExpressionLiverNSD <- paste(DATADIR,"htseq-count_summary.Liver.txt.NSD.log2CPMnormalizedWITHNSDSD.txt",sep="")
FileExpressionLiverSD <- paste(DATADIR,"htseq-count_summary.Liver.txt.SD.log2CPMnormalizedWITHNSDSD.txt",sep="")

# Text files containing phenotype data
FileSleepPhenotype <- paste(DATADIR,"AllPhenotest.txt",sep="")
FileMetaboliteNSDPhenotype <- paste(DATADIR,"MetabolitesMean.NSD.txt",sep="")
FileMetaboliteSDPhenotype <- paste(DATADIR,"MetabolitesMean.SD.txt",sep="")

# cis eQTL data
FileciseQTLCortexNSD <- paste(DATADIR2,"QTL_detection/cis-eQTL/Cortex_nsd/ciseQTL.Cortex.NSD.pvalcorrected.txt",sep="")
FileciseQTLCortexSD <- paste(DATADIR2,"QTL_detection/cis-eQTL/Cortex_sd/ciseQTL.Cortex.SD.pvalcorrected.txt",sep="")
FileciseQTLLiverNSD <- paste(DATADIR2,"QTL_detection/cis-eQTL/Liver_nsd/ciseQTL.Liver.NSD.pvalcorrected.txt",sep="")
FileciseQTLLiverSD <- paste(DATADIR2,"QTL_detection/cis-eQTL/Liver_sd/ciseQTL.Liver.SD.pvalcorrected.txt",sep="")

# RefSeq Data
RefSeqData <- paste(DATADIR,"RefSeqMiddlePosition.table",sep="")

# Variation table
VariantAnnotationFile <- paste(DATADIR,"Variant_Annotation.txt",sep="")
FilePolyphen2 <- paste(DATADIR,"Polyphen2.table",sep="")

# Genotype file
FileGenotype <- paste(DATADIR,"Genotype.FormatedName.geno",sep="")

# DE file
LimmaCortex <- paste(DATADIR2,"DE/RNA_SD_vs_NSD_DiffExp_Limma_Cortex.txt",sep="")
LimmaLiver <- paste(DATADIR2,"/DE/RNA_SD_vs_NSD_DiffExp_Limma_Liver.txt",sep="")
