import sys
import pysam
import numpy as np
import pandas as pd
import math
from scipy.spatial import distance
from scipy.spatial.distance import pdist, squareform
from scipy.stats import pearsonr, spearmanr

def get_read_level_cg(read_segment, pos):
    if read_segment.modified_bases != {}:
        read_alignment_start = read_segment.get_reference_positions()[0]
        read_alignment_end = read_segment.get_reference_positions()[-1]
        if read_alignment_start <= pos[0] and read_alignment_end >= pos[-1]:
            cg_ml = dict(list(read_segment.modified_bases.values())[0]) # read-level cytosine location and ML
            cg_met = list()
            if read_segment.is_reverse:
                cg_ml = {key-1: value for key, value in cg_ml.items()}
            for k,v in read_segment.get_aligned_pairs(): # read-based coordinate and corresponding reference coordinate
                if v in pos:
                    try:
                        cg_met.append(cg_ml[k]/256)
                    except KeyError:
                        cg_met.append(np.nan)
            return np.array(cg_met)

def make_cg_matrix(alignmentfile, refcgtab, coordinate):
    cg_pos = list(map(lambda x: int(x), refcgtab.loc[coordinate]['CG_Pos'].rstrip(';').split(';')))
    chrom, start, end = refcgtab.loc[coordinate]['chromosome'], refcgtab.loc[coordinate]['start'], refcgtab.loc[coordinate]['end']
    cg_matrix_list = list()
    for read in alignmentfile.fetch(chrom, start, end):
        read_level_cg = get_read_level_cg(read, cg_pos)
        if np.all(read_level_cg != None):
            cg_matrix_list.append(read_level_cg)
    return np.array(cg_matrix_list)

def remove_nan_column_from_cg_matrix(matrix):
    mask = np.isnan(matrix)
    mask = ~mask.any(axis=0)
    matrix = matrix[:, mask]
    return matrix

def get_pairwise_distances_from_cg_matrix(matrix):
    # input matrix from: remove_nan_column_from_cg_matrix()
    n_elements = math.comb(matrix.shape[0], 2)
    # Average pairwise cosine similarity (problem: distance 1 and -1 would cancel out)
    lower_tril_cos = np.tril(squareform(1- pdist(matrix, 'cosine')), k=-1)
    average_pairwise_cos_similarity = np.sum(lower_tril_cos) / n_elements
    # Average pairwise euclidean distance
    lower_tril_euc = np.tril(squareform(pdist(matrix, 'euclidean')), k=-1)
    average_pairwise_euc_distance = np.sum(lower_tril_euc) / n_elements
    # Other Metrics... (TBD)
    return average_pairwise_cos_similarity, average_pairwise_euc_distance

try: 
    bamfile = pysam.AlignmentFile(sys.argv[1], 'rb') # "chr20_500000-1000000_AK1.bam"
    dir = "/mnt/mone/Project/AK1_PacBio/01.DNA/Analysis_Samples_Merged/Heterogeneity/CpG_in_Reference"
    cgwindowfile = pd.read_table(f'{dir}/{sys.argv[2]}', index_col=0) # "10kb_CG_Information_hg38_primary_chrX.tab"
    with open(f"{sys.argv[3]}.tab", 'w') as outfile:
        outfile.write('ID\tchrom\tstart\tend\tMean_cos\tMean_euc\n')
        for i in cgwindowfile.index:
            chrom, start, end = cgwindowfile.loc[i]['chromosome'], cgwindowfile.loc[i]['start'], cgwindowfile.loc[i]['end']
            cg_matrix = make_cg_matrix(bamfile, cgwindowfile, i)
            if cg_matrix.shape[0] > 1:
                cg_matrix = remove_nan_column_from_cg_matrix(cg_matrix)    
                distances = get_pairwise_distances_from_cg_matrix(cg_matrix)
                outfile.write(f'{i}\t{chrom}\t{start}\t{end}\t{distances[0]}\t{distances[1]}\n')
                outfile.flush()
    bamfile.close()

except IndexError:
    print('\n')
    print('Please Provide Input Arguments\n')
    print('usage: python _heterogeneity_calculation.py [PacBio Bam File] [Reference CG window] [Output prefix]\n')
    print('usage example: python _heterogeneity_calculation.py AK1_haplotagged_wIndels_splt.bam 10kb_CG_Information_hg38_primary_chrX.tab AK1_10kb_CG_Heterogeneity')
    print('\n')