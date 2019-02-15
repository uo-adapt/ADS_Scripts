.. _task:


``task``
=========

``task`` module performs the General Linear Model (GLM) with FSL. It require a FSL-FEAT task design file
with  event files and full model setup.  The ``task`` module run like FEAT-FMRI analysis and the ouputs is
compatible with other ``xcpEngine`` modules such as ``roiquant``, ``fcon`` and ``norm``.

The :ref:`cohortfile` for the task can include a task design if the subjects' event files are different::

   id0,img,task_design
   sub-01,/path/to/bold1.nii.gz,/path/to/design1.fsf
   sub-02,/path/to/bold2.nii.gz,/path/to/design2.fsf
   sub-04,/path/to/bold4.nii.gz,/path/to/design4.fsf

Users can create a  design file for each subject (or group)   by running one subject in FSL GUI. This is 
a sample of  a template design : https://github.com/PennBBL/xcpEngine/blob/master/utils/template.fsf  for simple 
experiment of `EYES OPEN` versus `EYES CLOSE`
 
The outputs of task module is reorganized  as follow:: 
  - task/fsl   # the fsl feat directory
  - task/model  # the supplied design files and model
  - task/logs # logs and html report
  - task/mc  # motion parameters 
  - task/copes  # cope files depend on the design file and model setup 
  - task/vacopes # varcope files depend on the design file and model setup
  - task/pes # arcope files depend on the design file and model setup
  - task/sigchange # % signal change computed from pes
  - task/stats  # zstats files depend on the design file and model setup
 
 The other outputs are derived directly from the ``FMRIPREP``. The expected outputs include::
    - ``prefix_preprocessed.nii.gz``: Bold signal
    - ``prefix_referenceVolume.nii.gz``: reference volume with skull
    - ``prefix_referenceVolumeBrain.nii.gz``: reference volume without skull
    - ``prefix_segmenation.nii.gz``: segmentation tissues
    - ``prefix_struct.nii.gz``: T1w image
    - ``prefix_mask.nii.gz``: brain mask
    - ``prefix_fmriconf.tsv``: confound regressors from ``FMRIPREP`
    - ``prefix_meanIntensity.nii.gz`` # average volume of the BOLD

All  ``*nii.gz`` are expected to be have the same voxel size as the input but may have their
orientation changed to the FSL standard.

The  outputs also consist of Quality Assesmment between structrual and BOLD images::
    - ``prefix_coregCoverage.txt`` : Coverage index
    - ``prefix_coregCrossCorr.txt`` : Cross correlation
    - ``prefix_coregDice.txt`` : Dice index
    - ``prefix_coregJaccard.txt`` : Jaccard index 
