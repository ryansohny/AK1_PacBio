import os
genomesize = int(os.popen("awk -F '\t' 'BEGIN {SUM=0} {SUM+=$3-$2} END {print SUM}' genome_callable.bed").read().strip())
insize_hyper = int(os.popen("awk -F'\t' 'BEGIN {SUM=0} {SUM+=$3-$2} END {print SUM}' Inside_of_HyperDMR_DSS_woPMD_AK1-iPSC_MetTh40.bed").read().strip())
insize_hypo = int(os.popen("awk -F'\t' 'BEGIN {SUM=0} {SUM+=$3-$2} END {print SUM}' Inside_of_HypoDMR_DSS_woPMD_AK1-iPSC_MetTh40.bed").read().strip())

print(genomesize, insize_hyper, insize_hypo)

files = ["GM12878_cCREs_woY.bed",
"H1_cCREs_woY.bed"]

annotation = ['GM12878_cCREs', 'H1_cCREs']

print(annotation)

dbf = open("cCREs_elements.txt", 'r')
elements = list(map(lambda x: x.strip('\n'), dbf.readlines()))
print(elements)
rfh = open("Enrichment_cCREs_on_DMR.tab", 'w')
rfh.write('Category\tEnrichment\tDMR\n')
rfh.flush()

print("Hyper-DMR")
c = 0
for file in files:

	for element in elements:
		os.system("awk '$10 == " + f"\"{element}\"' {file} > temp_element.bed")

		overlapped = int(os.popen("/mnt/mone/Project/WC300/Tools/Anaconda3/bin/bedtools intersect -wao -a temp_element.bed -b Inside_of_HyperDMR_DSS_woPMD_AK1-iPSC_MetTh40.bed | awk '{sum+=$NF} END {print sum}'").read().strip())

		featuresize = int(os.popen("awk -F '\t' 'BEGIN {SUM=0} {SUM+=$3-$2} END {print SUM}' temp_element.bed").read().strip())

		enrichment = (overlapped / genomesize) / ((insize_hyper / genomesize) * (featuresize / genomesize))

		rfh.write(annotation[c] + f'_{element}' + '\t' + str(enrichment) + '\tHyper-DMR\n')
		rfh.flush()
		print(annotation[c] + f'_{element}' + '\t' + str(enrichment) + '\tHyper-DMR')
	c += 1

print('\n')

print("Hypo-DMR")
c = 0
for file in files:

	for element in elements:
	    os.system("awk '$10 == " + f"\"{element}\"' {file} > temp_element.bed")	
		
        overlapped = int(os.popen("/mnt/mone/Project/WC300/Tools/Anaconda3/bin/bedtools intersect -wao -a temp_element.bed -b Inside_of_HypoDMR_DSS_woPMD_AK1-iPSC_MetTh40.bed | awk '{sum+=$NF} END {print sum}'").read().strip())

        featuresize = int(os.popen("awk -F '\t' 'BEGIN {SUM=0} {SUM+=$3-$2} END {print SUM}' temp_element.bed").read().strip())

        enrichment = (overlapped / genomesize) / ((insize_hypo / genomesize) * (featuresize / genomesize))

		rfh.write(annotation[c] + f'_{element}' + '\t' + str(enrichment) + '\tHypo-DMR\n')
		rfh.flush()
		print(annotation[c] + f'_{element}' + '\t' + str(enrichment) + '\tHypo-DMR')
	c += 1
