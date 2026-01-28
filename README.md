# Animal Well Flute Player

This is an [AutoHotKey](https://www.autohotkey.com/) script that automatically plays the flute in [Animal Well](https://store.steampowered.com/app/813230/ANIMAL_WELL/).

The flute allows you to play any note from 1 to 8:
|Number|Pitch|
|------|-----|
|1|A|
|2|B|
|3|C#|
|4|D|
|5|E|
|6|F#|
|7|G#|
|0 or 8|A (one octave up)|
|9|rest|

This means the user can play any tune within a single octave of an A Major
scale.

## To encode a song:

The basic format of a song is an array of pitches in order:

    SongName := [1,2,3,4,5,6,7,8]

If you're using this script to make playing an in-game tune easier (and not just
for funsies), you'll probably want to use this format since it's easiest.

For longer songs or just to make it easier to read with your own eyes you can
break it into multiple lines:

    SongName := [[1,2,3,4],
                 [5,6,7,8]]

Any simple number will be interpreted as a quarter note. To adjust the length
of a note, use a two- or three-character string, like these:

    ['4.1','2.6','17','4+1']
            
### First Position: length of note
|Number|Length|
|------|------|
|1|whole|
|2|half|
|4|quarter|
|8|eighth|
|#|sixteenth|
|T|32nd|

### Middle Position (optional): length modifier
|Symbol|Effect| |
|-|-|-|
|.|staccato|The note will be shortened by 25% and automatically followed by a rest for the remaining 25%. The result is a note of the same length but with a slightly shortened sound. This is especially useful when there are multiple consecutive quarter or eighth notes of the same pitch.|
|+|dotted note|The note will be shortened by 25% and automatically followed by a rest for the remaining 25%. The result is a note of the same length but with a slightly shortened sound. This is especially useful when there are multiple consecutive quarter or eighth notes of the same pitch.|

### Last Position: pitch
This uses the same pitch encoding as the simple form described above.

Simple notes and string notes can be used interchangeably:

    [1,2,3,4,'15','26','27','1.8']

## To Configure

You can encode any number of songs you want, as long as they each have a unique
name. There is no limit to the length of a song.

### To change which song plays when you run the script:
Change SONG_TO_PLAY to point to the song you want to play, then re-run script.

### To change speed:
Change TEMPO value. Lower numbers are faster. Default is 2000.

## To Execute

After running the script, inside of Animal Well press `HOME` to play the selected
song. Press `ESC` at any time to stop playing. If you play again after pressing
`ESC` it will start from the beginning.
