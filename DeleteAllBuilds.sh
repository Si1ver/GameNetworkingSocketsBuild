#!/bin/bash

# Delete BuildLinux directory if it exists
if [[ -d "BuildLinux" ]]; then
    echo "Deleting BuildLinux directory..."
    rm -rf BuildLinux
else
    echo "BuildLinux directory does not exist."
fi

# Delete BuildAndroid directory if it exists
if [[ -d "BuildAndroid" ]]; then
    echo "Deleting BuildAndroid directory..."
    rm -rf BuildAndroid
else
    echo "BuildAndroid directory does not exist."
fi
