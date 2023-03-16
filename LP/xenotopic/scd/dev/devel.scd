


SynthDef(\phpHatSnare,
	{
		arg gate = 1, amp = 0.1, pan = 0, outBus = 0,
		rls = 1, rls1 = 0.01,  lpa = 1, hpa = 1, bpa = 1;
		var snd;

		snd = WhiteNoise.ar;
		snd = snd + (Pulse.ar(freq: Rand(5000!10, 15000)).sum * 0.2);
		snd = (
			LPF.ar(snd, Rand(1500,3000)) * lpa * 4
			* LFSaw.ar(LFNoise1.ar(1/3).range(15,30)).range(LFNoise1.ar(1).range(0.5,0.9), 1)
			* EnvGen.ar(Env.perc(0, rls), gate) )
		+ (
			HPF.ar(snd, Rand(5000,9000)) * hpa
			* LFSaw.ar(LFNoise1.ar(1/3).range(15,30)).range(LFNoise1.ar(1).range(0.5,0.9), 1)
			* EnvGen.ar(Env.perc(0, rls), gate) )
		+ (
			BPF.ar(snd, Rand(1000,5000), 0.2) * bpa * 4
			* LFSaw.ar(LFNoise1.ar(1/3).range(15,30)).range(LFNoise1.ar(1).range(0.5,0.9), 1)
			* EnvGen.ar(Env.perc(0, Rand(0.1, rls)), gate) )
		;
		snd = HPF.ar(snd, 200);
		snd = LPF.ar(snd, 13000);
		snd = snd * EnvGen.kr(Env.cutoff(rls), gate, doneAction:Done.freeSelf);
		snd = Pan2.ar(snd, pan);
		snd = snd * amp;

		OffsetOut.ar(outBus, snd);
	}
).add;

SynthDef(\phpKick, {
	arg
	//Standard Values
	out = 0, pan = 2, amp = 0.4, curve = -4,
	//tone1 arguments
	t1freq = 400, t1harmonic = 2, t1glide = 0.01,
	t1att = 0.0005, t1rel = 0.01, t1curve = -4, t1del = 0, t1amp = 1,
	//tone2 arguments
	t2freq = 50, t2harmonic = 3.44, t2glide = 0.01,
	t2att = 0.0001, t2rel = 0.3, t2curve = \lin, t2del = 0.005, t2amp = 1,
	//hit1 arguments
	h1freq = 100, h1harmonic = 8, h1glide = 0.01, h1rq = 0.6,
	h1att = 0.001, h1rel = 0.02, h1curve = -4, h1del = 0.001, h1amp = 1,
	//hit2 arguments
	h2freq = 1320, h2harmonic = 1, h2glide = 0,
	h2att = 0.003, h2rel = 0.03, h2curve = -4, h2del = 0, h2amp = 0.5,
	//click arguments
	cfreq = 6100, crq = 1, camp = 1.41;

    var snd, noise, tone1, tone2, hit1, hit2, click;

	noise = Hasher.ar(Sweep.ar); //deterministic white noise

    tone1 = SinOsc.ar(
		freq: XLine.ar(start: t1freq * t1harmonic, end: t1freq, dur: t1glide),
		mul: Env.perc(attackTime: t1att, releaseTime: t1rel, level: t1amp, curve: t1curve).delay(t1del).ar);

	tone2 = SinOsc.ar(
		freq: XLine.ar(start: t2freq * t2harmonic, end: t2freq, dur: t2glide),
		mul: Env.perc(attackTime: t2att, releaseTime: t2rel, level: t2amp, curve: t2curve).delay(t2del).ar);

    hit1 = BPF.ar(
		in: noise,
		freq: XLine.ar(start: h1freq * h1harmonic, end: h1freq, dur: h1glide),
		rq: h1rq,
		mul: Env.perc(attackTime: h1att, releaseTime: h1rel, level: h1amp, curve: h1curve).delay(h1del).ar);

	hit2 = HPF.ar(
		in: noise,
		freq: XLine.ar(start: h2freq * h2harmonic, end: h2freq, dur: h2glide),
		mul: Env.perc(attackTime: h2att, releaseTime: h2rel, level: h2amp, curve: h2curve).delay(h2del).ar);

	click = BPF.ar(
		in: Impulse.ar(0) * SampleRate.ir / 48000,
		freq:  cfreq,
		rq: crq,
		mul: camp);

	snd = Mix.ar(tone1 + tone2 + hit1 + hit2 + click).tanh * amp;

	DetectSilence.ar(in: snd, doneAction: 2);

	OffsetOut.ar(out, Pan2.ar(snd, pan));
},
	metadata: (
		credit: "originals by Nathan Ho aka snapizz",
		category: \drums,
		tags: [\bass]
	)
).add;







///////////////////////////////////////////////////////////////////////////////////////////////////////


(
Pbindef(\phpSnareP, *[
	instrument: 'phpHatSnare',
	//dur: Pseq([3,3,Prand([2,3],inf)] * (1/4), inf),
	dur: Pseq([
		Pseq([Rest(2),3,3] * (1/4),3),
		Pseq([3/8,3/8,2/8]),2],inf),
	rls: 0.3,
	amp:0.3,
	bpa: 0,
	lpa: 2,
	hpa: 3,
	legato:0.1,
	outBus: ~satBus
]);

Pbindef(\phpHiHatP, *[
	instrument: 'phpHatSnare',
	dur:
	Pseq([
		Pn(1/2,16),
		Prand([Pn(1/2,2),Pn(1/4,8)], 8),
		Pseq([Prand([1,2]),2,Prand([1,3,Pn(1/2,2)])] * 0.25, 12),
		Pseq([ Pn(1/4,16), Pn(1/8,12)], 16)
	],inf),
	rls: Pwrand([0.02, 0.2], [0.9,0.1], inf),
	bpa: 0,
	lpa: 0,
	hpa: 2,
	amp: Prand([0.5,0.7],inf),
	legato:0.1,
	pan: Pwhite(-0.2,0.2),
	outBus: ~satBus,
	//	outBus: 0,
]);

Pbindef( \phpKickP,
	\instrument, \phpKick,
	\dur,
		Prand([
			Pseq([1,2,1,1/4]),
			Pseq([1,2,2,1/4]),
			Pseq([Pn(1/4,2),3/4,3/4,2/4]),
			Pseq([Pn(1/4,1),3/4,3/4,2/4]),
			Pseq([3/4,3/4,2/4]),
			Pseq([3/4,3/4,2/4,3/4]),
			Pseq([3/8,3/8,2/8]),
		], inf),
	//\dur, 1,
	//\dur, Pseq([3/4,3/4,2/4],inf)*0.5,
	\t1freq,     200, //Pseq([400,    161,    800],    3),
	\t1curve, \lin, //Pwhite(-4,1),
	\t1curve, Pwhite(-4,1),
	\t2curve, \lin, //Pwhite(-4,1),
	\t2curve, Pwhite(-4,1),
	\t2freq, Pwhite(49,53,inf),
	\t2del, 0.001,
	\t2glide, Pwhite(0.03,0.1, inf),
	\amp, 1.5,
	\out, ~satBus
);

Pbindef(\lcmnoip,
	\instrument, \lcmnoise,

		\dur, Pseq([
		Pseq([20
		Prand([Pseq([0.01,0.01]),0.02]),
		Pn(0.05,19),
		9.03
		], 20), // 20 x 10
		30]),

	\dur, 8,
	\amp, 0.7,
	\amp1, 0, //Pseq([1,0.1],inf),
	\amp2, 0.7, //Pseq([0.6,1],inf),
	\legato, 1,
	\out, 0,
)
)
///////////////////////////////////////////////////////////////////////////////////

(
// fx on the bus !!
~saturator.free;
~saturator = Synth(\saturator, [\inBus, ~satBus]);
~saturator.set(\amplag, 1, \amp, 0.7)
)
TempoClock.tempo = 60/60;

Pbindef(\phpHiHatP).play(quant:4);
Pbindef(\phpKickP).play(quant:4);
Pbindef(\phpSnareP).play(quant:4);
Pbindef(\lcmnoip).play(quant:4);

// fx controls
~saturator.set(\amplag, 2, \amp, 1.5)
~saturator.set(\amplag, 5, \amp, 0.7)
~saturator.set(\amplag, 30, \amp, 0)

// random
~saturator.set(\revtime, rrand(0.01,5), \earlyreflevel, rrand(0.01,1))

~saturator.set(\taillevel, 1)
~saturator.set(\taillevel, 0)
~saturator.set(\earlyreflevel, 0.5)
~saturator.set(\earlyreflevel, 0.1)
~saturator.set(\earlyreflevel, 0.3)
~saturator.set(\earlyreflevel, 0)
~saturator.set(\revtime, 1)
~saturator.set(\revtime, 3)
~saturator.set(\revtime, 0.1)
~saturator.set(\revtime, 0.01)

(
Pbindef(\phpHiHatP).stop;
Pbindef(\phpKickP).stop;
Pbindef(\phpSnareP).stop;
Pbindef(\lcmnoip).stop;
)

Pdef(\phpHiHatP).clear;
Pdef(\phpKickP).clear;
Pdef(\phpSnareP).clear;
Pdef(\lcmnoip).clear


///////////////////////////////////////////////////////////////////////////////////////



SynthDef(\harpsi, {
	arg outbus = 0, freq = 440, ffreq = 2, amp = 1, gate = 1, release = 1;
	var out;
	freq = freq * rrand(1, 1.01);
	out = EnvGen.ar(Env.adsr(releaseTime:release), gate, doneAction: Done.freeSelf)
	* amp * Pulse.ar([freq,freq*1.006]/1, 0.25, 0.75);
	out = RLPF.ar(out, freq * (ffreq / 4) + 1 );
	Out.ar(outbus, out);
}).add;



( // then run this - sequence
TempoClock.default.tempo = 1.4;
~scale = Scale.new(#[0,2,4,5,7,8,10],tuning: \pythagorean, name: "mixolydianb6");
p = Pbind(
	\instrument, \harpsi,
	\root, -12,
	\scale, ~scale,
	//	\ffreq, Pseq(((1..2) ++ (3..1)),inf),
	\ffreq, Pfunc { ~filterFreq },
	//\ffreq, 30,
	\degree, Pseq([
		Pseries({ rrand(0, 7) }, { ([1,2]).choose }, { rrand(4, 8) }),
		Pseries({ rrand(0, 7) }, {([1,2]).choose}, { rrand(4, 8) }),
		Pseries({ rrand(7, 14) }, 0-{([1,2]).choose}, { rrand(4, 8) })
	], inf),
	\release, Prand([5,6,7,8],inf),
	\dur, Prand((1..8)/4, inf),
	//	\amp, Prand(((1..8)/8)+1, inf),
	\amp, 0.6,
	\sendosc, Pfunc(
		{(
			~imgID = (~imgID + 1) % 9;
			~osc.sendMsg("/ctlin", 74, ~imgID.asInt);
			~imgID.postln;

		)
		},
		{"reseted".postln}),
).play;
)
~osc.sendMsg("/ctlin", 85, 7);





SynthDef('mhh1',
	{
		arg gate = 1, amp = 0.1, pan = 0, outBus = 0,
		rls = 1, rls1 = 0.01,  lpa = 1, hpa = 1, bpa = 1;
		var snd;

		snd = WhiteNoise.ar;
		snd = snd + (Pulse.ar(freq: Rand(5000!10, 15000)).sum * 0.2);
		snd = (
			LPF.ar(snd, Rand(500,2000)) * lpa * 4
			* LFSaw.ar(LFNoise1.ar(1/3).range(15,30)).range(LFNoise1.ar(1).range(0.2,0.9), 1)
			* EnvGen.ar(Env.perc(0, Rand(0.1, rls)), gate) )
		+ (
			HPF.ar(snd, Rand(2000,15000)) * hpa
			* LFSaw.ar(LFNoise1.ar(1/3).range(15,30)).range(LFNoise1.ar(1).range(0.2,0.9), 1)
			* EnvGen.ar(Env.perc(0, Rand(0.1, rls)), gate) )
		+ (
			BPF.ar(snd, Rand(1000,5000), 0.2) * bpa * 4
			* LFSaw.ar(LFNoise1.ar(1/3).range(15,30)).range(LFNoise1.ar(1).range(0.2,0.9), 1)
			* EnvGen.ar(Env.perc(0, Rand(0.1, rls)), gate) )
		;
		snd = HPF.ar(snd, 200);
		snd = LPF.ar(snd, 13000);
		snd = snd * EnvGen.kr(Env.cutoff(rls), gate, doneAction:Done.freeSelf);
		snd = Pan2.ar(snd, pan);
		snd = snd * amp;

		Out.ar(outBus, snd);
	}
).add;

SynthDef(\kick,
	{
		arg gate = 1, out = 0, amp = 0.1, release = 0.9, freq=50, pan = 0, cutoff = 500, fxout=0, hpf=0;
		var snd, env, fenv;

		freq = freq * Rand(0.98, 1.02);
		fenv = EnvGen.ar(Env([freq*4,freq],0.08,'cub'));
		snd = SinOsc.ar(freq: [fenv,fenv*2], mul:[1,0.4] ).sum;
		snd = snd * LFPulse.ar(24).range(0.7,1).lag(0.02);
		snd = snd + WhiteNoise.ar(0.8);
		snd = snd + SinOsc.ar(freq: [freq*2,freq*4], mul:EnvGen.ar(Env.perc(0, 0.2)) * 0.5).sum;
		snd = snd + LFTri.ar(freq: freq*4, mul:EnvGen.ar(Env.perc(0, 0.5)) * 0.3);
		snd = RLPF.ar(snd, cutoff, 0.7);
		snd = HPF.ar(snd, hpf);
		snd = snd.softclip;
		snd = snd * EnvGen.ar(Env.adsr(0, 0.05, 0.4, release, curve:'sqr'), gate: gate, doneAction:Done.freeSelf);
		snd = snd * amp * 5;
		snd = Pan2.ar(snd, pan);

		Out.ar(fxout, snd);
		Out.ar(out, snd);
	}
).add;

SynthDef.new(\sc808hh, {
	arg decay=0.42, amp=1, pan=0, out=0;
	var sig, sighi,siglow, sum, env, osc1, osc2, osc3, osc4, osc5, osc6;
	env = EnvGen.kr(Env.perc(0.00001, decay, 1, -30),doneAction:2);
	osc1 = LFPulse.ar(203.52);
	osc2 = LFPulse.ar(366.31);
	osc3 = LFPulse.ar(301.77);
	osc4 = LFPulse.ar(518.19);
	osc5 = LFPulse.ar(811.16);
	osc6 = LFPulse.ar(538.75);
	sighi = (osc1 + osc2 + osc3 + osc4 + osc5 + osc6);
    siglow = (osc1 + osc2 + osc3 + osc4 + osc5 + osc6);
    sighi = BPF.ar(sighi, 8900, 1);
    sighi = HPF.ar(sighi, 9000);
    siglow = BBandPass.ar(siglow, 8900, 0.8);
    siglow = BHiPass.ar(siglow, 9000, 0.3);
    sig = BPeakEQ.ar((siglow+sighi), 9700, 0.8, 0.7);
    sig = sig * env * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;

SynthDef('ringer',
	{
		arg outBus = 0, amp = 0.1, freq = 140, gate = 1, pan = 0;
		var snd;

		freq = freq * LFNoise1.kr(1/10).range(1,1.01);
		snd = WhiteNoise.ar;
		snd = snd + Pulse.ar(
			freq: [freq, freq * 0.5, freq * 2] * SinOsc.ar(1).range(0.99,1.01),
			mul: 0.01 ).sum;
		snd = Resonz.ar(snd,
			[
				freq,
				freq * 1.5 * SinOsc.kr(4).range(0.99,1.02) ,
				freq * 1.75 * SinOsc.kr(4).range(0.99,1.02) ,
				freq * 0.75 * LFNoise1.kr(4).range(0.99,1.01),
				freq * 0.5 * LFNoise1.kr(4).range(0.99,1.01),
				freq * 2 * LFNoise1.kr(4).range(0.99,1.01)
			], 0.001, [100,1,1,10,10,5]).sum * 0.5;
		snd = snd + LFTri.ar(freq/2*0.99, mul:0.03);
		snd = snd + Pulse.ar(freq/2*1.01, mul:0.005);
		snd = Limiter.ar(snd, 0.8);
		snd = snd * amp ;
		snd = snd * EnvGen.ar(Env.adsr(0.001, 0.2), gate, doneAction:2);

		Out.ar(outBus, snd);
	}
).add;

SynthDef(\deciverbfx,
	{
		arg inBus, outBus = 0;
		var snd, input;

		input = In.ar(inBus,1);
		snd = Decimator.ar(input, LFNoise1.ar(1/5).range(500,10000));
		snd = snd * LFPulse.ar(10).range(LFNoise1.kr(1/10).range(0.5,0.9),1)
		* LFNoise1.kr(1/10).range(0.2,0.5);
		snd = snd + input;
		snd = RLPF.ar(snd, LFNoise1.ar(0.1).exprange(1000,10000), rq:0.8);
		snd = GVerb.ar(snd, 100);

		Out.ar(outBus, snd);
	}
).add;




// SynthDef(\revfx,
// 	{
// 		arg inBus, outBus = 0;
// 		var snd, input;

// 		input = In.ar(inBus,2);
// 		snd = GVerb.ar(input.sum, 100);

// 		Out.ar(outBus, snd);
// 	}
// ).add;









SynthDef(\beep_sus_filt,
	{
		arg outBus = 0, freq=440, gate=1, amp=0.1, ffreq = 1000, fq = 0.5, pan=0;
		var snd;

		ffreq = EnvGen.ar(Env.adsr(0.001,0.05,0.5,0.1), gate, ffreq, ffreq/2);
		snd = Pulse.ar(freq) + Saw.ar(freq * Rand(0.99,1.01) * [2,4], mul:0.3) + LFTri.ar(freq);
		snd = RLPF.ar(snd, ffreq, fq);
		snd = snd * EnvGen.kr(Env.cutoff, gate, doneAction:Done.freeSelf);
		snd = snd * amp;
		snd = Splay.ar(snd, 1, 1, 0);
		Out.ar(outBus, snd);
	}
).add;


SynthDef(\fxdly,
	{
		arg inBus, outBus = 0;
		var snd, input;

		input = In.ar(inBus,2);

		snd = input + CombN.ar(
			HPF.ar(input, 500),
			1, [0.33,0.44], 5, 0.5 );

		Out.ar(outBus, snd);
	}
).add;





(
Pbindef(\kickP, *[
	instrument: 'kick',
	//dur: Pseq([3/4,3/4,2/8,2/8],inf),
	//dur: Pseq([3/4,3/4,3/8,1/8],inf),
	//dur: Pseq([3/4,3/4,3/8,1/8],inf),
	//dur: Pseq([2/4,2/4,1/4,3/4],inf),
	dur: Prand([
		Pseq([3/4,3/4,2/4],4),
		Pseq([3/4,3/4,2/8,2/8]),
		Pseq([3/4,3/4,3/8,1/8]),
		Pseq([2/4,2/4,1/4,3/4],2),
		Pseq([2/4,1/4,2/4,3/4],2)
	],inf),

	//dur: Pseq([3/4,3/4,2/4],inf),

	degree:0,
	octave:[2,3],
	//amp: [1,0.3] * 0.12,
	amp: Pwhite([0.1,0.3],[0.3,0.1]) * 0.2,
	release: [0.6, 0.3],
	legato:Pwhite(0.01,0.1),
	cutoff: Pwhite(500,2000),
	outBus: ~limitBus,
]).play(quant:4);
)
Pbindef(\kickP).stop

// fadeout
Pbindef(\kickP, *[ amp: Pwhite([0.1,0.3],[0.3,0.1]) * 0.2 * Pseq([ Pseg([1,0], 60,\lin), Pn(0)] ) ])
Pbindef(\kickP, *[ amp: Pwhite([0.1,0.3],[0.3,0.1]) * 0.2 * Pseq([ Pseg([0,1], 60,\lin), Pn(1)] ) ]).play

Pbindef(\kickP, *[ cutoff: Pwhite(2000,6000) ])

////////////////////////////////////////////////////////////////////////////////////////////
(
Pbindef(\hhP, *[
	instrument: 'mhh1',
	//dur: Pseq([Prand([1,2]),2,Prand([1,3,Pn(1/2,2)])] * 0.2, inf),
	dur: Prand([1/4,1/2,Pn(1/8,2), 1/8, Pn(1/3,3), Pn(1/6,3)],inf), //Pseq([Prand([1,2]),2,Prand([1,3,Pn(1/2,2)])] * 0.2, inf),
	dur: Prand([1/4,1/2,Pn(1/8,2), 1/8],inf), //Pseq([Prand([1,2]),2,Prand([1,3,Pn(1/2,2)])] * 0.2, inf),
	dur: Prand([1/4,1/2],inf), //Pseq([Prand([1,2]),2,Prand([1,3,Pn(1/2,2)])] * 0.2, inf),
	rls: Pwrand([0.5, 1], [0.9,0.1], inf),
	bpa: 0.6,
	lpa: 0.1,
	hpa: 1,
	legato:0.01,
	amp:0.4,
	pan: Pwhite(-0.2,0.2),
	outBus: ~subBus,
]).play(quant:4);
)
Pbindef(\hhP).stop
Pbindef(\snP).stop

Pbindef(\hhP, *[ amp: 0.4 * Pseq([ Pseg([1,0], 60,\lin), Pn(0)] )])


////////////////////////////////////////////////////////////////////////////////////////
(
Pbindef(\hh808P, *[
	instrument: 'sc808hh',
	dur: Pseq([Pn(1/2,16),Pn(1/4,64)],inf),
]).play(quant:4)
)


(
Pbindef(\snP, *[
	instrument: 'mhh1',
	dur: Pseq([Prand([4,6]),4,3] * 0.25, inf),
	rls: Pwrand([1, Pwhite(0.1,0.5)], [0.1,0.9], inf),
	bpa: 0,
	lpa: 2,
	hpa: 0,
	legato:0.1,
	amp:0.3,
	outBus: ~subBus,
]).play(quant:4);
)

Pbindef(\snP).stop

Pbindef(\snP, *[ amp: 0.4 * Pseq([ Pseg([1,0], 60,\lin), Pn(0)] )])


(
Pbindef(\bassP, *[
	instrument: \beep_sus_filt,
	dur: Pseq([Pn(0.5, 112), Pn(0.4, 140)], inf),
	dur: 1/2, //Pseq([Pn(0.5, 112), Pn(0.4, 140)], inf),
	octave: Pseq([Pn([3,4],28), Pn([5,4],28), Pn([6,4],28)], inf),
	scale: Scale.minor,
	degree: Pseq([Pn(Pwrand([0,14],[0.95,0.05]),7),7],inf) * Pwhite(0.999,1.001)
	//+ Pdup(4,Pxrand([0,3,2],inf))
	,
	outBus:~dlyBus,
	legato: Pwhite(0.4,0.7),
	fq: Pseg([0.9,0.6,0.9], 17, \lin, inf),
	amp:0,
	ffreq: Pseg([500,2000,500], 10, \exp, inf),
	pan:0
]).play(quant:4);
)
Pbindef(\bassP).play
Pbindef(\bassP).stop

// fade in
Pbindef(\bassP, *[ amp: 0.15 * Pseq([ Pseg([0,1], 60,\lin), Pn(1)] )])

// fadeout
Pbindef(\bassP, *[ amp: 0.15 * Pseq([ Pseg([1,0], 60,\lin), Pn(0)] )])


(
Pbindef(\beepP, *[
	instrument: \beep_sus,
	dur: 1/4,
	dur: 1/4,
	legato: 0.01,
	scale: Scale.minor,
	octave: 5,
	degree: Pseq([[-7,0], Pxrand([2,4,6,7],5)], inf),
	detune: Pseg([0,1,3,1,0], 5, \cub, inf),
	mtranspose: Pseq([Pn(0, 6*3), Pn(2, 6*3), Pn(-2, 6*4)],inf),
	mtranspose: 0,
	sawamp: Pseg([0,1,0], 40, \lin, inf),
	outBus: ~fxBus2,
	amp:0 // !!!
]).play(quant:4);
)

// fade in
Pbindef(\beepP, *[ amp: 1 * Pseq([ Pseg([0,1], 60,\lin), Pn(1)] )])

//fadeout
Pbindef(\beepP, *[ amp: 1 * Pseq([ Pseg([1,0], 60,\lin), Pn(0)] )])
Pbindef(\beepP, *[ amp: 0.3 * Pseq([ Pseg([0,1], 30,\lin), Pn(1)] )])
Pbindef(\beepP, *[ amp: 1 ])

Pbindef(\beepP, *[mtranspose: Pseq([Pn(0, 6*3), Pn(2, 6*3), Pn(-2, 6*4)],inf)])
Pbindef(\beepP, *[mtranspose: 0])

Pbindef(\beepP, *[ legato:0.01 ])
Pbindef(\beepP, *[ legato: Pseg([0.01,0.5,0.01], 10, \lin,inf) ])
Pbindef(\beepP, *[ octave: [5,6] ])
Pbindef(\beepP, *[ octave: [5] ])
Pbindef(\beepP).stop

(
Pbindef(\hhP).stop;
Pbindef(\snP).stop;
Pbindef(\kickP).stop;
Pbindef(\hh808P).stop;
)

(

Pbindef(\hhP).play;
Pbindef(\snP).play;
Pbindef(\kickP).play;
Pbindef(\hh808P).play;
)
Pbindef(\ringP, *[
	instrument: 'ringer',
	dur: 6,
	scale: Scale.minor,
	degree: Pseq([0,Prand([2,-2]), Prand([5,4])], inf),
	octave: [4,5,6],
	amp:    [2,2,1] * 0.5,
	detune: Pxrand([0,1,2,3], inf),
	legato: 1,
	outBus: ~fxBus
]).play(quant:4);
)

(
Pbindef(\ringP).stop;





SynthDef(\disson, {
	arg outBus=0, gate = 1, amp=0.1, freq=26.midicps, detune=1.2, lpf=7000, rls=1, pan=0;


	var snd;
	snd = Pulse.ar([freq, freq * 4, freq * 2] * LFNoise1.kr(1!12).range(1,detune));
	snd = RLPF.ar(snd, LFNoise1.kr(1/2!12).exprange(100,lpf.max(101)), LFNoise1.kr(1).exprange(0.1,0.5));
	snd = snd.sum;
	snd = Limiter.ar(snd, 0.9);
	snd = Pan2.ar(snd, SinOsc.kr(1/6).range(-1,1));
	//snd = snd * EnvGen.ar(Env)
	snd = snd * EnvGen.kr(Env.cutoff(rls), gate, doneAction:Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], pan);
	snd = snd * amp;

	OffsetOut.ar(outBus, snd);
	//	snd * -3.dbamp;

}).add;



(
Pbindef(\dissonP,
	*[
		instrument: \disson,
		dur:Pxrand([1,1/2,2,1/2,1/2,1,2,Pn(1/4,2),2],inf) * 1/4,
		//dur:Pxrand([1/4,Pn(1/8,2), 1/2],inf),
		//dur:Pxrand([1/4,Pn(1/8,2), 1/2],inf),
		//dur: 1/2,
		//dur: 1/4, //Pxrand([1/4,Pn(1/8,2), 1/2],inf),
		//degree: Pseq([0,3,-2],inf),
		octave: Prand([2,3],inf),
		scale: Scale.minor,
		degree: Pseq([0,2,7,12],inf),
		//degree:  0,
		legato:Pwhite(0.1, 0.4),
		rls:0.01,
		amp: Pwhite(0.6,0.9)*0.9,
		detune:Pwhite(1,1.01),
		lpf:Pwhite(100,2000),
		pan: -0.2
	])
)

Pbindef(\dissonP).play(quant:4)
Pbindef(\phpHiHatP).play(quant:4);

Pbindef(\dissonP).clear




SynthDef(\subsin, {
	arg outBus = 0, gate = 1, amp = 0.1, freq=50, rls=1;
	var snd;

	snd = SinOsc.ar(freq!2);
	snd = snd * EnvGen.kr(Env.cutoff(rls), gate, doneAction:Done.freeSelf);
	snd = snd * amp;

	Out.ar(outBus, snd);
}).add;





(
Pbindef(\subP,
	*[
		instrument: \subsin,
		dur: 4,
		octave: [2,3],
		degree: -3,
		legato: 0.1,
		rls:2,
		amp:[0.8,0.2]
]
 ).play
)


Pbindef(\subP).stop















SynthDef(\bet, { |gate = 1, freq = 234, out = 0, pan = 0, amp = 0.1, cutoff = 4000 |
	var snd, env, fenv;
	freq = [freq, freq * 1.01] * Rand(0.995, 1.0);
	freq = freq * SinOsc.kr(5).range(0.99, 1.01);
	env = EnvGen.ar(Env.asr(0, 1, 3), gate, doneAction:2);
	fenv = EnvGen.ar(Env.adsr(0.05, 0.5, 0.4, 2), gate);
	snd = SinOsc.ar(freq);
	snd = snd + Pulse.ar(freq * 0.5, mul:5);
	snd = snd + LFTri.ar(freq * [1,2].choose * 1.01, mul:1);
	snd = LPF.ar(snd, cutoff * fenv + 100);
	snd = snd + Decimator.ar(snd, freq*30);
	snd = snd * env * amp;
	snd = Balance2.ar(snd[0], snd[1], pan, 0.7);
	snd = snd * 0.4;
	OffsetOut.ar(out, snd);
}).add;

SynthDef(\nhat, { |gate = 1, out = 0, amp = 0.1, rls = 0.2, pan = 0|
	var snd, env;
	env = EnvGen.ar(Env.asr(0, 1, rls, -10), gate:gate, doneAction: Done.freeSelf);
	snd = WhiteNoise.ar;
	snd = snd * env;
	snd = BPF.ar(snd, 9000);
	snd = snd * amp;

	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;

SynthDef(\kick, { |gate = 1, out = 0, amp = 0.1, release = 0.9, freq=50, pan = 0, cutoff = 500, fxout=0, hpf=0 |
	var snd, env, fenv;
	fenv = EnvGen.ar(Env([freq*4,freq],0.08,'cub'));
	snd = SinOsc.ar(freq: [fenv,fenv*2], mul:[1,0.4] ).sum;
	snd = snd * LFPulse.ar(24).range(0.7,1).lag(0.02);
	snd = snd + WhiteNoise.ar(0.3);
	snd = snd + SinOsc.ar(freq: [freq*2,freq*4], mul:EnvGen.ar(Env.perc(0, 0.2)) * 0.5).sum;
	snd = snd + LFTri.ar(freq: freq*4, mul:EnvGen.ar(Env.perc(0, 0.5)) * 0.3);
	snd = RLPF.ar(snd, cutoff, 0.7);
	snd = HPF.ar(snd, hpf);
	snd = snd.softclip;
	snd = snd * EnvGen.ar(Env.adsr(0, 0.05, 0.4, release, curve:'sqr'), gate: gate, doneAction:Done.freeSelf);
	snd = snd * amp * 5;
	snd = Pan2.ar(snd, pan);
	//DetectSilence.ar(snd, doneAction:Done.freeSelf);
	Out.ar(fxout, snd);
	Out.ar(out, snd);
}).add;




// reverb on a reverb bus
	~revFx = Synth(\revfx, [\inBus, ~revBus, \amp, 0.4, \wet, 0.5], addAction:\addAfter);

	// PATTERNS: ////////////////////////////////////////

///        !!!!!
	t = TempoClock.default.tempo = 110/120;

(
	Pbindef(\kicko, *[
		instrument: \kick,
		freq: Prand((1..9) * 0.1 + 1 + 50,inf),
		dur: Pseq([2/3,2/3,1/3,2/3,1/6,1/6,1/3],inf) + Prand([0,0,1/3,1/6,2/3],inf) * 3 * 1/4,
		sustain: 0.1,
		//hpf: Pseg([300,300,0,0,3000, 3000],  [60, 60, 120, 30, 30]),
		hpf: 30, //Pseg([300,300,0,0,3000, 3000],  [60, 60, 120, 30, 30]),
		//amp: Pseg([0, 0, 0.1, 0.1, 0.01, 0], [60, 60, 120, 20, 10], \sqr),
		amp: 0.2,

		release: Prand((1..9) * 0.1, inf),
		cutoff: Prand((1..2) * 500, inf),
	]).play(quant:4);
)

Pbindef(\kicko).stop
Pbindef(\kicko).clear

(
	Pbindef(\nhatP, *[
		instrument: \nhat,
		dur: Pwrand([1/3, Pn(1/6,2)], [0.9,0.1], inf) * 3/2,
		//amp: Pseg([0, 0, 0.1, 0.1, 0], [60, 60, 120, 30]),
		amp: 0.1,
		pan: Pwhite(-0.5,0.5),
		sustain: Prand([0.002, 0.01, 0.02],inf)
	]).play(quant:4);
)

Pbindef(\nhatP).stop
Pbindef(\nhatP).clear


(
	Pbindef(\ichiP, *[
		instrument: 	\bet,
		dur: Prand([
			Pseq([1/3, 3/6, 1/3, 1/3, 1/6, 2/6],4),
			Pseq([3/6, 1/3, 1/3, 1/6, 2/6, 1/3],4),
			Pseq([1/3, 1/3, 1/6, 2/6, 1/3, 3/6],4),
			Pseq([1/3, 1/6, 2/6, 1/3, 3/6, 1/3],4),
			Pseq([1/6, 2/6, 1/3, 3/6, 1/3, 1/3],4),
			Pseq([2/6, 1/3, 3/6, 1/3, 1/3, 1/6],4)
		],inf) * 3/4,


		note:			Pseq([
			 1,		13,	15,	20,	16,		Rest(), 	// Dbm(add9)
			-1,		11,	15,	20,	16,		Rest(),		// EM7/B
			-3,		13,	15,	20,	16,		Rest(),		// Dbm(add9)/A
			-3,		12,	18,	23,	25,		Rest(),		// Gbsus4(+11)/A
			-6,		6,	9,	13,	20,		Rest(),		// Gbm(add9)
			-4,		8,	12,	18,	16,		20, 	// Abaug7
			 1,		13,	15,	20,	16,		Rest(), 	// Dbm(add9)
			-1,		11,	15,	20,	16,		Rest(),		// EM7/B
			-3,		13,	15,	20,	16,		Rest(),		// Dbm(add9)/A
			-3,		12,	18,	23,	16,		Rest(),		//
			-4,		6,	11,	15,	16,		Rest(),		// EM9/Ab
			-4,		6,	13,	16,	25,		28,		// Ab7sus4(-13(
			-6,		6,	9,	13,	20,		Rest(),		// Gbm(add9)
			-6,		8,	12,	18,	20,		16, 	// Abaug7
			], inf),

				octave:
		Pseq([ Pn([4,5],14*6*2),Pn([4,5,6],14*6*2),
			Pseq([
				Prand([[5,4],[5,6],[4,5,6]]),
				Pn(Pwrand([5,6],[0.9,0.1]), 5)
			], 14*2),
			Pseq([ Pn([4,5,6,7],14*6*4)])]),

		octave: 5,
		detune:			3, // Hz added to final freq
		legato:			Pseq([4, Pn(Prand((2..5)*0.2),5)],inf) * 0.1,
		cutoff:			Prand((1..4),inf) *
						Pseg([50, 500, 1000, 1000, 50,  10], [60,  60, 120, 30, 20], \cub),
		//amp:			Pseg([0,  0.1,  0.1,  0.01, 0], [10, 120+180, 30, 10], \cub) * 0.6,
		amp:			0.1,
		pan:			Prand((0..10)-5*0.1, inf),
		out:			~revBus,
	]).play(quant:4)
)

Pbindef(\ichiP, *[ octave: 5])
Pbindef(\ichiP, *[ octave: [4,5,6,7] ])
Pbindef(\ichiP, *[ octave: Prand([[5,4],[5,6],[4,5,6]], inf)])
Pbindef(\ichiP, *[ octave: Prand([[5,4,7],[4,5,6],[4,7,6]], inf)])
Pbindef(\ichiP, *[ amp: 0.1])
Pbindef(\ichiP, *[ cutoff: 3000])

Pbindef(\ichiP).stop
Pbindef(\ichiP).clear






SynthDef(\ping,{
	arg freq = 100, gate = 1, amp = 0.1, out=0, fxBus=nil, bufnum;
	var snd, env;
	freq = [freq, freq*1.01];
	//snd = SinOsc.ar(freq) + Pulse.ar(freq*0.99) + LFTri.ar(freq*1.01);
	snd = Osc.ar(bufnum, freq);
	snd = snd * Linen.kr(gate, 0.001, 1, 0.01, doneAction:Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = Limiter.ar(snd, 0.95);
	snd = snd * amp * 0.5 * 10;
	//Out.ar()
	Out.ar(out,snd);
} ).add;

SynthDef(\wab,{
	arg freq = 100, gate = 1, amp = 0.1, out=0, fxBus=nil, bufnum;
	var snd, env;
	snd = Osc.ar(bufnum, freq);
	snd = snd * Linen.kr(gate, 0.001, 1, 0.1, doneAction:Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = BRF.ar(snd, LFNoise1.kr(2).exprange(100,1000), 0.1);
	snd = RLPF.ar(snd, LFNoise1.kr(2).exprange(50,1000), 0.2);
	snd = snd * 20;
	snd = Limiter.ar(snd, 0.95);
	snd = Splay.ar(snd);
	snd = snd * amp * 0.7 * 10 ;
	Out.ar(out,snd);
} ).add;


SynthDef(\sab,{
	arg freq = 100, gate = 1, amp = 0.1, out=0, fxBus=nil, bufnum, sustain;
	var snd, env;
	freq = XLine.ar(freq,freq * 0.1, sustain);
	snd = Osc.ar(bufnum, freq);
	snd = snd * Linen.kr(gate, 0.001, 1, 0.01, doneAction:Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd + PinkNoise.ar(0.5);
	snd = HPF.ar(snd, 500);
	snd = snd * 20;
	snd = snd.softclip;
	snd = Limiter.ar(snd, 0.95);
	snd = Splay.ar(snd);
	snd = snd * amp * 0.15 * 10;
	Out.ar(out,snd);
} ).add;

SynthDef(\dlywrangler, {
	arg out=0, in, wet=0.1, wet2=0.5;
	var snd, dly2;
	snd = In.ar(in,2);
	dly2 = CombN.ar(HPF.ar(snd,300), 1, [0.5,0.77], 5, mul: LFNoise1.kr(0.1).range(0.4,0.1) * 2 * wet2);
	snd = CombN.ar(snd, 1, Lag.ar(LFNoise0.ar(1).range(0.01,0.1),0.1), 3, mul:wet) + snd;
	snd = Limiter.ar(snd, 0.8);
	snd = snd + dly2;
	Out.ar(out, snd);
}).add;






	// create delaymangler comb // on ctrl+. you need to reeval this
	~dw = Synth(\dlywrangler, [\out, 0, \in, ~dly, \wet2, 0.1, \wet, 0.02]);

	~dw.set(\wet2, 0.9)
	~dw.set(\wet, 0.5)





SynthDef(\baz1, {

	arg outBus=0, gate=1, freq, amp, fff=5, res=1, delwet=0.3, wrap=1.2;
	var snd, env, fenv;

	fenv = EnvGen.ar(Env.adsr(), gate) + 1;
	env = EnvGen.ar(Env.cutoff, gate, doneAction:Done.freeSelf);
	snd = Pulse.ar([freq, freq*1.005], mul:1);
	snd = snd + LFTri.ar([freq * 0.995, freq] * 1, mul:4);
	snd = snd.clip2;
	snd = snd.wrap2(wrap);
	snd = MoogFF.ar(snd, freq * fenv * fff, res);
	snd = Limiter.ar(snd);
	snd = snd * amp * env;

	Out.ar(outBus, snd);
}).add;



Pbindef(\line1,
	\instrument, \baz1,
	\dur, 1/8,
	\degree, Pseq([0,2,5,7,Pwrand([12,13,14],[0.9,0.05,0.05]),2,5], inf),
	\mtranspose, Pstutter(160,Pseq([0,3,5],inf)),
	\legato, Pseg([1,5,1]/10, 15, \cubed, inf),
	\octave, [3,5],
	\scale, Scale.major(\just),
	\amp, Pseg([0.1,0.2,0.1], 23, \lin, inf),
	\fff, Pseg([1,1.5,1], 30, \cubed, inf),
	\res, Pseg([1,2,1], 8, \cubed, inf),
	\delwet, 1,
	\outBus, ~dlyBus2
).play;

59.wait;

Pbindef(\line1,	\amp, 0) ;
1.wait;

Pbindef(\line1,	\amp, Pseg([0.1,0.2,0.1], 23, \lin, inf));

Pbindef(\bazpat,
	\instrument, \baz1,
	\dur, Pseq([1,1,2,4] / 8, inf),
	\degree, Pseq([0, 3, 2, 0, 7, 6], inf),
	\mtranspose, Pseq([ Pn(0, 4*20), Pn(3, 4*20) ],inf),
	\octave, [2,3],
	\scale, Scale.major(\just),
	\legato, Prand((1..10)/10, inf),
	\amp, Pseg([ [0, 0.6], [0.3,0.6], [0,0.6] ], 17, \lin, inf),
	\fff, Pseg([1,13,1], 15, \cubed, inf),
	\res, Pseq([1,2,3]/2,inf),
	\wrap, Pseg([2, 0.9, 2], 19, \exp, inf),
	\outBus, ~dlyBus1
).play;

120.wait;

Pbindef(\line1, \mtranspose, 0);



//AKJ to pattern femalemalenonbinary


wait(0.2);

Pbindef(\akjDisChordp, *[
	instrument: \akjDisChord,
	freq:300,
	dur: Pseq([260]),
	legato: 1.1,
	amp: 0.8,
	//out: ~mainOut,
	out: 0
]).play;

wait(60);

Pbindef(\akjClickp, *[
	instrument: \akjClick,
	dur: Pseq([
		Pn(1/8, 7), Rest(1/8), // 1
		Rest(1), // 1
		Pn(1/4, 3), Rest(3/8), Pn(1/8, 1),
		Pn(1/4, 3), Rest(3/8), Pn(1/8, 1),
		Pn(1/4, 3), Rest(4/8),
		Pn(1/8, 7),	Rest(1/8),
		Prand([ Rest(1), Pn(1/6,6) ]),
		Pn(1/8, 3),	Rest(1/8),
		Prand([ Rest(1.25), Pn(1/4, 5) ]),
		Prand([ Pn(1/8, 3), Pn(1/16, 6)	]), Rest(1/8),
	],inf),
	amp: 9/20,
	releaseTime: 0.3,
	freq:1,
	//out: ~mainOut,
	out: 0
]).play;

wait(60);

Pbindef(\akjBazp, *[
	instrument: \akjBaz,
	freq: 300,
	dur: 10,
	amp: 0.3,
	legato: 0.20,
	//out: ~mainOut
	out: 0
]).play;

wait(120);

Pbindef(\akjClickp).stop;
Pbindef(\akjBazp).stop;






"--- softdarksaw pattern...".postln;
Pbindef(\sawp0,
	\instrument, \softSaw,
	\dur, 10,
	\attackTime, 5,
	\releaseTime,5,
	\legato,1,
	\degree, Pseq([ [-2,3,11,20], [-2,5,7,21] ],inf),
	\octave, 3,
	\amp, [1,0.5,0.2,0.1] * 0.7,
	\out, 0
	//\out, ~reverBus,
	//\gainBus, ~softSawAmpBus
).play;






// --- lcmnoi ----------------------------------------------------------------------
"--- lcmnoi ...".postln;

SynthDef(\lcmnoise, {
	arg gate=1, outBus, amp1=0, amp2=1, amp=0.1;
	var snd, revchain, env;
	snd = [
		tanh(lcm(SinOsc.ar(
			LFNoise0.kr(LFNoise0.kr(1/10).exprange(0.1,1)).exprange(1,15000)
		).range(-100,100).round(1),SinOsc.ar(
			LFNoise0.kr(LFNoise0.kr(1/10).exprange(0.1,1)).exprange(1,15000)
		).range(-100,100).round(1))*0.0001),
		tanh(lcm(Saw.ar(
			LFNoise0.kr(LFNoise0.kr(1/10).exprange(0.1,1)).exprange(1,15000)
		).range(-100,100).round(1),LFCub.ar(
			LFNoise0.kr(LFNoise0.kr(1/10).exprange(0.1,1)).exprange(1,15000)
		).range(-100,100).round(1))*0.0001)
	] ;
	snd = BHiPass.ar(snd, 180);
	snd = snd.softclip * 0.8;
	snd = Splay.ar(snd, spread:1);
	revchain = snd * EnvGen.ar(Env.perc(0, 0.1, Rand(10,10000), 4));

	revchain = Greyhole.ar(
		in: revchain,
		delayTime: LFNoise1.ar(1).range(0.0001,0.2),
		damp: 0.5,
		size: LFNoise1.ar(0.1).exprange(0.0001,5),
		feedback: 0.95);

	revchain = LeakDC.ar(revchain);
	revchain = Limiter.ar(revchain) * LFNoise1.ar([1,1]).range(0,0.9);
	snd = snd * LFNoise0.ar([0.9,0.8]).range(0,2);
	snd = (snd * amp1) + (revchain * amp2);
	snd = snd.softclip * 0.8;

	env = Linen.kr(gate, 0, 1, 0, 2);
	snd = snd * amp * env;
	Out.ar(outBus, snd);
	//snd = LPF.ar(snd.softclip, LFNoise1.ar(0.1).exprange(10000,20000)) * 0.8;
}).add;



Pbindef(\lcmnoip,
	\instrument, \lcmnoise,

	\dur, Pseq([
		Pseq([
			Prand([Pseq([0.01,0.01]),0.02]),
			Pn(0.05,19),
			9.03
		], 20), // 20 x 10
		30]),
	\dur, Pseq([1,1,6], inf),
	\amp, 1,
	\amp1, Pseq([1,0.1],inf),
	\amp1, 0,
	\amp2, 1, //Pseq([0.6,1],inf),
	\legato, 1,
	\out, ~mainOut,
).play;



//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////



// --------------------------------------------------













////////////////////////////////////////////////////////////////////////////////////////////////////
// EXPERIMENTATION


/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////




/////////////////////////////////////////////////////////////////////////////////////////
// Buffer Player ////////////////////////////////////////////////////////////////////////
(

)

(
Pbindef(\playBufP, *[ instrument: \playBuf,
	bufnum: Pdup(64, Pxrand([
		~getSmp.("qebrus_machines_snip1"),
		~getSmp.("qebrus_machines_snip2"),
		~getSmp.("qebrus_machines_snip3"),
		~getSmp.("qebrus_machines_snip4"),
		~getSmp.("qebrus_machines_snip5")
	],inf)),

	dur: Pxrand([1,1/2,1/2,1/4],inf) * 1/2,
	legato:[0.9,0.1,0.2] * Pwhite(0.9,1),
	start:Pwhite(0,0.91),
	amp: 0.4,
	//rate:Prand([1,0.5,2],inf)
	//rate: Prand([1,0.5,2],inf),
	rate: 1,

]).play
)











//
(// main bus, synthdef and a synth /////////////////////////////////////////////////////////////////
SynthDef(\mainOut, {
	var snd = In.ar(\inBus.kr(0), 2);

	//snd = BHiPass4.ar(snd, 80); // cutsubout
	snd = snd * Lag.kr(\amp.kr(0), \ampLag.kr(0.1));

	Out.ar(\outBus.kr(0), snd)
}).add;

~mainOutVol.free;
~mainOutVol = Synth(\mainOut, [\inBus, ~mainOut, \outBus, 0, \ampLag, 2, \amp, 1], addAction:\addToTail);
)

~mainOut.free; ~mainOut = Bus.audio(s, 2);



( // testing
x.free;
x = SynthDef(\test, {Out.ar(~mainOut, SinOsc.ar(190)!2)}).play
)

~mainOutVol.set(\ampLag, 5, \amp, 1)

// FX BUSSES /////////////////////////////////////////////////////////////////////////////////////////
// FX: reverberations (GreyHole/JPverb/GVerb)
// simple delays with Comb + feedback + filters
(

)
s.freqscope

(
SynthDef(\fxdly,
	{
		arg inBus, outBus = 0;
		var snd, input;

		input = In.ar(inBus,2);

		snd = input + CombN.ar(
			HPF.ar(input, 500),
			1, [0.33,0.44], 5, 0.5 );

		Out.ar(outBus, snd);
	}
).add;
)














///////////////////////////////////////////////////////////////////////////////////////////////////



(
SynthDef(\beep_sus_filt,
	{
		arg outBus = 0, freq=440, gate=1, amp=0.1, ffreq = 1000, fq = 0.5, pan=0;
		var snd;

		ffreq = EnvGen.ar(Env.adsr(0.001,0.05,0.5,0.1), gate, ffreq, ffreq/2);
		snd = Pulse.ar(freq) + Saw.ar(freq * Rand(0.99,1.01) * [2,4], mul:0.3) + LFTri.ar(freq);
		snd = RLPF.ar(snd, ffreq, fq);
		snd = snd * EnvGen.kr(Env.cutoff, gate, doneAction:Done.freeSelf);
		snd = snd * amp;
		snd = Splay.ar(snd, 1, 1, 0);
		Out.ar(outBus, snd);
	}
).add;
SynthDef(\beep_sus,
	{
		arg outBus = 0, freq=440, gate=1, amp=0.1, sawamp = 0.1;
		var snd;

		snd = Pulse.ar(freq) + LFTri.ar(freq/ Rand(1.99,2.01)) + Saw.ar(freq * Rand(1.99,2.01), mul:sawamp);
		snd = snd * 0.5 + WhiteNoise.ar;
		snd = BPF.ar(snd, LFNoise1.kr(9).exprange(500,4000), 0.5);
		snd = snd * EnvGen.kr(Env.cutoff, gate, doneAction:Done.freeSelf);
		snd = snd * amp * 0.5;

		Out.ar(outBus, snd!2);
	}
).add;
)





(
Pbindef(\beepP, *[
	instrument: \beep_sus,
	//dur: 2,
	dur: Prand([1/4,1/2,1/2,1/4,Pn(1/4,2),Pn(1/3,3),Pn(1/6,3)],inf),
	legato: 0.01,
	scale: Scale.minor,
	octave: 4,
	degree: Pseq([[-7,0], Pxrand([2,4,6,7],5)], inf),
	detune: Pseg([0,1,3,1,0], 5, \cub, inf),
	mtranspose: Pseq([Pn(0, 6*3), Pn(2, 6*3), Pn(-2, 6*4)],inf),
	mtranspose: 0,
	sawamp: Pseg([0,1,0], 40, \lin, inf),
	outBus: ~localfdlyBus,
	amp:4 // !!!
]).stop(quant:4);
)
Pbindef(\beepP).stop
Pbindef(\beepP).clear














// VOLUME CONTROL // ------------------------------------------------------------------
SynthDef(\volFX, {
	var snd = In.ar(\inBus.kr(0), 2);

	//snd = BHiPass4.ar(snd, 80); // cutsubout
	snd = snd * VarLag.kr(\amp.kr(0), \ampLag.kr(0.1), 0, \exp);

	Out.ar(\outBus.kr(0), snd)
}).add;


~ch1Vol.free; ~ch1Vol = Synth(\volFX, [\inBus, ~ch1Bus, \outBus, 0, \ampLag, 2, \amp, 1], addAction:\addToTail);


~ch1Bus.free; ~ch1Bus = Bus.audio(s, 2);













//}); // end of s.waitForBoot
//)
//
//
//
//
//


























(
Pbindef(\playBufErr3, *[ instrument: \playBuf,
	bufnum: Pdup(3,
		Prand([
			~getSmp.("Misc034"),
			~getSmp.("Misc106"),
			~getSmp.("Misc188"),
			~getSmp.("RawGlitch_259"),
			~getSmp.("RawGlitch_412"),
			~getSmp.("RawGlitch_336")
		],inf)
	),
	start: 0,
	legato:1,
	dur:2,
	amp:0.7,
	rate:1
]).stop;
)


(
Pbindef(\playBufHat3, *[ instrument: \playBuf,
	bufnum: ~getSmp.("Hats076"),
	legato:1,
	//dur:Pseq([Pn(1/4,6),Pn(1/8,3)],inf),
	dur:Pseq([Pn(1/8,7),2],inf),
	amp: 3 * Pseq([1,1/5],inf) * Pwhite(0.3,1),
	rate: Pwhite(0.95,1.01)
]).play(quant:4);
);

(
Pbindef(\dissonP,
	*[
		instrument: \disson,
		dur:Pxrand([1,1/2,2,1/2,1/2,1,2,Pn(1/4,2),2],inf) * 1/4,
		//dur:Pxrand([1/4,Pn(1/8,2), 1/2],inf),
		//dur:Pxrand([1/4,Pn(1/8,2), 1/2],inf),
		//dur: 1/2,
		//dur: 1/4, //Pxrand([1/4,Pn(1/8,2), 1/2],inf),
		//degree: Pseq([0,3,-2],inf),
		octave: Prand([2,3],inf),
		scale: Scale.minor,
		degree: Pseq([0,2,7,12],inf),
		//degree:  0,
		legato:Pwhite(0.1, 0.4),
		rls:0.01,
		amp: Pwhite(0.6,0.9)*2,
		detune:Pwhite(1,1.21),
		lpf:Pwhite(100,2000),
		pan: -0.2
	]).play(quant:4)
)




(
Pbindef(\playBufKick5, *[ instrument: \playBuf,
	bufnum: ~getSmp.("Kicks010"),
	legato:1,
	dur:Pseq([3,4,1/4,2],inf),
	//dur:1/4,
	amp: 4 * Pwhite(0.7,1),
	rate: Pwhite(0.95,1.01)
]).play(quant:4);
);
