# In PMI cm03
# source activate dropletutils
# R
# From https://bioconductor.org/packages/devel/bioc/vignettes/DropletUtils/inst/doc/DropletUtils.html

library(DropletUtils)

# AK1 (genes) ################################################ 
sce <- read10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/AK1/genes_seurat") # store counts in counts(sce)

br.out <- barcodeRanks(sce)
# Making a plot.
plot(br.out$rank, br.out$total, log="xy", xlab="Rank", ylab="Total")
o <- order(br.out$rank)
lines(br.out$rank[o], br.out$fitted[o], col="red")

abline(h=metadata(br.out)$knee, col="dodgerblue", lty=2)
abline(h=metadata(br.out)$inflection, col="forestgreen", lty=2)
legend("bottomleft", lty=2, col=c("dodgerblue", "forestgreen"), 
    legend=c("knee", "inflection"))

# Detecting empty droplets (by emptyDrops function : Distinguishinig between empty droplets and cells)

set.seed(100) # The p-values are calculated by permutation testing, hence the need to set a seed.
e.out <- emptyDrops(sce)
'''
DataFrame with 229619 rows and 5 columns
           Total   LogProb    PValue   Limited         FDR
       <integer> <numeric> <numeric> <logical>   <numeric>
1           1369  -4360.19 9.999e-05      TRUE 0.000000000
2             15        NA        NA        NA          NA
3            294  -1013.14 9.999e-05      TRUE 0.000100517
4           1867  -5798.56 9.999e-05      TRUE 0.000000000
5           1141  -3625.35 9.999e-05      TRUE 0.000000000
...          ...       ...       ...       ...         ...
229615         0        NA        NA        NA          NA
229616         0        NA        NA        NA          NA
229617         0        NA        NA        NA          NA
229618         0        NA        NA        NA          NA
229619         0        NA        NA        NA          NA
'''
### Droplets with significant deviations from the ambient profile are detected at a specified FDR threshold, e.g., with FDR below 1%. 
### These can be considered to be cell-containing droplets, with a frequency of false positives (i.e., empty droplets) at the specified FDR
is.cell <- e.out$FDR <= 0.01
sum(is.cell, na.rm=TRUE) # ak1 ==> 9898

## 아래 결과에서 Limited == FALSE and Sig == FALSE 이면 niters value를 increase해야 함.
table(Limited=e.out$Limited, Significant=is.cell)

## Diagnostic plot (-LogProbability with respect to Total UMI count)
plot(e.out$Total, -e.out$LogProb, col=ifelse(is.cell, "red", "black"),
    xlab="Total UMI count", ylab="-Log Probability")

# Output Filtered Cells
cell.counts <- sce[,which(is.cell), drop=FALSE]
dim(cell.counts)

write10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/AK1/AK1_genes.h5", 
                counts(cell.counts),
                gene.id=rowData(cell.counts)$ID,
                gene.symbol=rowData(cell.counts)$Symbol,
                barcodes=colData(cell.counts)$Barcode,
                genome='hg38',
                overwrite=TRUE,
                version='3')

# iPSC (genes) ################################################ 
sce <- read10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/iPSC/genes_seurat") # store counts in counts(sce)
br.out <- barcodeRanks(sce)

plot(br.out$rank, br.out$total, log="xy", xlab="Rank", ylab="Total")
o <- order(br.out$rank)
lines(br.out$rank[o], br.out$fitted[o], col="red")
abline(h=metadata(br.out)$knee, col="dodgerblue", lty=2)
abline(h=metadata(br.out)$inflection, col="forestgreen", lty=2)
legend("bottomleft", lty=2, col=c("dodgerblue", "forestgreen"), 
    legend=c("knee", "inflection"))

set.seed(100) # The p-values are calculated by permutation testing, hence the need to set a seed.
e.out <- emptyDrops(sce)

is.cell <- e.out$FDR <= 0.01
sum(is.cell, na.rm=TRUE) # ak1 ==> 9898

table(Limited=e.out$Limited, Significant=is.cell)

plot(e.out$Total, -e.out$LogProb, col=ifelse(is.cell, "red", "black"),
    xlab="Total UMI count", ylab="-Log Probability")

cell.counts <- sce[,which(is.cell), drop=FALSE]
dim(cell.counts)

write10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/iPSC/iPSC_genes.h5", 
                counts(cell.counts),
                gene.id=rowData(cell.counts)$ID,
                gene.symbol=rowData(cell.counts)$Symbol,
                barcodes=colData(cell.counts)$Barcode,
                genome='hg38',
                overwrite=TRUE,
                version='3')

# NPC (genes) ################################################ 
sce <- read10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/NPC/genes_seurat") # store counts in counts(sce)
br.out <- barcodeRanks(sce)

plot(br.out$rank, br.out$total, log="xy", xlab="Rank", ylab="Total")
o <- order(br.out$rank)
lines(br.out$rank[o], br.out$fitted[o], col="red")
abline(h=metadata(br.out)$knee, col="dodgerblue", lty=2)
abline(h=metadata(br.out)$inflection, col="forestgreen", lty=2)
legend("bottomleft", lty=2, col=c("dodgerblue", "forestgreen"), 
    legend=c("knee", "inflection"))

set.seed(100) # The p-values are calculated by permutation testing, hence the need to set a seed.
e.out <- emptyDrops(sce)

is.cell <- e.out$FDR <= 0.01
sum(is.cell, na.rm=TRUE) # ak1 ==> 9898

table(Limited=e.out$Limited, Significant=is.cell)

plot(e.out$Total, -e.out$LogProb, col=ifelse(is.cell, "red", "black"),
    xlab="Total UMI count", ylab="-Log Probability")

cell.counts <- sce[,which(is.cell), drop=FALSE]
dim(cell.counts)

write10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/NPC/NPC_genes.h5", 
                counts(cell.counts),
                gene.id=rowData(cell.counts)$ID,
                gene.symbol=rowData(cell.counts)$Symbol,
                barcodes=colData(cell.counts)$Barcode,
                genome='hg38',
                overwrite=TRUE,
                version='3')

#################################################################
#################################################################
# AK1 (isoforms) ################################################ 
sce <- read10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/AK1/isoforms_seurat") # store counts in counts(sce)

br.out <- barcodeRanks(sce)
# Making a plot.
plot(br.out$rank, br.out$total, log="xy", xlab="Rank", ylab="Total")
o <- order(br.out$rank)
lines(br.out$rank[o], br.out$fitted[o], col="red")

abline(h=metadata(br.out)$knee, col="dodgerblue", lty=2)
abline(h=metadata(br.out)$inflection, col="forestgreen", lty=2)
legend("bottomleft", lty=2, col=c("dodgerblue", "forestgreen"), 
    legend=c("knee", "inflection"))

set.seed(100) # The p-values are calculated by permutation testing, hence the need to set a seed.
e.out <- emptyDrops(sce)

is.cell <- e.out$FDR <= 0.01
sum(is.cell, na.rm=TRUE) # ak1 ==> 9898

table(Limited=e.out$Limited, Significant=is.cell)

plot(e.out$Total, -e.out$LogProb, col=ifelse(is.cell, "red", "black"),
    xlab="Total UMI count", ylab="-Log Probability")

cell.counts <- sce[,which(is.cell), drop=FALSE]
dim(cell.counts)

write10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/AK1/AK1_isoforms.h5", 
                counts(cell.counts),
                gene.id=rowData(cell.counts)$ID,
                gene.symbol=rowData(cell.counts)$Symbol,
                barcodes=colData(cell.counts)$Barcode,
                genome='hg38',
                overwrite=TRUE,
                version='3')

# iPSC (isoforms) ################################################ 
sce <- read10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/iPSC/isoforms_seurat") # store counts in counts(sce)
br.out <- barcodeRanks(sce)

plot(br.out$rank, br.out$total, log="xy", xlab="Rank", ylab="Total")
o <- order(br.out$rank)
lines(br.out$rank[o], br.out$fitted[o], col="red")
abline(h=metadata(br.out)$knee, col="dodgerblue", lty=2)
abline(h=metadata(br.out)$inflection, col="forestgreen", lty=2)
legend("bottomleft", lty=2, col=c("dodgerblue", "forestgreen"), 
    legend=c("knee", "inflection"))

set.seed(100) # The p-values are calculated by permutation testing, hence the need to set a seed.
e.out <- emptyDrops(sce)

is.cell <- e.out$FDR <= 0.01
sum(is.cell, na.rm=TRUE) # ak1 ==> 9898

table(Limited=e.out$Limited, Significant=is.cell)

plot(e.out$Total, -e.out$LogProb, col=ifelse(is.cell, "red", "black"),
    xlab="Total UMI count", ylab="-Log Probability")

cell.counts <- sce[,which(is.cell), drop=FALSE]
dim(cell.counts)

write10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/iPSC/iPSC_isoforms.h5", 
                counts(cell.counts),
                gene.id=rowData(cell.counts)$ID,
                gene.symbol=rowData(cell.counts)$Symbol,
                barcodes=colData(cell.counts)$Barcode,
                genome='hg38',
                overwrite=TRUE,
                version='3')

# NPC (isoforms) ################################################ 
sce <- read10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/NPC/isoforms_seurat") # store counts in counts(sce)
br.out <- barcodeRanks(sce)

plot(br.out$rank, br.out$total, log="xy", xlab="Rank", ylab="Total")
o <- order(br.out$rank)
lines(br.out$rank[o], br.out$fitted[o], col="red")
abline(h=metadata(br.out)$knee, col="dodgerblue", lty=2)
abline(h=metadata(br.out)$inflection, col="forestgreen", lty=2)
legend("bottomleft", lty=2, col=c("dodgerblue", "forestgreen"), 
    legend=c("knee", "inflection"))

set.seed(100) # The p-values are calculated by permutation testing, hence the need to set a seed.
e.out <- emptyDrops(sce)

is.cell <- e.out$FDR <= 0.01
sum(is.cell, na.rm=TRUE) # ak1 ==> 9898

table(Limited=e.out$Limited, Significant=is.cell)

plot(e.out$Total, -e.out$LogProb, col=ifelse(is.cell, "red", "black"),
    xlab="Total UMI count", ylab="-Log Probability")

cell.counts <- sce[,which(is.cell), drop=FALSE]
dim(cell.counts)

write10xCounts("/data/Projects/phenomata/01.Projects/13.AK1_PacBio/02.RNA/NPC/NPC_isoforms.h5", 
                counts(cell.counts),
                gene.id=rowData(cell.counts)$ID,
                gene.symbol=rowData(cell.counts)$Symbol,
                barcodes=colData(cell.counts)$Barcode,
                genome='hg38',
                overwrite=TRUE,
                version='3')

### The END of Filtering using emptyDrops