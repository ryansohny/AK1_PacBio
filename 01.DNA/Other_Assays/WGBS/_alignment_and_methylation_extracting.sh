#!/bin/bash

export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate bismark

ref=/mnt/mone/Project/WC300/03.WGBS_New/Reference
fasta=/mnt/mone/Project/AK1_PacBio/01.DNA/Other_Assays/WGBS_NovaSeq6000/00.Sequence_Reads
outdir1=/mnt/mone/Project/AK1_PacBio/01.DNA/Other_Assays/WGBS_NovaSeq6000/01.Alignment
outdir2=/mnt/mone/Project/AK1_PacBio/01.DNA/Other_Assays/WGBS_NovaSeq6000/02.DNA_methylation

for((i=$2;i<=$3;i++))
do
        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        rm tmp${i}
bismark \
--genome ${ref} \
--multicore 14 \
--maxins 700 \
--dovetail \
-1 ${fasta}/${sample}_val_1.fq.gz \
-2 ${fasta}/${sample}_val_2.fq.gz

deduplicate_bismark \
--paired \
${sample}_val_1_bismark_bt2_pe.bam

bismark_methylation_extractor \
--paired-end \
--no_overlap \
--no_header \
--output ${outdir2} \
--gzip \
--buffer_size 40G \
--multicore 14 \
--cutoff 1 \
--cytosine_report \
--genome_folder ${ref} \
${sample}_val_1_bismark_bt2_pe.deduplicated.bam

done