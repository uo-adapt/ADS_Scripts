#!/bin/bash
#SBATCH --partition=long        ### Partition (like a queue in PBS)
#SBATCH --job-name=maTT         ### Job Name
#SBATCH --output=Hi.out         ### File in which to store job output
#SBATCH --error=Hi.err          ### File in which to store job error messages
#SBATCH --time=0-08:01:00       ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --mem-per-cpu=15G
#SBATCH --nodes=1               ### Number of nodes needed for the job
#SBATCH --ntasks-per-node=1     ### Number of tasks to be launched per Node
 
./job_multiAtlasTT.sh                         # run your actual program
