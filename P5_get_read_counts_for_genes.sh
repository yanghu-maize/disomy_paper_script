#!/bin/bash -l
#SBATCH -J  P5_getcount_5
#SBATCH -o P5_getcount_5-%j.out
#SBATCH -p Lewis
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem 50G
#SBATCH -t 2-00:00:00

echo "1. get read counts for genes";
cd bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc
echo "perl script_folder/getMulticomMapResults_maize_W22_gff_genelevel.pl  bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique.sam   Maize_reference_genome_W22_folder/Zea_mays_W22_multicom.gff readsLen.txt  multicom-10L26D_S10_R1_001_trim_fastqc.txt"
perl script_folder/getMulticomMapResults_maize_W22_gff_genelevel.pl  bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique.sam   Maize_reference_genome_W22_folder/Zea_mays_W22_multicom.gff readsLen.txt  multicom-10L26D_S10_R1_001_trim_fastqc.txt
echo "2. get reads new";
cd bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc
echo "perl script_folder/getMulticomReadsCount.pl  multicom-10L26D_S10_R1_001_trim_fastqc.txt multicom-10L26D_S10_R1_001_trim_fastqc_new.txt"
perl script_folder/getMulticomReadsCount.pl  multicom-10L26D_S10_R1_001_trim_fastqc.txt multicom-10L26D_S10_R1_001_trim_fastqc_new.txt
echo "3. get union genes";
cd bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc
echo "perl script_folder/unionGenes.pl Maize_reference_genome_W22_folder/Zea_mays_W22_multicom  multicom-10L26D_S10_R1_001_trim_fastqc_new.txt multicom-10L26D_S10_R1_001_trim_fastqc_newnew.txt"
perl script_folder/unionGenes.pl Maize_reference_genome_W22_folder/Zea_mays_W22_multicom  multicom-10L26D_S10_R1_001_trim_fastqc_new.txt multicom-10L26D_S10_R1_001_trim_fastqc_newnew.txt
