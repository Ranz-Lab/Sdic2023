#!/bin/bash


set -e
set -u
set -o pipefail

##Inpath and outpath, should take processed reads from 01- and put the outputs into 03- - CHANGE FOR EACH TISSUE

INPATH=""    ##processed reads
OUTPATH=""   ##matching reads

## !!!CHANGE THIS EACH TIME TO RUN SAMPLE SCRIPT FOR EACH SAMPLE TYPE!!! - will run for all 3 replicates (A-C) and both read directions
SAMPLE=""

##R1 Variables (Rev Compl) - CHANGE FOR EACH GENE
motifID_cur="SdicAll"     ## current motif ID, eg. Sdic1. - CHANGE FOR EACH GENE (SAME FOR R1&R2)
coremotifSeq_cur1="CTCAAAGTAGAATACGTTGA"    ## the seq of current core motif. - CHANGE FOR EACH GENE
refSeq_cur1="GTTCGTAGCCTGCACATTGTAGACGCTTAGGTTGAGAGGCTGTTTCTTTCCGCCGCTCAAAGTAGAATACGTTGATCGTAAAAACTTAATCAGTACTAAGCCCATTGTCCAATCTGTGTAATACTAAGCT" ##!!the seq of current extended motif. - CHANGE FOR EACH GENE
LCore_cur1="20" ## !!the length of current core motif seq - CHANGE FOR EACH GENE (SAME FOR R1&R2)
LRef_cur1="130" ## the length of current motif seq. - keep constant at 130 (same for R1&R2)
SRef_cur1="56"  ## !!the start pos of current core motif in ref. - CHANGE FOR EACH GENE
ERef_cur1="75"  ## !!the end pos of current core motif in ref. - CHANGE FOR EACH GENE

##R2 Variables - CHANGE FOR EACH GENE
#motifID_cur="SdicAll"    ## current motif ID, eg. Sdic1. - CHANGE FOR EACH GENE (SAME FOR R1&R2)
coremotifSeq_cur2="TCAACGTATTCTACTTTGAG"    ## the seq of current core motif. - CHANGE FOR EACH GENE
refSeq_cur2="AGCTTAGTATTACACAGATTGGACAATGGGCTTAGTACTGATTAAGTTTTTACGATCAACGTATTCTACTTTGAGCGGCGGAAAGAAACAGCCTCTCAACCTAAGCGTCTACAATGTGCAGGCTACGAAC"        ## !!the seq of current extended motif. - CHANGE FOR EACH GENE
LCore_cur2="20" ## !!the length of current core motif seq - CHANGE FOR EACH GENE (SAME FOR R1&R2)
LRef_cur2="130" ## the length of current motif seq. - keep constant at 130
SRef_cur2="56"  ## !!the start pos of current core motif in ref. - CHANGE FOR EACH GENE
ERef_cur2="75"  ## !!the end pos of current core motif in ref. - CHANGE FOR EACH GENE




##DO NOT MODIFY PAST HERE


#AR1
zcat ${INPATH}/${SAMPLE}_A/${SAMPLE}_A_R1.fastq.gz | grep -A 2 -B 1 ${coremotifSeq_cur1} - | sed '/^--/d' | gzip - > ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R1.fastq.gz
zcat ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R1.fastq.gz | grep -A 1 '^@'     | sed '/^--/d'     | sed 's/ /_/g'     | awk '/^@/&&NR>1{print "";}{ printf "%s",/^@/ ? $0"\t":$0 }' | awk -v n=${LCore_cur1} -v b=${coremotifSeq_cur1}  -v L=${LRef_cur1} -v S=${SRef_cur1} -v E=${ERef_cur1} -v RSeq=${refSeq_cur1} -v LRead=101 '{SRead=index($2,b);ERead=SRead+n-1;HeadLength=SRead-1;if(HeadLength>S-1)HeadLength=S-1; TailLength=LRead-ERead;if(TailLength>L-E)TailLength=L-E; SRefOverlap=S-HeadLength; ERefOverlap=E+TailLength; SReadOverlap=SRead-HeadLength; EReadOverlap=ERead+TailLength; LOverlap=EReadOverlap-SReadOverlap+1; SeqRefOverlap=substr(RSeq,SRefOverlap,LOverlap) ; SeqReadOverlap=substr($2,SReadOverlap,LOverlap) ; print $0"\t"LRead"\t"SRead"\t"ERead"\t"HeadLength"\t"TailLength"\t"SRefOverlap"\t"ERefOverlap"\t"SReadOverlap"\t"EReadOverlap"\t"LOverlap"\t"SeqRefOverlap"\t"SeqReadOverlap}' > ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R1_overlap
awk '{if($3!=-1 && $12>=70)print}' ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R1_overlap > ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R1_Reads
awk '{if($3!=-1 && $12>=70 && $13==$14)print}' ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R1_overlap > ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R1_PerfReads

#AR2
zcat ${INPATH}/${SAMPLE}_A/${SAMPLE}_A_R2.fastq.gz | grep -A 2 -B 1 ${coremotifSeq_cur2} - | sed '/^--/d' | gzip - > ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R2.fastq.gz
zcat ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R2.fastq.gz | grep -A 1 '^@'     | sed '/^--/d'     | sed 's/ /_/g'     | awk '/^@/&&NR>1{print "";}{ printf "%s",/^@/ ? $0"\t":$0 }' | awk -v n=${LCore_cur2} -v b=${coremotifSeq_cur2}  -v L=${LRef_cur2} -v S=${SRef_cur2} -v E=${ERef_cur2} -v RSeq=${refSeq_cur2} -v LRead=101 '{SRead=index($2,b);ERead=SRead+n-1;HeadLength=SRead-1;if(HeadLength>S-1)HeadLength=S-1; TailLength=LRead-ERead;if(TailLength>L-E)TailLength=L-E; SRefOverlap=S-HeadLength; ERefOverlap=E+TailLength; SReadOverlap=SRead-HeadLength; EReadOverlap=ERead+TailLength; LOverlap=EReadOverlap-SReadOverlap+1; SeqRefOverlap=substr(RSeq,SRefOverlap,LOverlap) ; SeqReadOverlap=substr($2,SReadOverlap,LOverlap) ; print $0"\t"LRead"\t"SRead"\t"ERead"\t"HeadLength"\t"TailLength"\t"SRefOverlap"\t"ERefOverlap"\t"SReadOverlap"\t"EReadOverlap"\t"LOverlap"\t"SeqRefOverlap"\t"SeqReadOverlap}' > ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R2_overlap
awk '{if($3!=-1 && $12>=70)print}' ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R2_overlap > ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R2_Reads
awk '{if($3!=-1 && $12>=70 && $13==$14)print}' ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R2_overlap > ${OUTPATH}/${SAMPLE}_A/${motifID_cur}_${SAMPLE}_A_R2_PerfReads


#BR1
zcat ${INPATH}/${SAMPLE}_B/${SAMPLE}_B_R1.fastq.gz | grep -A 2 -B 1 ${coremotifSeq_cur1} - | sed '/^--/d' | gzip - > ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R1.fastq.gz
zcat ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R1.fastq.gz | grep -A 1 '^@'     | sed '/^--/d'     | sed 's/ /_/g'     | awk '/^@/&&NR>1{print "";}{ printf "%s",/^@/ ? $0"\t":$0 }' | awk -v n=${LCore_cur1} -v b=${coremotifSeq_cur1}  -v L=${LRef_cur1} -v S=${SRef_cur1} -v E=${ERef_cur1} -v RSeq=${refSeq_cur1} -v LRead=101 '{SRead=index($2,b);ERead=SRead+n-1;HeadLength=SRead-1;if(HeadLength>S-1)HeadLength=S-1; TailLength=LRead-ERead;if(TailLength>L-E)TailLength=L-E; SRefOverlap=S-HeadLength; ERefOverlap=E+TailLength; SReadOverlap=SRead-HeadLength; EReadOverlap=ERead+TailLength; LOverlap=EReadOverlap-SReadOverlap+1; SeqRefOverlap=substr(RSeq,SRefOverlap,LOverlap) ; SeqReadOverlap=substr($2,SReadOverlap,LOverlap) ; print $0"\t"LRead"\t"SRead"\t"ERead"\t"HeadLength"\t"TailLength"\t"SRefOverlap"\t"ERefOverlap"\t"SReadOverlap"\t"EReadOverlap"\t"LOverlap"\t"SeqRefOverlap"\t"SeqReadOverlap}' > ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R1_overlap
awk '{if($3!=-1 && $12>=70)print}' ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R1_overlap > ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R1_Reads
awk '{if($3!=-1 && $12>=70 && $13==$14)print}' ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R1_overlap > ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R1_PerfReads

#BR2
zcat ${INPATH}/${SAMPLE}_B/${SAMPLE}_B_R2.fastq.gz | grep -A 2 -B 1 ${coremotifSeq_cur2} - | sed '/^--/d' | gzip - > ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R2.fastq.gz
zcat ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R2.fastq.gz | grep -A 1 '^@'     | sed '/^--/d'     | sed 's/ /_/g'     | awk '/^@/&&NR>1{print "";}{ printf "%s",/^@/ ? $0"\t":$0 }' | awk -v n=${LCore_cur2} -v b=${coremotifSeq_cur2}  -v L=${LRef_cur2} -v S=${SRef_cur2} -v E=${ERef_cur2} -v RSeq=${refSeq_cur2} -v LRead=101 '{SRead=index($2,b);ERead=SRead+n-1;HeadLength=SRead-1;if(HeadLength>S-1)HeadLength=S-1; TailLength=LRead-ERead;if(TailLength>L-E)TailLength=L-E; SRefOverlap=S-HeadLength; ERefOverlap=E+TailLength; SReadOverlap=SRead-HeadLength; EReadOverlap=ERead+TailLength; LOverlap=EReadOverlap-SReadOverlap+1; SeqRefOverlap=substr(RSeq,SRefOverlap,LOverlap) ; SeqReadOverlap=substr($2,SReadOverlap,LOverlap) ; print $0"\t"LRead"\t"SRead"\t"ERead"\t"HeadLength"\t"TailLength"\t"SRefOverlap"\t"ERefOverlap"\t"SReadOverlap"\t"EReadOverlap"\t"LOverlap"\t"SeqRefOverlap"\t"SeqReadOverlap}' > ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R2_overlap
awk '{if($3!=-1 && $12>=70)print}' ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R2_overlap > ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R2_Reads
awk '{if($3!=-1 && $12>=70 && $13==$14)print}' ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R2_overlap > ${OUTPATH}/${SAMPLE}_B/${motifID_cur}_${SAMPLE}_B_R2_PerfReads


#CR1
zcat ${INPATH}/${SAMPLE}_C/${SAMPLE}_C_R1.fastq.gz | grep -A 2 -B 1 ${coremotifSeq_cur1} - | sed '/^--/d' | gzip - > ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R1.fastq.gz
zcat ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R1.fastq.gz | grep -A 1 '^@'     | sed '/^--/d'     | sed 's/ /_/g'     | awk '/^@/&&NR>1{print "";}{ printf "%s",/^@/ ? $0"\t":$0 }' | awk -v n=${LCore_cur1} -v b=${coremotifSeq_cur1}  -v L=${LRef_cur1} -v S=${SRef_cur1} -v E=${ERef_cur1} -v RSeq=${refSeq_cur1} -v LRead=101 '{SRead=index($2,b);ERead=SRead+n-1;HeadLength=SRead-1;if(HeadLength>S-1)HeadLength=S-1; TailLength=LRead-ERead;if(TailLength>L-E)TailLength=L-E; SRefOverlap=S-HeadLength; ERefOverlap=E+TailLength; SReadOverlap=SRead-HeadLength; EReadOverlap=ERead+TailLength; LOverlap=EReadOverlap-SReadOverlap+1; SeqRefOverlap=substr(RSeq,SRefOverlap,LOverlap) ; SeqReadOverlap=substr($2,SReadOverlap,LOverlap) ; print $0"\t"LRead"\t"SRead"\t"ERead"\t"HeadLength"\t"TailLength"\t"SRefOverlap"\t"ERefOverlap"\t"SReadOverlap"\t"EReadOverlap"\t"LOverlap"\t"SeqRefOverlap"\t"SeqReadOverlap}' > ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R1_overlap
awk '{if($3!=-1 && $12>=70)print}' ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R1_overlap > ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R1_Reads
awk '{if($3!=-1 && $12>=70 && $13==$14)print}' ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R1_overlap > ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R1_PerfReads

#CR2
zcat ${INPATH}/${SAMPLE}_C/${SAMPLE}_C_R2.fastq.gz | grep -A 2 -B 1 ${coremotifSeq_cur2} - | sed '/^--/d' | gzip - > ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R2.fastq.gz
zcat ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R2.fastq.gz | grep -A 1 '^@'     | sed '/^--/d'     | sed 's/ /_/g'     | awk '/^@/&&NR>1{print "";}{ printf "%s",/^@/ ? $0"\t":$0 }' | awk -v n=${LCore_cur2} -v b=${coremotifSeq_cur2}  -v L=${LRef_cur2} -v S=${SRef_cur2} -v E=${ERef_cur2} -v RSeq=${refSeq_cur2} -v LRead=101 '{SRead=index($2,b);ERead=SRead+n-1;HeadLength=SRead-1;if(HeadLength>S-1)HeadLength=S-1; TailLength=LRead-ERead;if(TailLength>L-E)TailLength=L-E; SRefOverlap=S-HeadLength; ERefOverlap=E+TailLength; SReadOverlap=SRead-HeadLength; EReadOverlap=ERead+TailLength; LOverlap=EReadOverlap-SReadOverlap+1; SeqRefOverlap=substr(RSeq,SRefOverlap,LOverlap) ; SeqReadOverlap=substr($2,SReadOverlap,LOverlap) ; print $0"\t"LRead"\t"SRead"\t"ERead"\t"HeadLength"\t"TailLength"\t"SRefOverlap"\t"ERefOverlap"\t"SReadOverlap"\t"EReadOverlap"\t"LOverlap"\t"SeqRefOverlap"\t"SeqReadOverlap}' > ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R2_overlap
awk '{if($3!=-1 && $12>=70)print}' ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R2_overlap > ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R2_Reads
awk '{if($3!=-1 && $12>=70 && $13==$14)print}' ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R2_overlap > ${OUTPATH}/${SAMPLE}_C/${motifID_cur}_${SAMPLE}_C_R2_PerfReads
