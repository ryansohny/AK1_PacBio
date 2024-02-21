export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate gffread

gffread \
chm13.draft_v2.0.gene_annotation.gff3 \
-O \
--attrs gene_id,transcript_id,gene_name \
-o chm13.draft_v2.0.gene_annotation.gffread.gff3