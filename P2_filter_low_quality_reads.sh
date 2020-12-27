#!/bin/bash -l
#SBATCH -J  P2_fastqc_1
#SBATCH -o P2_fastqc_1-%j.out
#SBATCH -p Lewis
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem 50G
#SBATCH -t 6:00:00

/FASTX_Toolkit/fastq_quality_filter -Q 33  -q 20 -p 80  -i fastq_folder/10L26D_S10_R1_001.fastq -o  filter_low_quality_reads_folder/10L26D_S10_R1_001_trim_fastqc.fastq

