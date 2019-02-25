s.boot;

b = Buffer.loadDialog;

[b.bufnum, b.numChannels, b.path, b.numFrames]

b.play;

// 768000/44100

{PlayBuf.ar(2, b, LFNoise0.kr(0.5, 3))}.play;

{PlayBuf.ar(2, b, 1.0, Impulse.kr(1), MouseX.kr(0, b.numFrames))}.play;

// envelopes

{WhiteNoise.ar}.plot(1);

{WhiteNoise.ar}.plot(0.001);

{WhiteNoise.ar*EnvGen.kr(Env.linen(0.1, 0.6, 0.1))}.plot(1);

{WhiteNoise.ar*EnvGen.kr(Env.linen(0.1, 0.6, 0.1), Impulse.kr(1))}.play;