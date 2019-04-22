#!/bin/bash
#

module load singularity
module load afni
module load ants
module load fsl
module load c3d
module load R
module load python3

cd /projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine

XCPEDIR=/projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine
SIMG=/projects/adapt_lab/shared/containers/xcpEngine.simg
HOME=/projects/adapt_lab/shared/ADS


bash xcpEngine -d /projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine/fc-ICA-AROMA_201903131537.dsn \
	-c "${TEMP_COHORT}",${ses} \
	-o /projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/xcpEngine/data \
	-t 2 \
	-r /projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine \
	-i \$TMPDIR
