
---
title: "BXD MetaData"
output: 
  html_document:
    toc: true
    toc_float: true
    theme: spacelab
    df_print: paged
    rows.print: 6
---
![alt text](MyDiagram.png)

# Project

## Systems Genetics of Sleep

#### Authors

[Maxime Jan](README.html#maxime-jan); [Ioannis Xenarios](README.html#ioannis-xenarios); [Paul Franken](README.html#paul-franken); [Shanaz Diessler](README.html#shanaz-diessler)

#### Link

Link toward our publication: https://www.ncbi.nlm.nih.gov/pubmed/

Vital-IT: https://www.vital-it.ch/

Link toward Franken lab: https://www.unil.ch/cig/en/home/menuinst/research/research-groups/prof-franken.html	

# Author

## Maxime Jan

#### Link

Adress: Maxime.Jan@sib.swiss

## Nicolas Guex

#### Link

Adress: Nicolas.Guex@sib.swiss

## Yann Emmenegger

#### Link

Adress: yann.emmenegger@unil.ch

## Paul Franken

#### Link

Adress: paul.franken@unil.ch

## Ioannis Xenarios

#### Link

Adress: Ioannis.Xenarios@sib.swiss

## Shanaz Diessler

#### Link

Adress: shanaz.diessler@gmail.com

# File

## Normalized Counts

### CPM Liver NSD

#### Description

 
The file is generated using [Transcript normalization](README.html#counts-normalization), each row is a [Gene](README.html#refseq-dataset-2014) and each column is a [BXD line](README.html#molecular-data).
 
The tissu come from the [Liver](README.html#liver) during the [Control](README.html#control). Counts are in Count Per Million [CPM]


#### Path

/home/mjan/PhD/GeneExpression/NormalizedExpression/htseq-count_summary.Liver.txt.NSD.CPMnormalizedWITHNSDSD.txt

### CPM Cortex SD

#### Description

 
The file is generated using [Transcript normalization](README.html#counts-normalization), each row is a [Gene](README.html#refseq-dataset-2014) and each column is a [BXD line](README.html#molecular-data).
 
The tissu come from the [Cortex](README.html#cortex) during the [sleep deprivation](README.html#sleep-deprived). Counts are in Count Per Million [CPM]


#### Path

/home/mjan/PhD/GeneExpression/NormalizedExpression/htseq-count_summary.Cortex.txt.SD.CPMnormalizedWITHNSDSD.txt

### CPM Cortex NSD

#### Description

 
The file is generated using [Transcript normalization](README.html#counts-normalization), each row is a [Gene](README.html#refseq-dataset-2014) and each column is a [BXD line](README.html#molecular-data).
 
The tissu come from the [Cortex](README.html#cortex) during the [Control](README.html#control). Counts are in Count Per Million [CPM]


#### Path

/home/mjan/PhD/GeneExpression/NormalizedExpression/htseq-count_summary.Cortex.txt.NSD.CPMnormalizedWITHNSDSD.txt

### CPM Liver SD

#### Description

 
The file is generated using [Transcript normalization](README.html#counts-normalization), each row is a [Gene](README.html#refseq-dataset-2014) and each column is a [BXD line](README.html#molecular-data).
 
The tissu come from the [Liver](README.html#liver) during the [sleep deprivation](README.html#sleep-deprived). Counts are in Count Per Million [CPM]


#### Path

/home/mjan/PhD/GeneExpression/NormalizedExpression/htseq-count_summary.Liver.txt.SD.CPMnormalizedWITHNSDSD.txt

## Transcript raw counts

### Raw Counts in Liver

#### Description

The file is generated using [Htseq-count](README.html#htseq-count-union), each row is a [Gene](README.html#refseq-dataset-2014) and each column is a [BXD line](README.html#molecular-data).
 
The tissu come from the [Liver](README.html#liver) during the [sleep deprivation or sd](README.html#sleep-deprived) and [Control or nsd](README.html#control).


#### Path

/home/mjan/PhD/GeneExpression/RawCounts/RawCounts.Liver.txt

### Raw Counts in Cortex

#### Description

The file is generated using [Htseq-count](README.html#htseq-count-union), each row is a [Gene](README.html#refseq-dataset-2014) and each column is a [BXD line](README.html#molecular-data).
 
The tissu come from the [Cortex](README.html#cortex) during the [sleep deprivation or sd](README.html#sleep-deprived) and [Control or nsd](README.html#control).


#### Path

/home/mjan/PhD/GeneExpression/RawCounts/RawCounts.Cortex.txt

## Fastq Files

### Fastq Liver SD

#### Description

Fastq files from each [BXD lines](README.html#bxd-mouse) generated using Illumina RNA-seq


#### Path

Archived

#### Input

[BXD molecular experiment](README.html#molecular-data)

### Fastq Liver NSD

#### Description

Fastq files from each [BXD lines](README.html#bxd-mouse) generated using Illumina RNA-seq


#### Path

Archived

#### Input

[BXD molecular experiment](README.html#molecular-data)

### Fastq Cortex SD

#### Description

Fastq files from each [BXD lines](README.html#bxd-mouse) generated using Illumina RNA-seq


#### Path

Archived

#### Input

[BXD molecular experiment](README.html#molecular-data)

### Fastq Cortex NSD

#### Description

Fastq files from each [BXD lines](README.html#bxd-mouse) generated using Illumina RNA-seq


#### Path

Archived

#### Input

[BXD molecular experiment](README.html#molecular-data)

## MetaboFiles

### Metabolite level

#### Description

Metabolite level for each [BXD lines](README.html#bxd-mouse)
 
* This file contain Metabolite data for New strains and parental and F1 during [Control](README.html#control) and [Sleep deprivation](README.html#sleep-deprived)
 
* A file containing also old strains is located: /home/mjan/PhD/Rdata/Metabolites_BXD_alldata.txt
 
* Two file containing Mean metabolite values can be found here: /home/mjan/PhD/Rdata/MetabolitesMean.NSD.txt (for control) and /home/mjan/PhD/Rdata/MetabolitesMean.SD.txt (for SD)


#### Path

/home/mjan/PhD/BXD_Paper_Public/Data/Metabolite_BXD.txt

## Bam Files

### Bam Files Cortex NSD

#### Description

Alignement File [Bam] for [Cortex](README.html#cortex) during [Control](README.html#control)


#### Path

frt.el.vital-it.ch:/scratch/cluster/monthly/mjan

## eQTLfiles

### eQTL Cortex NSD

#### Description

eQTL for [Cortex](README.html#cortex) during [Control](README.html#control)
Each row is a [Gene](README.html#refseq-dataset-2014) , first column is the FDR adjusted pvalue using Rpackage qvalue
the last column is a [genetic marker](README.html#bxd-genotypes)


#### Path

/home/mjan/PhD/Rdata/ciseQTL.Cortex.NSD.pvalcorrected.txt

## Partial Correlation Matrix

### Partial correlation matrix, liver SD

#### Path

/scratch/cluster/monthly/mjan/pcor_spearman_LiverSD_LiverSD.Rdata

## Spectral Data

#### Description

Spectral data used for manual annotation and semi-automatic learning approach.
The files are transforme using Fast Fourier transform (FFT). Ask [Yann Emmenegger](README.html#yann-emmenegger) for the processing details.


#### Path

Archived by [Paul Franken](README.html#paul-franken)

## Manual Annotation

#### Description

manually annotated data on the [3rd day of recording (R1)](README.html#bxd-behavioraleeg). Performed by [Yann Emmenegger](README.html#yann-emmenegger). Manual annotation is performed on each mouse of each [BXD lines](README.html#bxd-mouse).


#### Path

Archived by [Paul Franken](README.html#paul-franken)

## PIR motion sensor data

#### Description

PIR motion sensor data recording activity for each mouse of each [BXD lines](README.html#bxd-mouse)


#### Path

Archived by [Paul Franken](README.html#paul-franken)

## Predicted EEG State

#### Description

Predicted state for each [BXD](README.html#bxd-mouse). Prediction for 4 days every 4 seconds (86400 epochs). State are wake [w], NREM sleep [n], REM sleep [r] or artefact value of wake [1], NREM [2] or REM [3]. The 3rd day is replaced by the [manual annotation](README.html#manual-annotation)


#### Path

Archived by [Paul Franken](README.html#paul-franken)

## EEG and Behavioral Phenotypes

#### Description

EEG and Behavioral sleep phenotypes.
Phenotypes contain:
 	 	
* activity
* EEG
* State
 
The directory "Phenotypes/" contains the following information:
 
* [line (BXD lines)](README.html#bxd-mouse)
* mouseID (in format "lines"_"mouseID")
* room (room used for recording)
* rec (recording time period)
* worm (worm detection yes:1 no:0)
* Phenotypes ...
 
A mean value per lines was computed and stored into the following files:
 	
* as text: AllPheno.txt
* as Rdata matrix: SleepPhenotype.Rdata


#### Path

/home/mjan/PhD/Rdata

## Phenotypes Categories

#### Description

Categories for each sleep phenotypes. The categories are related to EEG/State or Activity. The file contain also subcategories and condition related to each phenotypes (can be [bsl](README.html#control), [rec: after sleep deprivation](README.html#sleep-deprived) or $< SD: during sleep deprivation [Sd])	


#### Path

/home/mjan/PhD/Rdata/Phenotype.Categories.txt

## Hypothalamus Bam files

#### Description

RNA-seq aligned read from hypothalamus.
The Data were generated by Bernard Thorens group
Single-End Illumina reads 100bps


#### Path

Archived

#### Input

[BXD mice](README.html#bxd-mouse)

#### Link

Bernard Thorens group: https://www.unil.ch/cig/en/home/menuinst/research/research-groups/prof-thorens.html

## Brain stem Bam files

#### Description

RNA-seq aligned read from brain stem.
The Data were generated by Bernard Thorens group
Single-End Illumina reads 100bps


#### Path

Archived

#### Input

[BXD mice](README.html#bxd-mouse)

#### Link

Bernard Thorens group: https://www.unil.ch/cig/en/home/menuinst/research/research-groups/prof-thorens.html

## BXD variant [.vcf]

#### Description

Variant calling file generated with [GATK](README.html#variant-calling-with-gatk)


#### Path

My Data ..

## BXD genotypes

#### Description

Genotype of the BXD using the merge of GeneNetwork and Variant calling


#### Path

/home/mjan/PhD/Rdata/Genotype.FormatedName.geno

## Significant interaction genotype x SD for gene

#### Description

These files contain the significant interaction term between local genotypes and sleep deprivation effect.
The SD effect map significantly on the local region (cis) and the interaction term for genotype effect on SD effect is also significant. 


#### Path

/home/mjan/PhD/Rdata/Genotype_SD_Interaction_Liver.txt & Genotype_SD_Interaction_Cortex.txt

## Significant interaction genotype x SD for metabolite

#### Description

These files contain the significant interaction term between local genotypes and sleep deprivation effect.


#### Path

/home/mjan/PhD/Rdata/Genotype_SD_Interaction_Metabolites.txt

## Significant interaction genotype x SD for phenotypes

#### Description

These files contain the significant interaction term between local genotypes and sleep deprivation effect.


#### Path

/home/mjan/PhD/Rdata/Genotype_SD_Interaction_Phenotypes.txt

## RefSeq DataSet 2014

#### Description

File that come from UCSC table browser. It was generated using RefSeq Reflat database on the 2014/01/29.


#### Path

/home/mjan/PhD/Rdata/RefSeq_20140129.gtf

#### Link

UCSC table browser: https://genome.ucsc.edu/cgi-bin/hgTables

## GeneNetwork genotypes

#### Description

Genotype from GeneNetwork


#### Path

/home/mjan/PhD/Rdata/GNmm9.Fred.GNformat.geno

#### Version

2005

#### Link

Genenetwork: http://genenetwork.org/webqtl/main.py

## Reference genome

#### Description

Mus_musculus.NCBIM37.67.dna.top.level.fa


# Workflow

## EEG & State & PIR analysis

#### Description

* EEG spectral data analysis for spectral power and spectral gain analysis.
* Activity is measure using PIR motion sensor.
* State concerns Wake [w], NREM[n] and REM[n]


#### Input

[spectral files](README.html#spectral-data); [PIR data](README.html#pir-motion-sensor-data); [Semi-Automatic Annotation](README.html#predicted-eeg-state)

#### Output

[341 Phenotype Data](README.html#eeg-and-behavioral-phenotypes)

#### Authors

[Paul Franken](README.html#paul-franken)

#### Link

Phenotypes full description: Phenotypes.docx

## Semi-Automatic EEG scoring

#### Description

 
* Supervised machine learning approach for EEG annotation.
 
* Multiple SVMs on 1s data resolution
 
* For reinstallation follow the README.txt
 
* Full description of the Workflow available in the README.txt
 
* Main bash script is: Mouse_SleepState_Prediction


#### Path

/data/ul/projects/bxd/PROD-V1.0.1a/

#### Input

[Manually annotated data](README.html#manual-annotation); [Spectral data](README.html#spectral-data)

#### Output

[Predicted Files](README.html#predicted-eeg-state)

#### Version

1.0.1a

#### Authors

[Nicolas Guex](README.html#nicolas-guex); [Maxime Jan](README.html#maxime-jan)

## fastq to bam files

#### Description

transformation of fastq files into bam files. Fastq files are filtered to remove low quality reads. STAR is used for alignment with the [NCBI mm9](README.html#reference-genome) reference genome. Bam are then processed using samtools, piccard and GATK for indexing, add read group, mark duplicates, realign indel, and base recalibration.


#### Path

/home/mjan/PhD/Scripts/

#### Input

[Fastq Files](README.html#fastq-files)

#### Output

[Bam Files](README.html#bam-files)

#### CS

>GenBSUB_Clean_Fastq.py <br>
generate_STAR_alignement_bsubs_1pass.pl <br>
generate_STAR_alignement_bsubs.pl <br>
PreProcessBam.py <br>

## Variant calling with GATK

#### Description

We use the standard GATK pipeline for variant calling on RNA-sequencing. GenBSUB* scritps generate LSF commands.
As some bam file were aligned on mm9 (NCBI, for sleep data) and other on mm9 (UCSC, for hypothalamus and brainstem)
Some file needed to be reheader (ReheaderFiles.py) and modify chromosome name (chr1 -> 1 RemoveCHR.py) 


#### Path

/home/mjan/PhD/Scripts/

#### Input

[Bam files](README.html#bam-files); [Bam files hypothalamus](README.html#hypothalamus-bam-files); [Bam files BrainStem](README.html#brain-stem-bam-files)

#### Output

[VCF file](README.html#bxd-variant-[vcf])

#### CS

>ReheaderFiles.py <br>
GenBSUB_CallGenotypeLikelihood.py <br>
CallGeno.sh <br>
GenBSUB_GenotypingGVCF.py <br>
genotyping.sh <br>

#### Version

GATK: 3.3.0

#### Link

GATK website: https://software.broadinstitute.org/gatk/

## Variant merging

#### Description

Workflow to merge the public genotype available in geneNetwork and variant called using
RNA-sequencing. The variant that are highly different from the RNA-seq data are tag as
unknown 'U'


#### Input

[VCF file](README.html#bxd-variant-[vcf]); [GeneNetwork Genotype](README.html#genenetwork-genotypes)

#### Output

[BXD Genotypes](README.html#bxd-genotypes)

#### CS

>FilterRNAseqVariant.py <br>
FormateGNmm9.Fred.py	 <br>
CombineGenotype.py <br>

## eQTL dectection with FastQTL

#### Description

Generation of cis-eQTL files using FastQTL, the complete workflow is empacked using the Rmarkdown cis_eQTL_Analysis.Rmd.


#### Path

/home/mjan/PhD/Analysis/cis-eQTL_Detection/cis_eQTL_Analysis.Rmd

#### Input

[Normalized counts](README.html#normalized-counts); [Genotypes](README.html#bxd-genotypes)

#### Output

[eQTL files](README.html#eqtlfiles)

#### CS

>GenoToVcf.py <br>
bgzip & tabix <br>
Create_BED_UCSC.py <br>
bgzip & tabix <br>
ciseQTLAnalysis.sh <br>
Compute qvalue <br>

#### Version

fastQTL.1.165.linux

#### Link

FastQTL: http://fastqtl.sourceforge.net/

## eQTL detection for fold-change after SD

#### Description

 
Generation of cis-eQTL files using FastQTL, the complete workflow is empacked using the Rmarkdown cis_FC_eQTL_Analysis.Rmd.	
 
Same pipeline as [standard cis-eQTL](README.html#eqtl-dectection-with-fastqtl) but using fold-change


#### Path

/home/mjan/PhD/Analysis/cis-eQTL_Detection/cis_FC_eQTL_Analysis.Rmd

#### Input

[Normalized counts](README.html#normalized-counts); [Genotypes](README.html#bxd-genotypes)

#### Output

[eQTL files](README.html#eqtlfiles)

#### CS

>Fold-change calculation <br>
GenoToVcf.py <br>
bgzip & tabix <br>
Create_BED_UCSC.py <br>
bgzip & tabix <br>
ciseQTLAnalysis.sh <br>
Compute qvalue	 <br>

#### Version

fastQTL.1.165.linux

#### Link

FastQTL: http://fastqtl.sourceforge.net/

# Script

## Counts normalization

#### Description

Script used for transcript normalization using edgeR


#### Path

/home/mjan/PhD/Scripts/Normalization.R

#### Input

[Raw counts](README.html#transcript-raw-counts)

#### Output

[Normalized counts](README.html#normalized-counts)

## htseq-count union

#### Description

 
* Script to generate count file from multiple bam file alignment, generate LSF command
 
* The counts were merge using MergeCount.py


Script take as input a list of the processed bam file


#### Path

/home/mjan/PhD/Scripts/GenBSUB_htseq-count.py

#### Input

[Bam Files](README.html#bam-files); [RefSeq file](README.html#refseq-dataset-2014)

#### Output

[Raw counts](README.html#transcript-raw-counts)

#### Arguments

-q -s reverse -t exon -m union

#### Version

0.5.4p3

## Genes partial correlations

#### Description

A Rscript to generate a partial correlation matrix.
 
* Example using the script to compute pcor for gene in cortex during Control (Cortex NSD vs Cortex NSD): Matrix<-BXDpcor(CNSD,cis_CNSD,CNSD,cis_CNSD,GenotypeMatrix,CORES=30,method="pearson")
 
* The input file (Expression matrix: CNSD and cis-eQTL matrix: cis_CNSD) need to be formated to contain the same gene, You can see an example here: /home/mjan/PhD/Analysis/Partial_Correlation/GetPartialCorrelationForBXD.R
 
* The method can be "spearman" or "pearson"
* "parallel","reshape2","matrixStats" and "RcppEigen" packages are required
* If you want to change between interaction or additive effect, edit model matrix in the CorResiduals() function


#### Path

/home/mjan/PhD/Scripts/BXDpcor_V1.0.1.R

#### Input

[Expression Data](README.html#normalized-counts); [cis-eQTL File](README.html#eqtlfiles)

#### Output

[Partial correlation Matrix](README.html#partial-correlation-matrix)

#### Version

1.0.1

# Population

## BXD mouse

#### Description

Used to generate [Molecular data](README.html#molecular-data) and [Behavioral data](README.html#bxd-behavioraleeg)   


# Tissu

## Cortex

#### Description

Cortex sample extracted for RNA-seq sequencing


## Liver

#### Description

Liver sample extracted for RNA-seq sequencing


## Blood Metabolism

#### Description

Blood Metabolism quantification


# Condition

## Control

#### Description

Control sample from the [BXD](README.html#bxd-mouse) Experiments


## Sleep deprived

#### Description

6h of sleep deprivation during the 3rd day of recording during the first our of light phase [ZT0-6]


# Rmarkdown

## Genotype-SD interaction for transcript

#### Description

 	 
A limma pipeline that test if a gene fold-change after [sleep deprivation](README.html#sleep-deprived) that was map locally (using [cis-eQTL fold-change](README.html#eqtl-detection-for-fold-change-after-sd)) 
has a significant interaction term.
 		
The pipeline use the following linear model: Gene Level = Genotype * Condition


#### Path

/home/mjan/PhD/Analysis/Allelic_Differential_Expression/Allelic_Differential_Expression_Final.Rmd

#### Input

[Raw counts](README.html#transcript-raw-counts); [Genotypes](README.html#bxd-genotypes); $<cis-eQTL fold-change [FC_FastQTL] >

#### Output

[Genotype SD significant interaction](README.html#significant-interaction-genotype-x-sd-for-gene)

## Genotype-SD interaction for metabolite

#### Description

 
An ANOVA pipeline that test if a metabolite fold-change after [sleep deprivation](README.html#sleep-deprived) that was map locally (using mQTL) 
has a significant interaction term.
  
As we have independent measurement between condition and multiple value for each BXD lines, we use the following linear model
 
The pipeline use the following nested linear model: Metabolite Level = Genotype/BXDLines + Genotype * Condition


#### Path

/home/mjan/PhD/BXD_Paper_Public/Analysis/Differential_Expression_Metabolites_FC.Rmd

#### Input

[Metabolite level](README.html#metabolite-level); [Genotypes](README.html#bxd-genotypes); mQTL

#### Output

[Genotype SD significant interaction](README.html#significant-interaction-genotype-x-sd-for-metabolite)

## Genotype-SD interaction for phenotypes

#### Description

 
A mixed model pipeline that test if a phenotypes fold-change after [sleep deprivation](README.html#sleep-deprived) that was map locally (using ph-QTL) 
has a significant interaction term.
As we have dependent measurement between condition and multiple value for each BXD lines, we use the following linear mixed model (we didn't use lines as fixed effect to reduce
the number of parameter used in our model)
 
The pipeline use the following linear mixed model: Phenotypes Level => fixed effect: Genotype * Condition; random effect: Mouse individual, we model a different intercept
for different mouse.
(using lmer: Phenotype ~ Genotype * Condition + (1|mID)) 


#### Path

/home/mjan/PhD/Analysis/SDEffectOnPhenotypes/SDeffectOnPhenotype_FCdiff.Rmd

#### Input

[Phenotype data](README.html#eeg-and-behavioral-phenotypes); [Genotypes](README.html#bxd-genotypes); ph-QTL

#### Output

[Genotype SD significant interaction](README.html#significant-interaction-genotype-x-sd-for-phenotypes)

## Heritability calculation

#### Description

Rmarkdown for heritability calculation, details in the Rmarkdown


#### Path

/home/mjan/PhD/BXD_Paper_Figures/Heritability.html

#### Input

[Sleep phenotypes](README.html#eeg-and-behavioral-phenotypes); [Sleep categories](README.html#phenotypes-categories)

## Metabolite Ctl vs SD

#### Description

Rmarkdown for differential metabolite level, details in the Rmarkdown


#### Path

/home/maxime/Link_To_Cluster/BXD_Paper_Public/Analysis/Differential_Expression_Metabolites.html

#### Input

[Metabolite level](README.html#metabolite-level)

# Experiment

## Molecular data

### BXD Molecular SD

#### Description

BXD cohort for molecular quantification after sleep deprivation


#### Input

[BXD](README.html#bxd-mouse); [Sleep Deprivation](README.html#sleep-deprived); [Cortex](README.html#cortex); [Liver](README.html#liver); [Blood](README.html#blood-metabolism)

#### Output

[fastq files Cortex SD](README.html#fastq-cortex-sd); [fastq files Liver SD](README.html#fastq-liver-sd); [Metabolite level](README.html#metabolite-level)

### BXD Molecular NSD

#### Description

BXD cohort for molecular quantification after sleep deprivation


#### Input

[BXD](README.html#bxd-mouse); [Control](README.html#control); [Cortex](README.html#cortex); [Liver](README.html#liver); [Blood](README.html#blood-metabolism)

#### Output

[fastq files Liver Control](README.html#fastq-liver-nsd); [fastq files Cortex Control](README.html#fastq-cortex-nsd); [Metabolite level](README.html#metabolite-level)

## BXD Behavioral/EEG

#### Description

Generation of data for EEG and behavioral phenotypes.
The [BXD](README.html#bxd-mouse) are recorded for 4 days under light and dark condition. The 3rd day, mice underwent 6h of [sleep deprivation](README.html#sleep-deprived). The recording follow-up for 2 day (recovery).
The 2 days of baseline are considered as [Control](README.html#control) and the 2 days of recorvery are considered as the condition [sleep deprivted](README.html#sleep-deprived)	


#### Input

[BXD](README.html#bxd-mouse); [Control](README.html#control); [Sleep deprivation](README.html#sleep-deprived)

#### Output

[EEG Spectral Data](README.html#spectral-data); [PIR motion Data](README.html#pir-motion-sensor-data); [EEG manula annotation](README.html#manual-annotation)

