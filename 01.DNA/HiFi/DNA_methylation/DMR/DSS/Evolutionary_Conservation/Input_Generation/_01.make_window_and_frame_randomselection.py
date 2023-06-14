import os
bedtools='/mnt/mone/Project/WC300/Tools/Anaconda3/bin/bedtools'
shuf='/usr/bin/shuf'
region='hg38_primary_chrX.bed'
cpg_region='hg38_primary_chrX_CpG.bed'
pmd_region='AK1_WGBS_PMD.bed'
N_region='hg38.analysisSet_N.bed'

# 1. Make hg38 10kb bed file with step size 100bp
os.system(f'{bedtools} makewindows -b {region} -w 10000 -s 100 -s > {region.rstrip(".bed") + "_10kb_sw100bp.bed"}')

# 2. Filter out non-cpg tiles
os.system(f'{bedtools} intersect -wa -u -a {region.rstrip(".bed") + "_10kb_sw100bp.bed"} -b {cpg_region} > {region.rstrip(".bed") + "_10kb_sw100bp_wCpG.bed"}')

# 3. Filter out regions overlapped with PMD (from AK1-WGBS)
os.system(f'{bedtools} intersect -v -a {region.rstrip(".bed") + "_10kb_sw100bp_wCpG.bed"} -b {pmd_region} > {region.rstrip(".bed") + "_10kb_sw100bp_wCpG_woPMD.bed"}')

# 4. Filter out regions with N runs
os.system(f'{bedtools} intersect -v -a {region.rstrip(".bed") + "_10kb_sw100bp_wCpG.bed"} -b {N_region} > {region.rstrip(".bed") + "_10kb_sw100bp_wCpG_woPMD_woN.bed"}')

# 5. Randomly select 100k lines
os.system(f'{shuf} {region.rstrip(".bed") + "_10kb_sw100bp_wCpG_woPMD_woN.bed"} > {region.rstrip(".bed") + "_10kb_sw100bp_wCpG_woPMD_woN_shuffle100k.bed"}')


'''
bedtools intersect -wa -u -a hg38_primary_chrX_10kb_sw100bp.bed -b hg38_primary_chrX_CpG.bed > hg38_primary_chrX_10kb_sw100bp_wCpG.bed
bedtools intersect -v -a hg38_primary_chrX_10kb_sw100bp_wCpG.bed -b AK1_WGBS_PMD.bed > hg38_primary_chrX_10kb_sw100bp_wCpG_woPMD.bed
bedtools intersect -v -a hg38_primary_chrX_10kb_sw100bp_wCpG_woPMD.bed -b hg38.analysisSet_N.bed > hg38_primary_chrX_10kb_sw100bp_wCpG_woPMD_woN.bed 
shuf -n 100000 hg38_primary_chrX_10kb_sw100bp_wCpG_woPMD_woN.bed > hg38_primary_chrX_10kb_sw100bp_wCpG_woPMD_woN_shuffle100k.bed
'''
