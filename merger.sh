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
mkdir ~/tmp/merger
cd ~/tmp/merger

#download filters
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Hosts/GoodbyeAds.txt
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-YouTube-AdBlock.txt
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-Xiaomi-Extension.txt
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-Spotify-AdBlock.txt
wget https://raw.githubusercontent.com/racuna/customadfilters/master/customAdFilters.txt
wget https://raw.githubusercontent.com/anudeepND/blacklist/master/CoinMiner.txt
wget https://raw.githubusercontent.com/badmojr/1Hosts/master/Lite/hosts.txt

#download exceptions
wget https://raw.githubusercontent.com/racuna/customadfilters/master/whitelist.txt

# Remove whitelist blank lines
sed -r '/^\s*$/d' whitelist.txt > wl2.txt

# Generate master filter list
cat GoodbyeAds* CoinMiner.txt customAdFilters.txt hosts.txt|grep -v -f wl2.txt|grep -v ^#|sort|uniq -i > $THISDIR/GBAplusMine.txt

# delete temporary workspace
rm -rf ~/tmp/merger

# comeback to previous directory
cd $THISDIR

# Add results of the script to the repo
git add GBAplusMine.txt

# Comment of update
git commit -m "Actualizacion de GBAplusMine.txt dia: `date`"

# Generate Adblock syntax
#sed 's/^0\.0\.0\.0 /||/; s/$/.^/' GBAplusMine.txt > adblock_rules.txt
grep "0.0.0.0" GBAplusMine.txt | \
grep -v "::1\|127.0.0.1\|255.255.255.255\|fe80::\|ff00::\|ff02::" | \
sed 's/^0\.0\.0\.0 /||/; s/$/.^/' > adblock_rules.txt
git add adblock_rules.txt
git commit -m "Actualizacion de adblock_rules.txt dia: `date`"

# Update online repo
git push -u origin master


