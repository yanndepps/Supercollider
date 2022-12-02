//~clean.lsf("~/snd/pno")

(
Routine{
    //s.record;
    //1.wait;
    Pdef(0,
        Pseed(2356,
            Pbind(*[
                snd: \pno,
                atk: 15.0,
                hld: 15.0,
                rel: 15.0,
                crv: 0.0,
                bgn: Plprand(0.0, 0.5),
                scale: Pdup(Plprand(999, 9999), Pxshuf([
                    Scale.ionian,
                    Scale.superLocrian,
                    Scale.lydian,
                    Scale.phrygian,
                    Scale.neapolitanMajor,
                    Scale.dorian,
                    Scale.mixolydian,
                    Scale.locrian,
                ], inf)),
                degree: Pdup(Plprand(19, 199), Pwhite(-7, 0)),
                octave: Pdup(Plprand(29, 299), Pwhite(3, 5)),
                //calcFreq: Pfunc{|ev|ev.use{ev.freq.asStringPrec(48).postln}},
                frq: Pfunc{|ev|ev.use{ev.freq}},
                dur: (Pseg(Plprand(30.0, 40.0), Plprand(30.0, 90.0), \wel, inf) / 256
                    / Pkey(\frq).expexp(66, 67, 8, 1)),
                num: Pdup(Plprand(9, 99), Pxshuf((0 .. 3), inf)),
                pan: Pmeanrand(0.0, 1.0),
                amp: Pseg(Plprand(1/4, 1/2), Plprand(30.0, 90.0), \wel, inf),
                cai: Pseg(Phprand(0.1, 1.0), Plprand(30.0, 90.0), \wel, inf),
                cav: 1/3,
                legato: 699.0,
                stretch: Pseed(0, Pseg(Plprand(1.0, 3.0), Plprand(30.0, 90.0), \wel, inf)),
                type: Pfunc {arg event;
                    if (event.dur < 0.02) {
                        [\cln, \rest].choose

                    } {
                        \cln
                    }
                },
                //aux: Pseed(1, Pxshuf((0 .. 10), inf)),
            ])
        )
    ).play;
    (19 * 60).wait;
    Pdef(0).stop;
    240.wait;
    //s.stopRecording
}.play
)