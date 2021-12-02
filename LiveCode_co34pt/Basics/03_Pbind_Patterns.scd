// --- Basics : Pbind & Patterns --- //

("../Setup/setup.scd").loadRelative;

p.fadeTime = 3;

// have a kick drum playing once each beat in time with the ProxySpace timer :
(
~k = Pbind(
  \instrument, \vplaym,
  \buf, d["sc"][7],
  \pos, 0.3,
  \dur, 1,
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
  \amp, 0.4,
);
~l.play(out:4);
)
