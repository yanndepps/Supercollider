// 

s.boot;

(
Ndef(\alone, { arg amp=0.5;
        var source, local, lfo;

        lfo = LFNoise1.kr(0.32).abs*50+[70,0.01];
        source = Decay.ar(Impulse.ar(lfo), 0.1) * WhiteNoise.ar(0.2);
        source = source * [LFNoise1.ar(0.17,0.4,1.1), LFNoise1.ar(0.57,1,1)];
        source = source;

        local = LocalIn.ar(2) + source;

        local = LPF.ar(local, 400 + LFNoise1.kr(0.1,300,100)) * 1.5;
        local = HPF.ar(local, 100 + LFNoise1.kr(0.15,050,050)) * 1.0;
        local = DelayN.ar(local, 0.2, 0.1);

        local = Limiter.ar(local.reverse,0.5);
        LocalOut.ar(local * 0.6);
        local = [local, Decay.ar(Impulse.ar(LFNoise1.kr(2.12).exprange(2,400)), 0.2 + LFNoise1.kr(0.11,0.1)) * local];
        local = FreqShift.ar(local, LFNoise1.kr(LFNoise1.kr(0.21).exprange(0.1,5)).exprange(0.1,500));
        local = HPF.ar(local, LFNoise1.kr(0.4).range(50,170), LFNoise1.kr(0.1).range(0.1,0.7));

        Splay.ar(local, LFNoise1.kr(0.21).range(0,1)) * amp;
}).play;
)
