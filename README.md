# spotify-lyrics
Bash script to show lyrics from spotify name of song and artist name.

## Dependencies
* DBUS (to get spotify name of artist and song)
* Spotify (obviously)
* w3m (for displaying lyrics)
* wget (for downloading lyrics from AZLyrics.com)

## Installation
* Download awk script from [here](https://gist.github.com/csssuf/13213f23191b92a7ce77#file-spotify_song-awk).
* Put it in directory with `getLyrics.sh` and `getInfo.sh`.

## Usage
* Run spotify.
* Play a song.
* Run `getLyrics.sh`.

## Known issues
* Song with a () in a name won't show.
* Live recorded song will also not display because of problem above.
* Program needs to be properly closed to delete temporary directory from /tmp

## WARNING
Don't use this program commercialy AZLyrics's license is prohibiting the usage of their lyrics.

## Credits
* [@rpieja](https://github.com/rpieja) - For inspiration and getInfo.sh script.
* [@csssuf](https://github.com/csssuf) - For awk script.
