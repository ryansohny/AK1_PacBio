import os
genomesize = int(os.popen("awk -F '\t' 'BEGIN {SUM=0} {SUM+=$3-$2} END {print SUM}' genome_callable.bed").read().strip())
outpmdsize = int(os.popen("awk -F'\t' 'BEGIN {SUM=0} {SUM+=$3-$2} END {print SUM}' Outside_of_PMD.bed").read().strip())
inpmdsize = int(os.popen("awk -F'\t' 'BEGIN {SUM=0} {SUM+=$3-$2} END {print SUM}' Inside_of_PMD.bed").read().strip())

print(genomesize, outpmdsize, inpmdsize)

files = ["TRANSCRIPT_gencode.v41.annotation.basic.sorted_woYnM.bed", \
"TRANSCRIPT_gencode.v41.annotation.basic.sorted.protein_coding_woYnM.bed", \
"GENE_gencode.v41.annotation.sorted_woYnM.bed", \
"GENE_gencode.v41.annotation.sorted.protein_coding_woYnM.bed"]


annotation = ["Transcripts", "Protein_Coding_Transcripts", "Genes", "Protein_Coding_Genes"]
print(annotation)
print("PMD")

c = 0
for file in files:
	overlapped = int(os.popen("/mnt/mone/Project/WC300/Tools/Anaconda3/bin/bedtools intersect -wao -a " + file + " -b Inside_of_PMD.bed | awk '{sum+=$NF} END {print sum}'").read().strip())

	featuresize = int(os.popen("awk -F '\t' 'BEGIN {SUM=0} {SUM+=$3-$2} END {print SUM}' " + file).read().strip())

	enrichment = (overlapped / genomesize) / ((inpmdsize / genomesize) * (featuresize / genomesize))

	print(annotation[c] + '\t' + str(enrichment))
	c += 1

print('\n')

print("Non-PMD")
c = 0
for file in files:
	overlapped = int(os.popen("/mnt/mone/Project/WC300/Tools/Anaconda3/bin/bedtools intersect -wao -a " + file + " -b Outside_of_PMD.bed | awk '{sum+=$NF} END {print sum}'").read().strip())

	featuresize = int(os.popen("awk -F '\t' 'BEGIN {SUM=0} {SUM+=$3-$2} END {print SUM}' " + file).read().strip())

	enrichment = (overlapped / genomesize) / ((outpmdsize / genomesize) * (featuresize / genomesize))

	print(annotation[c] + '\t' + str(enrichment))
	c += 1

'''
cat Enrichment_Transcripts_on_PMD.tab 
Category	PMD	Non-PMD
Transcripts	0.7701047372319193	1.2585992704004665
Protein_Coding_Transcripts	0.6668503030065758	1.391039453151524
'''

import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
sns.set(font="Arial", font_scale=1.2, style='ticks')
plt.rc("axes.spines", top=False, right=False)

enrich_df = pd.read_table("Enrichment_Transcripts_on_PMD.tab", index_col=0)

fig, ax = plt.subplots(figsize=(5, 5), constrained_layout=True)
enrich_df.plot.bar(ax=ax, color=['darkkhaki', 'black'])
ax.set_xlabel('')
ax.set_ylabel('Fold Enrichment of Overlap')
ax.set_xticklabels(['Transcripts\n(All)', 'Transcripts\n(Protein coding)'], rotation=0)
ax.axhline(y=1.0, linestyle='--', color='darkred')
ax.legend(loc='upper right', bbox_to_anchor=(1.25, 0.15), frameon=True, fancybox=False, edgecolor='black', prop={'size':10}, title=None)
plt.savefig("Barplot_Fold_Enrichment_transcripts_overPMD_n_nonPMD.pdf")