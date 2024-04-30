#!/bin/bash

# Loop over each accession number
for ACC in "$@"
do
	echo ""; echo "Processing : ${ACC}"; echo ""
	prefetch "$ACC" --progress --output-directory ../data/raw_data
	fasterq-dump ../data/raw_data/"$ACC" --outdir ../data/raw_data --progress --threads 12 --split-files
	fastqc ../data/raw_data/"${ACC}_1".fastq --outdir ../results/fastqc --threads 12	
	fastqc ../data/raw_data/"${ACC}_2".fastq --outdir ../results/fastqc --threads 12
done
