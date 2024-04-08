import os
bedtools='bedtools'
region='chm13v2.0_woYnM.bed'

# 1. Make hg38 100kb bed file
os.system(f'{bedtools} makewindows -b {region} -w 10000 > {region.rstrip(".bed") + "_10kb.bed"}')
os.system(f'{bedtools} makewindows -b {region} -w 5000 > {region.rstrip(".bed") + "_5kb.bed"}')
os.system(f'{bedtools} makewindows -b {region} -w 1000 > {region.rstrip(".bed") + "_1kb.bed"}')
os.system(f'{bedtools} makewindows -b {region} -w 10000 -s 5000 > {region.rstrip(".bed") + "_10kb_step5kb.bed"}')
os.system(f'{bedtools} makewindows -b {region} -w 10000 -s 1000 > {region.rstrip(".bed") + "_10kb_step1kb.bed"}')
os.system(f'{bedtools} makewindows -b {region} -w 5000 -s 1000 > {region.rstrip(".bed") + "_5kb_step1kb.bed"}')
'''
os.system(f'{bedtools} makewindows -b {region} -w 1000 -s 500 > {region.rstrip(".bed") + "_1kb_step500bp.bed"}')
os.system(f'{bedtools} makewindows -b {region} -w 1000 -s 100 > {region.rstrip(".bed") + "_1kb_step100bp.bed"}')
'''

# 2. Make intesected bed file (CG position for each tiles)
os.system(f'{bedtools} intersect -wao -a {region.rstrip(".bed") + "_10kb.bed"} -b CpG_Sites_CHM13v2.0_woY.bed > {region.rstrip(".bed") + "_10kb_forwad_CG.bed"}')
os.system(f'{bedtools} intersect -wao -a {region.rstrip(".bed") + "_5kb.bed"} -b CpG_Sites_CHM13v2.0_woY.bed > {region.rstrip(".bed") + "_5kb_forwad_CG.bed"}')
os.system(f'{bedtools} intersect -wao -a {region.rstrip(".bed") + "_1kb.bed"} -b CpG_Sites_CHM13v2.0_woY.bed > {region.rstrip(".bed") + "_1kb_forwad_CG.bed"}')
os.system(f'{bedtools} intersect -wao -a {region.rstrip(".bed") + "_10kb_step5kb.bed"} -b CpG_Sites_CHM13v2.0_woY.bed > {region.rstrip(".bed") + "_10kb_step5kb_forwad_CG.bed"}')
os.system(f'{bedtools} intersect -wao -a {region.rstrip(".bed") + "_10kb_step1kb.bed"} -b CpG_Sites_CHM13v2.0_woY.bed > {region.rstrip(".bed") + "_10kb_step1kb_forwad_CG.bed"}')
os.system(f'{bedtools} intersect -wao -a {region.rstrip(".bed") + "_5kb_step1kb.bed"} -b CpG_Sites_CHM13v2.0_woY.bed > {region.rstrip(".bed") + "_5kb_step1kb_forwad_CG.bed"}')
'''
os.system(f'{bedtools} intersect -wao -a {region.rstrip(".bed") + "_1kb_step500bp.bed"} -b CpG_Sites_CHM13v2.0_woY.bed > {region.rstrip(".bed") + "_1kb_step500bp_forwad_CG.bed"}')
os.system(f'{bedtools} intersect -wao -a {region.rstrip(".bed") + "_1kb_step100bp.bed"} -b CpG_Sites_CHM13v2.0_woY.bed > {region.rstrip(".bed") + "_1kb_step100bp_forwad_CG.bed"}')
'''
