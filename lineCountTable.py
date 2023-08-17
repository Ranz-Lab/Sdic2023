#!/usr/bin/env python3
###Ranz Lab 2022

###Goal: From the list of files and line counts make a table and output as a csv

import pandas as pd

def process_data(infile_path: str, data: dict) -> None:
	#If available, open the line count input file and read the lines
	infile = None
	try:
		with open(infile_path, 'r') as infile:
			
			#Extract the data from each line into a usable list
			for line in infile:
				line = line.strip().split(" ")
				ldata = [line[0]] + line[1].split("_")
				
				#If the strain_tissue_replicate is not in the data dict already add it
				if ldata[2]+"_"+ldata[3]+"_"+ldata[4] not in data.keys():
					data[ldata[2]+"_"+ldata[3]+"_"+ldata[4]] = {}
				
				#Add the gene_readDirection_fileType and line count to the correct dictionary
				data[ldata[2]+"_"+ldata[3]+"_"+ldata[4]][ldata[1]+"_"+ldata[5]+"_"+ldata[6]] = int(ldata[0])
		return None
	finally:
		if infile != None:
			infile.close()





if __name__ == '__main__':
	allData = {}
	process_data("allLineCounts.txt", allData)

	#Convert data dict to pandas dataframe
	out_data = pd.DataFrame.from_dict(allData, orient="columns")
	out_data = out_data.rename_axis("Gene")

	#Write dataframe to a csv file
	out_data.to_csv("CountsTable.csv")
