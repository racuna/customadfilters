#!/bin/bash

# This script just merge everything I need from GBA, plus my own filters and merge them eliminating duplicates

# v.0.2 added Spotify url filters

git pull

rm GBAplusMine.txt
THISDIR=`pwd`



mkdir /tmp/merger
cd /tmp/merger

wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Hosts/GoodbyeAds.txt
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-YouTube-AdBlock.txt
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-Xiaomi-Extension.txt
wget https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-Spotify-AdBlock.txt
wget https://raw.githubusercontent.com/racuna/customadfilters/master/customAdFilters.txt
wget https://raw.githubusercontent.com/racuna/customadfilters/master/whitelist.txt

cat GoodbyeAds* customAdFilters.txt |grep -v `cat whitelist.txt`|grep -v ^#|sort|uniq> $THISDIR/GBAplusMine.txt

rm -rf /tmp/merger

cd $THISDIR

git add GBAplusMine.txt

git commit -m "Actualizacion de GBAplusMine.txt dia: `date`"

git push -u origin master


