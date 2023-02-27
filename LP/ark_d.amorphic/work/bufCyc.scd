
(
// function to partially match filename for buffers
~getSmp = { |regexp|
    ~smpBuffers.detect { |buf|
        regexp.matchRegexp(buf.path)
    }
};
)

(
SynthDef(\bufCyc, {
    arg bufnum, gate=1, freq=440, chanDetune=1, out=0, amp = 1,
    attackTime=0.01, releaseTime=1, fltfact = 1;
    var snd, env;
    
    env = Linen.kr(gate, attackTime:attackTime, releaseTime:releaseTime, doneAction:2);

    freq = [freq, freq * (1 + (chanDetune * 0.0005))];
    
    snd = BufRd.ar(
        numChannels: 1,
        bufnum: bufnum,
        phase: LFSaw.ar(freq).range(0, BufFrames.ir(bufnum)),
        loop: 1,
        interpolation: 2);

    snd = (snd * 0.5) + (snd.clip2(0.3) * 2);

    snd = RLPF.ar(snd, (freq * fltfact).min(20000), rq: 0.3).clip2(1.0.linrand+0.8);

    snd = snd * amp * env;
	
    Out.ar(out, snd); 
}).add;
)

Pdef(\x32).play
Pdef(\x32).fadeTime = 0;

(
Pdef(\x32,
    Pbind(
        \instrument,    \bufCyc,
        \bufnum,        [~getSmp.value("0229"),~getSmp.value("0246")],
        
        \dur,           Pseq([0.20, 0.40, 0.60, Prand([0.20,0.60]), Prand([Pseq([0.10,0.10]), Pseq([0.30,0.10])])], inf) ,
        \degree,        Pseq([ 2, 2, 4, 1 ], inf),
        
        \mtranspose,    Pseq([  Pn([0], 10 ),
                                Pn([1],  5 ),
                                Pn([0], 10 ),
                                Pn([3],  4 ) ], inf),

        \ctranspose,    Pseq([ Pn([0], 50 ),
                               Pn([5],  5 ) ],inf),

        \octave,        [3, 2, 4],
        \amp,           [0.3, 0.5, 0.1] * 0.6,

        \detune,        [0.2, 0],
        \chanDetune,    30,
        \legato,        Prand([0.8,0.6,0.4],inf),
        \releaseTime,   0.01,
        \fltfact,       Prand([9,15,12,7],inf)
    ));
)

// cleaning up
Pdef(\x32).clear
Pdef(\x32).free

Pdef(\x33).play
Pdef(\x33).fadeTime = 0;
(
Pdef(\x33,
    Pbind(
        \instrument,    \bufCyc,
        \bufnum,        [~getSmp.value("0246"),~getSmp.value("0229")],

        \dur,           Pseq([  0.20,
                                0.40,
                                Prand([0.60,0.20]),
                                0.10,
                                0.10,
                                Prand([ Pseq([0.13,0.07]), Pseq([0.30,0.10]) ])
                        ], inf),

        \degree,        Pseq([ [4,9], 2, 8, 4, 1], inf),
        \mtranspose,    Pseq([ Pn([0],10), Pn([3],10), Pn([0],10), Pn([5],5), Pn([7],2) ], inf),
        \ctranspose,    Pseq([ Pn([0],50), Pn([5],10) ], inf),

        \octave,        [4,5,6],
        \legato,        Prand([0.1,0.3,0.2,0.4],inf),
        \releaseTime,   Prand([0.1, 0.01, 0.02, 0.03, 0.05, 0.09],inf),
        \fltfact,       Prand([2,20,9],inf),
        \amp,           [0.7,0.5,0.1] * 0.2,
        \detune,        [0,0.3,-0.3],
        \chanDetune,    Pseq([-10,0,5,10,-5],inf),
    ));
)

Pdef(\x35).play
Pdef(\x35).fadeTime = 0;
(
Pdef(\x35,
    Pbind(
        \instrument,    \bufCyc,
        \bufnum,        [~getSmp.value("0246"),~getSmp.value("0229")],

        \dur,           Pseq([  0.20,
                                0.10,
                                Prand([0.10,0.20]),
                                0.10,
                                0.10,
                                Prand([ Pseq([0.13,0.07]),
                                        Pseq([0.30,0.10]) ])
                        ], inf),

        \degree,        Pseq([ [4,9], 2, 8, 4, 1 ], inf),
        \mtranspose,    Pseq([ Pn([0],10), Pn([3],10), Pn([0],10), Pn([5],5), Pn([7],2) ], inf),
        \ctranspose,    Pseq([ Pn([0],50), Pn([5],10) ], inf),
        \octave,        5,

        \detune,        [0, 0.3, -0.3],
        \chanDetune,    Pseq([ -10, 0, 5, 10, -5 ], inf),
        \legato,        Prand([ 0.1, 0.05 ], inf),
        \amp,           [0.7, 0.5, 0.1] * 0.1,
        \fltfact,       Prand([ 2, 5 ], inf),
        \releaseTime,   Prand([ 0.01, 0.02, 0.05, 0.09 ], inf)
    ));
)
