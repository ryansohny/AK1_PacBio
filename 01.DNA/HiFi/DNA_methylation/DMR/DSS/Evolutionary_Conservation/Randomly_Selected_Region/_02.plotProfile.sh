export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate deeptools

plotProfile \
--matrixFile phyloP_inside_random100k.matrix.gz \
--averageType "mean" \
--outFileName phyloP_inside_random100k.pdf \
--plotType lines \
--plotTitle "Evolutionary Conservation" \
--refPointLabel "Random tile center" \
--yAxisLabel "PhyloP score"

plotProfile \
--matrixFile phyloP_inside_random100k.matrix.gz \
--averageType "mean" \
--yMax 0.128 \
--yMin 0.114 \
--outFileName phyloP_inside_random100k_heatmap.pdf \
--plotType heatmap \
--plotTitle "Evolutionary Conservation" \
--yAxisLabel "PhyloP score" \
--refPointLabel "Random tile center"
