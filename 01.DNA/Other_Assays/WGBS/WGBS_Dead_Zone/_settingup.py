import os
import sys
from glob import glob
'''
#tar xvf GSE186458_RAW.tar --wildcards '*.hg38.beta'
tar xvf GSE186458_RAW.tar GSM5652204_Dermal-Fibroblasts-Z00000423.hg38.beta
tar xvf GSE186458_RAW.tar GSM5652224_Neuron-Z000000TH.hg38.beta
tar xvf GSE186458_RAW.tar GSM5652316_Blood-B-Z000000TX.hg38.beta
tar xvf GSE186458_RAW.tar GSM5652317_Blood-B-Z000000UB.hg38.beta
tar xvf GSE186458_RAW.tar GSM5652318_Blood-B-Z000000UR.hg38.beta

os.system('wgbstools init_genome GRCh38 --fasta_path /mnt/mone/Project/AK1_PacBio/Tools/Reference/GRCh38/DNA/hg38.analysisSet.fa')
os.system('wgbstools init_genome hg38')
os.system('wgbstools beta2bed --keep_na -c 5 --outpath ./GSM5652204_Dermal-Fibroblasts-Z00000423.hg38.bed --genome hg38 GSM5652204_Dermal-Fibroblasts-Z00000423.hg38.beta')
'''

'''
os.system('tar tvf GSE186458_RAW.tar | grep hg38.beta > GSE186458_RAW_betaFile_List.txt')
with open("GSE186458_RAW_betaFile_List.txt", 'r') as dbf:
        for line in dbf:
                sample = line.strip('\n').split()[-1]
                os.system(f'tar xvf GSE186458_RAW.tar {sample}')                
'''

wgbstools = '/mnt/mone/Project/AK1_PacBio/Tools/wgbs_tools/src/python/wgbs_tools.py'
directory = '/mnt/mone/Project/AK1_PacBio/01.DNA/Public_Data/GSE186458_DNAmATLAS/GSE186458'
files = glob(f'{directory}/Beta_Files/*.hg38.beta')
sampleID = list(map(lambda x: x.rstrip('.beta').split('/')[-1], files))

start = int(sys.argv[1])
end = int(sys.argv[2])
sampleID = sampleID[start-1: end] # Total 207 samples

for sample in sampleID:
        os.system(f'{wgbstools} beta2bed --keep_na --force -c 1 --outpath {directory}/BED_from_Beta_Files/{sample}.bed --genome hg38 {directory}/Beta_Files/{sample}.beta')
