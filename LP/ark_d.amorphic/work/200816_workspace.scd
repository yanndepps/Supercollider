

// synthdefs

(
SynthDef(\noiSyn, {
	arg out=0, gate=1, amp=0.1, pan=0, relTime=0.5;
	var snd, env, aenv;

	snd = WhiteNoise.ar(0.7);
	aenv = Env.perc(releaseTime:relTime).kr;

	snd = snd * aenv;

	snd = BHiPass.ar(snd, Line.ar(50,20000,relTime*2));
	//snd = HPF.ar(snd, Line.ar(200,10000,relTime));
	
	// this responds favourably to Pbind gate:0 / release
	env = Linen.kr(releaseTime: 0.05, gate: gate, doneAction:Done.freeSelf);
	snd = snd * env;
	snd = snd * amp;
	snd = Pan2.ar(snd, pos:pan);
	//DetectSilence.ar(snd, doneAction:Done.freeSelf);
	Out.ar(out, snd);

}).add;
)



// patterns

TempoClock.tempo = 100/120


Pdef(\noises).play;
Pdef(\noises).stop;

(
Pdef(\noises,
	Ppar([
		Pbind(
			\instrument, \noiSyn,
			\dur, Prand([1/4, Pn(1/8,2)], inf),
			\legato, 0.9,
			\relTime, Pseq([Pseries(0.001,0.01,32)],inf),
			\amp, 0.8
		)]
	)
)
)


s.meter
s.freqscope