#!/bin/bash

#SBATCH --job-name=test_job 	#give jobs a name
#SBATCH --account=ec34		#current project that we are on
#SBATCH --nodes=1 		#number of nodes/CPU
#SBATCH --ntasks=1		#how many tasks to run simutanously
#SBATCH --time=3:00:00		#how long the job will go for
#SBATCH --mem=4G		#how much memory

## Set up job environment
set -o errexit 			# Exit script on any error
set -o nounset 		 	# Treat any unset variables as an error

module --quiet purge 		#this resets the module environment, always good to start clean!

#Usually you load a number of modules below
#module load <module name>	#this loads a specific "module" allowing you to run programs installed on the cluster

## DO SOMETHING 

##accept argument
FILENAME=$1
module load BIOS-IN5410/HT-2023

##create a gvcf.list
ls *gvcf.gz > gvcf.list

##force create and remove an empty directory
mkdir -p ${FILENAME}_DB; rm -r ${FILENAME}_DB

##run GATK database import 
gatk GenomicsDBImport -V gvcf.list \
--genomicsdb-workspace-path ${FILENAME}_DB \
--intervals NC_004029.2

##run GATK genotype GVCF 

gatk GenotypeGVCFs -R ../Orosv1mt.fasta \
-V gendb://${FILENAME}_DB -O ${FILENAME}.vcf.gz


## Message that you are done with the job
echo "Finished running "


