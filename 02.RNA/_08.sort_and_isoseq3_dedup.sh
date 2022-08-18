export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq

samtools=/mnt/mone/Project/WC300/Tools/Anaconda3/envs/masisoseq/bin/samtools

/usr/bin/time \
-f "%E" \
-o ./logs/time_samtools_sort.out \
${samtools} sort \
-m 2G \
-@ 55 \
-t CB \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.bam \
-o m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.sorted.bam

/usr/bin/time \
-f "%E" \
-o ./logs/time_isoseq3-groupdedup.out \
isoseq3 groupdedup \
--verbose \
--num-threads 55 \
--log-level INFO \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.sorted.bam \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.sorted.dedup.bam
