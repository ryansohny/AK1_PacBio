import os

bedtools="/mnt/mone/Project/WC300/Tools/Anaconda3/envs/pygenometracks/bin/bedtools"
AK1 = "Candidate_ICR_metcutoff65_from_AK1_Hap_sorted_slop500bp.bed"
HG002 = "Candidate_ICR_metcutoff65_from_HG002_Hap_sorted_slop500bp.bed"
knownICR = "Known_ICR_cleaned.bed"
putativeICR = "Putative_ICR_wochrX.bed"

cmd = f'wc -l {knownICR}'
os.popen(cmd)
total_knownICR = int(os.popen(cmd).read().split()[0])

cmd = f'wc -l {putativeICR}'
total_putativeICR = int(os.popen(cmd).read().split()[0])

cmd = f'{bedtools} intersect -a {knownICR} -b {AK1} -u | wc -l'
knownICR_overlap_w_AK1 = int(os.popen(cmd).read().strip())

cmd = f'{bedtools} intersect -a {putativeICR} -b {AK1} -u | wc -l'
putativeICR_overlap_w_AK1 = int(os.popen(cmd).read().strip())

cmd = f'bedtools intersect -a {knownICR} -b {HG002} -u | wc -l'
knownICR_overlap_w_HG002 = int(os.popen(cmd).read().strip())

cmd = f'{bedtools} intersect -a {putativeICR} -b {HG002} -u | wc -l'
putativeICR_overlap_w_HG002 = int(os.popen(cmd).read().strip())

with open("Overlap_w_geneImprint.tab", 'w') as rfh:
	rfh.write(',AK1_Known,AK1_Putative,HG002_Known,HG002_Putative\n')
	rfh.write(f'Overlapped,{knownICR_overlap_w_AK1},{putativeICR_overlap_w_AK1},{knownICR_overlap_w_HG002},{putativeICR_overlap_w_HG002}\n')
	rfh.write(f'Not overlapped,{total_knownICR - knownICR_overlap_w_AK1},{total_putativeICR - putativeICR_overlap_w_AK1},{total_knownICR - knownICR_overlap_w_HG002},{total_putativeICR - putativeICR_overlap_w_HG002}\n')
	rfh.flush()


'''
from /mnt/mone/Project/AK1_PacBio/01.DNA/Analysis_Samples_Merged/DNA_Methylation_Analysis/DMR/Haplotype_DSS/Imprinting/Overlap_w_Imprintome
and /mnt/data/Projects/phenomata/01.Projects/13.AK1_PacBio/01.DNA/Analysis_2023/Imprinting/Counts

$cat Overlap_w_geneImprint.tab
,AK1_Known,AK1_Putative,HG002_Known,HG002_Putative
Overlapped,14,46,17,111
Not overlapped,11,1344,8,1279
'''
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
sns.set(font="Arial", font_scale=1.2, style='ticks')
plt.rc("axes.spines", top=False, right=False)

df = pd.read_csv("Overlap_w_geneImprint.tab", index_col=0)

fig, ax = plt.subplots(figsize=(5,6), constrained_layout=True)
df[['AK1_Known']].T.plot(kind='bar', stacked=True, color={'Overlapped': '#00203FFF', 'Not overlapped': '#ADEFD1FF'}, rot=0, ax=ax)
ax.set_ylim((0,25))
ax.set_ylabel("The Number of Known ICRs from Imprintome (N = 25)")
legend = ax.legend_
handles = legend.legendHandles
labels = [text.get_text() for text in legend.texts]
ax.legend(handles, labels, loc='upper right', bbox_to_anchor=(1.25, 0.7), frameon=True, fancybox=False, edgecolor='black', prop={'size':10}, title=None)
ax.set_xticklabels(['Candidate ICRs in AK1 Haplotypes'])
plt.savefig("Barplot_AK1_ICRs_Overlapped_w_KnownICRs_from_Imprintome.pdf")

fig, ax = plt.subplots(figsize=(5,5), constrained_layout=True)
data_pie = [df['AK1_Putative']['Overlapped'], df['AK1_Putative']['Not overlapped']]
wedges, texts, autotexts = ax.pie(data_pie, colors=['#00203FFF', '#ADEFD1FF'], autopct=lambda p: f'{data_pie[int(p/100*len(data_pie))]:,}\n({p:.2f}%)')
autotexts[0].set_color('white')
autotexts[0].set_fontsize(10)
autotexts[0].set_x(autotexts[0].get_position()[0] + 0.24)
autotexts[0].set_y(autotexts[0].get_position()[1] + 0.022)
autotexts[1].set_fontsize(14)
ax.legend(wedges, ['Overlapped', 'Not overlapped'], title='', loc='center left', bbox_to_anchor=(0.85, -0.3, 0.5, 1), prop={'size':8}, frameon=True, fancybox=False, edgecolor='black')
plt.savefig("Piechart_AK1_ICRs_Overlapped_w_PutativeICRs_from_Imprintome.pdf")