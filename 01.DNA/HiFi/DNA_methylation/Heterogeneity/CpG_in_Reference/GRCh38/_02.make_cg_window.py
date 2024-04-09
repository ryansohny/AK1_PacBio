import os, sys
bedtools='/mnt/mone/Project/WC300/Tools/Anaconda3/bin/bedtools'

try:
	tile_cg_file = sys.argv[1] # hg38_primary_chrX_10kb_forward_CG.bed
	output_file_prefix = sys.argv[2] # 10kb_CG_Information_hg38_primary_chrX
except IndexError:
	print('\nPlease provide input arguments\n')
	print('usage: python _02.processing.py [tile file with CG info (bed)] [output prefix]\n')
	print('usage example: python _02.processing.py hg38_primary_chrX_10kb_step1kb_forwad_CG.bed 10kb_step1kb_CG_Information_hg38_primary_chrX\n')
	sys.exit()

with open(f"{tile_cg_file}", 'r') as dfh, open(f"{output_file_prefix}.tab", 'w') as rfh:
	rfh.write('ID\tchromosome\tstart\tend\tCG_Num\tCG_Pos\n')

	cg_pos_dict = dict()
	cg_num_dict = dict()

	line = dfh.readline().strip('\n').split('\t')

	if line[-1] != '0':
		id = f'{line[0]}:{line[1]}-{line[2]}'
		pos = line[4]
		
		try:
			cg_pos_dict[id] += f'{pos};'
			cg_num_dict[id] += 1
		except KeyError:
			cg_pos_dict[id] = f'{pos};'
			cg_num_dict[id] = 1

	line = dfh.readline().strip('\n').split('\t')

	while line != ['']:
		if line[-1] != '0':
			
			id = f'{line[0]}:{line[1]}-{line[2]}'
			pos = line[4]
			
			try:
				cg_pos_dict[id] += f'{pos};'
				cg_num_dict[id] += 1
			except KeyError:
				cg_pos_dict[id] = f'{pos};'
				cg_num_dict[id] = 1

		line = dfh.readline().strip('\n').split('\t')

	for k in cg_pos_dict.keys():
		chrom, start, end = k.split(':')[0], k.split(':')[1].split('-')[0], k.split(':')[1].split('-')[1] 
		rfh.write(f'{k}\t{chrom}\t{start}\t{end}\t{cg_num_dict[k]}\t{cg_pos_dict[k]}\n')
		rfh.flush()

# check
dfh = open(f"{output_file_prefix}.tab", 'r')
dfh.readline()
for i in dfh:
	line = i.strip('\n').split('\t')
	count = int(line[4])
	if len(line[5].rstrip(';').split(';')) != count:
		print('Something went wrong!!!')