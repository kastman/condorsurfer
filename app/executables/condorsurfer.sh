#!/usr/bin/env bash
# This is the main script that is run for each node.  All the actual
# action takes place here.  This script is run on the EXECUTE machine
# so care must be take to prepare the environment accordingly


# export NO_FSFAST=1
export SUBJECTS_DIR=$(pwd)/subjects
source $FREESURFER_HOME/SetUpFreeSurfer.sh

uniq=$1
archive_file=${uniq}.tar.gz
# tar -xzvf ${archive_file}
mkdir subjects

echo "FREESURFER_HOME"
echo $FREESURFER_HOME

echo "FUNCTIONALS_DIR"
echo $FUNCTIONALS_DIR

echo "SUBJECTS_DIR"
echo $SUBJECTS_DIR

echo "This is what's here"
ls

# importfile=""
# if (-f I0001.dcm); then
# 	importfile="I0001.dcm"
# elif (ls *.0001 &> /dev/null); then
# 	importfile=$(ls *.0001)
# elif (ls *.nii); then
# 	importfile=$(ls *.nii)
# fi
# 
# echo "Import file:" ${importfile}
# 
# recon-all -i ${importfile} -subjid ${uniq}
recon-all -i ${uniq}.nii -subjid ${uniq}
# recon-all -i ${uniq}/${uniq}.nii -subjid ${uniq}
recon-all -all -subjid ${uniq}

pushd subjects
tar -czvf freesurfer_results.tar.gz ${uniq}
popd
mv subjects/freesurfer_results.tar.gz .

