// --- Rhythm : Basic Rhythm Examples --- //

("../Setup/setup.scd").loadRelative;

p.fadeTime = 3;

// basic kick
(
~k = Pbind(
    \instrument, \vplaym,
    \buf, d["sp"][1],
    \rate, 1.0,
    \dur, 2,
    \amp, 0.5,
);
~k.play(out:0);
)

// alternate-beat snare 
(
~sn = Pbind(
    \instrument, \vplaym,
    \buf, d["sp"][5],
    \dur, 0.5,
    \rate, 1.0,
    \amp, 0.5,
);
~sn.play(out:2);
)

// basic hi-hat pattern 
(
~h = Pbind(
    \instrument, \vplaym,
    \buf, d["sb"][0],
    \dur, 1.0,
    \amp, Pwhite(0.25, 0.5),
);
~h.play(out:4);
)

// 3/4 note clap 
(
~c = Pbind(
    \instrument, \vplaym,
    \buf, d["sd"][6],
    \dur, 0.75,
    \rate, 0.5,
    \amp, 0.5,
);
~c.play(out:6);
)

// off-beat open hi-hat 
(
~oh = Pbind(
    \instrument, \vplaym,
    \buf, d["sd"][5],
    \dur, Pseq.new([0.5, Pseq([1], inf)], inf),
    \amp, 0.5,
);
~oh.play(out:8);
)
