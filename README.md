# Motif-Counter 
Follow these steps to run the "Motif-Counter" pipeline used in Clifton et al 2023 Communications Biology (modified from Clifton et al 2017 Molecular Biology and Evolution)

Before starting:
    
    1. Create a .txt file with a list of your sample IDs
    2. Create a directory containing subdirectories for each of your samples. You can use script CreateSampleSubdirectories.sh to quickly create subdirectories from your sample list.

To run Motif-Counter and obtain reads with perfect matches to the extended motif:

    1. Preprocess raw paired-end RNA-seq reads using HTStream (https://s4hts.github.io/HTStream/)
    2. Run the MotifCounter script after modifying it for your gene of interest sequences and data paths. [Input = preprocessed reads]

To obtain reads with =<1 mismatch to the extended motif:

    1. Transfer _overlap files from above into a mismatch directory with matching subdirectories for each sample. You can use script CreateSampleSubdirectories.sh to quickly create subdirectories from your sample list.
    2. Run (on slurm) AnalysisJob.sh [Note the seq_pairwise_alignment.py script needs to be in the same directory as your AnalysisJob.slurm script, do not modify the .py script]
    3. Run (./) readAllLines.sh
    4. Run (./) lineCountTable.py [This will generate a .csv files containing the counts for each gene x sample]

To generate fasta files containing matching reads:

    1. Transfer _less1mismatch files (or _PerfReads depending on if you want reads with less and 1 or 0 mismatches to the extended motif, respectively) generated above into a directory containing the three *.alignment.sh scripts
    2. Run script (./) 1-to_fasta.files.alignment.sh
    3. Run script (./) 2-run_to_fasta.alignment.sh
