#In /mnt/mone/Project/AK1_PacBio/01.DNA/Analysis_Samples_Merged/DNA_Methylation_Analysis/PMD/Gene_Density
# Make Gene/Transcript bed files
#bedtools merge -i TRANSCRIPT_gencode.v41.annotation.basic.sorted_woYnM.bed > transcript_woYnM.bed
#bedtools merge -i TRANSCRIPT_gencode.v41.annotation.basic.sorted.protein_coding_woYnM.bed > transcript_protein_coding_woYnM.bed
#bedtools merge -i GENE_gencode.v41.annotation.sorted_woYnM.bed > gene_woYnM.bed
#bedtools merge -i GENE_gencode.v41.annotation.sorted.protein_coding_woYnM.bed > gene_protein_coding_woYnM.bed

# Genome Size (callable)
bedtools subtract -a hg38.analysisSet_primary_woY.bed -b hg38.analysisSet_N.bed | bedtools subtract -a - -b AK1_Low_coverage.bed > genome_callable.bed

# Callable region inside of PMD
bedtools subtract -a AK1_PMD_HiFi.bed -b AK1_Low_coverage.bed > Inside_of_PMD.bed

# Callable region outside of PMD
bedtools subtract -a hg38.analysisSet_primary_woY.bed -b hg38.analysisSet_N.bed | bedtools subtract -a - -b Inside_of_PMD.bed > Outside_of_PMD.bed
