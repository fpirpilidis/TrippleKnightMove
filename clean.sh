#!/bin/bash
# Script to clean all DS_Store files

find ./ -name ".DS_Store" -depth -exec rm {} \;
