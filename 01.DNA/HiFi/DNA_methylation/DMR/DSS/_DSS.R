ak1_chr1 <- read.table("/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs/chr1/AK1_merged_DSS_chr1.tab", header=TRUE)
ipsc_chr1 <- read.table("/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs/chr1/iPSC_merged_DSS_chr1.tab", header=TRUE)
npc_chr1 <- read.table("/mnt/mone/Project/AK1_PacBio/01.DNA/Merged/Phasing_wIndels/ML_Model/Analysis/DMR/DSS/Inputs_Generation/Inputs/chr1/NPC_merged_DSS_chr1.tab", header=TRUE)

BSobj = makeBSseqData( list( ak1_chr1, ipsc_chr1, npc_chr1 ))
