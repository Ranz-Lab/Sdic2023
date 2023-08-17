# Sdic2023
Scripts used in the 2023 Sdic paper (Clifton et al 2023)

Motif-Counter , originally used in Clifton et al 2017 and improved in Clifton et al 2023

These are the steps for running the Motif-Counter Pipeline.

1. Process raw paired-end RNA-seq reads using HTStream (https://s4hts.github.io/HTStream/)
2. Run the MotifCounter script after adjusting for your gene of interest sequences and data paths. !Note the two seq_pairwise_alignment*.py scripts need to be in the same directory as your MotifCounter script, do not modify them!
3. Analysis?
4. readAllLines.sh
5. lineCountTable.py
