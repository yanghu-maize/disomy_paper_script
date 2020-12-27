#!/bin/bash -l
#SBATCH -J  P3_bowtie2_1
#SBATCH -o P3_bowtie2_1-%j.out
#SBATCH -p Lewis
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem 80G
#SBATCH -t 2-00:00:00

module load bowtie2/bowtie2-2.2.9

bowtie2 --phred33   -N 0  --no-unal -k 10 -x Maize_reference_genome_W22_folder/reference  -U filter_low_quality_reads_folder/10L26D_S10_R1_001_trim_fastqc.fastq   -S bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10.sam

perl scripts_folder/P3_getBowtie2Result.pl bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10.sam bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2.sam 2

