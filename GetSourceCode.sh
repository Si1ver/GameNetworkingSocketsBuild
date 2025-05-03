#!/bin/bash

# Check that Source directory does not exist
if [[ -d "Source" ]]; then
    echo "Source directory already exists. Please remove it before running this script."
    exit 1
fi

mkdir Source

cd Source

git init
git remote add origin https://github.com/ValveSoftware/GameNetworkingSockets.git
git fetch --depth 1 origin 1e724c3248eefd0f49003ce2843140495e2cb475
git config --local advice.detachedHead false
git checkout FETCH_HEAD
git submodule update --init --depth 1
