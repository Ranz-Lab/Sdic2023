#!/bin/bash

#This script makes a subdirectory for each sample in a given <SAMPLE LIST>.txt file within a directory given by outpath

start=`date +%s`
echo $HOSTNAME

outpath="" #PATH TO THE DIRECTORIES WHERE YOU WANT THE SUBDIRECTORIES CREATED


file=$(cat <SAMPLE LIST>.txt) # !!CHANGE <SAMPLE LIST> TO THE NAME OF YOUR FILE WITH ALL YOUR SAMPLES LISTED!!

for line in $file
do
   mkdir $outpath/$line
done


