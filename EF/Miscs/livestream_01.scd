

(
SynthDef.new(\tone, {
	arg nn=60, amp=0.1, panHz=1, out=0;
	var sig;
	sig = SinOsc.ar(nn.midicps, 0, amp);
	sig = Pan2.ar(sig, SinOsc.kr(panHz));
	Out.ar(out, sig);
}).add;
)

(
SynthDef.new(\binaural, {
	arg freq=500, beatHz=0, amp=0.1, out=0;
	var sig;
	sig = SinOsc.ar([freq, freq+beatHz], 0, amp);
	Out.ar(out, sig);
}).add;
)


Synth.new(\tone, [\nn, 62, \amp, 0.05, \panHz, 2]);
Synth.new(\binaural, [\freq, 60.midicps, \beatHz, 2,  \amp, 0.04]);

// {SinOsc.ar(500, 0, 0.1)}.play
// 60.midicps
// [69, 72].midicps
// {CombN.ar(SoundIn.ar(0), 0.2, 0.2, 0)}.play

