#!/bin/bash

# Check that Source directory exist
if [[ ! -d "Source" ]]; then
    echo "Source directory does not exist. Please run GetSourceCode.sh before running this script."
    exit 1
fi

cd Source

git apply --whitespace=nowarn ../Patches/1.4.1/Patch001.patch
git apply --whitespace=nowarn ../Patches/1.4.1/Patch002.patch
git apply --whitespace=nowarn ../Patches/1.4.1/Patch003.patch
git apply --whitespace=nowarn ../Patches/1.4.1/Patch004.patch
git apply --whitespace=nowarn ../Patches/1.4.1/Patch005.patch
git apply --whitespace=nowarn ../Patches/1.4.1/Patch006.patch
git apply --whitespace=nowarn ../Patches/1.4.1/Patch007.patch
git apply --whitespace=nowarn ../Patches/1.4.1/Patch008.patch
git apply --whitespace=nowarn ../Patches/1.4.1/Patch009.patch
