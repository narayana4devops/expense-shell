#!/bin/bash

COURSE="DevOps Current script"

echo "Before calling other script, course: $COURSE"
echo "Process ID of current shell script: $$"

chmod +x 05-other_script.sh
./05-other_script.sh

echo "After calling other script, course: $COURSE"
#echo "Process ID of current shell script: $$"
