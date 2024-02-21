export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq_new
reference=/mnt/mone/Project/AK1_PacBio/Tools/Reference/CHM13/chm13v2.0.fa
reftss=/mnt/mone/Project/AK1_PacBio/Tools/Reference/CHM13/gffread/human.refTSS_v3.1.hg38.liftOver.chm13.sorted.bed
intropolis=/mnt/mone/Project/AK1_PacBio/Tools/Reference/CHM13/gffread/intropolis.v1.hg19_with_liftover_to_hg38.tsv.min_count_10.modified2.liftOver.chm13.sorted.bed

pigeon prepare \
chm13.draft_v2.0.gene_annotation.gffread.modified.gff3 \
${reference} \
${reftss}