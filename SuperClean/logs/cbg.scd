//~clean.lsf("~/snd/cbg");

(
var scales = Pseed(0, 
    Pxshuf([
        Scale.augmented,
        Scale.bartok,
        Scale.minor,
        Scale.harmonicMinor,
        Scale.mixolydian
    ], inf)
).asStream;

Routine{
    //s.record;
    //1.wait;
    Pdef(0,
        Pseed(1240,
            Pbind(*[
                type: \cln,
                snd: \cbg,
                num: Pdup(Plprand(1, 15), Phprand(0, 16)),
                dur: Plprand(1.0, 8.0) * 3,
                bgn: Plprand(0.0, 0.5),
                tun: Pdup(Plprand(10, 20), Pxshuf([
                    Tuning.pythagorean, 
                    Tuning.just, 
                    Tuning.sept1, 
                    Tuning.sept2, 
                    Tuning.vallotti,
                    Tuning.wcSJ,
                ], inf)),
                scale: Pdup(Plprand(10, 20), Pfunc {|ev| 
                    var scale = scales.next;
                    scale.tuning = ev[\tun];
                    "% : %".format(scale.name, scale.tuning.name).debug('scale');
                    scale;
                }),
                degree: Pdup(Plprand(10, 20), Plprand(0, 7)),
                octave: Pdup(Plprand(10, 20), Pmeanrand(3, 5)),
                mtranspose: Pdup(Plprand(111, 222), Plprand(-5, 2)),
                calcFreq: Pfunc{|ev|ev.use{ev.freq.asStringPrec(48).postln}},
                frq: Pfunc{|ev|ev.use{ev.freq}},
                legato: 999,
                sustain: 999,
                atk: Plprand(9.0, 15.0) * 2,
                hld: Plprand(11.0, 17.0) * 2,
                rel: Plprand(7.0, 13.0) * 4,
                crv: Phprand(2.0, 6.0),
                pan: Pdup(Plprand(1, 2), Pmeanrand(0.0, 1.0)),
                amp: (Pseg(Plprand(1/3, 1/2), Plprand(15.0, 115.0), \wel, inf) 
                    / Pkey(\frq).expexp(130, 523, 0.75, 1.0) * Pkey(\num).linexp(0, 23, 1, 3) / 3).trace,
                cav: 2/3,
                cai: Pseg(Phprand(0.0, 1.0), Phprand(90.0, 180.0), \wel, inf),
                //aux: Pseed(0, Pxshuf((0 .. 10), inf),
            ])
        )
    ).play;
    (19 * 60).wait;
    Pdef(0).stop;
    240.wait;
    //s.stopRecording
}.play
)
)