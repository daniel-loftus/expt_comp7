#!/bin/bash
#SBATCH -n 1 # Number of cores
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 0-03:00 # Runtime in D-HH:MM
#SBATCH -p whipple # Partition to submit to
#SBATCH --mem=16G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o %x%j.out # File to which STDOUT will be written
#SBATCH -e %x%j.err # File to which STDERR will be written
#SBATCH --mail-type=ALL
#SBATCH --mail-user="danielloftus@g.harvard.edu"


#This script will copy all cells of a given type (as determined by Table S4 from Tan et al., 2020) into its own directory 

IFS=$'\n' #for loops sep by all whitespace by default, including spaces. I only want new lines. 

for type in $(cut -f9 cell_info.txt | sort | uniq) ; do 

	#make a temp txt file that contains only cells of the type of interest 
	awk -v var="$type" 'BEGIN{FS="\t"} { if($9 == var) print}' cell_info.txt > cell_info_${type}.temp 

	rm -r $type 
	mkdir $type 
	
	#cp cells of a given type to a directory with that type name 
	for cell in $(cut -f1 cell_info_${type}.temp) ; do 
		
		cp $(ls | grep $cell) $type 

	done 
	
	#rm cell_info_${type}.temp 
	
done 