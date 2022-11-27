//~clean.lsf("~/snd/bcm")

(
Routine{
    //s.record;
    //1.wait;
    Pdef(0,
        Pseed(9678,
            Pbind(*[
                type: \cln,
                snd: \bcm,
                num: Pwhite(0, 1),
                seg: Pseg([0, 1], 1200, \lin, 1),
                bgn: Pseq([Pwhite(0.0, 0.5, 1), Pwhite(0.5, 1.0, 1)], inf),
                amp: Pseg(Phprand(0.2, 0.4), Plprand(30.0, 90.0), \sin, inf),
                spd: Pdup(Plprand(2, 4),
                    Plprand(1/4, 4.0).round(1 / Pkey(\seg).linlin(0.624, 0.625, 7, 13))).trace,
                atk: Phprand(9.0, 19.0),
                hld: Phprand(9.0, 19.0),
                rel: Phprand(9.0, 19.0),
                dur: Pwhite(1.5, 6.0),
                cav: 1,
                legato: 99,
                //aux: Pseed(0, Pxshuf((0 .. 10), inf)),
            ])
        )
    ).play;
    (19 * 60).wait;
    Pdef(0).stop;
    240.wait;
    //s.stopRecording;
}.play
)