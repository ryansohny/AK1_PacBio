export PATH=/mnt/mone/Project/WC300/Tools/Anaconda3/bin:$PATH
source activate deeptools

plotProfile \
--matrixFile phyloP_inside_DMR_woPMD.matrix.gz \
--outFileName phyloP_inside_DMR_woPMD.pdf \
--plotType lines \
--plotTitle "Evolutionary Conservation" \
--refPointLabel "DMR center" \
--yAxisLabel "PhyloP score"
