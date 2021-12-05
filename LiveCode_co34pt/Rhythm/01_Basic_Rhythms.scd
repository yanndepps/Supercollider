// --- Rhythm : Basic Rhythm Examples --- //

("../Setup/setup.scd").loadRelative;

p.fadeTime = 3;

// basic kick
(
~k = Pbind(
    \instrument, \bplay,
    \buf, d["k"][0],
    \dur, 1,
    \amp, 0.5,
);
~k.play(out:0);
)

// alternate-beat snare 
(
~sn = Pbind(
    \instrument, \bplay,
    \buf, d["s"][1],
    \dur, 2,
    \amp, 0.5,
);
~sn.play(out:2);
)

// basic hi-hat pattern 
(
~h = Pbind(
    \instrument, \bplay,
    \buf, d["ding"][0],
    \dur, 0.75,
    \amp, Pwhite(0.25, 0.5),
);
~h.play(out:4);
)

// 3/4 note clap 
(
~c = Pbind(
    \instrument, \bplay,
    \buf, d["s"][2],
    \dur, 0.75,
    \amp, 0.5,
);
~c.play(out:6);
)

// off-beat open hi-hat 
(
~oh = Pbind(
    \instrument, \bplay,
    \buf, d["s"][3],
    \dur, Pseq.new([0.5, Pseq([1], inf)], inf),
    \amp, 0.5,
);
~oh.play(out:8);
)
