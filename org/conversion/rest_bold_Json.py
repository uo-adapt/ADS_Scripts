import os
import json
from pprint import pprint

# Change these to your own paths/times/etc.
bidsdir = os.path.join(os.sep, 'projects', 'adapt_lab', 'shared', 'ADS', 'data', 'BIDS_data')

TaskName = 'rest'
RepetitionTime = '1.4'
EchoTime = '0.03'
FlipAngle = '90'
PhaseEncodingDirection = 'j-'
EffectiveEchoSpacing = '0.000349999'

def main():
    subjectdirs = get_subjectdirs()
    for subjectdir in subjectdirs:
        timepoints = get_timepoints(subjectdir)
        for timepoint in timepoints:
            func_dir_path = os.path.join(bidsdir, subjectdir, timepoint, 'func')
            if os.path.isdir(func_dir_path):
                func_niftis_partialpath = get_funcdir_niftis(func_dir_path, timepoint)
                write_to_json(func_niftis_partialpath, TaskName, RepetitionTime, EchoTime, FlipAngle, PhaseEncodingDirection, EffectiveEchoSpacing)
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

def write_to_json(func_niftis_partialpath:list, TaskName:str, RepetitionTime:str, EchoTime:str, FlipAngle:str, PhaseEncodingDirection:str, EffectiveEchoSpacing:str):
    for func_json in func_jsons:
        json_path = os.path.join(func_dir_path, func_json)
        with open(json_path) as target_json:
            json_file = json.load(target_json)
            json_file['TaskName'] = TaskName
            json_file['RepetitionTime'] = RepetitionTime
            json_file['EchoTime'] = EchoTime
            json_file['FlipAngle'] = FlipAngle
            json_file['PhaseEncodingDirection'] = PhaseEncodingDirection
            json_file['EffectiveEchoSpacing'] = EffectiveEchoSpacing
        with open(json_path, 'w') as target_json:
            json.dump(json_file, target_json, indent=4)

main()



