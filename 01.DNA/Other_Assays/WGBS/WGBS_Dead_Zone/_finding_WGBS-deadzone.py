from glob import glob
bedfiles = sorted(glob("BED_from_Beta_Files/*.bed"))
covered_dir = 'Covered_BED'
deadzone_dir = 'WGBSDZ_BED'

for bedfile in bedfiles:
    sampleID = bedfile.split('/')[1].split('_')[0]
    with open(bedfile, 'r') as input_file, open(f'{covered_dir}/{sampleID}_covered.bed', 'w') as covered_file, open(f'{deadzone_dir}/{sampleID}_WGBSdeadzone.bed', 'w') as deadzone_file:
        current_chromosome = None
        current_start = None
        current_end = None
        current_file = None
        line_count = 0
        for line in input_file:
            chromosome, start, end, methylated_coverage, total_coverage = line.strip().split()
            if int(total_coverage) >= 5:
                if current_chromosome == chromosome and current_file == covered_file:
                    current_end = end
                    line_count += 1
                else:
                    if current_chromosome is not None:
                        current_file.write(f'{current_chromosome}\t{current_start}\t{current_end}\t{line_count}\n')
                        current_file.flush()
                    current_chromosome = chromosome
                    current_start = start
                    current_end = end
                    current_file = covered_file
                    line_count = 1
            else:
                if current_chromosome == chromosome and current_file == deadzone_file:
                    current_end = end
                    line_count += 1
                else:
                    if current_chromosome is not None:
                        current_file.write(f'{current_chromosome}\t{current_start}\t{current_end}\t{line_count}\n')
                        current_file.flush()
                    current_chromosome = chromosome
                    current_start = start
                    current_end = end
                    current_file = deadzone_file
                    line_count = 1
        if current_chromosome is not None:
            current_file.write(f'{current_chromosome}\t{current_start}\t{current_end}\t{line_count}\n')
            current_file.flush()
