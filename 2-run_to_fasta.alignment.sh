#!/usr/bin/bash
###Ranz Lab 2022
#Goal: Run to_fasta.alignment.sh on every file in to_fasta_files.txt
while read -r line; do 
	infile=($line) 
	./to_fasta.alignment.sh $infile
done < to_fasta_files.txt
