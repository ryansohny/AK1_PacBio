# Merging AK1 & iPSC low coverage region
cat AK1_Low_coverage.bed iPSC_Low_coverage.bed | bedtools sort -i - | bedtools merge -i - > AK1-iPSC_Low_coverage.bed

# Genome Size (callable)
bedtools subtract -a hg38.analysisSet_primary_woY.bed -b hg38.analysisSet_N.bed | bedtools subtract -a - -b AK1-iPSC_Low_coverage.bed > genome_callable.bed

# Callable region inside of Hyper-DMR
bedtools subtract -a HyperDMRs_DSS_woPMD_AK1-iPSC_MetTh40.bed -b AK1-iPSC_Low_coverage.bed > Inside_of_HyperDMR_DSS_woPMD_AK1-iPSC_MetTh40.bed

# Callable region inside of Hyper-DMR
bedtools subtract -a HypoDMRs_DSS_woPMD_AK1-iPSC_MetTh40.bed -b AK1-iPSC_Low_coverage.bed > Inside_of_HypoDMR_DSS_woPMD_AK1-iPSC_MetTh40.bed