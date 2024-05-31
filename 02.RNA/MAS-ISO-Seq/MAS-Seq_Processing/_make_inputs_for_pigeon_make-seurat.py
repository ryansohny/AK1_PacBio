for sample in ['AK1', 'iPSC', 'NPC']:
	with open(f'{sample}_deconcat.wo5mC.trimmed.5p--3p.flt.fltnc.clipTSO.bccorr.sorted.dedup.Headermodified.fasta', 'r') as dfh, open(f'{sample}_molecule_fl_assoc.tab', 'w') as rfh:
		rfh.write("ID\tfl_assoc\tlength\tCB\tXM\tCB-XM\n")
		for i in dfh:
		
			if i[0] == '>':
				line = i.strip('\n').split()
				id = line[0][1:]
	
				info_line = {j.split('=')[0]: j.split('=')[1] for j in line[1].split(';')}

				fl_assoc = info_line['full_length_coverage']
				length = info_line['length']
				cb = info_line['CB']
				xm = info_line['XM']
	
				rfh.write(f'{id}\t{fl_assoc}\t{length}\t{cb}\t{xm}\t{cb+xm}\n')
				rfh.flush()

# For creating classification.txt file for each sample
with open("Merged_mapped_modified_classification.filtered_lite_classification.txt", 'r') as dfh:
	classification_dict_by_pb = dict()

	column_names = dfh.readline().strip('\n').split('\t')[1:]
	column_dict_original = dict.fromkeys(column_names, '')

	for i in dfh:
		column_dict_new = column_dict_original.copy()
		line = i.strip('\n').split('\t')
		id = line[0]
		values = line[1:]
		for x, y in enumerate(values):
			column_dict_new[column_names[x]] = y
		classification_dict_by_pb[id] = column_dict_new # {'PB.1.1': {'chrom': 'chr1', 'strand': '+', ...}

with open("Merged_mapped_modified.collapsed.group.txt", 'r') as dfh:
	rfh1 = open("AK1.group.txt", 'w')
	rfh2 = open("iPSC.group.txt", 'w')
	rfh3 = open("NPC.group.txt", 'w')
	
	for i in dfh:
		line = i.strip('\n').split('\t')
		pbid, ak1_mol, ipsc_mol, npc_mol = line[0], list(), list(), list()
		for j in line[1].split(','):
			if 'AK1' in j:
				ak1_mol.append(j)
			elif 'iPSC' in j:
				ipsc_mol.append(j)
			elif 'NPC' in j:
				npc_mol.append(j)

		if len(ak1_mol) != 0:
			rfh1.write(pbid + '\t' + ','.join(ak1_mol) + '\n')
		if len(ipsc_mol) != 0:
			rfh2.write(pbid + '\t' + ','.join(ipsc_mol) + '\n')
		if len(npc_mol) != 0:
			rfh3.write(pbid + '\t' + ','.join(npc_mol) + '\n')
	rfh1.close()
	rfh2.close()
	rfh3.close()

# Making a hash table with PB.X.X as key and Cell Barcode represented as N as value for each sample
with open("Merged_mapped_modified.collapsed.abundance.txt", 'r') as dfh:

	pb_cb_numdict_ak1 = dict() # Main
	pb_cb_numdict_ipsc = dict() # Main
	pb_cb_numdict_npc = dict() # Main

	cb_numdict_ak1 = dict()
	cb_numdict_ipsc = dict()
	cb_numdict_npc = dict()
	c_ak1 = 1
	c_ipsc = 1
	c_npc = 1

	for i in range(4):
		dfh.readline()
	for i in dfh:
		line = i.strip('\n').split('\t')
		for j in line[3].split(','):
			if j not in cb_numdict_ak1 and j not in cb_numdict_ipsc and j not in cb_numdict_npc:
				if 'AK1' in j:
					cb_numdict_ak1[j] = str(c_ak1)
					c_ak1 += 1
				elif 'iPSC' in j:
					cb_numdict_ipsc[j] = str(c_ipsc)
					c_ipsc += 1
				elif 'NPC' in j:
					cb_numdict_npc[j] = str(c_npc)
					c_npc += 1
		
		pb_cb_numlist_ak1 = list()
		pb_cb_numlist_ipsc = list()
		pb_cb_numlist_npc = list()
		for j in line[3].split(','):
			if 'AK1' in j:
				pb_cb_numlist_ak1.append(cb_numdict_ak1[j])
			elif 'iPSC' in j:
				pb_cb_numlist_ipsc.append(cb_numdict_ipsc[j])
			elif 'NPC' in j:
				pb_cb_numlist_npc.append(cb_numdict_npc[j])
		
		if len(pb_cb_numlist_ak1) != 0:
			pb_cb_numdict_ak1[line[0]] = ','.join(pb_cb_numlist_ak1)
		if len(pb_cb_numlist_ipsc) != 0:
			pb_cb_numdict_ipsc[line[0]] = ','.join(pb_cb_numlist_ipsc)
		if len(pb_cb_numlist_npc) != 0:
			pb_cb_numdict_npc[line[0]] = ','.join(pb_cb_numlist_npc)

	#print(len(cb_numdict)) -> 24,626

###### We can definitely build a sample-specific abundance.txt file later ! ######

for sample in ['AK1', 'iPSC', 'NPC']:
	# fl_assoc for each molecule (!!!) -> later for PB.X.X we need to add the assigned values for each molecule
	with open(f'{sample}_molecule_fl_assoc.tab', 'r') as dfh:
		dfh.readline()
		mol_fl_assoc = dict()
		for i in dfh:
			line = i.strip('\n').split('\t')
			mol_fl_assoc[line[0]] = line[1] # {'molecule/0/AK1':'1'}

	# fl_assoc and count_fl for each PB.X.X (!!!): each for fl_assoc and FL for output classification.txt
	with open(f'{sample}.group.txt', 'r') as dfh:
		pb_count_fl_fl_assoc = dict()
		for i in dfh:
			line = i.strip('\n').split('\t')
			mols = line[1].split(',') # molecule/10611246/AK1,molecule/18223142/AK1
			pb_count_fl = len(mols)
			pb_fl_assoc = 0
			pb_fl_assoc += sum(int(mol_fl_assoc[j]) for j in mols)
			pb_count_fl_fl_assoc[line[0]] = f'{pb_count_fl}/{pb_fl_assoc}' # {'PB.X.X': 'A/B'}

	with open(f'{sample}.filtered_lite_classification.txt', 'w') as rfh:
		rfh.write('isoform' + '\t' + '\t'.join(column_names) + '\n') # isoform chrom strand length ...

		pb_cb_numdict_sample = globals()[f'pb_cb_numdict_{sample.lower()}'] # {'PB.X.X': '3,4,5,6'}

		for i in pb_cb_numdict_sample:
			try:
				new_count_fl = pb_count_fl_fl_assoc[i].split('/')[0] # type:str
				new_fl_assoc = pb_count_fl_fl_assoc[i].split('/')[1] # type:str
				new_cb_nums = pb_cb_numdict_sample[i] # type:str
				classification_dict_sample = classification_dict_by_pb[i].copy() # type:dict
				classification_dict_sample['FL'] = new_count_fl
				classification_dict_sample['fl_assoc'] = new_fl_assoc
				classification_dict_sample['cell_barcodes'] = new_cb_nums
				rfh.write(i + '\t' + '\t'.join(classification_dict_sample.values()) + '\n') # i -> PB.X.X
				rfh.flush()
			except KeyError:
				pass
	with open(f'{sample}.filtered_lite_classification.txt', 'r') as dfh:
		pb_set = set()
		dfh.readline()
		for i in dfh:
			line = i.strip('\n').split('\t')
			pb_set.add(line[0])
		if sample == 'AK1':
			ak1_pb_set = pb_set.copy()
		elif sample == 'iPSC':
			ipsc_pb_set = pb_set.copy()
		elif sample == 'NPC':
			npc_pb_set = pb_set.copy()


def parsing_gff_attributes(string):
	'''gene_id "PB.1"; transcript_id "PB.1.1";'''
	string = string.split(';')
	attr_dict = dict()
	for kv in string:
		if kv != '':
			k, v = kv.strip().split()
			attr_dict[k] = v.strip('"')
	return attr_dict
		
with open("Merged_mapped_modified.collapsed.sorted.filtered_lite.gff", 'r') as dfh:
	rfh_ak1 = open("AK1.filtered_lite.gff", 'w')
	rfh_ipsc = open("iPSC.filtered_lite.gff", 'w')
	rfh_npc = open("NPC.filtered_lite.gff", 'w')

	for i in dfh:
		line = i.strip('\n').split('\t')
		transcript_id = parsing_gff_attributes(line[8])['transcript_id']
		if transcript_id in ak1_pb_set:
			rfh_ak1.write('\t'.join(line) + '\n')
			rfh_ak1.flush()
		if transcript_id in ipsc_pb_set:
			rfh_ipsc.write('\t'.join(line) + '\n')
			rfh_ipsc.flush()
		if transcript_id in npc_pb_set:
			rfh_npc.write('\t'.join(line) + '\n')
			rfh_npc.flush()
	rfh_ak1.close()
	rfh_ipsc.close()
	rfh_npc.close()