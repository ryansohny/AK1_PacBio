liftOver=/mnt/mone/Project/AK1_PacBio/Tools/liftOver/liftOver

chm13tohg38=/mnt/mone/Project/AK1_PacBio/Tools/liftOver/chm13v2-hg38.over.chain.gz
hg38tochm13=/mnt/mone/Project/AK1_PacBio/Tools/liftOver/hg38-chm13v2.over.chain.gz

$liftOver \
human.refTSS_v3.1.hg38.sorted.bed \
${hg38tochm13} \
human.refTSS_v3.1.hg38.liftOver.chm13.bed \
human.refTSS_v3.1.hg38.liftOver.chm13.unmapped.bed

bedtools sort \
-i human.refTSS_v3.1.hg38.liftOver.chm13.bed \
> human.refTSS_v3.1.hg38.liftOver.chm13.sorted.bed

$liftOver \
intropolis.v1.hg19_with_liftover_to_hg38.tsv.min_count_10.modified2.sorted.tsv \
${hg38tochm13} \
intropolis.v1.hg19_with_liftover_to_hg38.tsv.min_count_10.modified2.liftOver.chm13.bed \
intropolis.v1.hg19_with_liftover_to_hg38.tsv.min_count_10.modified2.liftOver.chm13.unmapped.bed

bedtools sort \
-i intropolis.v1.hg19_with_liftover_to_hg38.tsv.min_count_10.modified2.liftOver.chm13.bed \
> intropolis.v1.hg19_with_liftover_to_hg38.tsv.min_count_10.modified2.liftOver.chm13.sorted.bed