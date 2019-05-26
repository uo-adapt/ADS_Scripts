# This script wil take a list from an fmriprep directory
# and will remove duplicates
import os

# Set study info (may need to change for your study)
# These variables are used only in this file for paths. Can omit if wanted.
group = "adapt_lab"
study = "ADS"
PI = "Allen"
scriptsFolder = "Scripts"

# The following variables are used in the main script and need to be defined here. 
# They need to exist prior to running the script

# Directories
parentdir = os.path.join(os.sep, "projects", group, "shared", study) # folder that contains bidsdir and codedir
fmiprepdir = os.path.join(parentdir, "data", "BIDS_data", "derivatives", "fmriprep")
codedir = os.path.join(parentdir, scriptsFolder, "rsfMRI") # Contains subject_list.txt, config file, and dcm2bids_batch.py

subjectdir_contents = os.listdir(fmiprepdir)
subjectdir_contents.sort()

html_list = [html[:-5] for html in subjectdir_contents if '.html' in html]
subjectdir_contents = [html for html in subjectdir_contents if '.html' not in html and 'sub' in html]

subjectdir_contents = list(set(subjectdir_contents) - set(html_list))

subjectdir_contents.sort()

with open(os.path.join(codedir,"subject_list.txt"), mode="w") as outfile:  # also, tried mode="rb"
    for subject in subjectdir_contents:
        outfile.write("%s\n" % subject)




