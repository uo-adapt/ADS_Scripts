.. _designfile:

Pipeline design file
====================

A pipeline design file (``.dsn``) defines a processing pipeline that is interpreted by the image
processing system.

The design file contains:

 * A list of the :ref:`modules` that should be executed;
 * The set of parameters that configure each module, as well as their values

Preparing the design file
--------------------------

We strongly recommend you copy and use one of the
`standard design files <https://github.com/PennBBL/xcpEngine/tree/master/designs>`_ that come with
XCP Engine. These are regularly tested and usually work.

Examples
~~~~~~~~~

A `library of preconfigured pipelines <https://github.com/PennBBL/xcpEngine/tree/master/designs>`_
is available for each of the following experiments:

 * Anatomical (``anat``)
 * Functional connectivity (``fc``)
 * Functional connectivity benchmarking (``qcfc``)

Specifications (advanced)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Design variables fall into four main categories:

 * *Analysis variables* are input variables accessible at all stages of the pipeline
 * The *pipeline definition* specifies the modules (stages) of the pipeline that are to be run
 * *Module variables* are input variables accessible at only a single stage of the pipeline, and
   typically configure the behavior of that pipeline stage
 * *Output variables* are produced as the pipeline is run and are accessible at all stages of the
   pipeline
 * A fifth category of variable is not defined in the design file at all. *Subject variables* take
   different values for different subjects. See the :ref:`cohortfile` file
   documentation for more information about this type of variable.

Analysis variables
~~~~~~~~~~~~~~~~~~~~

Each design file includes a set of variables that are accessible at all stages of the pipeline.::

  analysis=accelerator_$(whoami)
  design=${XCPEDIR}/designs/fc-36p.dsn
  sequence=fc-rest
  standard=MNI%1x1x1


Pipeline definitions
~~~~~~~~~~~~~~~~~~~~~

The design file includes the ``pipeline`` variable, which defines the backbone of the pipeline: a
comma-separated sequence of the :ref:`modules` that together comprise the
processing stream.

The standard functional connectivity processing stream is:::

  pipeline=confound,regress,fcon,reho,alff,net,roiquant,seed,norm,qcfc

The standard benchmarking processing stream is an abbreviated version of the FC stream:::

  pipeline=confound,regress,fcon,qcfc

The complete anatomical processing stream is:::

  pipeline=struc,jlf,gmd,cortcon,sulc,roiquant,qcanat


Module configurations
~~~~~~~~~~~~~~~~~~~~~~~

In addition to the overall backbone of the processing stream, the design file includes
specifications for each of its constituent modules. As an illustrative example, the specifications
of the ``regress`` module in a standard functional connectivity stream are provided here:::

  regress_tmpf[3]=butterworth
  regress_hipass[3]=0.01
  regress_lopass[3]=0.08
  regress_tmpf_order[3]=1
  regress_tmpf_pass[3]=2
  regress_tmpf_ripple[3]=0.5
  regress_tmpf_ripple2[3]=20
  regress_dmdt[3]=2
  regress_1ddt[3]=1
  regress_smo[3]=6
  regress_sptf[3]=susan
  regress_usan[3]=default
  regress_usan_space[3]=
  regress_rerun[3]=0
  regress_cleanup[3]=1
  regress_process[3]=DMT-TMP-REG

Each row defines a different parameter for the ``regress`` module (e.g., ``regress_smo`` -- the
smoothing parameter) and assigns it a value (e.g., ``6`` -- 6mm).
When the module is executed, it processes its inputs according to the specifications in the
pipeline design file.

Output variables
~~~~~~~~~~~~~~~~~

Output variables aren't defined in the design file that's provided as an argument at runtime.
Instead, they are defined as the pipeline is run and written to a copy of the design file. Output
variables are typically accessible by all pipeline stages after they are produced. An illustrative
example is provided, again for the ``coreg`` module:::

  # ··· outputs from IMAGE COREGISTRATION MODULE[2] ··· #
  struct2seq_img[9001]=accelerator/9001/coreg/9001_struct2seq.nii.gz
  struct2seq_mat[9001]=accelerator/9001/coreg/9001_struct2seq.mat
  seq2struct[9001]=accelerator/9001/coreg/9001_seq2struct.txt
  seq2struct_img[9001]=accelerator/9001/coreg/9001_seq2struct.nii.gz
  struct2seq[9001]=accelerator/9001/coreg/9001_struct2seq.txt
  seq2struct_mat[9001]=accelerator/9001/coreg/9001_seq2struct.mat
  fit[9001]=0.3
  sourceReference[9001]=accelerator/9001/prestats/9001_meanIntensityBrain.nii.gz
  targetReference[9001]=9001_antsct/ExtractedBrain0N4.nii.gz
  altreg2[9001]=mutualinfo
  altreg1[9001]=corratio

Each row corresponds to an output defined by the ``coreg`` module that can be used by all downstream
modules. For example, ``struct2seq`` defines an affine transformation from the subject's
high-resolution anatomical space to the subject's functional space. This transformation can later
be used to align white matter and CSF masks to the functional image, enabling tissue-based confound
regression.
