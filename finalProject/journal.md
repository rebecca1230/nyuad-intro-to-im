# Mini MIDI Keyboard with Loopstation
I am thinking of building a Mini MIDI Keyboard that uses Switches to play notes and a Potentiometer to change the scales from lower to higher. The interface will also support Looping of audio using beats.

The player will need to move around the octave / 2 (because we only have 4 switches) area using Potentiometer and play the notes. On the computer screen, there will be an interface to see notes, add tracks and create beats. All the generated music will be played in one loop; therefore, the player will be able to generate their own audio.

This is a very general idea of the project, so a lot of things might change. Anyway, I will document my journey of the project in this document.

### Idea Sketch
![](images/sketch.jpg)

### Schematic
Most of the work will be handled in Processing but the Arduino will be used to retrieve information on which keys were pressed (using switches) and where to move the octave / 2 range on screen (using the potentiometer). I am also thinking about showing some result in Arduino too, but need to brainstorm about it. Here's my initial schematic:

![](images/schematic.jpg)


To be continued...
