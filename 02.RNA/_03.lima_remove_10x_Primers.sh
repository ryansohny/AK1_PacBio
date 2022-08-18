export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq

/usr/bin/time \
-f "%E" \
-o ./logs/time_lima1.out \
lima \
--num-threads 55 \
--isoseq \
--peek-guess \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.bam \
/mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/mas_seq_sequences/5p_10x_primers.mod1.fasta \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.bam
