export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq

/usr/bin/time \
-f "%E" \
-o ./logs/time_lima2.out \
lima \
--same \
--ccs \
--num-threads 55 \
--log-level INFO \
--log-file clip_5p_tso.log \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.bam \
/mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/mas_seq_sequences/clip_5p_10x_tso.fasta \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bam
