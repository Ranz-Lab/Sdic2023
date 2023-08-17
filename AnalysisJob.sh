#!/bin/bash
#SBATCH --job-name=RNAseqCounts_T         ## Name of the job. !!CHANGE THIS TO APPROPRIATE NAME!!
#SBATCH -A JRANZ_LAB                                    ## account to charge
#SBATCH -p standard                                     ## partition/queue name
#SBATCH --nodes=1                                                               ## use 1 node, don’t ask for multiple
#SBATCH --ntasks=4                                                      ##number of CPUS on 1 node
#SBATCH --time=72:00:00                                                 ##time limit for job
#SBATCH --mem-per-cpu=8G                                                ##memory put CPU; if ntasks = 4, total mem = 32Gb
#SBATCH --output=/dfs5/bio/bclifton/Founders/Testis/slurmout/mismatch_%A_%a.out  ## File to which STDOUT will be written ## slurm error file, %x - job name, %A job id
#SBATCH --error=/dfs5/bio/bclifton/Founders/Testis/slurmout/mismatch_%A_%a.err           ## File to which STDERR will be written ## slurm output file, %x - job name, %A job id
#SBATCH --mail-type=ALL
#SBATCH --mail-user=bclifton@uci.edu

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
#Get the path to the main directory
cd /dfs5/bio/bclifton/Founders/Testis/03-GeneCounter/mismatch/03-GeneCounter #CHANGE THIS PATH!!!
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
