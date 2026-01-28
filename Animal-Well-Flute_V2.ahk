/*

ANIMAL WELL FLUTE PLAYER
Version 2
By Nius Atreides

This is an AutoHotKey script that automatically plays the flute in Animal Well.

The flute allows you to play any note from 1 to 8:
         1 = A
         2 = B
         3 = C#
         4 = D
         5 = E
         6 = F#
         7 = G#
    0 or 8 = A (1 octave up)
         9 = rest
This means the user can play any tune within a single octave of an A Major
scale.

/////////////////
To encode a song:
/////////////////

The basic format of a song is an array of pitches in order:

    SongName := [1,2,3,4,5,6,7,8]

If you're using this script to make playing an in-game tune easier (and not just
for funsies), you'll probably want to use this format since it's easiest.

For longer songs or just to make it easier to read with your own eyes you can
break it into multiple lines:

    SongName := [[1,2,3,4],
                 [5,6,7,8]]

You can also add spaces wherever you want to, between lines or notes, as needed.

Any simple number will be interpreted as a quarter note. To adjust the length
of a note, use a two- or three-character string, like these:

    ['4.1','2.6','17','4+1']
            
    First Position: Length of note
        1 = whole note
        2 = half note
        4 = quarter note
        8 = eigth note
        # = sixteenth note
        T = 32nd note

    Middle Position (optional): Length modifier
        . = staccato
            The note will be shortened by 25% and automatically followed by a
            rest for the remaining 25%. The result is a note of the same length
            but with a slightly shortened sound. This is especially useful when
            there are multiple consecutive quarter or eighth notes of the same
            pitch.
        + = dotted note
            Adds half again the note's length. '2+' would be a dotted half note,
            '4+' would be a dotted quarter note, etc.
        3 = triplet
            Divides the length of the note in 3.
    
    Last Position: Pitch
        This uses the same pitch encoding as the simple form described above.

A note that has no modifier and is just two numbers can be expressed as an
integer instead of a string:

    ['81','82','83','84','85']   is the same as   [81,82,83,84,85]

Beware that even though decimals ('8.1','4.6','2.5',etc) appear to be just
numbers, you still have to enclose them in a string or the script will fail.

Simple notes and string notes can be used interchangeably:

    [1,2,3,4,'15','26','27','1.8']

You can encode any number of songs you want, as long as they each have a unique
name. There is no limit to the length of a song.

////////////
TO CONFIGURE
////////////

To change songs:
Change SONG_TO_PLAY to point to the song you want to play, then re-run script.

To change speed:
Change TEMPO value. Lower numbers are faster. Default is 2000.

//////////
TO EXECUTE
//////////

After running the script, inside of Animal Well press HOME to play the selected
song. Press ESC at any time to stop playing. If you play again after pressing
ESC it will start from the beginning.

*/

#Requires AutoHotkey v2.0
#SingleInstance Force

SetTitleMatchMode 2

#HotIf WinActive("ANIMAL WELL")

Commander := [
    ; Recommended tempo: 1500
    [85,86,85],
    [5,3,'432','433','432','4+1'],
    [85,86,85,84,85,'8.6',89,4,89],
    [84,83,84,85,86],
    [5,'434','435','434','4+3'],
    [83,84,83,82,81,'8.5',89,2,89],
    [85,83,85,86,85,4,3,84,85,83,81,'#2','#3',82,21,89],
    [85,88,85,'8.6',89,'435','436','435','4+4'],
    [84,83,84,85,86,5,'434','435','434','4+3'],
    [83,84,83,82,81,'8.5',89,87,88,86,87,'8.5'],
    [85,83,85,86,85,4,83,81,84,85,83,81,'#2','#3',82,'2+1',89],
    ['#3','#5'],
    ['#8','#5','#3','#5',  '#8','#5','#3','#5'],
    ['#8','#5','#3','#5',  '#8','#5','#3','#5'],
    ['#6','#4','#1','#4',  '#6','#4','#1','#4'],
    ['#7','#5','#2','#5',  '#7','#5','#2','#5'],
    ['#8','#5','#3','#5',  '#8','#5','#3','#5'],
    ['#8','#5','#3','#5',  '#8','#5','#3','#5'],
    ['#6','#4','#1','#4',  '#6','#4','#1','#4'],
    ['#7','#5','#2','#5',  '#7','#5','#2','T33','T35'],
    ['8.8',89,21]

]

Hornpipe := [
    
    ; Recommended tempo: 500

    ['435','436','437'],
    [8,5,3,1,4,1,5,4],
    [83,84,3,'4.1',1,4,1,5,4],
    [83,84,3,'4.1',1,4,1,5,4],
    [83,84,3,'4.1',1,22,9,86,87],
    [8,5,3,1,4,1,5,4],
    [83,84,3,'4.1',1,4,1,5,4],
    [3,4,5,6,7,8,2,3,4,3,2,7,28,9],

    [5],
    [8,5,3,1,4,1,5,4],
    [83,84,3,'4.1',1,4,1,5,4],
    [83,84,3,'4.1',1,4,1,5,4],
    [83,84,3,'4.1',1,22,9,86,87],
    [8,5,3,1,4,1,5,4],
    [83,84,3,'4.1',1,4,1,5,4],
    [3,4,5,6,7,8,2,3,4,3,2,7,28,9],

    [87,88],
    [2,7,5,7,2,5,2,5],
    [3,1,5,1,3,5,3,5],
    [2,3,2,1,87,88,7,2,7,86,87,6,2,6,25,9],
    ['438','437','435'],
    [6,4,1,4,6,8,7,8,5,3,1,3,'8.5',89,'8.5',89,'8.5',89,5],
    [7,8,2,3,4,3,2,8,7,5,6,7,28,9],

    [87,88],
    [2,7,5,7,2,5,2,5],
    [3,1,5,1,3,5,3,5],
    [2,3,2,1,87,88,7,2,7,86,87,6,2,6,25,9],
    ['438','437','435'],
    [6,4,1,4,6,8,7,8,5,3,1,3,'8.5',89,'8.5',89,'8.5',89,5],
    [7,8,2,3,4,3,2,8,7,5,6,7,28,9],

    [5],
    [8,5,3,1,4,1,5,4],
    [83,84,3,'4.1',1,4,1,5,4],
    [83,84,3,'4.1',1,4,1,5,4],
    [83,84,3,'4.1',1,22,9,86,87],
    [8,5,3,1,4,1,5,4],
    [83,84,3,'4.1',1,4,1,5,4],
    [3,4,5,6,7,8,2,3,4,3,2,7,'4.8','2+9'],

    [11]
]

LethalCompany := [
    ; Recommended tempo: 1300
    [83,82],
    ['4.1',81,82,81,85,83,84,85,86,85,83,5,81,82],
    ['4.3','4.3',83,82,81,82,3,'4.2',2,83,82],
    ['4.1',81,82,81,85,83,84,85,86,85,83,5,81,82],
    [83,5,86,85,83,81,82,3,2,1]
]

RisenToday := [
    [1,3,5,1,4,'4.6',6,'4.5'],
    [83,84,85,81,4,83,84,3,2,1,9],
    [4,5,6,5,4,'4.3',3,'4.2'],
    [83,84,85,81,4,83,84,3,2,1,9],
    [7,8,2,5,1,2,3,9],
    [87,88,82,85,8,87,88,7,6,5,9],
    [85,86,87,85,8,3,4,'4.6',6,'4.5'],
    [88,87,88,85,86,87,88,85,8,7,28]
]

Scotland := [
    [5],
    [81,89,'8+1','#2',83,81,83,'#5','T6','T7',],
    [88,89,'8+8','#7',88,85,83,81],
    [4,'8+6','#4',83,85,83,81],
    [2,'4.5','8+5','#6','#5','#4','#3','#2'],
    [81,89,'8+1','#2',83,81,83,'#5','T6','T7',],
    [88,89,'8+8','#7',88,85,83,81],
    [4,'8+6','#4',83,85,83,81],
    [2,'8+1','#2',1],
    [83,85],
    [88,89,'8+8','#7',88,85,83,81],
    [88,89,'8+8','#7',88,85,83,81],
    [88,89,'8+8','#5',6,'8+8','#5',86,88,87,86,85,84,83,82],
    [81,89,'8+1','#2',83,81,83,'#5','T6','T7',],
    [88,89,'8+8','#7',88,85,83,81],
    [4,'8+6','#4',83,85,83,81],
    [2,'8+1','#2',1],

]
                
TwinkleLittleStar := [
    ['4.1','4.1','4.5','4.5','4.6','4.6','25'],
    ['4.4','4.4','4.3','4.3','4.2','4.2','21'],
    ['4.5','4.5','4.4','4.4','4.3','4.3','22'],
    ['4.5','4.5','4.4','4.4','4.3','4.3','22'],
    ['4.1','4.1','4.5','4.5','4.6','4.6','25'],
    ['4.4','4.4','4.3','4.3','4.2','4.2','21']
]

Yoshi := [
    ; Recommended tempo: 1000
    ['2+6',24,1,22,'4.4','2+4'],
    [21,'4.4',24,8,'2+6','2+5'],
    ['2+6',24,1,22,'4.4','2+4'],
    [21,4,8,6,5,'2+4'],
    [4,9,1],
    ['2+6',24,1,'2+6',24,1,'2+5',24,1,'2+5',5,9],
    [1],
    ['2+6',24,1,'2+6',24,1,'2+5',24,5,'2+8',8,9],
    [1],
    ['2+6',24,1,22,'4.4','2+4'],
    [21,'4.4',24,8,'2+6','2+5'],
    ['2+6',24,1,22,'4.4','2+4'],
    [21,4,8,6,5,'2+4'],
    [24,9],
]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; What song to play!
SONG_TO_PLAY := Hornpipe

; How fast to play. Lower number means faster. Default is 2000.
TEMPO := 500

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BREAK_LOOP := false

Home::
{
    global BREAK_LOOP
    BREAK_LOOP := false

    if(IsObject(SONG_TO_PLAY[1]))
    {
        for _, LINE in SONG_TO_PLAY
        {
            if( BREAK_LOOP )
                break

            PlayLine(LINE)
        }
    }
    else
        PlayLine(SONG_TO_PLAY)

    BREAK_LOOP := false
}

Esc::
{
    global BREAK_LOOP

    BREAK_LOOP := true
}

PlayLine(LINE)
{
    for _, note in LINE
    {
        if( BREAK_LOOP )
            break

        duration := .25
        modifier := ''
        pitch := 1

        if(StrLen(note) = 1)
            pitch := SubStr(note,1,1)
        else
        {

            switch SubStr(note,1,1), 0
            {
                ; Quarter note
                Case '4': duration := .25

                ; Half note
                Case '2': duration := .5

                ; Whole note
                Case '1': duration := 1

                ; Eigth note
                Case '8': duration := .125

                ; Sixteenth note
                Case '#': duration := .0625

                ; 32nd note
                Case 'T': duration := .03125

                ; Default to a quarter note
                Default:  duration:= .25
            }

            if(StrLen(note) = 3)
            {
                modifier := SubStr(note,2,1)
                pitch := SubStr(note,3,1)
            }
            else
                pitch := SubStr(note,2,1)
        }

        ; If staccato, 3/4 the duration of the note. A rest for 1/4 the duration
        ; will be played after.
        if(modifier = '.')
            duration *= 0.75

        ; If a dotted note, add half again the duration.
        if(modifier = '+')
            duration *= 1.5

        ; If a 3, divide the note's length by 3; this is how triplets are made.
        if(modifier = '3')
            duration /= 3

        PlayNote(pitch,duration)

        ; If staccato, play a rest for 1/4 the note's duration.
        if(modifier = '.')
            PlayNote(9,duration * 0.25)
        
    }
}

PlayNote(PITCH,DURATION)
{
    if( PITCH != 9 )
    {
        if ( PITCH <= 2 or PITCH = 8)
            Send("{d down}")
        if ( PITCH >= 2 and PITCH <= 4)
            Send("{s down}")
        if ( PITCH >= 4 and PITCH <= 6)
            Send("{a down}")
        if ( PITCH >= 6 or PITCH = 0)
            Send("{w down}")
    }

    if( PITCH != 9 )
        Send("{x down}")

    Sleep(TEMPO * DURATION)

    Send("{x up}")
    Send("{d up}")
    Send("{s up}")
    Send("{a up}")
    Send("{w up}")
}