#!/bin/bash -l
#SBATCH -J  P6_getres_5
#SBATCH -o P6_getres_5-%j.out
#SBATCH -p Lewis
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem 50G
#SBATCH -t 2-00:00:00
echo "1. generate map from bowtie sam   res 100";
cd bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc
echo "perl script_folder/P6_convert_BowtieMap_to_position_dist_by_resolution_W22.pl  bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique.sam   readsLen.txt  100  bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100.txt"
perl script_folder/P6_convert_BowtieMap_to_position_dist_by_resolution_W22.pl  bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique.sam   readsLen.txt  100  bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100.txt
echo "2. sum  mapping counts for fix-window region for 1kb";
cd bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc
echo "perl script_folder/P6_summary_counts_by_resolution_W22.pl  bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100.txt 100 1000 bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100_convertTo1KB.txt"
perl script_folder/P6_summary_counts_by_resolution_W22.pl  bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100.txt 100 1000 bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100_convertTo1KB.txt
echo "3. sum  mapping counts for fix-window region for 1MB";
cd bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc
echo "perl script_folder/P6_summary_counts_by_resolution_W22.pl bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100.txt 100 1000000 bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100_convertTo1MB.txt"
perl script_folder/P6_summary_counts_by_resolution_W22.pl bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100.txt 100 1000000 bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100_convertTo1MB.txt
