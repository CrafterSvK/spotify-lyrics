#!/bin/bash

dir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

function get_info {
	#param: $1 - Sets which metadata should be given
	if [[ -z $1 ]]; then
		local result="NULL"
		echo "$result"
	elif [[ $1 == "song" ]]; then
		local result=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk -f ${dir}/spotify_song.awk | tail -n1 | cut -d':' -f2)
		echo "$result"
	elif [[ $1 == "artist" ]]; then
		local result=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk -f ${dir}/spotify_song.awk | head -n 1 | cut -d':' -f2)
		echo "$result"
	fi
}

function escape {
	#param: $1 - This string will be escaped
	if [[ -z $1 ]]; then
		echo "NULL"
	else
		local first=$(echo $1 | sed -e 's/[^a-zA-Z0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')
		local result=${first%%-*}
		echo $result
	fi
}

function trim {
	#param: $1 - This string will be trimmed from unusefull characters
	local trim1="${1//[[:space:]]/}"
	local trim2="${trim1%\?}"
	local trim3="${trim2//\'}"
	local trim4="${trim3//\/}"
	local trim5="${trim4%%-*}"
	local trim8=$trim5

	#trim brackets if they are available
	if [[ $trim4 == *[{}\(\)\[\]]* ]]; then
		local string_brackets="$(echo $trim5 | cut -d "(" -f2 | cut -d ")" -f1)"
		local trim6="${trim5//$string_brackets}"
		local trim7="${trim6//\(}"
		local trim8="${trim7//\)}"
	fi

	local result="${trim8,,}"
	echo $result
}

function join {
	#param: $1 joins as the first one
	#param: $2 joins to $1
	local result=$1"\ \-\ "$2
	echo $result
}

rm -rf /tmp/lyrics.*
tmp=$(mktemp -d /tmp/lyrics.XXX)
touch $tmp/lyrics.html

artist_raw=$(get_info artist)
artist=$(trim "$artist_raw")

song_raw=$(get_info song)
song=$(trim "$song_raw")

artist_escaped=$(escape "$artist_raw")
song_escaped=$(escape "$song_raw")

both_escaped=$(join "$artist_escaped" "$song_escaped")

website="http://www.azlyrics.com/lyrics/"$artist"/"$song".html"

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


