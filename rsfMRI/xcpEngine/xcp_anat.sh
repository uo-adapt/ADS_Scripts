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

echo ${DATA_ROOT} "hello"

singularity run -B ${DATA_ROOT}:${HOME} $SIMG \
   -d ${HOME}/Scripts/rsfMRI/xcpEngine/anat-Minimal_201903162306.dsn \
   -c "${TEMP_COHORT}" \
   -o ${HOME}/data/BIDS_data/derivatives/xcpEngine/data \
   -t 2 \
   -i \$TMPDIR

rm "${TEMP_COHORT}",${ses}
