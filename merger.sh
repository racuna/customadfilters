#!/bin/bash

# This script just merge everything I need from GBA, plus my own filters and merge them eliminating duplicates

# v.1.0 added whitelist support
# v.1.2 remove blank lines of the whitelist + comments to the entire script

# update local repo
git pull

#delete old filter list
rm GBAplusMine.txt

# remember where I am
THISDIR=`pwd`


#create temorary workspace
mkdir /tmp/merger
cd /tmp/merger

#download filters
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Hosts/GoodbyeAds.txt
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-YouTube-AdBlock.txt
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-Xiaomi-Extension.txt
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-Spotify-AdBlock.txt
wget https://raw.githubusercontent.com/racuna/customadfilters/master/customAdFilters.txt

#download exceptions
wget https://raw.githubusercontent.com/racuna/customadfilters/master/whitelist.txt

# Remove whitelist blank lines
sed -r '/^\s*$/d' whitelist.txt > wl2.txt

# Generate master filter list
cat GoodbyeAds* customAdFilters.txt |grep -v -f whitelist.txt|grep -v ^#|sort|uniq> $THISDIR/GBAplusMine.txt

# delete temporary workspace
rm -rf /tmp/merger

# comeback to previous directory
cd $THISDIR

# Add results of the script to the repo
git add GBAplusMine.txt

# Comment of update
git commit -m "Actualizacion de GBAplusMine.txt dia: `date`"

# Update online repo
git push -u origin master


