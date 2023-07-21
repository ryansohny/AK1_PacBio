suppressMessages(library(genomation))
suppressMessages(library(genomationData))
suppressMessages(library(GenomicRanges))

# Open a DMR File
dmrs <- readGeneric("DMRs_DSS_woPMD_AK1-iPSC_MetTh40.bed", zero.based=TRUE, meta.cols=list(DMR_name=4)) # test before DMR merging

#chr1    35140   36845   AK1-iPSC_4891_(20/-0.725346026518269)
#chr1    39422   40416   AK1-iPSC_5616_(17/-0.743722572281095)
#chr1    45340   46332   AK1-iPSC_25703_(7/-0.602094914627995)
#chr1    47175   48025   AK1-iPSC_25033_(6/-0.686214158467075)

gencodeV41 <- gffToGRanges("/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/RNA/gencode.v41.annotation.gtf")

#다음과 같이 하는 것도 가능하다.
#gffToGRanges("/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/RNA/gencode.v41.annotation.gtf", filter = c("exon", "CDS"))

#GRanges object with 3375759 ranges and 22 metadata columns:
#colnames(mcols(gencodeV41))
# [1] "source"                   "type"                    
# [3] "score"                    "phase"                   
# [5] "gene_id"                  "gene_type"               
# [7] "gene_name"                "level"                   
# [9] "hgnc_id"                  "havana_gene"             
#[11] "transcript_id"            "transcript_type"         
#[13] "transcript_name"          "transcript_support_level"
#[15] "tag"                      "havana_transcript"       
#[17] "exon_number"              "exon_id"                 
#[19] "ont"                      "protein_id"              
#[21] "ccdsid"                   "artif_dupl"              
cpgi <- readGeneric("/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/DNA/CpGi/CpGi_hg38_Primary.sorted.bed", zero.based=TRUE, meta.cols=list(CpGi_Name=4))
cpgi.shore <- readGeneric("/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/DNA/CpGi/CpGishores_hg38_Primary.sorted.bed", zero.based=TRUE)
cpgi.shelve <- readGeneric("/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/DNA/CpGi/CpGishelves_hg38_Primary.sorted.bed", zero.based=TRUE)