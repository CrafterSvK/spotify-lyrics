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
	#param: $1 - This string will be trimmed from unuseful characters
	local trim1="${1//[[:space:]]/}"
	local trim2="${trim1%\?}"
	local trim3="${trim2//\'}"
	local trim4="${trim3//\/}"
	local trim5="${trim4%%-*}"
	local trim6="${trim5//.}"	
	local trim7="${trim6//\!}"
	local trim8="${trim7//,}"
    local trim11=$trim8

	#trim brackets if they are available
	if [[ $trim8 == *[{}\(\)\[\]]* ]]; then
		local string_brackets="$(echo $trim8 | cut -d "(" -f2 | cut -d ")" -f1)"
		local trim9="${trim8//$string_brackets}"
		local trim10="${trim9//\(}"
		local trim11="${trim10//\)}"
	fi

	local result="${trim11,,}"
	echo $result
}

function trim_the {
	#param: $1 - This string will be trimmed from The
	
    detect=$(echo "${1}" | cut -c1-3)
    if [[ $detect == "the" ]]; then
        local trim="${1//the}"
	    local result=$trim

	    echo $result
    else
        echo ${1}
    fi
}

function detect_override {
    #Overriding songs that are violating the algorithm

    #param: $1 - Passing artist name for override
    #param: $2 - Passing song name for override  

    local file="$(cat $dir/override.txt)"
    local artist_name_search="$(echo $file | grep $1)"
    local song_name_search="$(echo $artist_name_search | grep $2)"
    
    local song="$(echo $song_name_search | cut -d ":" -f2)" 

    local result=$song 
    echo $result
}

function join {
	#param: $1 joins as the first one
	#param: $2 joins to $1
	local result=$1"\ \-\ "$2
	echo $result
}

function get_spotify {
    artist_raw=$(get_info artist)
    artist_with_the=$(trim "$artist_raw")
    artist=$(trim_the "$artist_with_the")

    song_raw=$(get_info song)
    song=$(trim "$song_raw")
}

function get_manual {
    artist_raw=$1
    artist_with_the=$(trim "$artist_raw")
    artist=$(trim_the "$artist_with_the")   

    song_raw=$2
    song=$(trim "$song_raw")
}

rm -rf /tmp/lyrics.*
tmp=$(mktemp -d /tmp/lyrics.XXX)
touch $tmp/lyrics.html

if [[ -z $1 ]]; then
    get_spotify
else
    echo "Artist"
    read -r artist_input
    
    echo "Song name"
    read -r song_input
    get_manual "$artist_input" "$song_input"
fi

artist_escaped=$(escape "$artist_raw")
song_escaped=$(escape "$song_raw")

both_escaped=$(join "$artist_escaped" "$song_escaped")

override=$(detect_override "$artist" "$song")

if [[ -z $override ]]; then
    website="http://www.azlyrics.com/lyrics/"$artist"/"$song".html"
else 
    website="http://www.azlyrics.com/lyrics/"$artist"/"$override".html"
fi

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


