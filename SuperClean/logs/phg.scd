//~clean.lsf("~/snd/phg")

(
Routine{
    //s.record;
    //1.wait;
    Pdef(0,
        Pseed(3626,
            Pbind(*[
                type: \cln,
                snd: \phg,
                dur: Plprand(4.0, 8.0),
                legato: 199,
                spd: Pdup(Plprand(1, 3), Plprand(1/32, 7.0).round(1/12)),
                octave: Pkey(\spd).linlin(1, 1/16, 4, 5),
                lpf: Pkey(\octave).linlin(4, 5, 200, 20000),
                rel: Pkey(\spd).linlin(1/32, 7.0, 180.0, 90.0),
                crv: -4,
                pan: Pwhite(0.0, 1.0),
                amp: (Plprand(0.75, 1.5) / Pkey(\spd).linlin(1/16, 4.0, 1/8, 4)).trace,
                cav: 1/2,
            ])
        )
    ).play;
    (17 * 60).wait;
    Pdef(0).stop;
    240.wait;
    //s.stopRecording;
}.play
)