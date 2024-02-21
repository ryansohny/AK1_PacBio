export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq_new

gencode=/mnt/mone/Project/AK1_PacBio/Tools/Reference/CHM13/gffread/chm13.draft_v2.0.gene_annotation.gffread.modified.sorted.gff3
reference=/mnt/mone/Project/AK1_PacBio/Tools/Reference/CHM13/chm13v2.0.fa
cage=/mnt/mone/Project/AK1_PacBio/Tools/Reference/CHM13/gffread/human.refTSS_v3.1.hg38.liftOver.chm13.sorted.sorted.bed
polya=/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/RNA/polyA.list.txt

:<<'END'
inputfile ($1) looks like below
AK1_chm13
iPSC_chm13
NPC_chm13
END

for((i=$2;i<=$3;i++))
do

        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        bam=$(awk '{print $2}' tmp${i})
        rm tmp${i}

echo 'Collapse into unique isoforms'
isoseq3 collapse \
./${sample}/${sample}_mapped.bam \
./${sample}/${sample}_collapsed.gff

echo 'Sort transript GFF (replaced by pigeon prepare)'
pigeon sort \
./${sample}/${sample}_collapsed.gff \
-o ./${sample}/${sample}_collapsed.sorted.gff

echo 'Classify isoforms'
pigeon classify \
./${sample}/${sample}_collapsed.sorted.gff \
${gencode} \
${reference} \
--out-dir ./${sample} \
--num-threads 55 \
--log-level INFO \
--fl ./${sample}/${sample}_collapsed.abundance.txt \
--cage-peak ${cage} \
--poly-a ${polya}

echo 'Filter isoforms'
pigeon filter \
./${sample}/${sample}_collapsed_classification.txt \
--isoforms ./${sample}/${sample}_collapsed.sorted.gff \
--num-threads 55 \
--log-level INFO

echo 'Report gene saturation'
pigeon report \
--num-threads 55 \
--log-level INFO \
./${sample}/${sample}_collapsed_classification.filtered_lite_classification.txt \
./${sample}/${sample}_collapsed_classification.filtered_lite_classification_saturation.txt

echo 'Make Seurat/Scanpy compatible input'
pigeon make-seurat \
--dedup ./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.sorted.dedup.fasta \
--group ./${sample}/${sample}_collapsed.group.txt \
--out-prefix ${sample} \
--out-dir ./${sample} \
--keep-novel-genes \
--keep-ribo-mito-genes \
--num-threads 55 \
--log-level INFO \
./${sample}/${sample}_collapsed_classification.filtered_lite_classification.txt

done