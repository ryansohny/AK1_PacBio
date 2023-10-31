#!/mnt/mone/Project/WC300/Tools/Anaconda3/envs/pygenometracks/bin/python
import sys
import os
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
sns.set(font="arial", font_scale=1.15, style='ticks')
plt.rc("axes.spines", top=False, right=False)

input_file = sys.argv[1] # bed file

# Make Length files
os.system("awk '{print $3 - $2}' " + f"{input_file} > temp_{input_file}_length.tab")

df = pd.read_table(f'temp_{input_file}_length.tab', header=None, names=['Length'])

bin_edges = np.concatenate([np.arange(0, 5500, 500), [4e4]])
counts, _ = np.histogram(df['Length'], bins=bin_edges)

fig, ax = plt.subplots(1, 1, figsize=(8.5, 7.5), constrained_layout=True)
ax.bar(range(len(counts)), counts, width=1, color='black')
ax.set_xticks(range(0, len(counts)))
newlabels = [f'{int(left):,}-{int(right):,}bp' for left, right in zip(bin_edges[:-1], bin_edges[1:])]
newlabels[-1] = '≥5,000bp'
ax.set_xticklabels(newlabels)
for xticklabel in ax.get_xticklabels():
    xticklabel.set_rotation(25)
ax.get_yaxis().set_major_formatter(matplotlib.ticker.FuncFormatter(lambda x, p: format(int(x), ',')))
ax.set_xlabel("Length of DMR")
ax.set_ylabel("Number of DMR")

plt.savefig("DMR_Length_histogram.png")
os.system(f'/usr/bin/rm temp_{input_file}_length.tab')