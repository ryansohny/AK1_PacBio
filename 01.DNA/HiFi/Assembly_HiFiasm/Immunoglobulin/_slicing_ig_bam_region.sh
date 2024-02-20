if [ -z "$1" ]; then
	echo "Provide Argument (i.e. IGH, IGK or IGL)"
	exit 1
fi

for sample in AK1 iPSC NPC
do
mkdir -p ${1}
if [ "$1" == "IGH" ]; then
	region_hg38="chr14:105,586,437-106,879,844"
	region_t2t="chr14:99,839,469-101,155,136"
elif [ "$1" == "IGK" ]; then
	region_hg38="chr2:88,857,361-90,235,368"
	region_t2t="chr2:88,866,370-90,790,947"
elif [ "$1" == "IGL" ]; then
	region_hg38="chr22:22,026,076-22,922,913"
	region_t2t="chr22:22,439,629-23,345,823"
else
	echo "Invalid Argument (Neither IGH, IGK nor IGL)"
	exit 1
fi
echo "${sample} Contigs in ${1} region"
samtools view -@ 30 -bh ${sample}.asm.bp.p_ctg.sorted.bam \
${region_hg38} \
> ${1}/${sample}.${1}.bam
samtools index -@ 30 ${1}/${sample}.${1}.bam

echo "${sample} Haplotype 1 Contigs in ${1} region"
samtools view -@ 30 -bh ${sample}.asm.bp.hap1.p_ctg.sorted.bam \
${region_hg38} \
> ${1}/${sample}.${1}.bam
samtools index -@ 30 ${1}/${sample}.${1}.bam

echo "${sample} Haplotype 2 Contigs in ${1} region"
samtools view -@ 30 -bh ${sample}.asm.bp.hap2.p_ctg.sorted.bam \
${region_hg38} \
> ${1}/${sample}.${1}.bam
samtools index -@ 30 ${1}/${sample}.${1}.bam

echo "${sample} Contigs in T2T-CHM13 ${1} region"
samtools view -@ 30 -bh ${sample}.asm.bp.p_ctg.chm13.sorted.bam \
${region_t2t} \
> ${1}/${sample}.chm13.${1}.bam
samtools index -@ 30 ${1}/${sample}.chm13.${1}.bam

echo "${sample} Haplotype 1 Contigs in T2T-CHM13 ${1} region"
samtools view -@ 30 -bh ${sample}.asm.bp.hap1.p_ctg.chm13.sorted.bam \
${region_t2t} \
> ${1}/${sample}.chm13.${1}.bam
samtools index -@ 30 ${1}/${sample}.chm13.${1}.bam

echo "${sample} Haplotype 2 Contigs in T2T-CHM13 ${1} region"
samtools view -@ 30 -bh ${sample}.asm.bp.hap2.p_ctg.chm13.sorted.bam \
${region_t2t} \
> ${1}/${sample}.chm13.${1}.bam
samtools index -@ 30 ${1}/${sample}.chm13.${1}.bam
done