# Use CrossMap to convert mm9 position to mm10
# Citation:
# Zhao, H., Sun, Z., Wang, J., Huang, H., Kocher, J.-P., & Wang, L. (2013). CrossMap: a versatile tool for coordinate conversion between genome assemblies. Bioinformatics (Oxford, England), btt730.

## Polyphen2.table
# Create simple bed file with position
cat Polyphen2.table | awk '{print $6,$7,$7,$1,$2,$3,$4,$5}' > Polyphen2_mm9_position.bed
# Convert these position into mm10
CrossMap.py bed NCBIM37_to_GRCm38.chain.gz Polyphen2_mm9_position.bed Polyphen2_mm10_position.bed
# Replace old position with new position
python3 Replace.py Polyphen2.table Polyphen2_mm10_position.bed Polyphen2_mm10.table
# awk 'FNR==NR{a[NR]=$2;next}{$7=a[FNR]}1' Polyphen2_mm10_position.bed Polyphen2.table > Polyphen2_mm10.table
# Remove genes not found in mm10
python3 Filter.py Polyphen2_mm10.table ../GenePosition.txt Polyphen2_mm10_filtered.table
cp Polyphen2_mm10_filtered.table ..

# Create simple bed file with position
cat Variant_Annotation.txt | awk '{print $6,$7,$7,$1,$2,$3,$4,$5}' > Variant_Annotation_mm9_position.bed
# Convert these position into mm10
CrossMap.py bed NCBIM37_to_GRCm38.chain.gz Variant_Annotation_mm9_position.bed Variant_Annotation_mm10_position.bed
# Replace old position with new position
python3 Replace.py Variant_Annotation.txt Variant_Annotation_mm10_position.bed Variant_Annotation_mm10.txt
# Remove genes not found in mm10
python3 Filter.py Variant_Annotation_mm10.txt ../GenePosition.txt Variant_Annotation_mm10_filtered.txt
cp Variant_Annotation_mm10_filtered.txt ..