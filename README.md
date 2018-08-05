# spotify-lyrics
Bash script to show lyrics from spotify name of song and artist name.

## Dependencies
* w3m (for displaying lyrics)
* wget (for downloading lyrics from AZLyrics.com)
* jq (for json WebAPI parsing)
* sed and curl

## Installation
Clone repository into Computer.
Make symlink into /bin folder so you can run it from terminal everywhere.

## Usage
* Get auth token from [WebAPI](https://developer.spotify.com/console/get-users-currently-playing-track/), click on GET TOKEN and check user-read-currently-playing
* Write it into `getLyrics` key variable (2nd line)

## Override (Songs that violates with algorithm) currently unavailable
* If you find a song that violates with algorithm for example AWOLNATION - Hollow Moon (Bad Wolf) just add it into override.txt file
* How to write override (all in lowercase): ArtistName-SongNameAfterAlgorithm:SongOverride

## WARNING
Don't use this program commercialy AZLyrics's license is prohibiting the usage of their lyrics.

## TODO list
* Add Windows installation tutorial
