# spotify-lyrics - beta branch
Bash script to show lyrics from spotify name of song and artist name.

## Dependencies
* DBUS (to get spotify name of artist and song)
* Spotify (obviously)
* w3m (for displaying lyrics)
* wget (for downloading lyrics from AZLyrics.com)
* awk script from [@csssuf](https://github.com/csssuf) [download here](https://gist.github.com/csssuf/13213f23191b92a7ce77#file-spotify_song-awk)

## Installation
* Download awk script from [here](https://gist.github.com/csssuf/13213f23191b92a7ce77#file-spotify_song-awk).
* Put it in directory with `getLyrics.sh`.

## Usage
* Run spotify.
* Play a song.
* Run `getLyrics.sh`.

## WARNING
Don't use this program commercialy AZLyrics's license is prohibiting the usage of their lyrics.

## TODO list
* Make script MacOS compatible (Which is hard because there is no DBus on Mac defaultly)
* Rewrite to Python 3

## Credits
* [@csssuf](https://github.com/csssuf) - For awk script.
* My friend which helped me with coding this script.
