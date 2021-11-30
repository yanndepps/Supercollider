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

// building complexity
// 1.
~ring1 = Pbind(
  \instrument, \ring1,
  \f, Pkey(\freq),
  \scale, Scale.minor,
  \root, 0,
  \degree, 0,
  \octave, 5,
  \dur, 0.25,
  \d, 0.3,
  \a, 0.6,
  \pan, 0,
  \amp, 1,
);
~ring1.play;

// 2.
~ring1 = Pbind(
  \instrument, \ring1,
  \f, Pkey(\freq),
  \scale, Scale.minor,
  \root, 0,
  \degree, 0,
  \octave, 5,
  \dur, 0.25,
  \d, 0.3,
  \a, Pexprand(0.6, 10),
  \pan, 0,
  \amp, 1,
);
~ring1.play;

// 3.
~ring1 = Pbind(
  \instrument, \ring1,
  \f, Pkey(\freq),
  \scale, Scale.minor,
  \root, 0,
  \degree, 0,
  \octave, Pwrand([5,4,3], [0.6, 0.2, 0.2], inf),
  \dur, 0.25,
  \d, 0.3,
  \a, Pexprand(0.6, 10),
  \pan, 0,
  \amp, 1,
);
~ring1.play;

// 4.
~ring1 = Pbind(
  \instrument, \ring1,
  \f, Pkey(\freq),
  \scale, Scale.minor,
  \root, 0,
  \degree, 0,
  \octave, Pwrand([5,4,3], [0.6, 0.2, 0.2], inf),
  \dur, Pbjorklund2(Pwhite(10, 15), 16)/4,
  \d, 0.3,
  \a, Pexprand(0.6, 10),
  \pan, 0,
  \amp, 1,
);
~ring1.play;

// 5.
~ring1 = Pbind(
  \instrument, \ring1,
  \f, Pkey(\freq),
  \scale, Scale.minor,
  \root, 0,
  \degree, 0,
  \octave, Pwrand([5,4,3], [0.6, 0.2, 0.2], inf),
  \dur, Pbjorklund2(Pwhite(10, 15), 16)/4,
  \d, 0.3,
  \a, Pexprand(0.6, 80),
  \pan, 0,
  \amp, 1,
);
~ring1.play;

// 6.
~ring1 = Pbind(
  \instrument, \ring1,
  \f, Pkey(\freq),
  \scale, Scale.minor,
  \root, 0,
  \degree, Prand([0, 2, 4, 6, 7], inf),
  \octave, Pwrand([5,4,3], [0.6, 0.2, 0.2], inf),
  \dur, Pbjorklund2(Pwhite(10, 15), 16)/4,
  \d, 0.3,
  \a, Pexprand(0.6, 80),
  \pan, 0,
  \amp, 0.8,
);
~ring1.play;

// the beauty of ProxySpace means we can run function proxies
// alongside pattern proxies
~sines = {SinOscFB.ar([36.midicps, 48.midicps + 1], SinOsc.kr(0.1).range(0.1, 1), 0.5)}
~sines.play;

// we can also use function proxies to effect patterns
~sinfb = Pbind(
  \instrument, \sinfb,
  \degree, 0,
  \octave, 5,
  \dur, 0.25,
  \amp, 0.7,
  \fb, 0.1,
);
~sinfb.play;

// then create a control rate proxy to control that pattern
~sinfbControl = { SinOsc.kr(0,1).range(0.1, 0.9) }

// then set an argument on the pattern against the kr rate proxy
~sinfb.set(\fb, ~sinfbControl);

// we can chain pattern proxies too
// add reverb
~verb = { FreeVerb.ar(~sinfb, 1) }
~verb.play;

// make the reverb ridiculous
~verb = { FreeVerb.ar(~sinfb, 1, 1, 0.1) }

// cut the percs for some ambience
(
~k.stop;
~sn.stop;
~h.stop;
)

// and make another sinfb pattern a fifth above the old one
// for more ambience
~sinfb2 = Pbind(
  \instrument, \sinfb,
  \degree, 4,
  \octave, 6,
  \dur, 0.25,
  \amp, 0.7,
  \fb, 0.1,
);
~sinfb2.play;

// make sure it has the control proxy assigned too !
// or make another one !
~sinfbControl2 = { SinOsc.kr(0.11).range(0.1, 1.5) }
~sinfb2.set(\fb, ~sinfbControl2);

// slow it down a bit
p.clock.tempo = 120/60;

// --- END --- //
p.clear;
