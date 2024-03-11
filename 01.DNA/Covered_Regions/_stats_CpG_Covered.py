# /mnt/mone/Project/AK1_PacBio/01.DNA/CHM13_Merged/00.Mapping_Stats/mosdepth/CpG_Covered
# For CHM13-T2T
import os
from glob import glob
bedfiles = sorted(glob("*_chm13_Low_coverage.bed"))
cpg_region = "CpG_Sites_CHM13v2.0_woY.bed"

cmd = f'wc -l {cpg_region}'
cpg_counts = int(os.popen(cmd).read().strip().split()[0])

with open("Covered_CpGs_for_each_sample_T2T.tab", 'w') as rfh:
        rfh.write('Sample\tCpG_Covered_T2T\tTotal_CpG_T2T\n')
        for bedfile in bedfiles:
                sampleid = bedfile.rstrip('_chm13_Low_coverage.bed')
                cmd = f'bedtools intersect -v -a {cpg_region} -b {bedfile} | wc -l'
                covered_cpg = int(os.popen(cmd).read().strip())
                rfh.write(sampleid + '\t' + str(covered_cpg) + '\t' + str(cpg_counts) + '\n')
                rfh.flush()

# /mnt/mone/Project/AK1_PacBio/01.DNA/Analysis_Samples_Merged/Coverage_Calculation/mosdepth/New_Merged/CpG_Covered
# For GRCh38
import os
from glob import glob
bedfiles = sorted(glob("*_Low_coverage.bed"))
cpg_region = "CpG_Sites_hg38_woY.bed"

cmd = f'wc -l {cpg_region}'
cpg_counts = int(os.popen(cmd).read().strip().split()[0])

with open("Covered_CpGs_for_each_sample_hg38.tab", 'w') as rfh:
        rfh.write('Sample\tCpG_Covered_GRCh38\tTotal_CpG_GRCh38\n')
        for bedfile in bedfiles:
                sampleid = bedfile.rstrip('_Low_coverage.bed')
                cmd = f'bedtools intersect -v -a {cpg_region} -b {bedfile} | wc -l'
                covered_cpg = int(os.popen(cmd).read().strip())
                rfh.write(sampleid + '\t' + str(covered_cpg) + '\t' + str(cpg_counts) + '\n')
                rfh.flush()

# Switch the iPSC and NPC linen manually in vim editor

# From /data/Projects/phenomata/01.Projects/13.AK1_PacBio/01.DNA/Analysis_2023/CpG_Covered (scanpy_1.9.3 environment)
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
sns.set(font="Arial", font_scale=1.2, style='ticks')
plt.rc("axes.spines", top=False, right=False)

df1 = pd.read_table("Covered_CpGs_for_each_sample_hg38.tab", index_col=0)
df2 = pd.read_table("Covered_CpGs_for_each_sample_T2T.tab", index_col=0)
df = pd.concat([df1, df2], axis=1)
df = df.reset_index()
df.columns = ['Sample', 'CpG covered (GRCh38)', 'CpG sites (GRCh38)', 'CpG covered (T2T)', 'CpG sites (T2T)']
'''
df['CpG sites (GRCh38)'] - df['CpG covered (GRCh38)'] # CpG sites not covered in GRCh38
df['CpG sites (T2T)'] - df['CpG covered (T2T)'] # CpG sites not covered in T2T
'''
# Setting the bar position
bar_width = 0.45
x1 = df.index - bar_width/2
x2 = df.index + bar_width/2

colors = ['darkgreen', 'orange', 'darkred', 'darkblue']
fig, ax = plt.subplots(figsize=(10, 5), constrained_layout=True)
ax.bar(x1, df['CpG sites (GRCh38)'], width=bar_width, label='CpG sites (GRCh38)', color=colors[0])
ax.bar(x1, df['CpG covered (GRCh38)'], width=bar_width, label='CpG covered (GRCh38)', color=colors[1])
ax.bar(x2, df['CpG sites (T2T)'], width=bar_width, label='CpG sites (T2T)', color=colors[2])
ax.bar(x2, df['CpG covered (T2T)'], width=bar_width, label='CpG covered (T2T)', color=colors[3])

ax.set_xticks(df.index)
ax.set_xticklabels(['AK1\nHiFi', 'AK1\nWGBS', 'H1\nWGBS', 'HUES64\nWGBS', 'iPSC\nHiFi', 'NPC\nHiFi'])
ax.set_ylabel('CpG Sites Covered (10 millions)')
ax.legend(loc='upper right', bbox_to_anchor=(1.25, 0.25), frameon=True, fancybox=False, edgecolor='black', prop={'size':10}, title=None)
plt.savefig("Barplot_CpG_Covered_across_samples_hg38_and_T2T.pdf")


### CpG islands, shores and shelves
sample_palette = {'AK1':'#FF0000', 'AK1_WGBS': '#FF00FF', 'HG002': '#999999', 'H1_WGBS': '#40E0D0', 'HUES64_WGBS': '#437299' ,'iPSC': '#154360','NPC': '#229954'}

cpgishoshe = pd.read_table("CpGishoresshelves_covered_by_sample.tab", index_col=0)
cpgishoshe_p = cpgishoshe[cpgishoshe.index.str.endswith('P')]
rename_dict = {'CpGiP': 'CpG Islands', 'CpGshoresP': 'CpG Shores', 'CpGshelvesP': 'CpG Shelves'}
cpgishoshe_p.rename(index=rename_dict, inplace=True)
cpgishoshe_p_melted = cpgishoshe_p.reset_index().melt(id_vars='ID', var_name='Sample', value_name='Covered Percentage (%)')
fig, ax = plt.subplots(figsize=(10, 5), constrained_layout=True)
sns.barplot(data=cpgishoshe_p_melted, x='Sample', y='Covered Percentage (%)', hue='ID', palette='tab20c', ax=ax)
ax.legend(loc='upper right', bbox_to_anchor=(1.18, 0.2), frameon=True, fancybox=False, edgecolor='black', prop={'size':10}, title=None)
ax.set_xticklabels(['AK1\nHiFi', 'AK1\nWGBS', 'HG002\nHiFi', 'H1\nWGBS', 'HUES64\nWGBS', 'iPSC\nHiFi', 'NPC\nHiFi'])
ax.set_xlabel('')
plt.savefig("Barplot_CpGishoresshelves_Covered_across_samples_hg38.pdf")