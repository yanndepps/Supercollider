// recoded live stream from mads kjeldgaard
// SynthDef and Patterns

s.boot;

// synth

( 
  SynthDef.new(\depps, {
    |freq = 444, amp = 0.25, pan = 0, dur = 1, out = 0, atk = 0.1, rel = 0.9|
    var sig, env;

    env = EnvGen.kr(
      Env.perc(atk, rel),
      gate: 1.0,
      timeScale: dur,
      doneAction: 2,
    );

    sig = LFTri.ar(freq);

    // scale signal by env
    sig = sig * env;
    // volume control
    sig = sig * amp;
    // pan the signal
    sig = Pan2.ar(sig, pan);

    Out.ar(out, sig);
  }).add; 
)

// pattern

(
  Pdef(\d, 
    Pbind(
      \instrument, \depps,
      \dur, 0.5 * Pseq([0.25, 0.5, Rest(0.5), 1], inf),
      \degree, Pseq([0, 4, 5], inf),
      \release, 1.5,
      \octave, 3,
      \pan, Pwhite(-1.0, 1.0),
    )
  ).play;
)

// --- END --- //
