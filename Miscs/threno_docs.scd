s.boot;
ThrenoScope.new(2);

// introduction to the threnoscope

// ---
// Here we have removed the harmonics view and are now drawing the chosen scale. We then choose the "chromatic" scale (every halfnote in the octave, 12 notes) and then set the tuning to "just" intonation. We change the scale to a minor scale and set the tuning back to equal tempered 12-tone tuning.
~drones.drawHarmonics = false
~drones.drawScale = true

~drones.scale = \chromatic
~drones.tuning = \just
~drones.scale =\minor
~drones.tuning = \et12  // 12-tome equal temperament

// ---
~drones.createDrone(\saw, 2, harmonics: 3);

// ---
~oxo.harmonics = 9;
~oxo.length = 330;
~oxo.speed = 15;
~oxo.type = \gendy;
~oxo.resonance = 3;
~oxo.kill; // if you want to kill it now

// ---
~oxo.tonic_(1, 20); // moving from the 2nd harmonic to the 1st in 20 seconds
~oxo.harmonics_(1, 10); // moving the cutoff frequency of the lowpass filter to the first harmonic in 10 seconds§

// ---
~oxo.kill
~oxo.kill(10) // here it takes 10 seconds to fade out
~drones.killAll // kill all the drones
~drones.killAll(3) // kill all the drones in three seconds.

// ---
~drones.createChord(\saw, \minor, 2)
~drones.createChord(\saw, \dominant7add11, 4, name:\dom7)

~dom7.tonic_(1, 4)
~dom7.harmonics_(10, 4)
~drones.chords // see all the available chords