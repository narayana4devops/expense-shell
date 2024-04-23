#!/bin/bash

COURSE="DevOps Current script"

echo "Before calling other script, course: $COURSE"
echo "Process ID of current shell script: $$"

./05-other_script.sh

echo "After calling other script, course: $COURSE"
#echo "Process ID of current shell script: $$"
