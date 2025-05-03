#!/bin/bash

# Check that Source directory exist
if [[ ! -d "Source" ]]; then
    echo "Source directory does not exist. Please run GetSourceCode.sh before running this script."
    exit 1
fi

# Check that build directory does not exist
if [[ -d "BuildLinux" ]]; then
    echo "BuildLinux directory already exists. Please remove it before running this script."
    exit 1
fi

cmake --preset linux-x64-openssl-release -B BuildLinux -S Source
cmake --build BuildLinux
