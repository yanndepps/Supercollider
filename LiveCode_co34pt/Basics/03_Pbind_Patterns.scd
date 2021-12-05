// --- Basics : Pbind & Patterns --- //

("../Setup/setup.scd").loadRelative;

p.fadeTime = 3;

// have a kick drum playing once each beat in time with the ProxySpace timer :
(
~k = Pbind(
  \instrument, \vplaym,
  \buf, d["sc"][3],
  \pos, 0.2,
  \dur, Pwhite(0.5, 1),
  \amp, 0.5,
);
~k.play(out:0);
)

~k.clear;

// Pbind can take Pattern classes as inputs.
// PWhite gives random values between a min and a max
// add a random pitch to the pattern
(
~m = Pbind(
  \instrument, \vplaym,
  \buf, d["sc"][2],
  \pos, Pwhite(0.3, 0.5),
  \dur, 3,
  // \rate, Pwhite(1.0, 1.2),
  \rate, Pseq([1, 1.2], inf),
  \amp, 0.3,
);
~m.play(out:[2,7]);
)

~m.clear;

p.clock.tempo = 60/60;

// footwork kickdrums
(
~l = Pbind(
  \instrument, \vplaym,
  \buf, d["sc"][7],
  \pos, 0.28,
  \dur, Pbjorklund2(Pseq([3,3,3,5], inf), 8)/4,
  \rate, Pseq([1, 1.5], inf),
  \amp, 0.2,
);
~l.play(out:4);
)

~l.clear;

// skittery hi-hats 
(
p.clock.tempo = 1.5;
~h = Pbind(
    \instrument, \vplaym,
    \buf, d["sc"][10],
    \pos, 0.8,
    \dur, Pwrand([0.25,Pseq([0.125],2),0.5,Pseq([0.125/2],4)],[4,1,1,0.5].normalizeSum, inf),
    \amp, Pwhite(0.2, 0.7),
);
~h.play(out:0);
)
~h.clear;

// offset perc patterns for techno feel behind a basic kick
(
p.clock.tempo = 135/60;
~c = Pbind(
    \instrument, \vplaym,
    \buf, d["sc"][3],
    \dur, Pbjorklund2(Pexprand(2,15).round(1),16,inf,Pwhite(1,5).asStream)/4,
    \amp, 0.5,
    \rate, 2.2
);
~c2 = Pbind(
    \instrument, \vplaym,
    \buf, d["sc"][6],
    \dur, Pbjorklund2(Pexprand(2,15).round(1),16,inf,Pwhite(1,5).asStream)/4,
    \amp, 0.5,
    \rate, 0.6,
);
~k = Pbind(
    \instrument, \vplaym,
    \buf, d["sc"][3],
    \dur, 1,
    \amp, 0.5,
);
~c.play(out:0);
~c2.play(out:2);
~k.play(out:4);
)

// snare running forwards and back 
(
p.clock.tempo = 150/60;
~sn = Pbind(
    \instrument, \vplaym,
    \buf, d["sc"][7],
    \dur, Pwhite(1,4)/2,
    \amp, 0.7,
    \rate, Prand([1,-1],inf),
    \pos, Pkey(\rate).linlin(-2,2,0.9,0),
);
~sn.play(out:0);
)

// here, the `freq` argument is the pitch of the oscillator
// pitch can be specified manually
(
~sinfb = Pbind(
    \instrument, \sinfb,
    \dur, 0.25,
    \freq, Pwhite(100,600),
);
~sinfb.play(out:0);
)

// run up and down chromatic scale one degree at a time 
(
~sinfb = Pbind(
    \instrument, \sinfb,
    \scale, Scale.chromatic(tuning:\et12),
    \degree, Pseq((0..12).pyramid.mirror, inf),
    \octave, 4,
    \dur, 0.125/2,
    \amp, 0.3,
    \fb, 0.8,
    \rel, 0.1,
);
~sinfb.play(out:0);
)
