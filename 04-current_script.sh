#!/bin/bash

COURSE="DevOps Current script"
A=10

echo "Before calling other script, course: $COURSE"
echo "Before calling other script, A: $A"
echo "Process ID of current shell script: $$"

chmod +x 05-other_script.sh
./05-other_script.sh
chmod -x 05-other_script.sh

echo "After calling other script, course: $COURSE"
echo "After calling other script, A: $A"
#echo "Process ID of current shell script: $$"
