#!/bin/bash

mkdir Build
mkdir Source

cd Source

git init
git remote add origin https://github.com/ValveSoftware/GameNetworkingSockets.git
git fetch --depth 1 origin 1e724c3248eefd0f49003ce2843140495e2cb475
git config --local advice.detachedHead false
git checkout FETCH_HEAD
git submodule update --init --depth 1
