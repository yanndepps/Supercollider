//~clean.lsf("~/snd/thb");

(
Routine{
    //s.record;
    //1.wait;
    Pdef(0,
        Pseed(2883,
            Ppar([
                Pbind(*[
                    type: \cln,
                    snd: \thb,
                    num: Pxshuf((0 .. 3), inf),
                    bgn: Pwhite(0.0, 1.0),
                    atk: Plprand(30.0, 100.0),
                    hld: Pmeanrand(30.0, 100.0),
                    rel: Phprand(30.0, 100.0),
                    crv: Pdup(Pseq([1, 1, inf], 1), Pseq([8, 4, 2], 1)),
                    amp: Pseq([0.33, Pdup(Pwhite(1, 8), Plprand(0.33, 0.88))], inf),
                    dur: (300 / Phprand(1.0, 9.0)),
                    pan: Pseq([1, Pmeanrand(0.0, 1.0)], inf),
                    cav: 1.5,
                    cai: Pseg([0, 1, 0.5], 560, \wel, inf),
                    spd: Plprand(Pkey(\cai).linlin(0.0, 1.0, 0.5, 0.33), Pkey(\cai).linlin(0.0, 1.0, 2.0, 1.0)),
                    bnd: Pmeanrand(Pkey(\cai).linlin(0.0, 1.0, 0.0, -1.0), Pkey(\cai)) / 10,
                    bno: Pkey(\atk) + Pkey(\hld) + Pkey(\rel) / 2,
                    bnt: Pkey(\atk) + Pkey(\hld) + Pkey(\rel) / 2,
                    sustain: 300,
                    legato: 300,
                ]),
                Pbind(*[
                    type: \cln,
                    snd: \sin,
                    amp: 0,
                    dur: 1/99,
                    cav: 0.75,
                    cai: Pseg([0, 1, 0.5], 560, \wel, inf).trace,
                ])
            ])
        )
    ).play;
    1050.wait;
    Pdef(0).stop;
    240.wait;
   // s.stopRecording;
}.play
)