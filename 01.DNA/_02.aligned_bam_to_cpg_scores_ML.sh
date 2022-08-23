export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate pbcpg
python=/mnt/mone/Project/WC300/Tools/Anaconda3/envs/pbcpg/bin/python
bamtocpg=/mnt/mone/Project/AK1_PacBio/Tools/pb-CpG-tools/aligned_bam_to_cpg_scores.py
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
-o ./logs/time_cpg_${sample}.out \
${python} ${bamtocpg} \
--bam ${bam} \
--fasta ${reference} \
--output_label ${sample}_merged \
--pileup_mode count \
--modsites denovo \
--min_coverage 5 \
--min_mapq 0 \
--hap_tag HP \
--threads 55
done
