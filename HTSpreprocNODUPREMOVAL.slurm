#!/bin/bash


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

