#!/bin/bash

# Define index file, output files and input directory
INDEX="../data/hsapiens_index"
OUTPUT_DIR="../results/salmon_output"
INPUT_DIR="../data/processed"

# Loop through each input fastq file
for ACC in "$@"
do
	echo ""; echo "Processing : ${ACC}"; echo ""

	# Run salmon quant command
    	salmon quant -i "$INDEX" -l A -1 "${INPUT_DIR}/${ACC}_1_trimmed.fastq" -2 "${INPUT_DIR}/${ACC}_2_trimmed.fastq" -o "${OUTPUT_DIR}/${ACC}" \
 	--validateMappings -p 16
done
