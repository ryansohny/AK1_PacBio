# /mnt/mone/Project/AK1_PacBio/01.DNA/CHM13_Merged/00.Mapping_Stats/mosdepth/CpG_Covered
options(scipen = 999) # preventing scienfic notation in R
# For CHM13-T2T
library(BSgenome.Hsapiens.NCBI.T2T.CHM13v2.0)
chrs <- names(Hsapiens)[1:24] # From 1 to Y
cpgs <- lapply(chrs, function(x) start(matchPattern("CG", Hsapiens[[x]])))
cpg_regions <- do.call(c, lapply(1:24, function(x) GRanges(names(Hsapiens)[x], IRanges(cpgs[[x]], width = 2))))

cpg_bed <- data.frame(seqnames=seqnames(cpg_regions), 
                      starts=start(cpg_regions)-1, 
                      ends=end(cpg_regions)-1)
write.table(cpg_bed, file="CpG_Sites_CHM13v2.0.bed", quote=F, sep="\t", row.names=F, col.names=F)
#awk '{print "chr"$0}' CpG_Sites_CHM13v2.0.bed | grep -v 'chrY' - > CpG_Sites_CHM13v2.0_woY.bed


# /mnt/mone/Project/AK1_PacBio/01.DNA/Analysis_Samples_Merged/Coverage_Calculation/mosdepth/New_Merged/CpG_Covered
# For GRCh38
library(BSgenome.Hsapiens.UCSC.hg38)
chrs <- names(Hsapiens)[1:24] # From 1 to Y
cpgs <- lapply(chrs, function(x) start(matchPattern("CG", Hsapiens[[x]])))
cpg_regions <- do.call(c, lapply(1:24, function(x) GRanges(names(Hsapiens)[x], IRanges(cpgs[[x]], width = 2))))

cpg_bed <- data.frame(seqnames=seqnames(cpg_regions), 
                      starts=start(cpg_regions)-1, 
                      ends=end(cpg_regions)-1)
write.table(cpg_bed, file="CpG_Sites_CHM13v2.0.bed", quote=F, sep="\t", row.names=F, col.names=F)
# grep -v 'chrY' CpG_Sites_hg38.bed > CpG_Sites_hg38_woY.bed