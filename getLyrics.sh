#!/bin/bash
# Made by Jakub Janek 2017
# All lyrics are provided by AZLyrics
# COMMERCIAL USE IS PROHIBITED

dir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

#get song information
rm -rf /tmp/lyrics.*
tmp=$(mktemp -d /tmp/lyrics.XXX)
touch $tmp/lyrics.html

artist_raw=$(${dir}/getInfo.sh artist)
song_name_raw=$(${dir}/getInfo.sh song)

#escape song_name and artist
artist_escaped=$(echo $artist_raw | sed -e 's/[^a-zA-Z0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')
song_name_escaped=$(echo $song_name_raw | sed -e 's/[^a-zA-Z0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')
both_escaped=$artist_escaped"\ \-\ "$song_name_escaped

#trimm the name of song and artist to azlyrics format
artist_trim="${artist_raw//[[:space:]]/}"
artist_trim2="${artist_trim//\/}"
artist="${artist_trim2,,}"

#TODO: trim brackets with text inside them
song_name_trim="${song_name_raw//[[:space:]]/}"
song_name_trim2="${song_name_trim%\?}"
song_name_trim3="${song_name_trim2//\'}"
song_name_trim4="${song_name_trim3//\/}"
song_name_trim7=$song_name_trim4

if [[ $song_name_trim4 == *[{}\(\)\[\]]* ]]; then
	song_name_brackets="$(echo $song_name_trim4 | cut -d "(" -f2 | cut -d ")" -f1)"
	song_name_trim5="${song_name_trim4//$song_name_brackets}"
	song_name_trim6="${song_name_trim5//\(}"
	song_name_trim7="${song_name_trim6//\)}"
fi

song_name="${song_name_trim7,,}"

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
