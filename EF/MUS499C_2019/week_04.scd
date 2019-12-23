// Week 04 : Audio Coding With SC
s.boot;
s.scope;
// s.freqscope;

// Filters
// LPF
// make sure the cutoff stays between 20 and 20000 Hz !
(
    {
        var sig;
        sig = PinkNoise.ar(0.5!2);
        // sig = LPF.ar(sig, 500);
        sig = LPF.ar(sig, MouseX.kr(30,18000,1));
    }.play;
)

// n hertz sinewave ranging n to n used to control the cutoff frequency of the LPF

(
    {
        var sig;
        sig = PinkNoise.ar(0.5!2);
        // sig = LPF.ar(sig, 500);
        sig = LPF.ar(sig, SinOsc.kr(8).exprange(500, 5000));
    }.play;
)

// HPF
(
    {
        var sig;
        sig = Saw.ar([60,61], 0.3);
        sig = HPF.ar(sig, SinOsc.kr(0.2).exprange(50, 500));
    }.play;
)

// BPF : rq = (bandwith/cutoffFreq)
// a quality of 1 is the wildest possible band, as the quality 
// increases the band gets narrower.
// the value of rq is supposed to stand between 0 and 1, never 0.
// increase the quality by lowering the rq value
(
    {
        var sig;
        sig = Saw.ar([60,61], 0.3);
        sig = BPF.ar(sig, SinOsc.kr(0.2).exprange(50, 500), 0.01);
        sig = sig * 5;
    }.play;
)

// lowering the rq value, we lose amplitude and need to compensate
(
    {
        arg rq = 0.5;
        var sig;
        sig = Saw.ar([60,61], 0.3);
        sig = BPF.ar(sig, SinOsc.kr(0.2).exprange(50, 500), rq, 1/rq.sqrt);
    }.play;
)

// 1/0.5.sqrt;
// see also RLPF, RHPF

// Buffer
b = Buffer.read(s, "/Users/yanndepps/Documents/Musik/samplz/Dirts/CL_TH/110\ I\ Modular\ A_A1_.wav");

b.play;

// query some informations about our soundfile
b.duration;
b.numChannels;
b.sampleRate;
// duration*sampleRate : numFrames -> how many individual samples are in this file
// all of the samples at that vertical frame.
b.numFrames;

// Buffer UGen
Buffer.freeAll;

~cluster = Buffer.read(s, "/Users/yanndepps/Documents/Musik/samplz/Dirts/FuckBox/Ghost\ Siren\ C1.wav");

~cluster.duration;

(
    x = {
        arg t_trig = 1;
        var sig;
        sig = PlayBuf.ar(
            2,
            ~cluster,
            // BufRateScale.kr(~cluster) * 0.5,
            // .ir calculates the value once, if u do not plan to hot swap buffers
            BufRateScale.ir(~cluster) * 0.5,
            t_trig,
            ~cluster.numFrames * 0.0,
            0,
            doneAction:2
        );
    }.play;
)

x.free;

// wrap all in a SynthDef
(
    SynthDef.new(\bufplay,
        {
            // which buffer are we going to play, make it modular
            arg buf=0, rate=1, atk=0.001, rel=8, spos=0, amp=1, da=2, out=0;
            var sig, env;
            env = EnvGen.kr(
                Env.new([0,1,0], [atk,rel], [1,-1]),
                doneAction: da
            );
            sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, startPos:spos);
            sig = sig * env * amp;
            Out.ar(out, sig);
        }
    ).add;
)

Synth.new(
    \bufplay, 
    [
        \buf, ~cluster, 
        \at, exprand(0.001,1),
        \rel, rrand(5,8),
        \spos, rrand(0,~cluster.numFrames*0.1),
        \rate, rrand(0.5,2),
        \amp, exprand(0.2, 1)
    ]
);

// using midiration to transpose by semitones
Synth.new(
    \bufplay, 
    [
        \buf, ~cluster, 
        \atk, 0.001, 
        \rel, 8,
        \spos, ~cluster.numFrames*0.0,
        \rate, -2.midiratio,
        \amp, exprand(0.2, 1)
    ]
);

// random chances
Buffer.freeAll;

~cl1 = Buffer.read(s, "/Users/yanndepps/Documents/Musik/samplz/Dirts/CL_FL/110\ Karl\ Popper\ A_A1_.wav");

~cl2 = Buffer.read(s, "/Users/yanndepps/Documents/Musik/samplz/Dirts/CL_FL/110\ Hubris\ B_A1\ _.wav");

~cl3 = Buffer.read(s, "/Users/yanndepps/Documents/Musik/samplz/Dirts/FuckBox/Ghost\ Siren\ C1.wav");

~cl4 = Buffer.read(s, "/Users/yanndepps/Documents/Musik/samplz/Dirts/CL_FL/130\ Anthony\ Burgess\ D_C1.wav");

(
    SynthDef.new(\bufplay,
        {
            // which buffer are we going to play, make it modular
            arg buf=0, rate=1, atk=0.001, rel=8, spos=0, amp=1, da=2, out=0;
            var sig, env;
            env = EnvGen.kr(
                Env.new([0,1,0], [atk,rel], [1,-1]),
                doneAction: da
            );
            sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, startPos:spos);
            // Filters ???
            sig = sig * env * amp;
            Out.ar(out, sig);
        }
    ).add;
)


(
    var which;
    which = [~cl1, ~cl2, ~cl3, ~cl4].choose;
    Synth.new(
        \bufplay, 
        [
            \buf, which, 
            \atk, 0.001, 
            \rel, 8,
            \spos, which.numFrames*0.0,
            \rate, rrand(-2,2).midiratio,
            \amp, exprand(0.2, 1)
        ]
    );
)

// Instead of manually running it :
(
    r = {
        {
            var which, frmult;
            which = [~cl1, ~cl2, ~cl3, ~cl4].choose;
            frmult = rrand(-0.5, 0.5);
            Synth.new(
                \bufplay, 
                [
                    \buf, which, 
                    \atk, exprand(0.01,2), 
                    \rel, exprand(5,8),
                    \spos, which.numFrames*frmult,
                    \rate, [-12, -7, -5, -2, 0, 2, 4, 7, 9].choose.midiratio,
                    \amp, exprand(0.2, 1)
                ]
            );
            exprand(0.1,2).wait;
        }.loop;
    }.fork;
)

// End
