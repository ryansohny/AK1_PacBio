ak1_chr1 <- read.table("/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs/chr1/AK1_merged_DSS_chr1.tab", header=TRUE)
ipsc_chr1 <- read.table("/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs/chr1/iPSC_merged_DSS_chr1.tab", header=TRUE)
npc_chr1 <- read.table("/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs/chr1/NPC_merged_DSS_chr1.tab", header=TRUE)

BSobj = makeBSseqData( list( ak1_chr1, ipsc_chr1, npc_chr1 ), c("AK1", "iPSC", "NPC"))

dmltest_ak1_ipsc = DMLtest(BSobj, group1=c("AK1"), group2=c("iPSC"), smoothing=TRUE)
dmltest_ak1_npc = DMLtest(BSobj, group1=c("AK1"), group2=c("NPC"), smoothing=TRUE)


dmls_ak1_ipsc = callDML(dmltest_ak1_ipsc, p.threshold=0.001)