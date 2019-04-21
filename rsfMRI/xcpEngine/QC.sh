#!/bin/bash
#
XCPEDIR=/projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine
outputdir=/projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/xcpEngine/data

${XCPEDIR}/utils/combineOutput \
	-p $outputdir \
	-f "ses-*quality.csv" \
	-o XCP_QAVARS.csv

