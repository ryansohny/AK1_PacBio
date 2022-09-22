# AK1_PacBio

## 1. Setting up Environment

### 1-1. HiFi DNA processing

```
# Download https://github.com/PacificBiosciences/pb-CpG-tools/raw/main/conda_env_cpg.yaml
# vim conda_env_cpg.yaml
#name: pbcpg
#channels:
#  - bioconda
#  - conda-forge
#  - defaults
#dependencies:
#  - python=3.9
#  - tensorflow=2.7
#  - numpy=1.20.0
#  - biopython
#  - pandas
#  - pysam
#  - tqdm
#  - pybigwig
conda env create -f conda_env_cpg.yaml
source activate pbcpg
conda install -c bioconda samtools
conda install -c bioconda pbmm2

# Download "hg38.analysisSet.fa.gz" from http://hgdownload.cse.ucsc.edu/goldenpath/hg38/bigZips/analysisSet/
```

#### The model for calculating the modification probabilties across CpG context is available in https://github.com/PacificBiosciences/pb-CpG-tools/tree/main/pileup_calling_model

### 1-2. HiFi single-cell RNA (MAS-ISO-Seq)

```
conda create -y -n masisoseq -c bioconda pbskera
source activate masisoseq
conda install -y -c bioconda lima
conda install -y -c bioconda samtools
conda install -c bioconda isoseq3
conda install -c bioconda pbccs
conda install -c bioconda minimap2
```

```
# For _02.remove_5mc_from_bam.sh
conda create -y -n masisoseq2 -c bioconda argparse pysam tqdm matplotlib numpy
source activate masisoseq2
```

#### 10X Cell Barcode downloaded from https://github.com/10XGenomics/cellranger/blob/master/lib/python/cellranger/barcodes/737K-august-2016.txt
