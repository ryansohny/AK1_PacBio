import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
sns.set(font="arial", font_scale=1.15, style='ticks')
plt.rcParams['figure.figsize'] = (6,6)
plt.rc("axes.spines", top=False, right=False)

'''files=[H9, H1, GM12878, WTC11]'''

h9 = pd.read_table("H9/H9_collapsed_classification.filtered_lite_classification_saturation.txt")
h9_melt = pd.melt(h9, id_vars=['reads'], value_vars=['unique_genes', 'unique_isoforms', 'unique_genes_known', 'unique_isoforms_known'])
sns.lineplot(data=h9_melt, x='reads', y='value', hue='variable')
plt.tight_layout()
plt.savefig('H9/H9_saturation_plot.pdf')
plt.clf()

h1 = pd.read_table("H1/H1_collapsed_classification.filtered_lite_classification_saturation.txt")
h1_melt = pd.melt(h1, id_vars=['reads'], value_vars=['unique_genes', 'unique_isoforms', 'unique_genes_known', 'unique_isoforms_known'])
sns.lineplot(data=h1_melt, x='reads', y='value', hue='variable')
plt.tight_layout()
plt.savefig('H1/H1_saturation_plot.pdf')
plt.clf()

gm12878 = pd.read_table("GM12878/GM12878_collapsed_classification.filtered_lite_classification_saturation.txt")
gm12878_melt = pd.melt(gm12878, id_vars=['reads'], value_vars=['unique_genes', 'unique_isoforms', 'unique_genes_known', 'unique_isoforms_known'])
sns.lineplot(data=gm12878_melt, x='reads', y='value', hue='variable')
plt.tight_layout()
plt.savefig('GM12878_saturation_plot.pdf')
plt.clf()

wtc11 = pd.read_table("WTC11/WTC11_collapsed_classification.filtered_lite_classification_saturation.txt")
wtc11_melt = pd.melt(wtc11, id_vars=['reads'], value_vars=['unique_genes', 'unique_isoforms', 'unique_genes_known', 'unique_isoforms_known'])
sns.lineplot(data=wtc11_melt, x='reads', y='value', hue='variable')
plt.tight_layout()
plt.savefig('WTC11_saturation_plot.pdf')
plt.clf()