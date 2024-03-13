export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate mosdepth
mosdepth=/mnt/mone/Project/WC300/Tools/Anaconda3/envs/mosdepth/bin/mosdepth
bedtools=/mnt/mone/Project/WC300/Tools/Anaconda3/bin/bedtools

# input file ($1) format
# AK1     AK1_haplotagged_wIndels_splt.bam
# iPSC    iPSC_haplotagged_wIndels_splt.bam
# NPC     NPC_haplotagged_wIndels_splt.bam
# AK1_WGBS        AK1_val_1_bismark_bt2_pe.deduplicated_mapq10_sorted.bam
# H1      H1_merge_val_1_bismark_bt2_pe.deduplicated_mapq10_sorted.bam
# HUES64  HUES64_merge_val_1_bismark_bt2_pe.deduplicated_mapq10_sorted.bam
# HG002 HG002.GRCh38.haplotagged.bam

for((i=$2;i<=$3;i++))
do
        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        bam=$(awk '{print $2}' tmp${i})
        rm tmp${i}

mkdir -p ${sample}

${mosdepth} \
--threads 4 \
${sample}/${sample} \
${bam}

if [ "$sample" == "H1" ] || [ "$sample" == "HUES64" ] || [ "$sample" == "AK1_WGBS"  ]; then
        zcat ${sample}/${sample}.per-base.bed.gz | awk '$4 < 5' | $bedtools merge -i - | grep -vE 'chrM|chrY' - > ${sample}/${sample}_Low_coverage.bed
else
        zcat ${sample}/${sample}.per-base.bed.gz | awk '$4 < 4' | $bedtools merge -i - | grep -vE 'chrM|chrY' - > ${sample}/${sample}_Low_coverage.bed
fi

done
