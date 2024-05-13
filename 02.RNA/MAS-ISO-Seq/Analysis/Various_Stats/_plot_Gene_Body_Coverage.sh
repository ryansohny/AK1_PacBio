# In /mnt/mone/Project/AK1_PacBio/02.RNA/01.Analysis/ReAnalysis/GRCh38/GeneBody_Coverage
source activate deeptools

gencode=gencode.v41.annotation.sorted.gtf
blacklist=GRCh38_unified_blacklist.bed

bamCoverage \
--bam ${sample}_mapped.bam \
--outFileName ${sample}_MAS-ISO-seq.bw \
--numberOfProcessors 55

computeMatrix scale-regions \
--regionsFileName ${gencode} \
--scoreFileName \
AK1_MAS-ISO-seq.bw \
iPSC_MAS-ISO-seq.bw \
NPC_MAS-ISO-seq.bw \
--metagene \
--transcriptID "transcript" \
--exonID "exon" \
--upstream 3000 \
--downstream 3000 \
--regionBodyLength 5000 \
--skipZeros \
--blackListFileName ${blacklist} \
--numberOfProcessors 55 \
--outFileName GeneBody_Transcript_GENCODEv41_scaled.gz \
--outFileNameMatrix GeneBody_Transcript_GENCODEv41_scaled.bed

plotProfile \
--matrixFile GeneBody_Transcript_GENCODEv41_scaled.gz \
--outFileName Coverage_GeneBody_Transcript_GENCODEv41_scaled.pdf \
--plotType lines \
--plotHeight 10 \
--plotWidth 10 \
--colors "#FF0000" "#154360" "#229954" \
--samplesLabel "AK1" "iPSC" "NPC" \
--yAxisLabel "Read Depth" \
--dpi 250 \
--plotTitle "Gene Body Coverage" \
--legendLocation upper-right \
--perGroup
