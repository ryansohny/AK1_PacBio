export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq_new

gencode=/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/RNA/pigeon/gencode.v41.annotation.pigeonsorted.gtf
reference=/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/DNA/hg38.analysisSet.fa

for((i=$2;i<=$3;i++))
do
        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        rm tmp${i}

echo 'Collapse into unique isoforms'
isoseq3 collapse \
./${sample}/${sample}_mapped.bam \
./${sample}/${sample}_collapsed.gff

echo 'Sort transript GFF'
pigeon sort \
./${sample}/${sample}_collapsed.gff \
-o ./${sample}/${sample}_collapsed.sorted.gff

pigeon classify \
../New_Analysis/${sample}/${sample}_collapsed.sorted.gff \
/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/RNA/pigeon/gencode.v41.annotation.pigeonsorted.gtf \
/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/DNA/hg38.analysisSet.fa \
--out-dir ${sample} \
--num-threads 55 \
--log-level INFO \
--fl ../New_Analysis/${sample}/${sample}_collapsed.abundance.txt \
--cage-peak /mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/RNA/pigeon/human.refTSS_v3.1.hg38.sorted.bed \
--poly-a /mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/RNA/polyA.list.txt

echo 'Filter isoforms'
pigeon filter \
./${sample}/${sample}_collapsed_classification.txt \
--isoforms ../New_Analysis/${sample}/${sample}_collapsed.sorted.gff \
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
--dedup ../New_Analysis/${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.sorted.dedup.fasta \
--group ../New_Analysis/${sample}/${sample}_collapsed.group.txt \
--out-prefix ${sample} \
--out-dir ./${sample} \
--keep-novel-genes \
--keep-ribo-mito-genes \
--num-threads 55 \
--log-level INFO \
./${sample}/${sample}_collapsed_classification.filtered_lite_classification.txt
done
