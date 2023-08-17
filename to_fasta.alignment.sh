#!/usr/bin/bash
###Ranz Lab 2022

#Goal: Write fasta file using the first two columns of each line

infile=$1
outfile="${infile}_alignment"

while read -r line; do
	stringarray=($line)
	header=${stringarray[0]}
	header=${header/@/>}
	echo $header >> $outfile
	echo ${stringarray[1]} >> $outfile
done <$infile
