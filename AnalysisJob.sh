#!/bin/bash

set -e
set -u
set -o pipefail

###Goal: From the _overlap files generate _Reads, _PerfReads, and _less1mismatch 
###	files from the gene, strain, tissue, and replicate information
###	Files named: Gene_Strain_Tissue_Replicate_ReadDirection_FileType


cd ~
source miniconda3/bin/activate
conda activate pairwise_alignment

###Go through each directory and run analysis
cd <PATH> #CHANGE THIS TO THE PATH TO YOUR MAIN DIRECTORY
MAINDIR=$(pwd)

#For each directory in the main directory find the sample directories
for DIRECTORY in */
do

	#Move into each strain/tissue/replicate directory
	cd "${DIRECTORY}"

	#For each _overlap file in the current directory
	for FILE in *_overlap
	do 
		#Get core name of file
		NAME=$(echo "${FILE%_*}")
		

		#Run all analysis to get _Reads, _PerfReads, _less1mismatch, and _less1mismatchMAX
		awk '{if($3!=-1 && $12>=70)print}' "${NAME}"_overlap > "${NAME}"_Reads
		awk '{if($3!=-1 && $12>=70 && $13==$14)print}' "${NAME}"_overlap > "${NAME}"_PerfReads
		python3 "${MAINDIR}"/seq_pairwise_alinment.py -c1 12 -c2 13 "${NAME}"_Reads | awk '{if($17>=($12-1))print}'  >  "${NAME}"_less1mismatch
		python3 "${MAINDIR}"/seq_pairwise_alinment_maxS.py -c1 12 -c2 13 "${NAME}"_Reads | awk '{if($17>=($12-1))print}'  >  "${NAME}"_less1mismatchMAX
	done

	#Move back to the main directory to repeat
	cd ../
done
