GenoF=GNmm10.newgenotypes_subset_sorted.geno
PhenoF=AllPhenotest.txt
ExprF=edgeR_normalized_log2CPM_Cortex_NSD.tab
OutF=CNSD
RefPosMiddle=GenePosition.txt

python Create_MAP.py $GenoF $OutF.map
python Create_PED.py $PhenoF $GenoF $OutF.ped
python Create_PHENO.py $ExprF $OutF.ped $OutF.pheno
plink --noweb --file $OutF --make-bed --maf 0.05 --geno 0.1 --out $OutF
preFastEpistasis --bfile $OutF --pheno $OutF.pheno --gwas --hdf5 --out $OutF.out
smpFasteQTL --epi1 0.0001 $OutF.out.hdf5
python Parse_AssocHDF5.py $OutF.out.assoc.qt.lm.hdf5 $OutF.out.assoc.qt.lm.txt
plink --noweb --bfile $OutF --blocks
plinkF=plink.blocks.det
python FilterTranseQTL.py $OutF.out.assoc.qt.lm.txt $GenoF $RefPosMiddle $plinkF > $OutF.Filter.out.assoc.qt.lm.txt

ExprF=edgeR_normalized_log2CPM_Cortex_SD.tab
OutF=CSD
python Create_MAP.py $GenoF $OutF.map
python Create_PED.py $PhenoF $GenoF $OutF.ped
python Create_PHENO.py $ExprF $OutF.ped $OutF.pheno
plink --noweb --file $OutF --make-bed --maf 0.05 --geno 0.1 --out $OutF
preFastEpistasis --bfile $OutF --pheno $OutF.pheno --gwas --hdf5 --out $OutF.out
smpFasteQTL --epi1 0.0001 $OutF.out.hdf5
python Parse_AssocHDF5.py $OutF.out.assoc.qt.lm.hdf5 $OutF.out.assoc.qt.lm.txt
python FilterTranseQTL.py $OutF.out.assoc.qt.lm.txt $GenoF $RefPosMiddle $plinkF > $OutF.Filter.out.assoc.qt.lm.txt

ExprF=edgeR_normalized_log2CPM_Liver_NSD.tab
OutF=LNSD
python Create_MAP.py $GenoF $OutF.map
python Create_PED.py $PhenoF $GenoF $OutF.ped
python Create_PHENO.py $ExprF $OutF.ped $OutF.pheno
plink --noweb --file $OutF --make-bed --maf 0.05 --geno 0.1 --out $OutF
preFastEpistasis --bfile $OutF --pheno $OutF.pheno --gwas --hdf5 --out $OutF.out
smpFasteQTL --epi1 0.0001 $OutF.out.hdf5
python Parse_AssocHDF5.py $OutF.out.assoc.qt.lm.hdf5 $OutF.out.assoc.qt.lm.txt
python FilterTranseQTL.py $OutF.out.assoc.qt.lm.txt $GenoF $RefPosMiddle $plinkF > $OutF.Filter.out.assoc.qt.lm.txt

ExprF=edgeR_normalized_log2CPM_Liver_SD.tab
OutF=LSD
python Create_MAP.py $GenoF $OutF.map
python Create_PED.py $PhenoF $GenoF $OutF.ped
python Create_PHENO.py $ExprF $OutF.ped $OutF.pheno
plink --noweb --file $OutF --make-bed --maf 0.05 --geno 0.1 --out $OutF
preFastEpistasis --bfile $OutF --pheno $OutF.pheno --gwas --hdf5 --out $OutF.out
smpFasteQTL --epi1 0.0001 $OutF.out.hdf5
python Parse_AssocHDF5.py $OutF.out.assoc.qt.lm.hdf5 $OutF.out.assoc.qt.lm.txt
python FilterTranseQTL.py $OutF.out.assoc.qt.lm.txt $GenoF $RefPosMiddle $plinkF > $OutF.Filter.out.assoc.qt.lm.txt


