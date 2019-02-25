#!/bin/bash
#GOAL: This script performs the eQTL analysis using fastQTL.

# load fastQTL
module add UHTS/Analysis/FastQTL/2.184;

##FastQTL="/home/maxime/Documents/Software/FastQTL-2.165.linux/bin/fastQTL.1.165.linux"
# file with the genotype info
GenotypeF=$1
# file with the molecular phenotype (=gene expression)
PhenotypeF=$2
# name set of data (condition: SD or NSD and tissue: liver or cortex)
OutF=$3
# list of pheotype(s) to exclude
TrExclude=$4

# exit setting: exit immediately if a command/part of a command/pipeline exits with a non-zero status 
set -e

if [ -f ciseQTL.$OutF\.txt ] ; then
    rm ciseQTL.$OutF\.txt
fi

# create a empty file for the final input
touch ciseQTL.$OutF\.txt

# separate in multiple chuncks for running on the cluster, the phenotypes are treated in parallel.
for c in $(seq 1 25); do 
echo $c >&2

# exclude phenotypes for the analysis if there are some listed. 
if [ -n "$4" ] ; then
	fastQTL  --vcf $GenotypeF --window 2e6 --permute 1000 --bed $PhenotypeF --seed 1 --out $OutF.$c\.25.txt --chunk $c 25 --exclude-phenotypes $TrExclude
else
	fastQTL  --vcf $GenotypeF --window 2e6 --permute 1000 --bed $PhenotypeF --seed 1 --out $OutF.$c\.25.txt --chunk $c 25
fi

# The fastQTL command does:
# uses the beta distribution approximation estimated from 1000 permutations to calculate adjusted p-values (--permute 1000, no default)
# tests association for a molecular phenotype only for variants that are 2 Mb above or below the transcription start site of the gene coding for the phenotype (--window 2e6, default is 1e6)
# chose to use seed one to help reproducibility of permutations (--seed 1, no default)

# group intermediate files from the different chunks
cat $OutF.$c\.25.txt >> ciseQTL.$OutF\.txt
# remove intermediate files
rm $OutF.$c\.25.txt
done



