export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate deeptools

computeMatrix \
reference-point \
--referencePoint center \
--scoreFileName hg38.phyloP100way.bw \
--regionsFileName ${1} \
--outFileName phyloP_inside_random100k.matrix.gz \
--outFileNameMatrix phyloP_inside_random100k.tab \
--upstream 5000 \
--downstream 5000 \
--skipZeros \
--numberOfProcessors 55
