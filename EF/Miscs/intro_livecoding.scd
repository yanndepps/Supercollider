// intro to live coding in SC

s.boot;

p = ProxySpace.new.push;

~sig.play;
~sig2.play;

~sig = { SinOsc.ar([440, 443] * -5.midiratio) * 0.2 };

~sig = { SinOsc.ar([440, 443] * 5.midiratio) * -20.dbamp * LFPulse.kr([ 6, 6.1 ], 0, 0.3) };
~sig2 = { SinOsc.ar([440, 443] * -5.midiratio) * -20.dbamp * LFPulse.kr([ 6, 6.1 ], 0, 0.3) };

~sig = { PinkNoise.ar(-20.dbamp!2) };

~sig = nil;

~sig.stop(3);

// full stop and reset
~sig.clear(5);

// crossfade
~sig.fadeTime = 2;
~sig2.fadeTime = 2;

// samples
b = ();
b.put(\drone, Buffer.read(s, "path/to/samples.wav"));

// access that file
b.drone.numChannels;
b.drone.duration;
b.play;

// play a proxy called buf
~buf.play;
~buf.fadeTime = 3;
~buf = { PlayBuf.ar(1, b.drone, -2.midiratio, loop:1) * -12.dbamp!2 };

// send a clear message to the proxy space itself
p.clear(8);

// -------------------------------------------------------------------- //
