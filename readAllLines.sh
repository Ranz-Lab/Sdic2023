#!/usr/bin/bash
###Ranz Lab 2022


###Goal: Return a text file with the line count of all files in directories
###	Files named: Gene_Strain_Tissue_Replicate_ReadDirection_FileType

###Go through each directory and add line count to output file
#Get the path to the main directory
MAINDIR=$(pwd)

#Name intermediary output file
output_file_name="allLineCounts.txt"
touch "${output_file_name}"

#For each directory in the main directory find the sample directories
for DIRECTORY in */
do

	#Move into each strain/tissue/replicate directory
	cd "${DIRECTORY}"

	#For each _overlap file in the current directory
	for FILE in *
	do 
		#Add line count and file name to output file
		LINECOUNT=$(wc -l "${FILE}")
		echo "${LINECOUNT}" >> "${MAINDIR}"/"${output_file_name}"
	done

	#Move back to the main directory to repeat
	cd ../
done
