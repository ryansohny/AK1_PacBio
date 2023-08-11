export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate masisoseq_new

for((i=$2;i<=$3;i++))
do
        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        bam=$(awk '{print $2}' tmp${i})
        rm tmp${i}

mkdir -p ${sample}

skera split \
--log-level INFO \
--num-threads 55 \
${bam} \
/mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/mas_seq_sequences/mas15_primers.fasta \
./${sample}/${sample}_deconcat.bam

done

conda deactivate
source activate masisoseq2

python=/mnt/mone/Project/WC300/Tools/Anaconda3/envs/masisoseq2/bin/python

for((i=$2;i<=$3;i++))
do
        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        bam=$(awk '{print $2}' tmp${i})
        rm tmp${i}

${python} /mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/in-house_script/remove_5mc_from_bam.py \
--input ./${sample}/${sample}_deconcat.bam \
--output ./${sample}/${sample}_deconcat.wo5mC.bam \
-j 55

done

conda deactivate
source activate masisoseq_new

for((i=$2;i<=$3;i++))
do
        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        bam=$(awk '{print $2}' tmp${i})
        rm tmp${i}

lima \
--num-threads 55 \
--isoseq \
--peek-guess \
./${sample}/${sample}_deconcat.wo5mC.bam \
/mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/mas_seq_sequences/5p_10x_primers.mod1.fasta \
./${sample}/${sample}_deconcat.wo5mC.trimmed.bam

isoseq3 tag \
--design 16B-10U-T \
--min-read-length 50 \
--log-level INFO \
--verbose \
--num-threads 55 \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.bam \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.bam

isoseq3 refine \
--min-polya-length 15 \
--require-polya \
--verbose \
--num-threads 55 \
--log-level INFO \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.bam \
/mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/mas_seq_sequences/5p_10x_primers.mod1.fasta \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.bam

lima \
--same \
--ccs \
--num-threads 55 \
--log-level INFO \
--log-file ./${sample}/${sample}_clip_5p_tso.log \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.bam \
/mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/mas_seq_sequences/clip_5p_10x_tso.fasta \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bam

isoseq3 correct \
--verbose \
--barcodes /mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/mas_seq_sequences/737K-august-2016.txt \
--num-threads 55 \
--log-level INFO \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bam \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.bam

isoseq3 bcstats \
--num-threads 55 \
--json ./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.json \
--output ./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr_bcstats_report.tsv \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.bam

done

conda deactivate
source activate masisoseq2

for((i=$2;i<=$3;i++))
do
        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        bam=$(awk '{print $2}' tmp${i})
        rm tmp${i}

python /mnt/mone/Project/AK1_PacBio/Tools/MAS_ISO-Seq_requirements/plot_knees.py \
--tsv ./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr_bcstats_report.tsv \
--estimate_percentile 95 \
--output ./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr_bcstats_report

done

conda deactivate
source activate masisoseq_new

for((i=$2;i<=$3;i++))
do
        sed -n ${i}p $1 > tmp${i}
        sample=$(awk '{print $1}' tmp${i})
        bam=$(awk '{print $2}' tmp${i})
        rm tmp${i}

samtools=/mnt/mone/Project/WC300/Tools/Anaconda3/envs/masisoseq_new/bin/samtools
${samtools} sort \
-m 2G \
-@ 55 \
-t CB \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.bam \
-o ./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.sorted.bam

isoseq3 groupdedup \
--verbose \
--num-threads 55 \
--log-level INFO \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.sorted.bam \
./${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.sorted.dedup.bam

reference=/mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/DNA/hg38.analysisSet.fa

pbmm2 align \
-j 55 \
--sort \
--preset ISOSEQ \
--log-level INFO \
${reference} \
${sample}/${sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.sorted.dedup.bam \
${sample}/${sample}_mapped.bam

done
