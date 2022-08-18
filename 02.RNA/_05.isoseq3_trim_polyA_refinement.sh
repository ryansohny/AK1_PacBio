export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq

/usr/bin/time \
-f "%E" \
-o ./logs/time_isoseq3-refine.out \
isoseq3 refine \
--min-polya-length 20 \
--require-polya \
--verbose \
--num-threads 55 \
--log-level INFO \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.bam \
/mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/mas_seq_sequences/5p_10x_primers.mod1.fasta \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.bam
