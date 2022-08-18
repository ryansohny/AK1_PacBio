export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq

/usr/bin/time \
-f "%E" \
-o ./logs/time_isoseq3-tag.out \
isoseq3 tag \
--design 16B-10U-T \
--min-read-length 50 \
--log-level INFO \
--verbose \
--num-threads 55 \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.bam \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.bam
