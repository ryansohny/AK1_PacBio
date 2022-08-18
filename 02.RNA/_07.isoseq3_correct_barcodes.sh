export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq

/usr/bin/time \
-f "%E" \
-o ./logs/time_isoseq3-correctCBC.out \
isoseq3 correct \
--verbose \
--barcodes /mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/mas_seq_sequences/737K-august-2016.txt \
--num-threads 55 \
--log-level INFO \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bam \
m64088e_220624_143310.hifi_reads_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.bam
