#!/bin/bash -l
#SBATCH -J  P4_readstat_1
#SBATCH -o P4_readstat_1-%j.out
#SBATCH -p Lewis
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem 40G
#SBATCH -t 2:00:00

module load samtools/samtools-1.3.1;
echo "1. Calculate the reads counts in Fastq file";
echo "perl scripts_folder/calReadsCount.pl filter_low_quality_reads_folder/10L26D_S10_R1_001_trim_fastqc.fastq &> statistics_k10.txt"
perl scripts_folder/calReadsCount.pl filter_low_quality_reads_folder/10L26D_S10_R1_001_trim_fastqc.fastq &> statistics_k10.txt

echo "2. Calculate mapping statistics (unique/multiple locations)";
echo "perl scripts_folder/calReadsCountMap.pl bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2.sam    &>> statistics_k10.txt"
perl scripts_folder/calReadsCountMap.pl bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2.sam   &>> statistics_k10.txt

echo "3. remove reads mapped to multiple locations";
echo "perl  scripts_folder/selectReads.pl bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2.sam bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique.sam"
perl  scripts_folder/selectReads.pl bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2.sam bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc_bowtie2_k10_mismatch_2_unique.sam

echo "4. get read length";
echo "perl scripts_folder/getReadsLength.pl  bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc.fastq  readsLen.txt"
perl scripts_folder/getReadsLength.pl bowtie_output_folder/10L26D_S10_R1_001_trim_fastqc/10L26D_S10_R1_001_trim_fastqc.fastq readsLen.txt

