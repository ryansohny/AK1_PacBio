export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq

/usr/bin/time \
-f "%E" \
-o ./logs/time_rmv_5mc.out \
python /mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/in-house_script/remove_5mc_from_bam.py \
--input m64088e_220624_143310.hifi_reads_deconcat.bam \
--output m64088e_220624_143310.hifi_reads_deconcat.wo5mC.bam \
-j 55
