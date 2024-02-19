total_tfbs=$(awk '{sum += $3-$2} END {print sum}' all_chr_woY_merged.bed)

ak1_intersected=$(bedtools intersect -wo -a AK1_Retained_Primary_woY.bed -b all_chr_woY_merged.bed | awk '{sum += $NF} END {print sum}')
ipsc_intersected=$(bedtools intersect -wo -a iPSC_Retained_Primary_woY.bed -b all_chr_woY_merged.bed | awk '{sum += $NF} END {print sum}')
npc_intersected=$(bedtools intersect -wo -a NPC_Retained_Primary_woY.bed -b all_chr_woY_merged.bed | awk '{sum += $NF} END {print sum}')
ak1wgbs_intersected=$(bedtools intersect -wo -a AK1_WGBS_Retained_Primary_woY.bed -b all_chr_woY_merged.bed | awk '{sum += $NF} END {print sum}')
h1_intersected=$(bedtools intersect -wo -a H1_Retained_Primary_woY.bed -b all_chr_woY_merged.bed | awk '{sum += $NF} END {print sum}')
hues64_intersected=$(bedtools intersect -wo -a HUES64_Retained_Primary_woY.bed -b all_chr_woY_merged.bed | awk '{sum += $NF} END {print sum}')

ak1_percent=$(echo "$ak1_intersected / $total_tfbs * 100" | bc -l)
ipsc_percent=$(echo "$ipsc_intersected / $total_tfbs * 100" | bc -l)
npc_percent=$(echo "$npc_intersected / $total_tfbs * 100" | bc -l)
ak1wgbs_percent=$(echo "$ak1wgbs_intersected / $total_tfbs * 100" | bc -l)
h1_percent=$(echo "$h1_intersected / $total_tfbs * 100" | bc -l)
hues64_percent=$(echo "$hues64_intersected / $total_tfbs * 100" | bc -l)

echo -e "Category\tPercent_Covered\tActual_Size" > FIMO_TFBS_Covered.tab
echo -e "AK1 HiFi\t$ak1_percent\t$ak1_intersected" >> FIMO_TFBS_Covered.tab
echo -e "AK1 WGBS\t$ak1wgbs_percent\t$ak1wgbs_intersected" >> FIMO_TFBS_Covered.tab
echo -e "iPSC HiFi\t$ipsc_percent\t$ipsc_intersected" >> FIMO_TFBS_Covered.tab
echo -e "NPC HiFi\t$npc_percent\t$npc_intersected" >> FIMO_TFBS_Covered.tab
echo -e "H1 WGBS\t$h1_percent\t$h1_intersected" >> FIMO_TFBS_Covered.tab
echo -e "HUES64 WGBS\t$hues64_percent\t$hues64_intersected" >> FIMO_TFBS_Covered.tab