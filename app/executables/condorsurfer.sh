#!/usr/bin/env bash
# This is the main script that is run for each node.  All the actual
# action takes place here.  This script is run on the EXECUTE machine
# so care must be taken to prepare the environment accordingly

freesurfer_home="/data2/grecc/freesurfer5.1.0"
home=$(pwd)
export HOME=$home
export FREESURFER_HOME=$freesurfer_home

# These are usually called by running SetUpFreeSurfer.sh, but there was a
# matlab problem so we're calling them explicitly here for now.
export SUBJECTS_DIR=$home
export FS_OVERRIDE="0"
export PERL5LIB=$freesurfer_home/mni/lib/perl5/5.8.5
export OS="Linux"
export LOCAL_DIR=$freesurfer_home/local
export FSFAST_HOME=$freesurfer_home/fsfast
export MNI_PERL5LIB=$freesurfer_home/mni/lib/perl5/5.8.5
export FMRI_ANALYSIS_DIR=$freesurfer_home/fsfast
export MINC_BIN_DIR=$freesurfer_home/mni/bin
export FUNCTIONALS_DIR=$freesurfer_home/sessions
export MINC_LIB_DIR=$freesurfer_home/mni/lib
export MNI_DIR=$freesurfer_home/mni
export MNI_DATAPATH=$freesurfer_home/mni/data
export PATH=/bin:/usr/bin:${freesurfer_home}/mni/bin:${freesurfer_home}/bin

export NO_FSFAST=1
# export SUBJECTS_DIR=$(pwd)/subjects
# source $FREESURFER_HOME/SetUpFreeSurfer.sh

# Input Arguments
uniq=$1; shift
recon_all_phase=$1; shift
freesurfer_args="$*"

# First, handle known cases of zipped files and unzip them here.
# This is initial inputs, and previous results from earlier phases (1,2).

# Untar/Unzip Input File
if [ -f ${SUBJECTS_DIR}/${uniq}.tar.gz ]; then 
	mkdir ${SUBJECTS_DIR}/${uniq}
	tar -xzvf ${SUBJECTS_DIR}/${uniq}.tar.gz -C ${SUBJECTS_DIR}/${uniq}
	
	# In the case of a single file, mv that file out of the dataset dir
	# (since that should be managed by freesurfer).
	if [ -f ${SUBJECTS_DIR}/${uniq}/${uniq}.nii ]; then 
		mv ${SUBJECTS_DIR}/${uniq}/${uniq}.nii .
		rmdir ${SUBJECTS_DIR}/${uniq} # This will be created by recon-all below.
	fi
fi

# Untar results exist from a previous phase.
archive_file=freesurfer_results.tar.gz
if [ -f $archive_file ]; then tar -xzvf ${archive_file}; fi

echo "FREESURFER_HOME"
echo $FREESURFER_HOME

echo "FUNCTIONALS_DIR"
echo $FUNCTIONALS_DIR

echo "SUBJECTS_DIR"
echo $SUBJECTS_DIR

echo "Here's what's here:"
ls

# Currently, for inputs to phase 1, we can either provide a prepared T1.nii
# file, or a FS subject directory (including edits from earlier runs and
# freesurfer versions... [4.5]). In the case of the NIfTI, we need to initialize
# freesurfer by creating a subject directory with recon-all (without any
# autorecon options).
# 
# Prepare initial files if this is phase 1 Create the FS subject directory if a
# nifti is present.
if [ ${recon_all_phase} -eq 1 ]; then
	if [ -f ${uniq}.nii ]; then
		recon-all -i ${uniq}.nii -subjid ${uniq}
	fi
fi

# Run Autorecon for current phase and capture phase's output.
recon-all -autorecon${recon_all_phase} $freesurfer_args -subjid ${uniq} > phase${recon_all_phase}.out

if [ -f $archive_file ]; then rm $archive_file; fi
tar -czvf $archive_file ${uniq}
