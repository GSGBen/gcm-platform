#!/bin/bash

# use this in a github actions `run` step to still echo STDOUT, but to also make it
# available in a .OUTPUT variable in subsequent steps. E.g. ${{ step_name.outputs.OUTPUT }}
#
# usage: pipe to this script.
# e.g. `az <stuff> | pipeline/github_output.sh`

set -euo pipefail

# https://stackoverflow.com/questions/19408649/pipe-input-into-a-script
# Check to see if a pipe exists on stdin.
if [ -p /dev/stdin ]; then
    cat | tr '\r' '\n' > temp_output.txt
    # display in this step
    cat temp_output.txt
    # make available to lower steps
    EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
    echo "OUTPUT<<$EOF" >> "$GITHUB_OUTPUT"
    cat temp_output.txt >> "$GITHUB_OUTPUT"
    echo "$EOF" >> "$GITHUB_OUTPUT"T"
fi