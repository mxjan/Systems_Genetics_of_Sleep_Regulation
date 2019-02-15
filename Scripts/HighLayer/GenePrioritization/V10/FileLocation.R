# Set all files location

# Working directory
WD<-"/home/maxime/SwitchDrive/switchdrive/Project/GeneScoring_mm10/V10"
#WD<-"C:/Users/Maxime Jan/switchdrive/Project/GeneScoring_mm10/V10/"
# Data location DIR
DATADIR<-"/home/maxime/SwitchDrive/switchdrive/Project/GeneScoring_mm10/data/"
#DATADIR<-"C:/Users/Maxime Jan/switchdrive/Project/GeneScoring_mm10/data/"
# Temp File Directory
#TMPDIR<-"/scratch/beegfs/monthly/mjan/ScoringV8/tmp/"
TMPDIR<-"/home/maxime/SwitchDrive/switchdrive/Project/GeneScoring_mm10/V10/tmp/"
#TMPDIR<-"C:/Users/Maxime Jan/switchdrive/Project/GeneScoring_mm10/V10/tmp/"
# Scripts Dir:
SCRIPTDIR<-"/home/maxime/SwitchDrive/switchdrive/Project/GeneScoring_mm10/V10/src/"
#SCRIPTDIR<-"C:/Users/Maxime Jan/switchdrive/Project/GeneScoring_mm10/V10/src/"

###################################################################

# Script python
FormatQTLR<-paste(SCRIPTDIR,'FormatFileQTLR.py',sep="")

# Text files containing expression data
FileExpressionCortexNSD<-paste(DATADIR,"edgeR_normalized_log2CPM_Cortex_NSD.tab",sep="")
FileExpressionCortexSD<-paste(DATADIR,"edgeR_normalized_log2CPM_Cortex_SD.tab",sep="")
FileExpressionLiverNSD<-paste(DATADIR,"edgeR_normalized_log2CPM_Liver_NSD.tab",sep="")
FileExpressionLiverSD<-paste(DATADIR,"edgeR_normalized_log2CPM_Liver_SD.tab",sep="")
#FileExpressionLiverSD<-paste(DATADIR,"Liver.SD.TPM.V2.txt",sep="")

# Text files containing phenotype data
FileSleepPhenotype<-paste(DATADIR,"AllPhenotest.txt",sep="")
#FileSleepPhenotype<-paste(DATADIR,"Pheno_Alexandre/bxd_insuline_trim2.txt",sep="")
#FileSleepPhenotype<-"/home/maxime/Link_To_Cluster/Analysis/Delta1_2_20Min/BXDdel1_del2_20m_Means.out"
#FileSleepPhenotype<-paste(DATADIR,"Pheno_Jeff/bxd_d1d2_logtransform.txt",sep="")
FileMetaboliteNSDPhenotype<-paste(DATADIR,"MetabolitesMean.NSD.txt",sep="")
FileMetaboliteSDPhenotype<-paste(DATADIR,"MetabolitesMean.SD.txt",sep="")

# cis eQTL data
#FileciseQTLCortexNSD<-paste(DATADIR,"ciseQTL.Cortex.NSD.pvalcorrected.txt",sep="")
#FileciseQTLCortexSD<-paste(DATADIR,"ciseQTL.Cortex.SD.pvalcorrected.txt",sep="")
#FileciseQTLLiverNSD<-paste(DATADIR,"ciseQTL.Liver.NSD.pvalcorrected.txt",sep="")
#FileciseQTLLiverSD<-paste(DATADIR,"ciseQTL.Liver.SD.pvalcorrected.txt",sep="")
FileciseQTLLiverSD<-paste(DATADIR,"ciseQTL.Liver.SD.pvalcorrected.txt",sep="")
FileciseQTLCortexNSD<-paste(DATADIR,"ciseQTL.Cortex.NSD.pvalcorrected.txt",sep="")
FileciseQTLCortexSD<-paste(DATADIR,"ciseQTL.Cortex.SD.pvalcorrected.txt",sep="")
FileciseQTLLiverNSD<-paste(DATADIR,"ciseQTL.Liver.NSD.pvalcorrected.txt",sep="")

# RefSeq Data
RefSeqData<-paste(DATADIR,"GenePosition.txt",sep="")

# Variation table
VariantAnnotationFile<-paste(DATADIR,"Variant_Annotation_mm10_filtered.txt",sep="")
FilePolyphen2<-paste(DATADIR,"Polyphen2_mm10_filtered.table",sep="")

# Genotype file
#FileGenotype<-paste(DATADIR,"Genotype.FormatedName.geno",sep="")
FileGenotype<-paste(DATADIR,"GNmm10.newgenotypes_subset_sorted.geno",sep="")

# DE file
LimmaCortex<-paste(DATADIR,"Limma_Cortex.txt",sep="")
LimmaLiver<-paste(DATADIR,"Limma_Liver.txt",sep="")



