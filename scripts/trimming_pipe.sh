#!/bin/bash

# Accepts list of run numbers SRR...
# Loop over fastq files and trim Illumina Universal adapter AGATCGGAAGAG
# Remove poly A-tail and corresponding poly T fragments
# Cut of 3' ends with quality scores below 20
# Filter out reads below 50 bases
for ACC in "$@"
do
	echo ""; echo "Processing : ${ACC}"; echo ""

	cutadapt -a AGATCGGAAGAG -A AGATCGGAAGAG -o ../data/processed/"$ACC"_1_trimmed.fastq \
	-p ../data/processed/"$ACC"_2_trimmed.fastq --cores 0 --poly-a --minimum-length 50 --quality-cutoff 20 \
	../data/raw_data/"$ACC"_1.fastq ../data/raw_data/"$ACC"_2.fastq

	# Run FASTQC
	fastqc ../data/processed/"$ACC"_1_trimmed.fastq --outdir ../results/fastqc --threads 16
	fastqc ../data/processed/"$ACC"_2_trimmed.fastq --outdir ../results/fastqc --threads 16 

done
