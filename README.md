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

With the help of the bumpers on the controller, the player can include
accidentals (right bumper raises a note by a half-step) or drop the note an
octave (left bumper). This means the player can play any notes enclosed by a
two-octave span of A's.

## To encode a song:

The basic format of a song is an array of pitches in order:

    SongName := [1,3,5,1,4,6,6,5]

If you're using this script to make playing an in-game tune easier (and not just
for funsies), you'll probably want to use this format since it's easiest.

For longer songs or just to make it easier to read with your own eyes you can
break it into multiple lines:

    SongName := [[1,2,   3,4],
                 [5,6,   7,8],
                 
                 [4,4,2,   1,2,3],
                 [1,   4,    2]]

### Pitch Adjustment

You can adjust the pitch up or down a half step by adding an "accidental"
character after the pitch:

|Symbol|Effect|
|-|-|
|b|(flat): down a half step|
|n|natural (no change); this is used if a control character has set a pitch to flat or sharp and you want to "un-flat" or "un-sharp" it.|
|#|(sharp): up a half step|

If you're writing in D instead of A and you know all your 7's need to go down
a half step, you can lock them flat with a control pseudo-note:

    ':7b'

This note doesn't actually play and has a length of zero; it just tells the
player to always play 7's flat. You can override this on a per-note basis by
using a "natural" accidental, which is an "n", or cancel it completely by
overwriting it with a natural control pseudo-note:

    ':7n'

There are two octaves available to play in. By default the flute plays in the
upper octave. You can push a note down to the lower octave by including a minus
after the pitch:

    [5,4,3,2,1,'7-','6-','5-']

If you plan to spend a lot of time in the lower octave, you can add an octave
switch control pseudo-note:

    [5,4,3,2,1,':-',7,6,5]

The octave switch holds the lower octave until another switch is encountered.
While down there you can still bump notes up to the upper octave by adding a
plus:

    [5,4,3,2,1,':-',7,6,5,6,7,'1+','2+']

To make life easier, the player considers plusses and minuses to be the same
character. You can use them interchangeably.

### Length Adjustment

Any simple number by itself will be interpreted as a quarter note. To adjust the
length of a note, add an extra character in front of the pitch. If the length
character is also a number and there are no other modifiers you can optionally
leave off the quotes.

    [41,43,51,'T5','#8']
            
|Number|Length|
|------|------|
|1|whole|
|2|half|
|4|quarter|
|8|eighth|
|#|sixteenth|
|T|32nd|

You can further adjust the length of a note by putting a modifier between the
length character and the pitch. This is optional.

|Symbol|Effect| |
|-|-|-|
|.|staccato|The note will be shortened by 25% and automatically followed by a rest for the remaining 25%. The result is a note of the same length but with a slightly shortened sound. This is especially useful when there are multiple consecutive quarter or eighth notes of the same pitch.|
|+|dotted note|Adds half again the note's length. '2+' would be a dotted half note, '4+' would be a dotted quarter note, etc.|
|3|triplet|Divides the length of the note by 3.|

Beware that even though decimals `('8.1','4.6','2.5',etc)` appear to be just
numbers, you still have to enclose them in a string or the script will fail.

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
