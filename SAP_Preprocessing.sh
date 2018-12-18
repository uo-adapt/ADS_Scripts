# Copy the ADS files from the shared folder to your own folder on talapas

cp -r /projects/adapt_lab/shared/ADS_dicoms_subset/TALAPAS/Time* /projects/adapt_lab/pettitta/SAP/

# Rename Time_2 and Time_3 to wave_1 and wave_2 for the sake of formatting

mv /projects/adapt_lab/pettitta/SAP/Time_2 /projects/adapt_lab/pettitta/SAP/wave2
mv /projects/adapt_lab/pettitta/SAP/Time_3 /projects/adapt_lab/pettitta/SAP/wave2

# Move all the DICOMS from their subdirectories (they are quite nested) up so that they are just in the diretory with their ID, then delete the subdirectories 
# (must be in the parent directory with all the waves)

for d in */ ; do
    cd "$d"
    for d in */ ; do
    	cd "$d"
    	find . -mindepth 2 -type f -exec mv -f -- {} . \;
    	find . -depth -mindepth 1 -type d -empty -exec rmdir {} \;
    	cd ..
	done
    cd ..
done

# append the name of the dicom folders with their parent wave folders and then moves them up to the parent directory

for directory in *; do
  cd "$directory";
  for foldername in *; do
    mv "$foldername" ../"$foldername-$directory";
  done;
  cd ..;
done

# remove wave-1 and wave-2 directories

find . -depth -mindepth 1 -type d -empty -exec rmdir {} \;

# Reconfigure the files in dcm2bids in order for dcm2bids_helper to run on talapas

# Run the test subject for dcm2bids_helper

ls >> pre_subject_list.txt

cat pre_subject_list.txt | while read line
do
   base=$(echo $line)
   echo $base",ADS"${base::-7}",wave"${base: -1}
done >> subject_list.txt

# move subject_list.txt to Scripts folder

module load python3

python3 dcm2bids_helper.py

# Then check the new tmp_dcm2bids folder one directory up to make sure that all your files are there

# Configure all the other files so that dcm2bids_batch will run

module load python3 # If you skipped the previous step and didn't load it previously

python3 dcm2bids_batch.py

# Check to make sure that all of the files were correctly sorted in /data/BIDS_data/[ID]. 

# Next we need to get things ready to run freesurfer on all of the data. 
# The three files we will need are batch_reconall.sh, job_reconall.sh, SetUpFreeSurfer.sh. These will need to be configured specifically to the study
# These three files can be found here: https://github.com/dsnlab/TAG_scripts/tree/master/sMRI
# Create a new folder in the scripts for sMRI then create a new subfolder for output in there

mkdir /projects/adapt_lab/pettitta/SAP/Scripts/sMRI
mkdir /projects/adapt_lab/pettitta/SAP/Scripts/sMRI/output

# Create a folder for the output of the freesurfer program

mkdir /projects/adapt_lab/pettitta/SAP/data/BIDS_data/derivatives/freesurfer

# Put those three mentioned files in the sMRI folder just created

# Next, create a text file with the subject names. These should be the file names for each subject found under 
# /data/BIDS_data/ (e.g., sub-ADS110).

ls >> subject_list.txt


# don't forget to go into the new subject list and remove the last line


vi subject_list.txt 

i 

# make the changes you need, hit escape and then type this and hit enter:

:wq

# Next you'll need to run the bash_reconall.sh script in order to run freesurfer (this will take a long time)

mv subject_list.txt ../../Scripts/sMRI/

cd /projects/adapt_lab/pettitta/SAP/Scripts/sMRI
bash batch_reconall.sh














