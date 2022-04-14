# racuna's Custom Ad Filters
This are just some host filter to block some ads and other web annoyances that GBA (Good Bye Ads) doesn't already block.

How to use it:

## Blokada

Blacklists -> plus button -> add the url, name it (e.g RacunasCustomFilter) -> refresh filters

## DNS66

Hosts -> Plus button -> add the url, name it (e.g RacunasCustomFilter) -> Refresh and Start

## PersonalDNSFilter

(my current personal favorite)

Advanced Settings -> Configure filter update -> add the url, name it (e.g RacunasCustomFilter) -> enable it


## The URL

https://raw.githubusercontent.com/racuna/customadfilters/master/customAdFilters.txt

## BETA: GBA and mine Merged

GBA Already have the "Steven Black", "Adaway", "Dan Pollock", "MalwareDomain List", "Peter Lowe" and even more host lists (check their sources). So you can disable every other list on DNS66 (the same with PersonalDNSFilter and maybe Blokada too) and add this instead:

I'm merging the main GBA hosts list with their Xiaomi, Youtube and Spotify lists, then I add my own list, and then I clean the duplicates to generate this list.

Using the script merger.sh this file is generated daily:

https://raw.githubusercontent.com/racuna/customadfilters/master/GBAplusMine.txt

If you want to say thanks or show support, go to: https://github.com/jerryn70/GoodbyeAds
they do the real work here.

- 2022-04-13, I also added 1hosts Lite filters

### TO-DO:

- [x] Clean headers and commented lines to make it lighter 
- [x] Unfuck a problem with apps using Google Maps internally. Fixed implementing a whitelist.
- [x] Whitelist can't have blank lines
