# First steps

Load all of the dicom files you wish to convert and quality check into the "./data/dicoms" folder.

# Steps for bids helper

1) open "config_dcm2bids_helper.py" in the scripts folder and change the repo path to whatever the parent directory is that contains the data and the scripts (line 14)

2) Change the test_subject to whatever test subject you want to use, using their dicom folder name so that it can be recognized.

3) save the file

4) Using the terminal, cd into the directory that contains the script you just saved, then cd into the scripts folder.

5) type "python3 dcm2bids_helper.py" into the terminal without quotes. This should create a new folder: "./data/BIDS_data/tmp_dcm2bids" within this folder, you'll see a "helper" folder. Within that there will be a new set of nifty files and json files, one for each scan your participant ran (e.g., rsMRI, MPRAGE, dMRI).


# Steps for bids batch

1a) Make sure to open "subject_list.txt" and in the first column put all of the participants you want to convert data for. The specific participant identifier you will be using in this column is their dicom folder name, so make sure to use that and not just their particpant ID number (if they differ). Additionally, If, for instance, you want to exclude a participants data from this process, simply omit their participant number, and they will be excluded. 

1b) For the second column, put whatever you want to come after "sub-". For instance, if you want the new data to look like "sub-001", you would put "001" (without quotes) in the first row of the second column, and so on. 

1c) If you find that you have multiple waves of data, the third column can be used to differentiate waves of data. For example, putting "wave1" will dilineate that this scan should be from wave 1. 

1d) Save the file and close it once you've filled out all the rows and columns

2) Open "config_dcm2bids_batch.py" in the scripts folder and change the repo path to whatever the directory is that contains the data and the scripts (line 22). 

3) Save the file

4) [Change the study_config.json file if you want to have different types of data]

5) Using the terminal, cd into the directory that contains the script you just saved.

6) type "python3 dcm2bids_batch.py" into the terminal without quotes. This should create new data folders within the "./data/BIDS_data" folder for each participant. Within each participant, you should see which wave the data is, followed by the type of acquisition (e.g., func), and then finally the nifty files themselves with accompanying .json files. 


# Steps for using BIDSQC

1) Make sure docker is running and you have the memory allocation set to maximum, or this will (probably) not work (go to preferences>Advanced and slide the "Memory" bar to maximum).

2) Make sure that there is a "derivatives" folder within the BIDS_data folder.

3) Open "run_mriqc.sh" in the Scripts folder. Change repodir to whatever your parent directory is that contains the data and scripts (line 5).

4) Using the terminal, cd into the directory that contains the script you just saved.

5) type "sh run_mriqc.sh" into the terminal, without quotes. This process will take a long time, and will use up a significant chunk of memory.

6) This create 3 folders in the "data/BIDS_data/derivatives" folder, titled "derivatives", "logs", and "reports". Additionally, it will provide a .csv file with (what I'm assuming is) useful data. The derivatives folder will house .json files for each participant. The "reports" folder will house a .html file for each participant AND a group statistics .html file.

7) Within the subject .html file, you will be able to visualize BOLD averages across slices, look at standard deviation maps across slices, and finally look at different measurements of movement within the time-series data. (note, this is specifically written for reports with ONLY resting state data. Your mileage may vary.)