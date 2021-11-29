// --- Basics : ProxySpace Patterns --- //
// to start, either execute the setup file or 
("../Setup/setup.scd").loadRelative;

// Patterns can also be written directly into ProxySpace. 
// They will be synced to ProxySpace's TempoClock
// The tempoclock is initialised at setup by p.makeTempoClock
// The speed of the clock is controlled by modifying this value
p.clock.tempo = 1;

//Patterns can also have fades applied to them
p.fadeTime = 4;

// basic kick pattern
~k = Pbind(
  \instrument, \vplaym,
  \buf, d["sc"][7],
  \pos, 0.7,
  // \rel, 0.2,
  \rate, 1.25,
  \dur, 1,
  \amp, 1,
);
~k.play;
~k.stop;

// basic snare pattern
~sn = Pbind(
  \instrument, \vplaym,
  \buf, d["sc"][7],
  \pos, 0.3,
  // \rel, 0.2,
  \rate, 1.0,
  \dur, 2,
  \amp, 1,
);
~sn.play;
~sn.stop;

// basic hi-hat pattern
~h = Pbind(
  \instrument, \vplaym,
  \buf, d["sc"][7],
  \pos, 0.0,
  // \rel, 0.2,
  \rate, 1,
  \dur, 1,
  \amp, Pwhite(0.2, 1),
);
~h.play;
~h.stop;

// double the clock speed
p.clock.tempo = 2;

// with p.clock.tempo at 2, one full cyle in the 'dur' argument 
// of patterns happens twice a second, making the BPM 120
// we can get the BPM value of p.clock.tempo by multiplying it by 60
// we can also do this to set the tempo clock by BPM
p.clock.tempo = 135/60

// the proxyspace clock can be pushed very hard, with super low clock 
// speeds resulting in silence as patterns run too slowly (if only patterns are running)
p.clock.tempo = 0.00001;

//Extremely high clock speeds will result in extratone-like drums
p.clock.tempo = 20;

//Absurd clock speeds will result in hideous crashing and you having to recompile

// hear fades on patterns
~h = Pbind(
  \instrument, \vplaym, 
  \buf, d["sc"][7], 
  \pos, 0.7,
  \dur, Pwrand([0.25, Pseq([0.125], 2)], [0.8, 0.2], inf),
  \amp, Pwhite(0.2, 0.4),
);
~h.play;
~h.stop(2);

~sn = Pbind(
  \instrument, \vplaym,
  \buf, d["sc"][7],
  \pos, 0.7,
  \dur, Pbjorklund2(5, 16)/4,
  \amp, 0.5,
);
~sn.play;
~sn.stop(2);

~k = Pbind(
  \instrument, \vplaym,
  \buf, d["sc"][7],
  \pos, 0.7,
  \dur, Pbjorklund2(3, 8)/4,
  \amp, 1,
);
~k.play;
~k.stop(2);

//You can also use Pbinds to specify melodies
(
~ring1 = Pbind(
  \instrument,\ring1,
  \f,Pkey(\freq),
  \scale, Scale.minor,
  \root, 0,
  \degree, Pseq([0, 7, 3, 5], inf),
  \octave, 5,
  \dur, Pseq([1, 1/4, 1, 1/2], inf),
  \d, 0.6,
  \a, 0.6,
  \pan, 0,
  \amp, 1
);
~ring1.play;
)

p.clear;
