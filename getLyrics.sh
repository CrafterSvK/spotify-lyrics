#!/bin/bash
# Made by Jakub Janek 2017
# All lyrics are provided by AZLyrics
# COMMERCIAL USE IS PROHIBITED

#get song information
tmp=$(mktemp -d /tmp/lyrics.XXX)
touch $tmp/lyrics.html

artist_raw=$(./getInfo.sh artist)
song_name_raw=$(./getInfo.sh song)

#escape song_name and artist
artist_escaped=$(echo $artist_raw | sed -e 's/[^a-zA-Z0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')
song_name_escaped=$(echo $song_name_raw | sed -e 's/[^a-zA-Z0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')
both_escaped=$artist_escaped"\ \-\ "$song_name_escaped

#trimm the name of song and artist to azlyrics format
artist_trimm="${artist_raw//[[:space:]]/}"
artist="${artist_trimm,,}"

#TODO: trim brackets with text inside them
song_name_trim="${song_name_raw//[[:space:]]/}"
song_name_trim2="${song_name_trim%\?}"
song_name_trim3="${song_name_trim2//\'}"
song_name="${song_name_trim3,,}"

#make url
website="http://www.azlyrics.com/lyrics/"$artist"/"$song_name".html"

#get html file
wget -q --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" -O $tmp/lyrics.html $website

#remove unwanted things
lyrics=$(sed -n "/<div>/,/<\/div>/p" $tmp/lyrics.html)
echo $lyrics > $tmp/lyrics.html

#insert title at the top
sed -i '1s/^/<h1>'"$both_escaped"'<\/h1>\n/' $tmp/lyrics.html

#center all text
sed -i '1s/^/<center>\n/' $tmp/lyrics.html
echo "</center>" >> $tmp/lyrics.html

#show the lyrics
w3m $tmp/lyrics.html
#always quit with q and y
rm -rf $tmp
