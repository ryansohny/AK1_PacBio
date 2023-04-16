suppressMessages(library(DSS))

input_path <- "/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs"
output_path <- "/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/DSS_Outputs"
chromosomes <- append(append(paste("chr", c(1:22), sep=''), 'chrX'), 'chrY')

for (chrom in chromosomes){
    ak1 <- read.table(file.path(input_path, paste(chrom, "/AK1_merged_DSS_", chrom, '.tab', sep='')), header=TRUE)
    ipsc <- read.table(file.path(input_path, paste(chrom, "/iPSC_merged_DSS_", chrom, '.tab', sep='')), header=TRUE)
    h1 <- read.table(file.path(input_path, paste(chrom, "/H1_merged_DSS_", chrom, '.tab', sep='')), header=TRUE)
    npc <- read.table(file.path(input_path, paste(chrom, "/NPC_merged_DSS_", chrom, '.tab', sep='')), header=TRUE)

    # Make BSseq object
    BSobj <- makeBSseqData( list( ak1, ipsc, h1, npc ), c( "AK1", "iPSC", "H1", "NPC" ))

    # Comparing DNA methylation of each sample with that of AK1
    dmltest_ak1_ipsc <- DMLtest(BSobj, group1=c("AK1"), group2=c("iPSC"), smoothing=TRUE, smoothing.span = 500)
    dmltest_ak1_h1 <- DMLtest(BSobj, group1=c("AK1"), group2=c("H1"), smoothing=TRUE, smoothing.span = 500)
    dmltest_ak1_npc <- DMLtest(BSobj, group1=c("AK1"), group2=c("NPC"), smoothing=TRUE, smoothing.span = 500)

    # Call DMRs
    dmrs_ak1_ipsc = callDMR(dmltest_ak1_ipsc, delta=0.2, p.threshold=1e-5, minlen=50, minCG=3, dis.merge=50, pct.sig=0.5) # 10% Methylation difference / P value < 0.05
    dmrs_ak1_h1 = callDMR(dmltest_ak1_h1, delta=0.2, p.threshold=1e-5, minlen=50, minCG=3, dis.merge=50, pct.sig=0.5)
    dmrs_ak1_npc = callDMR(dmltest_ak1_npc, delta=0.2, p.threshold=1e-5, minlen=50, minCG=3, dis.merge=50, pct.sig=0.5)

    write.table(dmrs_ak1_ipsc, sep='\t', quote=FALSE, row.names=FALSE, file=file.path(output_path, paste(chrom, "/DMRs_DSS_AK1-iPSC_", chrom, ".tab", sep='')))
    write.table(dmrs_ak1_h1, sep='\t', quote=FALSE, row.names=FALSE, file=file.path(output_path, paste(chrom, "/DMRs_DSS_AK1-H1_", chrom, ".tab", sep='')))
    write.table(dmrs_ak1_npc, sep='\t', quote=FALSE, row.names=FALSE, file=file.path(output_path, paste(chrom, "/DMRs_DSS_AK1-NPC_", chrom, ".tab", sep='')))
}



##### TEST ################################ ################################ ################################
#ak1_chr1 <- read.table("/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs/chr1/AK1_merged_DSS_chr1.tab", header=TRUE)
#ipsc_chr1 <- read.table("/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs/chr1/iPSC_merged_DSS_chr1.tab", header=TRUE)
#npc_chr1 <- read.table("/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs/chr1/NPC_merged_DSS_chr1.tab", header=TRUE)
#h1_chr1 <- read.table("/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs/chr1/H1_merged_DSS_chr1.tab", header=TRUE)
# Make BSseq object
#BSobj_chr1 <- makeBSseqData( list( ak1_chr1, ipsc_chr1, npc_chr1, h1_chr1 ), c("AK1", "iPSC", "NPC", "H1"))

# Perform DMLtest on BSseq object
#dmltest_ak1_ipsc <- DMLtest(BSobj_chr1, group1=c("AK1"), group2=c("iPSC"), smoothing=TRUE, smoothing.span = 500)
#dmltest_ak1_npc <- DMLtest(BSobj_chr1, group1=c("AK1"), group2=c("NPC"), smoothing=TRUE, smoothing.span = 500)
#dmltest_ak1_h1 <- DMLtest(BSobj_chr1, group1=c("AK1"), group2=c("H1"), smoothing=TRUE, smoothing.span = 500)
# Note on DMLtest (core DSS function, http://www.bioconductor.org/packages/devel/bioc/vignettes/DSS/inst/doc/DSS.html#33_DMLDMR_detection_from_two-group_comparison)
# what it does
# (1) estimate average methylation levels for all CpG sites (Smoothing or not)
# (2) estimate dispersion at each CpG site.
# (3) conduct Wald test

# A threshold for defining DML. 
# In DML testing procedure, hypothesis test that the two groups means are equalis is conducted at each CpG site. 
# Here if 'delta' is specified, the function will compute the posterior probability that the difference of the means are greater than delta, and then call DML based on that
# The BS-seq count data are modeled as Beta-Binomial distribution, where the biological variations are captured by the dispersion parameter. The dispersion parameters are estimated through a shrinakge estimator based on a Bayesian hierarchical model. Then a Wald test is performed at each CpG site.

# Call DMR by callDMR
#dmrs_ak1_ipsc = callDMR(dmltest_ak1_ipsc, delta=0.2, p.threshold=1e-5, minlen=50, minCG=3, dis.merge=50, pct.sig=0.5) # 10% Methylation difference / P value < 0.05
#dmrs_ak1_npc = callDMR(dmltest_ak1_npc, delta=0.2, p.threshold=1e-5, minlen=50, minCG=3, dis.merge=50, pct.sig=0.5)
#dmrs_ak1_h1 = callDMR(dmltest_ak1_h1, delta=0.2, p.threshold=1e-5, minlen=50, minCG=3, dis.merge=50, pct.sig=0.5)

# Note on callDMR
# callDMR returns:
# chr   start   end length  nCG meanMethyl1 meanMethyl2 diff.Methy  arearStat
# areaStat: The sum of the test statistics of all CpG sites within the DMR.
# When specifying a 'delta' value, the posterior probability (pp) of each CpG site being DML is computed. Then the p.threshold is applied on (1 - posterior probability), e.g., sites with 1-pp

#pdf("test_DMR.pdf")
#showOneDMR(dmrs_ak1_ipsc[1,], BSobj_chr1)
#dev.off()

#pdf("test_DMR2.pdf")
#showOneDMR(dmrs_ak1_h1[1,], BSobj_chr1)
#dev.off()

#write.table(dmrs_ak1_h1, sep='\t', quote=FALSE, row.names=FALSE, file="DMRs_DSS_AK1-H1_chr1.tab")