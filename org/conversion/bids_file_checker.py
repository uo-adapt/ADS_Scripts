# This file will check the structure of the bids directory and make sure that there 
# are the exact files necessary. If there are additional or missing files, this
# will return an error. 

import os
import json
from pprint import pprint
import pathlib
import subprocess
import numpy as np
from datetime import datetime


# Set study info (may need to change for your study)
# These variables are used only in this file for paths. Can omit if wanted.
Group="adapt_lab"
Study="ADS"

# Change these to your own paths/times/etc.
parentdir = os.path.join(os.sep, "projects", Group, "shared", "ADS") # folder that contains bidsdir and codedir
bidsdir = os.path.join(parentdir, "BIDS_data") # where the niftis will be put
codedir = os.path.join(parentdir, "Scripts", "org", "conversion") # Contains subject_list.txt, config file, and dcm2bids_batch.py
logdir = os.path.join(codedir, "logs_checker")
outputlog = os.path.join(logdir, "outputlog_dcmchecker" + datetime.now().strftime("%Y%m%d-%H%M") + ".txt")
errorlog = os.path.join(logdir, "errorlog_dcmchecker" + datetime.now().strftime("%Y%m%d-%H%M") + ".txt")
subject_list = os.path.join(codedir,"subject_list.txt")

scan_type_list = ["anat","func","dwi","fmap"]

anat_files = ["T1w.json","T1w.nii.gz"]
func_files = ["bold.json","bold.nii.gz"]
dwi_files = ["dwi.json","dwi.nii.gz","dwi.bval","dwi.bvec"]
fmap_files = ["magnitude1.json","magnitude1.nii.gz","magnitude2.json","magnitude2.nii.gz","phasediff.json","phasediff.nii.gz"]


def main():
	with open(subject_list) as file:
			lines = file.readlines()  
			for line in lines:
				entry = line.strip()
				subject = entry.split(",")[1]
				subjectpath = os.path.join(bidsdir,"sub-"+subject)
				if os.path.isdir(subjectpath):
					if os.path.isdir(os.path.join(subjectpath,"ses-wave2")):
						wave_2_scan_types = os.listdir(os.path.join(subjectpath,"ses-wave2"))
						if ".DS_Store" in wave_2_scan_types:
							wave_2_scan_types.remove(".DS_Store")
						scan_type_missing_2 = list(set(scan_type_list)-set(wave_2_scan_types))
						for scan_type_missing_2 in scan_type_missing_2:
							write_to_errorlog(scan_type_missing_2 + " is missing for " + subject + ", ses-wave2" + os.linesep)
						for scan_type in wave_2_scan_types:
							if scan_type.startswith("anat"):
								real_anat_list = os.listdir(os.path.join(subjectpath,"ses-wave2","anat"))
								if ".DS_Store" in real_anat_list:
									real_anat_list.remove(".DS_Store")
								check_anat_files = ["sub-" + subject + "_ses-wave2_" + files for files in anat_files]
								anat_missing_list = list(set(check_anat_files)-set(real_anat_list)) 
								for anat_missing in anat_missing_list:
									write_to_errorlog(anat_missing + " is missing for sub-" + subject + ", ses-wave2" + os.linesep)
								anat_extra_list = list(set(real_anat_list)-set(check_anat_files))
								for anat_extra in anat_extra_list:
									write_to_errorlog(anat_extra + " is an unauthorized file in sub-" + subject + ", ses-wave2" + os.linesep)
								del [check_anat_files,anat_missing_list,anat_extra_list]
							elif scan_type.startswith("func"):
								real_func_list = os.listdir(os.path.join(subjectpath,"ses-wave2","func"))
								if ".DS_Store" in real_func_list:
									real_func_list.remove(".DS_Store")
								check_func_files = ["sub-" + subject + "_ses-wave2_task-rest_" + files for files in func_files]
								func_missing_list = list(set(check_func_files)-set(real_func_list)) 
								for func_missing in func_missing_list:
									write_to_errorlog(func_missing + " is missing for sub-" + subject + ", ses-wave2" + os.linesep)
								func_extra_list = list(set(real_func_list)-set(check_func_files))
								for func_extra in func_extra_list:
									write_to_errorlog(func_extra + " is an unauthorized file in sub-" + subject + ", ses-wave2" + os.linesep)
								del [check_func_files,func_missing_list,func_extra_list]
							elif scan_type.startswith("dwi"):
								real_dwi_list = os.listdir(os.path.join(subjectpath,"ses-wave2","dwi"))
								if ".DS_Store" in real_dwi_list:
									real_dwi_list.remove(".DS_Store")
								check_dwi_files = ["sub-" + subject + "_ses-wave2_" + files for files in dwi_files]
								dwi_missing_list = list(set(check_dwi_files)-set(real_dwi_list)) 
								for dwi_missing in dwi_missing_list:
									write_to_errorlog(dwi_missing + " is missing for sub-" + subject + ", ses-wave2" + os.linesep)
								dwi_extra_list = list(set(real_dwi_list)-set(check_dwi_files))
								for dwi_extra in dwi_extra_list:
									write_to_errorlog(dwi_extra + " is an unauthorized file in sub-" + subject + ", ses-wave2" + os.linesep)
								del [check_dwi_files,dwi_missing_list,dwi_extra_list]
							elif scan_type.startswith("fmap"):
								real_fmap_list = os.listdir(os.path.join(subjectpath,"ses-wave2","fmap"))
								if ".DS_Store" in real_fmap_list:
									real_fmap_list.remove(".DS_Store")
								check_fmap_files = ["sub-" + subject + "_ses-wave2_" + files for files in fmap_files]
								fmap_missing_list = list(set(check_fmap_files)-set(real_fmap_list)) 
								for fmap_missing in fmap_missing_list:
									write_to_errorlog(fmap_missing + " is missing for sub-" + subject + ", ses-wave2" + os.linesep)
								fmap_extra_list = list(set(real_fmap_list)-set(check_fmap_files))
								for fmap_extra in fmap_extra_list:
									write_to_errorlog(fmap_extra + " is an unauthorized file in sub-" + subject + ", ses-wave2" + os.linesep)
								del [check_fmap_files,fmap_missing_list,fmap_extra_list]
							else:
								continue
					else: 
						write_to_errorlog(subject + " wave-2 directory does not exist" + os.linesep)
					if os.path.isdir(os.path.join(subjectpath,"ses-wave3")):
						wave_3_scan_types = os.listdir(os.path.join(subjectpath,"ses-wave3"))
						if ".DS_Store" in wave_3_scan_types:
							wave_3_scan_types.remove(".DS_Store")
						scan_type_missing_3 = list(set(scan_type_list)-set(wave_3_scan_types))
						for scan_type_missing_3 in scan_type_missing_3:
							write_to_errorlog(scan_type_missing_3 + " is missing for " + subject + ", ses-wave3" + os.linesep)
						for scan_type in wave_3_scan_types:
							if scan_type.startswith("anat"):
								real_anat_list = os.listdir(os.path.join(subjectpath,"ses-wave3","anat"))
								if ".DS_Store" in real_anat_list:
									real_anat_list.remove(".DS_Store")
								check_anat_files = ["sub-" + subject + "_ses-wave3_" + files for files in anat_files]
								anat_missing_list = list(set(check_anat_files)-set(real_anat_list)) 
								for anat_missing in anat_missing_list:
									write_to_errorlog(anat_missing + " is missing for sub-" + subject + ", ses-wave3" + os.linesep)
								anat_extra_list = list(set(real_anat_list)-set(check_anat_files))
								for anat_extra in anat_extra_list:
									write_to_errorlog(anat_extra + " is an unauthorized file in sub-" + subject + ", ses-wave3" + os.linesep)
								del [check_anat_files,anat_missing_list,anat_extra_list]
							elif scan_type.startswith("func"):
								real_func_list = os.listdir(os.path.join(subjectpath,"ses-wave3","func"))
								if ".DS_Store" in real_func_list:
									real_func_list.remove(".DS_Store")
								check_func_files = ["sub-" + subject + "_ses-wave3_task-rest_" + files for files in func_files]
								func_missing_list = list(set(check_func_files)-set(real_func_list)) 
								for func_missing in func_missing_list:
									write_to_errorlog(func_missing + " is missing for sub-" + subject + ", ses-wave3" + os.linesep)
								func_extra_list = list(set(real_func_list)-set(check_func_files))
								for func_extra in func_extra_list:
									write_to_errorlog(func_extra + " is an unauthorized file in sub-" + subject + ", ses-wave3" + os.linesep)
								del [check_func_files,func_missing_list,func_extra_list]
							elif scan_type.startswith("dwi"):
								real_dwi_list = os.listdir(os.path.join(subjectpath,"ses-wave3","dwi"))
								if ".DS_Store" in real_dwi_list:
									real_dwi_list.remove(".DS_Store")
								check_dwi_files = ["sub-" + subject + "_ses-wave3_" + files for files in dwi_files]
								dwi_missing_list = list(set(check_dwi_files)-set(real_dwi_list)) 
								for dwi_missing in dwi_missing_list:
									write_to_errorlog(dwi_missing + " is missing for sub-" + subject + ", ses-wave3" + os.linesep)
								dwi_extra_list = list(set(real_dwi_list)-set(check_dwi_files))
								for dwi_extra in dwi_extra_list:
									write_to_errorlog(dwi_extra + " is an unauthorized file in sub-" + subject + ", ses-wave3" + os.linesep)
								del [check_dwi_files,dwi_missing_list,dwi_extra_list]
							elif scan_type.startswith("fmap"):
								real_fmap_list = os.listdir(os.path.join(subjectpath,"ses-wave3","fmap"))
								if ".DS_Store" in real_fmap_list:
									real_fmap_list.remove(".DS_Store")
								check_fmap_files = ["sub-" + subject + "_ses-wave3_" + files for files in fmap_files]
								fmap_missing_list = list(set(check_fmap_files)-set(real_fmap_list)) 
								for fmap_missing in fmap_missing_list:
									write_to_errorlog(fmap_missing + " is missing for sub-" + subject + ", ses-wave3" + os.linesep)
								fmap_extra_list = list(set(real_fmap_list)-set(check_fmap_files))
								for fmap_extra in fmap_extra_list:
									write_to_errorlog(fmap_extra + " is an unauthorized file in sub-" + subject + ", ses-wave3" + os.linesep)
								del [check_fmap_files,fmap_missing_list,fmap_extra_list]
							else:
								continue
					else:
						write_to_errorlog(subject + " wave-3 directory does not exist" + os.linesep) 
				else:
					write_to_errorlog(subject + " directory does not exist" + os.linesep)
				continue


def write_to_errorlog(message):
	"""
	Write a log message to the error log. Also print it to the terminal.

	@type message:          string
	@param message:         Message to be printed to the log
	"""
	with open(errorlog, 'a') as logfile:
		logfile.write(message + os.linesep)
	print(message)

main()


