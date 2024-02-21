import sys
dfh = open("chm13.draft_v2.0.gene_annotation.gffread.gff3", 'r')
rfh = open("chm13.draft_v2.0.gene_annotation.gffread.modified.gff3", 'w')

def gtf_attribute_parser(string):
	'''
	gene_id "ENSG00000223972.5"; gene_type "transcribed_unprocessed_pseudogene"; gene_name "DDX11L1"; level 2; hgnc_id "HGNC:37102"; havana_gene "OTTHUMG00000000961.2"; transcript_id "";
	'''
	tag_value_pairs = string.split(';')[:-1]
	attribute_dir = dict()
	for pair in tag_value_pairs:
		tag, value = pair.strip().split(' ', 1) # Ensure that split() produce at most two parts
		'''value = value.strip('"')'''
		attribute_dir[tag] = value
	return attribute_dir

for _ in range(3):
	'''rfh.write(dfh.readline())'''
	dfh.readline()

trans_attribute = dict()
transkeys = ['gene_name', 'gene_id', 'transcript_id']
for i in dfh:
	line = i.strip('\n').split('\t')
	if line[2] == 'gene':	
		attribute_parse = list(map(lambda x: ' '.join([x.split('=')[0], '"' + x.split('=')[1] + '"']), line[8].split(';')))
		attribute = '; '.join(attribute_parse).rstrip('\n') + ';'
		rfh.write('\t'.join(line[:8]) + '\t' + attribute + '\n')
	elif line[2] == 'transcript':
		attribute_parse = list(map(lambda x: ' '.join([x.split('=')[0], '"' + x.split('=')[1] + '"']), line[8].split(';')))
		attribute = '; '.join(attribute_parse).rstrip('\n') + ';'
		rfh.write('\t'.join(line[:8]) + '\t' + attribute + '\n')
		attribute_dir = gtf_attribute_parser(attribute)
		'''{'ID': '"LOFF_T0000001"', 'Parent': '"LOFF_G0000001"', 'gene_name': '"AL627309.3"', 'gene_id': '"LOFF_G0000001"', 'transcript_id': '"LOFF_T0000001"'}'''

		trans_attribute[attribute_dir['ID']] = {k: attribute_dir[k] for k in transkeys}
	elif line[2] == 'exon':
		attribute_parse = list(map(lambda x: ' '.join([x.split('=')[0], '"' + x.split('=')[1] + '"']), line[8].split(';')))
		attribute = '; '.join(attribute_parse).rstrip('\n') + ';'
		attribute_dir = gtf_attribute_parser(attribute)
		matching_trans = trans_attribute[attribute_dir['Parent']]
		
		rfh.write('\t'.join(line[:8]) + '\t' + ' '.join(list(map(lambda x: x + ' ' + matching_trans[x] + ';',  matching_trans.keys()))) + '\n')
	rfh.flush()