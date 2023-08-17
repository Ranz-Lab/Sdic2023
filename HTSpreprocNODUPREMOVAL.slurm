#!/bin/bash
#SBATCH --job-name=HTStream_FlyAtlas       ## Name of the job. !!CHANGE THIS TO APPROPRIATE NAME!!
#SBATCH -A JRANZ_LAB                     ## account to charge
#SBATCH -p standard                     ## partition/queue name
#SBATCH --nodes=1			## use 1 node, don’t ask for multiple
#SBATCH --ntasks=4  			##number of CPUS on 1 node
#SBATCH --time=72:00:00			##time limit for job
#SBATCH --mem-per-cpu=8G		##memory put CPU; if ntasks = 4, total mem = 32Gb
#SBATCH --array=1-12			##line of the array file to create a job; can do 1-n or just n
#SBATCH --output=/dfs5/bio/fangninl/slurmout/htstream_%A_%a.out 	## File to which STDOUT will be written ## slurm error file, %x - job name, %A job id
#SBATCH --error=/dfs5/bio/fangninl/slurmout/htstream_%A_%a.err 		## File to which STDERR will be written ## slurm output file, %x - job name, %A job id
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fangninl@uci.edu



start=`date +%s`
echo $HOSTNAME
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

sample=`sed "${SLURM_ARRAY_TASK_ID}q;d" FlyAtlasSamples.txt` ### !!CHANGE THIS TO SAMPLE FILE NAME!!

inpath="00-RawData"
outpath="01-HTS_PreprocDUP"
[[ -d ${outpath} ]] || mkdir ${outpath}
[[ -d ${outpath}/${sample} ]] || mkdir ${outpath}/${sample}

echo "SAMPLE: ${sample}"


call="./hts_Stats -L ${outpath}/${sample}/${sample}.json -N 'initial stats' \
          -1 ${inpath}/${sample}*1.fastq.gz \
          -2 ${inpath}/${sample}*2.fastq.gz | \
      ./hts_SeqScreener -A ${outpath}/${sample}/${sample}.json -N 'screen phix' | \
      ./hts_SeqScreener -A ${outpath}/${sample}/${sample}.json -N 'count the number of rRNA reads'\
          -r -s References/Dmel_rRNA.fasta | \
      ./hts_AdapterTrimmer -A ${outpath}/${sample}/${sample}.json -N 'trim adapters' | \
      ./hts_PolyATTrim --no-left --skip_polyT -A ${outpath}/${sample}/${sample}.json -N 'remove polyAT tails' | \
      ./hts_NTrimmer -A ${outpath}/${sample}/${sample}.json -N 'remove any remaining N characters' | \
      ./hts_QWindowTrim -A ${outpath}/${sample}/${sample}.json -N 'quality trim the ends of reads' | \
      ./hts_LengthFilter -A ${outpath}/${sample}/${sample}.json -N 'remove reads < 50bp' \
          -n -m 50 | \
      ./hts_Stats -A ${outpath}/${sample}/${sample}.json -N 'final stats' \
          -f ${outpath}/${sample}/${sample}"

echo $call
eval $call

end=`date +%s`
runtime=$((end-start))
echo $runtime

