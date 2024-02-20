export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate pbcpg
align=/mnt/mone/Project/AK1_PacBio/Tools/pb-CpG-tools/aligned_bam_to_cpg_scores.py
reference=/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/DNA/hg38.analysisSet.fa
refmmi=/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/DNA/hg38.analysisSet.fa.mmi

for((i=$2;i<=$3;i++))
do
        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        bam=$(awk '{print $2}' tmp${i})
        rm tmp${i}
/usr/bin/time \
-f "%E" \
-o ./logs/time_align.out \
pbmm2 align \
--sample ${sample} \
--preset HIFI \
--unmapped \
--num-threads 45 \
--sort \
--sort-memory 2G \
--sort-threads 10 \
--log-level INFO \
${refmmi} \
${bam} \
${sample}_aligned.sorted.bam
done
