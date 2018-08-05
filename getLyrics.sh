#!/bin/bash
dir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

key='BQBalmmv_2oc8cvOxwt8hIUkxxCCXoUgk-GH80C941QfNA63PrJMbp4SgdsHfH8Z7g23t73Cp_UFlYwVO2PesP-Q4s1qgUH8Wr0Wv64vlYx9Woex7fbO5oL6gnw702qPDyq45ypnw_R_DXQCPl54EY4'

function getInfo {
    local endpoint=$(curl -s -X "GET" "https://api.spotify.com/v1/me/player/currently-playing?market=SK" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $key")

    echo $endpoint
}

function adjust {
	local pre_result="$(echo $1 | sed -r -e 's/[^A-Za-z()]|\((.*?)\)//gi')"
    local result=${pre_result,,}

    echo $result
}

function join {
	#param: $1 joins as the first one
	#param: $2 joins to $1
	local result=$1"\ \-\ "$2
	echo $result
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

echo Loading lyrics...
info=$(getInfo)

track_name=$(echo $info | jq -r ".item.name")
author_name=$(echo $info | jq -r ".item.album.artists[].name")

rm -rf /tmp/lyrics.*
tmp=$(mktemp -d /tmp/lyrics.XXX)
touch $tmp/lyrics.html

artist_escaped=$(escape "$author_name")
song_escaped=$(escape "$track_name")

both_escaped=$(join "$artist_escaped" "$song_escaped")

artist=$(adjust "$author_name")
artist=$(echo $artist | sed -r -e 's/the//gi')
song=$(adjust "$track_name")

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
