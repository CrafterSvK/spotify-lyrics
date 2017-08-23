# spotify-lyrics
Bash script to show lyrics from spotify name of song and artist name.

## Dependencies
* DBUS (to get spotify name of artist and song)
* Spotify (obviously)
* w3m (for displaying lyrics)
* wget (for downloading lyrics from AZLyrics.com)

## Installation
Clone repository into Computer.
Make symlink into /bin folder so you can run it from terminal everywhere.

## Usage
* Run spotify.
* Play a song.
* Run `getLyrics.sh`.

## WARNING
Don't use this program commercialy AZLyrics's license is prohibiting the usage of their lyrics.

## TODO list
* Make script MacOS compatible (Which is hard because there is no DBus on Mac defaultly)
* Make script Windows compatible (I haven't find way to do this and I don't like batch needs rewrite in other language)
* Rewrite to Python 3

## Credits
* [@csssuf](https://github.com/csssuf) - For awk script.
* My friend which helped me with coding this script.
