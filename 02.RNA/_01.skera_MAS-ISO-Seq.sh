export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq

/usr/bin/time \
-f "%E" \
-o ./logs/time_skera.out \
skera split \
--log-level INFO \
--num-threads 55 \
/mnt/mone/Project/AK1_PacBio/02.RNA/01.Analysis/m64088e_220624_143310.hifi_reads.bam \
/mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/mas_seq_sequences/mas15_primers.fasta \
m64088e_220624_143310.hifi_reads_deconcat.bam
