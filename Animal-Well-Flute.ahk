/*

ANIMAL WELL FLUTE PLAYER
Version 3
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

With the help of the bumpers on the controller, the player can include
accidentals (right bumper raises a note by a half-step) or drop the note an
octave (left bumper). This means the player can play any notes enclosed by a
two-octave span of A's.

/////////////////
To encode a song:
/////////////////

The basic format of a song is an array of pitches in the order they should be
played:

    SongName := [1,3,5,1,4,6,6,5]

If you're using this script to make playing an in-game tune easier (and not just
for funsies), you'll probably want to use this format since it's easiest.

For longer songs or just to make it easier to read with your own eyes you can
break it into multiple lines or add spaces wherever you want:

    SongName := [[1,2,   3,4],
                 [5,6,   7,8],
                 
                 [4,4,2,   1,2,3],
                 [1,   4,    2]]

You can adjust the pitch up or down a half step by adding an "accidental"
character after the pitch:

    b = down a half step
    # = up a half step

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

Any simple number by itself will be interpreted as a quarter note. To adjust the
length of a note, add an extra character in front of the pitch. If the length
character is also a number and there are no other modifiers you can optionally
leave off the quotes.

    [41,43,51,'T5','#8']
            
    Length of note:
        1 = whole note
        2 = half note
        4 = quarter note
        8 = eigth note
        # = sixteenth note
        T = 32nd note

You can further adjust the length of a note by putting a modifier between the
length character and the pitch. This is optional.

    ['4.2'] <--- Must be quoted!
    ['T+8','231','232','233',14]

    Length modifiers:
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

#Include songs/commander.ahk
#Include songs/hornpipe.ahk
#Include songs/lethalCompany.ahk
#Include songs/risenToday.ahk
#Include songs/scotland.ahk
#Include songs/spongebob.ahk
#Include songs/twinkle.ahk
#Include songs/xFiles.ahk
#Include songs/yoshi.ahk

; What song to play!
SONG_TO_PLAY := Spongebob

; How fast to play. Lower number means faster. Default is 2000.
TEMPO := 850

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

ACCIDENTAL_LOCKS := [0,0,0,0,0,0,0]
OCTAVE_SWITCH_LOCK := false

PlayLine(LINE)
{
    global OCTAVE_SWITCH_LOCK
    global ACCIDENTAL_LOCKS

    for _, note in LINE
    {
        ; Quit if the user pressed ESC
        if( BREAK_LOOP )
            break

        ; If this note is a control pseudo-note, which starts with a colon
        if(SubStr(note,1,1) = ':')
        {
            ; Octave switch (:+ or :-)
            if(SubStr(note,2,1) = '+' or SubStr(note,2,1) = '-')
            {
                OCTAVE_SWITCH_LOCK := !OCTAVE_SWITCH_LOCK
                continue
            }

            ; Accidental lock
            accidental := 0
            switch SubStr(note,3,1)
            {
                Case 'b': accidental := -1
                Case '#': accidental := 1
            }

            ACCIDENTAL_LOCKS[SubStr(note,2,1)] := accidental

            continue
        }

        ; Defaults
        pitch := 1
        len_char := ''
        len_mod := ''
        accidental := -2 ; Denotes that this value hasn't been set by the user
        octave_switch := OCTAVE_SWITCH_LOCK
        sharp_switch := false

        ; Read from the end of the string backwards until we find an integer.
        ; We know that the final integer is the pitch and any characters after
        ; that are pitch modifiers.
        index := StrLen(note)
        while(index >= 1)
        {
            thisChar := SubStr(note,index,1)

            if IsInteger(thisChar)
            {
                pitch := thisChar
                break
            }

            else if(thisChar = '+' or thisChar = '-')
                octave_switch := !octave_switch

            else if(thisChar = 'b')
                accidental := -1

            else if(thisChar = '#')
                accidental := 1

            else if(thisChar = 'n')
                accidental := 0

            index -= 1
        }

        ; If the accidental wasn't set, defer to the locked value
        if(accidental = -2 and pitch != 9)
            accidental := ACCIDENTAL_LOCKS[(pitch = 8 ? 1 : pitch)]

        ; If the accidental was sharp, activate the sharp switch
        if(accidental = 1)
            sharp_switch := true

        ; If the accidental was flat, lower the pitch one and activate the
        ; sharp switch
        if(accidental = -1)
        {
            pitch -= 1
            if(pitch = -1)
            {
                ; If we tried to flat a zero, go back up to 7 but drop down an
                ; octave.
                pitch := 7
                octave_switch := true
            }

            sharp_switch := true
        }

        ; The pitch integer must be at position 1, 2, or 3.
        switch index
        {
            ; Length and length modifier are both present
            Case 3:
                len_mod := SubStr(note,2,1)
                len_char := SubStr(note,1,1)

            ; Only length is present
            Case 2:
                len_char := SubStr(note,1,1)

            ; Nothing is present before pitch
            ; Case 1:
            ; do nothing
        }

        switch len_char, 0
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

        ; If staccato, 3/4 the duration of the note. A rest for 1/4 the duration
        ; will be played after.
        if(len_mod = '.')
            duration *= 0.75

        ; If a dotted note, add half again the duration.
        if(len_mod = '+')
            duration *= 1.5

        ; If a 3, divide the note's length by 3; this is how triplets are made.
        if(len_mod = '3')
            duration /= 3

        PlayNote(pitch,duration,sharp_switch,octave_switch)

        ; If staccato, play a rest for 1/4 the note's duration.
        if(len_mod = '.')
            PlayNote(9,duration * 0.25,sharp_switch,octave_switch)
        
    }
}

PlayNote(PITCH,DURATION,SHARP,OCTAVE)
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

        if ( SHARP )
            Send("{3 down}")
        if ( OCTAVE )
            Send("{1 down}")
        
        Send("{x down}")
    }

    Sleep(TEMPO * DURATION)

    Send("{x up}")
    Send("{d up}")
    Send("{s up}")
    Send("{a up}")
    Send("{w up}")
    Send("{3 up}")
    Send("{1 up}")
}