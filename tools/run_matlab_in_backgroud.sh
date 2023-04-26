#!/bin/bash

file_name=$1
pathdef=$2

if [ "$file_name" = "" ] || [ ! -f $file_name ]; then
    echo "Cannot find input file!"
    exit 1
fi
echo "Running MATLAB file '$file_name'"

#run_name=${file_name:0:(-2)}
run_dir=$(dirname $file_name)
run_name=$(basename $file_name .m)

if [ "$pathdef" != "" ] && [ -f $pathdef ]; then
    echo "Using PATH defined in '$pathdef'"
    cp $pathdef $run_dir/pathdef.m
fi

cd $run_dir
mkdir -p log
run_log=./log/$run_name.run.log
err_log=./log/$run_name.err.log

nohup matlab -batch $run_name 1>$run_log 2>$err_log &

if [ "$pathdef" != "" ] && [ -f $pathdef ]; then
    echo "Waiting for MATLAB to start up......"
    sleep 10
    rm -f ./pathdef.m
fi

