# Motif-Counter 
Follow these steps to run the "Motif-Counter" pipeline originally used in Clifton et al 2017 MBE and improved in Clifton et al 2023 CB

Create a directory structure with XXXXXXXX -Testis --00-rawdata --01-preproc ---ISO1_T_A --03-GeneCounter ---ISO1_T_A

    Preprocess raw paired-end RNA-seq reads using HTStream (https://s4hts.github.io/HTStream/)
    Run the MotifCounter script after modifying it for your gene of interest sequences and data paths. Input = preprocessed reads

To obtain reads with =<1 mismatch to the extended motif

    Transfer _overlap files from above into a mismatch directory with matching subdirectories for each sample. Use script CreateSampleSubdirectories.sh to quickly create subdirectories from your sample list
    Run (on slurm) AnalysisJob.sh [Note the two seq_pairwise_alignment*.py scripts need to be in the same directory as your AnalysisJob.sh script, do not modify them]
    Run (./) readAllLines.sh
    Run (./) lineCountTable.py [This will generate a .csv files containing the counts for each gene x sample]

To generate fasta files containing making reads

    Transfer _less1mismatch files (or _PerfReads depending on if you want reads with less and 1 or 0 mismatches to the extended motif, respectively) generated above into a directory containing the three *.alignment.sh scripts
    Run script (./) 1-to_fasta.files.alignment.sh
    Run script (./) 2-run_to_fasta.alignment.sh
