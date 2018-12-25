import os
import json
from pprint import pprint

# Change these to your own paths/times/etc.
bidsdir = os.path.join(os.sep, 'projects', 'adapt_lab', 'shared', 'ADS', 'data', 'BIDS_data')

TaskName = 'rest'


def main():
    subjectdirs = get_subjectdirs()
    for subjectdir in subjectdirs:
        timepoints = get_timepoints(subjectdir)
        for timepoint in timepoints:
            func_dir_path = os.path.join(bidsdir, subjectdir, timepoint, 'func')
            if os.path.isdir(func_dir_path):
                func_niftis_partialpath = get_funcdir_niftis(func_dir_path, timepoint)
                func_jsons = get_func_jsons(func_dir_path)
                write_to_json(func_jsons, func_dir_path, TaskName)
            else:
                continue


def get_subjectdirs() -> list:
    """
    Returns subject directory names (not full path) based on the bidsdir (bids_data directory).
    @rtype:  list
    @return: list of bidsdir directories that start with the prefix sub
    """
    bidsdir_contents = os.listdir(bidsdir)
    has_sub_prefix = [subdir for subdir in bidsdir_contents if subdir.startswith('sub-')]
    subjectdirs = [subdir for subdir in has_sub_prefix if os.path.isdir(os.path.join(bidsdir, subdir))]
    subjectdirs.sort()
    return subjectdirs


def get_timepoints(subject: str) -> list:
    """
    Returns a list of ses-wave directory names in a participant's directory.
    @type subject:  string
    @param subject: subject folder name
    @rtype:  list
    @return: list of ses-wave folders in the subject directory
    """
    subject_fullpath = os.path.join(bidsdir, subject)
    subjectdir_contents = os.listdir(subject_fullpath)
    return [f for f in subjectdir_contents if not f.startswith('.')]


def get_funcdir_niftis(func_dir_path:str, timepoint:str) -> list:
    """
    Returns a list of json files in the func directory.
    """
    func_niftis_partialpath = [os.path.join(timepoint, 'func/', f) for f in os.listdir(func_dir_path) if f.endswith('.nii.gz')]
    return func_niftis_partialpath

def get_func_jsons(func_dir_path):
    func_jsons = [f for f in os.listdir(func_dir_path) if f.endswith('.json')]
    return func_jsons

def write_to_json(func_jsons:list, func_dir_path:str,TaskName:str):
    for func_json in func_jsons:
        json_path = os.path.join(func_dir_path, func_json)
        with open(json_path) as target_json:
            json_file = json.load(target_json)
            json_file['TaskName'] = TaskName
        with open(json_path, 'w') as target_json:
            json.dump(json_file, target_json, indent=4)

main()



