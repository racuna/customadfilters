# Custo Ad Filters
This are just some host filter to block some ads and other web annoyances that GBA (Good Bye Ads) doesn't already block.

How to use it:

## DNS66

Hosts -> Plus button -> add this url -> Refresh and Start

https://raw.githubusercontent.com/racuna/customadfilters/master/customAdFilters.txt

## BETA: GBA and mine Merged

GBA Already have the "Steven Black", "Adaway", "Dan Pollock", "MalwareDomain List", "Peter Lowe" and even more host lists (check their sources). So you can disable every other list on DNS66 (the same with PersonalDNSFilter and maybe Blokada too) and add this instead:

I'm merging the main GBA hosts list with their Xiaomi, Youtube and Spotify lists, then I add my own list, and then I clean the duplicates to generate this list.

Using the script merger.sh this file is generated daily:

https://raw.githubusercontent.com/racuna/customadfilters/master/GBAplusMine.txt

If you want to say thanks or show support, go to: https://github.com/jerryn70/GoodbyeAds
they do the real work here.

### TODO:

- [x] Clean headers and commented lines to make it lighter 
