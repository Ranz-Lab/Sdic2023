#!/bin/bash

#SBATCH --array=1-n  #	!!CHANGE n TO # OF SAMPLES!!
#SBATCH --output=<PATH>/slurmout/motifcounter_%A_%a.out 	## File to which STDOUT will be written ## slurm error file, %x - job name, %A job id  !!CHANGE <PATH> TO WHERE YOUR slurmout DIRECTORY IS!!
#SBATCH --error=<PATH>/slurmout/motifcounter_%A_%a.err 		## File to which STDERR will be written ## slurm output file, %x - job name, %A job id !!CHANGE <PATH> TO WHERE YOUR slurmout DIRECTORY IS!!


set -e
set -u
set -o pipefail


INPATH="" #preprocessed reads
OUTPATH=""

SAMPLE=`sed "${SLURM_ARRAY_TASK_ID}q;d" <SAMPLE LIST>.txt`  #  !!CHANGE <SAMPLE LIST> TO THE NAME OF YOUR FILE WITH ALL YOUR SAMPLES LISTED!!


##	!!MODIFY BELOW HERE FOR EACH GENE OF INTEREST, Keep Core_cur and Ref_cur constant lengths!!
motifID_cur="SdicAll"	## current motif ID, eg. Sdic1. 

#R1 sequence information 
coremotifSeq_cur1="CTCAAAGTAGAATACGTTGA"	## the seq of current core motif
refSeq_cur1="GTTCGTAGCCTGCACATTGTAGACGCTTAGGTTGAGAGGCTGTTTCTTTCCGCCGCTCAAAGTAGAATACGTTGATCGTAAAAACTTAATCAGTACTAAGCCCATTGTCCAATCTGTGTAATACTAAGCT" ##!!the seq of current extended motif
LCore_cur1="20"	## !!the length of current core motif seq 
LRef_cur1="130"	## the length of current motif seq. 
SRef_cur1="56"	## !!the start pos of current core motif in ref
ERef_cur1="75"	## !!the end pos of current core motif in ref

#R2 sequence information 
coremotifSeq_cur2="TCAACGTATTCTACTTTGAG"	## the seq of current core motif
refSeq_cur2="AGCTTAGTATTACACAGATTGGACAATGGGCTTAGTACTGATTAAGTTTTTACGATCAACGTATTCTACTTTGAGCGGCGGAAAGAAACAGCCTCTCAACCTAAGCGTCTACAATGTGCAGGCTACGAAC"	## !!the seq of current extended motif
LCore_cur2="20"	## !!the length of current core motif seq 
LRef_cur2="130"	## the length of current motif seq
SRef_cur2="56"	## !!the start pos of current core motif in ref
ERef_cur2="75"	## !!the end pos of current core motif in ref


##	!!DO NOT MODIFY BELOW HERE!!

#R1
zcat ${INPATH}/${SAMPLE}/${SAMPLE}_R1.fastq.gz | grep -A 2 -B 1 ${coremotifSeq_cur1} - | sed '/^--/d' | gzip - > ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R1.fastq.gz
zcat ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R1.fastq.gz | grep -A 1 '^@'     | sed '/^--/d'     | sed 's/ /_/g'     | awk '/^@/&&NR>1{print "";}{ printf "%s",/^@/ ? $0"\t":$0 }' | awk -v n=${LCore_cur1} -v b=${coremotifSeq_cur1}  -v L=${LRef_cur1} -v S=${SRef_cur1} -v E=${ERef_cur1} -v RSeq=${refSeq_cur1} -v LRead=101 '{SRead=index($2,b);ERead=SRead+n-1;HeadLength=SRead-1;if(HeadLength>S-1)HeadLength=S-1; TailLength=LRead-ERead;if(TailLength>L-E)TailLength=L-E; SRefOverlap=S-HeadLength; ERefOverlap=E+TailLength; SReadOverlap=SRead-HeadLength; EReadOverlap=ERead+TailLength; LOverlap=EReadOverlap-SReadOverlap+1; SeqRefOverlap=substr(RSeq,SRefOverlap,LOverlap) ; SeqReadOverlap=substr($2,SReadOverlap,LOverlap) ; print $0"\t"LRead"\t"SRead"\t"ERead"\t"HeadLength"\t"TailLength"\t"SRefOverlap"\t"ERefOverlap"\t"SReadOverlap"\t"EReadOverlap"\t"LOverlap"\t"SeqRefOverlap"\t"SeqReadOverlap}' > ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R1_overlap
awk '{if($3!=-1 && $12>=70)print}' ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R1_overlap > ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R1_Reads
awk '{if($3!=-1 && $12>=70 && $13==$14)print}' ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R1_overlap > ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R1_PerfReads


#R2
zcat ${INPATH}/${SAMPLE}/${SAMPLE}_R2.fastq.gz | grep -A 2 -B 1 ${coremotifSeq_cur2} - | sed '/^--/d' | gzip - > ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R2.fastq.gz
zcat ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R2.fastq.gz | grep -A 1 '^@'     | sed '/^--/d'     | sed 's/ /_/g'     | awk '/^@/&&NR>1{print "";}{ printf "%s",/^@/ ? $0"\t":$0 }' | awk -v n=${LCore_cur2} -v b=${coremotifSeq_cur2}  -v L=${LRef_cur2} -v S=${SRef_cur2} -v E=${ERef_cur2} -v RSeq=${refSeq_cur2} -v LRead=101 '{SRead=index($2,b);ERead=SRead+n-1;HeadLength=SRead-1;if(HeadLength>S-1)HeadLength=S-1; TailLength=LRead-ERead;if(TailLength>L-E)TailLength=L-E; SRefOverlap=S-HeadLength; ERefOverlap=E+TailLength; SReadOverlap=SRead-HeadLength; EReadOverlap=ERead+TailLength; LOverlap=EReadOverlap-SReadOverlap+1; SeqRefOverlap=substr(RSeq,SRefOverlap,LOverlap) ; SeqReadOverlap=substr($2,SReadOverlap,LOverlap) ; print $0"\t"LRead"\t"SRead"\t"ERead"\t"HeadLength"\t"TailLength"\t"SRefOverlap"\t"ERefOverlap"\t"SReadOverlap"\t"EReadOverlap"\t"LOverlap"\t"SeqRefOverlap"\t"SeqReadOverlap}' > ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R2_overlap
awk '{if($3!=-1 && $12>=70)print}' ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R2_overlap > ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R2_Reads
awk '{if($3!=-1 && $12>=70 && $13==$14)print}' ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R2_overlap > ${OUTPATH}/${SAMPLE}/${motifID_cur}_${SAMPLE}_R2_PerfReads






