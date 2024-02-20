export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate hifiasm

echo "Step 1. bam2fastq"
# AK1
bam2fastq \
-o AK1.hifi_reads \
-c 1 \
--num-threads 55 \
m64088e_220804_065540.hifi_reads.bam \
m64088e_220809_060022.hifi_reads.bam \
m64088e_230127_011831.hifi_reads.bam \
m64483e_220810_045456.hifi_reads.bam
# iPSC
bam2fastq \
-o iPSC.hifi_reads \
-c 1 \
--num-threads 55 \
m64088e_220805_174931.hifi_reads.bam \
m64483e_220812_053045.hifi_reads.bam \
m64483e_220816_050751.hifi_reads.bam \
m64088e_230129_192928.hifi_reads.bam
# NPC
bam2fastq \
-o NPC.hifi_reads \
-c 1 \
--num-threads 55 \
m64088e_220807_044513.hifi_reads.bam \
m64483e_220817_160209.hifi_reads.bam \
m64483e_220819_012934.hifi_reads.bam \
m64088e_230128_102259.hifi_reads.bam
# Retrieving Only Longer fragment library from AK1, iPSC and NPC HiFi
bam2fastq \
-o AK1_long.hifi_reads \
-c 1 \
--num-threads 55 \
m64088e_230127_011831.hifi_reads.bam \
m64088e_230129_192928.hifi_reads.bam \
m64088e_230128_102259.hifi_reads.bam

echo "Step 2. HiFiasm assembly"
hifiasm -o AK1.asm -t 55 AK1.hifi_reads.fastq.gz
hifiasm -o iPSC.asm -t 55 iPSC.hifi_reads.fastq.gz
hifiasm -o NPC.asm -t 55 NPC.hifi_reads.fastq.gz
hifiasm -o AK1_long.asm -t 55 AK1_long.hifi_reads.fastq.gz

echo "Step 3. Fasta Conversion of (Haplotype) Contig Assembly"
awk '/^S/{print ">"$2;print $3}' ../AK1.asm.bp.p_ctg.gfa > AK1.asm.bp.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ../iPSC.asm.bp.p_ctg.gfa > iPSC.asm.bp.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ../NPC.asm.bp.p_ctg.gfa > NPC.asm.bp.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ../AK1_long.asm.bp.p_ctg.gfa > AK1_long.asm.bp.p_ctg.fa

awk '/^S/{print ">"$2;print $3}' ../AK1.asm.bp.hap1.p_ctg.gfa > AK1.asm.bp.hap1.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ../AK1.asm.bp.hap2.p_ctg.gfa > AK1.asm.bp.hap2.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ../iPSC.asm.bp.hap1.p_ctg.gfa > iPSC.asm.bp.hap1.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ../iPSC.asm.bp.hap2.p_ctg.gfa > iPSC.asm.bp.hap2.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ../NPC.asm.bp.hap1.p_ctg.gfa > NPC.asm.bp.hap1.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ../NPC.asm.bp.hap2.p_ctg.gfa > NPC.asm.bp.hap2.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ../AK1_long.asm.bp.hap1.p_ctg.gfa > AK1_long.asm.bp.hap1.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' ../AK1_long.asm.bp.hap2.p_ctg.gfa > AK1_long.asm.bp.hap2.p_ctg.fa

conda deactivate
source activate minimap2_2.26
contigdir=/mnt/mone/Project/AK1_PacBio/01.DNA/HiFiasm/minimap2
grch38=/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/DNA/hg38.analysisSet.fa.mmi
samtools=/mnt/mone/Project/WC300/Tools/Anaconda3/envs/minimap2_2.26/bin/samtools

for((i=$2;i<=$3;i++))
do
        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        rm tmp${i}

mkdir -p ${sample}

echo "Align ${sample} HiFiasm Primary Contig to GRCh38"

minimap2 \
-t 55 \
-ax asm5 \
--eqx \
${grch38} \
${contigdir}/${sample}.asm.bp.p_ctg.fa \
> ${sample}/${sample}.asm.bp.p_ctg.sam

echo "Align ${sample} HiFiasm Haplotype 1 Contigs to GRCh38"
minimap2 \
-t 55 \
-ax asm5 \
--eqx \
${grch38} \
${contigdir}/${sample}.asm.bp.hap1.p_ctg.fa \
> ${sample}/${sample}.asm.bp.hap1.p_ctg.sam

echo "Align ${sample} HiFiasm Haplotype 2 Contigs to GRCh38"
minimap2 \
-t 55 \
-ax asm5 \
--eqx \
${grch38} \
${contigdir}/${sample}.asm.bp.hap2.p_ctg.fa \
> ${sample}/${sample}.asm.bp.hap2.p_ctg.sam

echo "${sample} Sam to bam file and sort it"
${samtools} view -@ 20 -S -b ${sample}/${sample}.asm.bp.p_ctg.sam \
| ${samtools} sort -@ 35 -o ${sample}/${sample}.asm.bp.p_ctg.sorted.bam

echo "${sample} Hap1 Sam to bam file and sort it"
${samtools} view -@ 20 -S -b ${sample}/${sample}.asm.bp.hap1.p_ctg.sam \
| ${samtools} sort -@ 35 -o ${sample}/${sample}.asm.bp.hap1.p_ctg.sorted.bam

echo "${sample} Hap2 Sam to bam file and sort it"
${samtools} view -@ 20 -S -b ${sample}/${sample}.asm.bp.hap2.p_ctg.sam \
| ${samtools} sort -@ 35 -o ${sample}/${sample}.asm.bp.hap2.p_ctg.sorted.bam

${samtools} index -@ 55 ${sample}/${sample}.asm.bp.p_ctg.sorted.bam
${samtools} index -@ 55 ${sample}/${sample}.asm.bp.hap1.p_ctg.sorted.bam
${samtools} index -@ 55 ${sample}/${sample}.asm.bp.hap2.p_ctg.sorted.bam

done
