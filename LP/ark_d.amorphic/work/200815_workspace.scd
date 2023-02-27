


( // "LFTri bass drum kick" - by luka@lukaprincic.si
SynthDef(\tribd, {
	arg out=0, gate=1, freq=77, amp=0.1;
	var snd, aenv, fenv, senv;

	fenv = Env(levels:[2, 1, 0], times: [0.1, 0.5]).kr;
	freq = freq * fenv;
	freq = freq.max(10);

	snd = LFTri.ar(freq) + SinOsc.ar(freq) + Pulse.ar(freq*2, mul:0.1);
	snd = LPF.ar(snd, freq * 3);

	snd = snd + RLPF.ar( BrownNoise.ar(0.15),
		Env(levels:[2000,500,90], times:[0.01,0.05]).kr, 0.3 );

	snd = snd + ( BPF.ar(WhiteNoise.ar(0.1), 3000) 
		* Env([1,1,0], [0.004,0.005]).kr );
	snd = snd + ( BPF.ar(WhiteNoise.ar(0.1), 9000) 
		* Env([1,1,0], [0.002,0.002]).kr );
	
	aenv = Env([1,1,0], [0.2,2], curve: -9).kr;
	snd = snd * aenv;
	
	senv = Linen.kr(releaseTime: 0.1, gate: gate, doneAction: Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd * amp * senv;
	snd = Pan2.ar(snd, pos:0);
	Out.ar(out, snd);
}).add;
)


TempoClock.tempo = 140/120

(
Pdef(\beat,
	Ppar([
		Pbind(
			\instrument, \tribd,
			\dur, Pseq([1+1/4,1,1/4],inf),
			\note, Prand([1,2,3] * 0.1, inf) + 1,
			//\freq, 77,
			\octave, 3,
			\amp, 0.15
		),
		Pbind(
			\instrument, \sc808sn,
			\dur, Pseq([Rest(1),1],inf),
			\amp, 0.1
		),
		Pbind(
			\instrument, \sc808hh,
			\dur, Pwrand([
				Pseq([1/4,1/4]),
				Pseq([1/8],4),
				Pseq([1/16],4),
				Pseq([1/6],3)
			], [0.4,0.4,0.2,0.2], inf),
			\amp, Prand([0.05,0.04,0.06],inf)
		),
		Pbind(
			\instrument, \sc808hh,
			\dur, Pseq([1/8], inf),
			\amp, 0
		)
	])
)
)

Pdef(\beat).play
Pdef(\beat).quant(8)

TempoClock.stop
TempoClock.play
TempoClock.tempo = 140/120



(// plot it!
{
	arg out=0, gate=1, freq=77, amp=1;
	var snd, aenv, fenv, senv;

	fenv = Env(levels:[2, 1, 0], times: [0.1, 1]).kr;
	freq = freq * fenv;
	freq = freq.max(10);

	snd = LFTri.ar(freq, mul:amp/2) + SinOsc.ar(freq, mul:amp/2);
	snd = LPF.ar(snd, freq * 4);

	snd = snd + RLPF.ar(
		BrownNoise.ar(0.2),
		Env(levels:[2000,500,90], times:[0.01,0.05]).kr, 0.3 );

	snd = snd + (
		BPF.ar(WhiteNoise.ar(0.1), 9000) 
	* Env([1,1,0], [0.004,0.005]).kr
		
	);
	aenv = Env([1,1,0], [0.2,2], curve: -9).kr;
	snd = snd * aenv;
	
	senv = Linen.kr(releaseTime: 0.1, gate: gate, doneAction: Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd * amp * senv;
	snd = Pan2.ar(snd, pos:0);
}.plot(2);
)

























({ // sound is fine despite steep release slope
var snd, env;
snd = LFTri.ar(80);
env = Env.linen(0,0.1,0.01).ar(doneAction:2);
snd = LPF.ar(snd,30); // filter BEFORE applying envelope
snd = snd * env;
snd!2
}.play)


({ // steep release and LPF after env produces click
var snd, env;
snd = LFTri.ar(80);
env = Env.linen(0,0.1,0.01).ar;
//env = Env.linen(0,0.1,0.01).ar(doneAction:Done.freeSelf);
snd = snd * env;
snd = LPF.ar(snd,30); // filter AFTER applying envelope
DetectSilence.ar(snd, doneAction:Done.freeSelf);
	snd!2
}.play)
