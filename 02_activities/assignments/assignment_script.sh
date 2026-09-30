#!/bin/bash
set -x
set -e

############################################
# DSI CONSULTING INC. Project setup script #
############################################
# This script creates standard analysis and output directories
# for a new project. It also creates a README file with the
# project name and a brief description of the project.
# Then it unzips the raw data provided by the client.

if [ -d newproject ]; then
  echo "Recreating the newproject directory"
  rm -rf newproject
fi
mkdir newproject
cd newproject

mkdir analysis output
touch README.md
echo "# Project Name: DSI Consulting Inc." > README.md
touch analysis/main.py

# download client data
curl -Lo rawdata.zip https://github.com/UofT-DSI/shell/raw/refs/heads/main/02_activities/assignments/rawdata.zip
unzip -q rawdata.zip

###########################################
# Complete assignment here

# 1. Create a directory named data
mkdir data
ls
ls -ld data

# 2. Move the ./rawdata directory to ./data/raw (eg. move it into ./data and rename it to raw)
mv ./rawdata ./data/raw && find ./data -maxdepth 2 -type f -print | sort | head -10 && printf 'Files moved: ' && find ./data/raw -type f | wc -l

# 3. List the contents of the ./data/raw directory
ls ./data/raw

# 4. Create the directory ./data/processed, 
#    then create the following sub-directories within it: server_logs, user_logs, and event_logs
mkdir -p ./data/processed/server_logs ./data/processed/user_logs ./data/processed/event_logs && find ./data/processed -type d -print | sort

# 5. Copy all server log files (files with "server" in the name AND a .log extension) from ./data/raw to ./data/processed/server_logs
find ./data/raw -maxdepth 1 -type f -name '*server*.log' -exec cp {} ./data/processed/server_logs/ \; && printf 'Copied server logs: ' && find ./data/processed/server_logs -maxdepth 1 -type f -name '*server*.log' | wc -l

# 6. Repeat the above step for user logs and event logs
cp ./data/raw/*user*.log ./data/processed/user_logs/

cp ./data/raw/*event*.log ./data/processed/event_logs/

# 7. For user privacy, remove all files containing IP addresses (files with "ipaddr" in the filename) from ./data/raw and ./data/processed/user_logs
find ./data/raw ./data/processed/user_logs -type f -name '*ipaddr*' -delete

# 8. Create a file named ./data/inventory.txt that lists all the files in the subfolders of ./data/processed
find ./data/processed -mindepth 2 -type f -print | sort > ./data/inventory.txt

printf 'Inventory entries: ' && wc -l < ./data/inventory.txt && printf 'Processed files: ' && find ./data/processed -mindepth 2 -type f | wc -l && diff -u <(find ./data/processed -mindepth 2 -type f -print | sort) ./data/inventory.txt

###########################################

echo "Project setup is complete!"