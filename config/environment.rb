# The name of this application, this should normally be set automagically by the app generator.
APP_NAME = "condorsurfer"

# This directory will contain all the run time action for this application.
# Generally each segment of submission will be in a subdirectory here and 
# when data is submitted all the relavant input files and scripts etc will
# provisioned into each dataset's directory
# i.e. RUNS_DIR/<segment>/<dataset>
# SEGMENTS_DIR = '/Data/vtrak1/analyses/freesurfer/scarcity_proc/segments'
SEGMENTS_DIR = '/Data/condorsurfer'
# Note: SEGMENTS_DIR is a condor run dir, which CANNOT be on NFS. Lousy condor.

# The place from which the input data for this application will be drawn.
# Nothing is ever changed in here, data is always copied out to the run time
# directories.  Use this as your archival place for original data.
# DATA_SOURCES_DIR = '/Data/vtrak1/analyses/freesurfer/tomm40'
DATA_SOURCES_DIR = '/Data/vtrak1/analyses/freesurfer/scarcity_proc/data'
