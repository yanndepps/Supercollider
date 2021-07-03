"SC_JACK_DEFAULT_OUTPUTS".setenv("REAPER");

// Placing drones in multichannel space
s.boot;
ThrenoScope.new(8);

// ---
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

// ---
~drones.scale = \chromatic
~drones.createChord(\tri, [1, 3, 5, 11], tonic: 4, name: \ixi)
~ixi.kill
~drones.createDrone(\sine, 2, degree: 1, name:\tonic)
~drones.createDrone(\sine, 2, degree: 3, name:\third)
~drones.createDrone(\sine, 2, degree: 5, name:\fifth)
~drones.defineChord(\dog, \tonic, \third, \fifth)
~dog.tonic = 4 // move the new chord up to the 4rth octave

// ---
// satellites : a larger cluster of drones moving in space
~drones.createSatellites(\saw, \minor, 8, name: \ooo)
~ooo.num = 40
~ooo.tonic=2
~ooo.speed=10
~ooo.speed={rrand(-20, 30)} // pass a function so each satellite gets a different speed

// ---
// tunings & scales
// let's look at the scale view for tunings
~drones.drawHarmonics = false
~drones.drawScale = true
// we move to the chromactic scale (all 12 notes) to see the different tunings
~drones.scale = \chromatic
~drones.tuning = \just
~drones.tuning = \mean6
~drones.tuning = \et12 // the standard western equal tempered tuning
~drones.tuning = \wcSJ // Wendy Carlos' Super Just Tuning
~drones.scale = \minor
~drones.tuning = \et12

// let's try some Scala scales/tunings
~drones.scale = \mean19
~drones.scale = \safi_arabic
~drones.scale = \safi_rahevi
~drones.scale = \solar
~drones.scale = 'bohlen-p' // because of the hyphen we need quotation marks
~drones.scale = 'bohlen-p_9'

// ---
// GUI & automation
~drones.createDrone(\eliane, 2, degree: 5, name: \oxo)
~oxo.setParam(\tonic, 1, 10) // the argument and its low and high values
~oxo.recParam(\harmonics, 1, 10) // move the mouse around to record. On release it will play

// ---
