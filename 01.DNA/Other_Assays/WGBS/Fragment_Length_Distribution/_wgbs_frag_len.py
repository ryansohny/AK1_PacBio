import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
sns.set(font="Arial", font_scale=1.15, style='ticks')
plt.rc("axes.spines", top=False, right=False)

bamPEFragmentSize="/mnt/mone/Project/WC300/Tools/Anaconda3/envs/deeptools/bin/bamPEFragmentSize"
samtools="/mnt/mone/Project/WC300/Tools/Anaconda3/bin/samtools"
sed='/bin/sed'
#sed='/usr/bin/sed'

os.system(
f'{samtools} sort \
-@ 55 \
-o AK1_val_1_bismark_bt2_pe.deduplicated.sorted.bam \
AK1_val_1_bismark_bt2_pe.deduplicated.bam')

os.system('f{samtools} index \
-@ 55 \
AK1_val_1_bismark_bt2_pe.deduplicated.sorted.bam')

os.system('f{bamPEFragmentSize} \
--bamfiles AK1_val_1_bismark_bt2_pe.deduplicated.sorted.bam \
--histogram AK1_WGBS_fragment_length_distribution.pdf \
--numberOfProcessors 55 \
--samplesLabel AK1_WGBS \
--plotTitle "Fragment Size of AK1 Paired-end WGBS Data" \
--maxFragmentLength 0 \
--outRawFragmentLengths Fragment_Lengths_Raw.tab \
--verbose')

input_file="Fragment_Lengths_Raw.tab"
output_file="Fragment_Lengths_Raw_modified.tab"
line_count = os.popen(f'wc -l {input_file}').read().split()[0]

os.system(f'{sed} -n 2,{line_count}p {input_file} > {output_file}')

cumul_percentage = (df['Occurrences'].cumsum() / df['Occurrences'].sum()) * 100
df['Cumulative Percentage'] = cumul_percentage

ax = sns.histplot(data=df, x="Size", weights="Occurrences", stat='percent', bins=100, kde=True, color="black")
ax.set_xlabel("Length of region mapped by paired-end WGBS reads (bp)")
ax.set_ylabel("Percentage (%)")
plt.tight_layout()

ax = sns.histplot(data=df, x="Size", weights="Occurrences", stat='percent', bins=100, cumulative=True, element="poly", fill=False, color="black")
ax.axvline(x=251, color='blue', linestyle='--')
ax.axhline(y=df[df['Size'] == 251]['Cumulative Percentage'].values, color='blue', linestyle='--')
ax.text(x=251-50, y=ax.get_ylim()[1]+1, s=f'251bp ({np.round(df[df["Size"] == 251]["Cumulative Percentage"].values, 2)[0]}%)', color='blue', size='x-small') # x-50 for plot aesthetics
ax.axvline(x=400, color='red', linestyle='--')
ax.axhline(y=df[df['Size'] == 400]['Cumulative Percentage'].values, color='red', linestyle='--')
ax.text(x=400-50, y=ax.get_ylim()[1]+1, s=f'400bp ({np.round(df[df["Size"] == 400]["Cumulative Percentage"].values, 2)[0]}%)', color='red', size='x-small') # x-50 for plot aesthetics
ax.set_xlabel("Length of region mapped by paired-end WGBS reads (bp)")
ax.set_ylabel("Percentage (%)")
ax.set_title("Empirical CDF", y=1.05)
plt.tight_layout()



