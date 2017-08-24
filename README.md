# spotify-lyrics
Bash script to show lyrics from spotify name of song and artist name.

## Dependencies
* w3m (for displaying lyrics)
* wget (for downloading lyrics from AZLyrics.com)

### If using spotify metadata
* DBUS (to get spotify name of artist and song)
* Spotify (obviously)

## Installation
Clone repository into Computer.
Make symlink into /bin folder so you can run it from terminal everywhere.

## Usage with spotify
* Run spotify.
* Play a song.
* Run `getLyrics.sh -s`.

## Usage without spotify
* Run `getLyrics.sh`.
* Give it artist and song name

## WARNING
Don't use this program commercialy AZLyrics's license is prohibiting the usage of their lyrics.

## TODO list
* Make script MacOS compatible (Which is hard because there is no DBus on Mac defaultly)

## Credits
* [@csssuf](https://github.com/csssuf) - For awk script.
