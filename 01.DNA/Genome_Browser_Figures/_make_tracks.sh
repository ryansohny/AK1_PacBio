#!/bin/bash

#export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
#source activate pygenometracks

# All of the configuration files (*.ini) were manually fixed after their generation (make_tracks_file).

make_tracks_file \
--trackFiles \
AK1_haplotagged_wIndels_splt_mincov4.combined.denovo.bw \
iPSC_haplotagged_wIndels_splt_mincov4.combined.denovo.bw \
NPC_haplotagged_wIndels_splt_mincov4.combined.denovo.bw \
DMRs_DSS_ALL_MetTh40.merged.bed \
AK1_WGBS_PMD.bed \
gencode.v41.annotation.basic.gtf \
--out test.tracks.ini


pyGenomeTracks --tracks test.tracks.ini --region chr3:29273536-29289000 --trackLabelFraction 0.05 --dpi 200 --outFileName test.pdf

make_tracks_file \
--trackFiles \
AK1_haplotagged_wIndels_splt_mincov4.combined.denovo.bw \
HG002_merged_ML.combined.denovo.bw \
iPSC_haplotagged_wIndels_splt_mincov4.combined.denovo.bw \
H1_merged_cov5.bw \
HUES64_merged_cov5.bw \
NPC_haplotagged_wIndels_splt_mincov4.combined.denovo.bw \
DMRs_DSS_ALL_MetTh40.merged.bed \
AK1_MAS-ISO-seq.bw \
iPSC_MAS-ISO-seq.bw \
NPC_MAS-ISO-seq.bw \
gencode.v41.annotation.basic.gtf \
--out allmet_dmr_rna.tracks.ini


make_tracks_file \
--trackFiles \
AK1_haplotagged_wIndels_splt_mincov4.hap1.denovo.bw \
AK1_haplotagged_wIndels_splt_mincov4.hap2.denovo.bw \
iPSC_haplotagged_wIndels_splt_mincov4.hap1.denovo.bw \
iPSC_haplotagged_wIndels_splt_mincov4.hap2.denovo.bw \
H1_merged_cov5.bw \
HUES64_merged_cov5.bw \
NPC_haplotagged_wIndels_splt_mincov4.hap1.denovo.bw \
NPC_haplotagged_wIndels_splt_mincov4.hap2.denovo.bw \
Candidate_ICR_metcutoff65_from_AK1_Hap_sorted.bed \
gencode.v41.annotation.basic.gtf \
--out hap.grch38.tracks.ini

# Manually corrected hap.grch38.tracks.ini to generate the file, hap_with_Imprintome.grch38.tracks.ini 
# Manually corrected hap.grch38.tracks.ini to generate the file, hap_with_lowmappability.grch38.tracks.ini

pyGenomeTracks --tracks hap.grch38.tracks.ini --region chr1:2383776-2395556 --trackLabelFraction 0.05 --dpi 200 --outFileName MORN1_Haplotype_mCG_Figure.pdf

pyGenomeTracks --tracks hap_with_Imprintome.grch38.tracks.ini --region chr1:68045530-68053103 --trackLabelFraction 0.05 --dpi 200 --outFileName DIRAS3_Haplotype_mCG_Figure.pdf

pyGenomeTracks --tracks hap_with_Imprintome.grch38.tracks.ini --BED known_imprinting_genes.bed --trackLabelFraction 0.05 --dpi 200 --width 30 --height 40 --outFileName Known_Imprinted_Genes_Haplotype_mCG_Figure.pdf

pyGenomeTracks --tracks hap_with_lowmappability.grch38.tracks.ini --region chr1:121395503-121398359 --trackLabelFraction 0.05 --dpi 200 --width 30 --height 40 --outFileName SRGAP2-AS1_LowMappability_Haplotype_mCG_Figure.pdf

pyGenomeTracks --tracks allmet_dmr_rna.tracks.ini --region chr12:25045726-25114566 --trackLabelFraction 0.05 --dpi 200 --width 30 --height 30 --outFileName IRGA2_mCG-DMR_Differential_Expression_Figure.pdf
