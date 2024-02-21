import scanpy as sc
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

%autoindent
%matplotlib

adata = sc.read_10x_mtx('AK1/')

knee = np.sort((np.array(adata.X.sum(axis=1))).flatten())[::-1]
cell_set = np.arange(len(knee))
cutoff = 200
num_cells = cell_set[knee > cutoff][::-1][0]

fig, ax = plt.subplots(figsize=(10, 7))

ax.loglog(knee, cell_set, lw=5, color="g")
ax.axvline(x=cutoff, lw=3, color="k")
ax.axhline(y=num_cells, lw=3, color="k")
ax.set_xlabel("UMI counts")
ax.set_ylabel("Set of Barcodes")
plt.grid(True, which = "both")

print(f"{num_cells:,.0f} cells passed the {cutoff} UMI threshold")
#9,364 cells passed the 200 UMI threshold (2022-10-22)