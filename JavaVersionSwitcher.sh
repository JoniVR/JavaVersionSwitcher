#!/bin/bash

# MIT License
#
# Copyright (c) 2018 Joni Van Roost
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

if [ `id -u` -ne 0 ]
then
    echo "Permission denied. Please start with sudo."
    exit 1
fi

echo "Your current Java version: "
Java --version
echo "------------------------------------------------------"

echo "Select a Java version you want to use:"

# Collect the folders in the array $folders
folders=( /Library/Java/JavaVirtualMachines/* )

# Enable extended globbing. This lets us use @(foo|bar) to
# match either 'foo' or 'bar'.
shopt -s extglob

# Start building the string to match against.
string="@(${folders[0]}"

# Add the rest of the folders to the string
for((i=1;i<${#folders[@]};i++))
do
    string+="|${folders[$i]}"
done

# Close the parenthesis. $string is now @(folder1|folder2|...|folderN)
string+=")"

# Show the menu. This will list all folders and the string "quit"
select selected_java_version in "${folders[@]}" "quit"
do
    case $selected_java_version in
    # If the choice is one of the folders (if it matches $string)
    $string)
        echo "Setting Java version from \"$selected_java_version\" as current version."
        
        # Loop through java versions again
        for java_version in ${folders[@]}
        do
            # If there's no info.plist or info.plist.disabled file, notify the user.
            if [ ! -f "$java_version/Contents/Info.plist" ] &&
               [ ! -f "$java_version/Contents/Info.plist.disabled" ]
            then 
                echo "No Info.plist or Info.plist.disabled file found for $java_version. \n Please check this installation."
                break
            fi 

            # When a java version does not match the selected version
            # if there is an Info.plist file, rename -> Info.plist.disabled
            if [ "$java_version" != "$selected_java_version" ] && 
               [ -f "$java_version/Contents/Info.plist" ]
            then
                `mv $java_version/Contents/Info.plist $java_version/Contents/Info.plist.disabled`
            
            # When a java version matches the selected version
            # if there is no Info.plist file but there is an Info.plist.disabled, rename -> Info.plist
            elif [ "$java_version" == "$selected_java_version" ] && 
                 [ ! -f "$selected_java_version/Contents/Info.plist" ] &&
                 [ -f "$selected_java_version/Contents/Info.plist.disabled" ]
            then 
                 `mv $java_version/Contents/Info.plist.disabled $java_version/Contents/Info.plist`
            fi
        done 

        break;
        ;;

    "quit")
        # Exit
        exit;;
    *)
        selected_java_version=""
        echo "Please choose a number from 1 to $((${#folders[@]}+1))";;
    esac
done

echo "Done!"
echo "------------------------------------------------------"
echo "Your new Java version: "
Java --version

exit 0
