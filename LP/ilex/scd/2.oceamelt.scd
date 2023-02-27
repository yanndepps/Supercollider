/*

	oceamelt.


	!!! - IMPORTANT - !!!

	YOU NEED DEIND UGens from sc3-plugins
	(https://github.com/supercollider/sc3-plugins)
	for this code to work in your SuperColider.

*/
(

Routine({

	"\n\n\n-------------------------------------\n>>> starting...".postln;

	s.latency = 0.1;
	TempoClock.tempo = 140/120;

	~disdelBus.free;
	~disdelBus = Bus.audio(s, 2);

	~revBus.free;
	~revBus = Bus.audio(s,2);

	SynthDef(\fm4, {
		arg gate=1, outBus=0, amp=0.1, freq=160,
		atk=0, rls=0, f=9, i=0.9, noiseamt=1;
		var c, m, d, snd, env, mod, modp;

		c = freq; // c = carrier frequency
		m = c * f; // f = ratio (factor) between carrier freq and mod freq
		d = m / i; // index = ratio between depth/distance and mod freq

		c = [c, c * 1.4, c * 2.6, c / 1.95];

		mod = SinOsc.ar( SinOsc.ar(m, mul:d), mul: d);
		modp = LFPulse.ar( SinOsc.ar(m, mul:d), mul: d);

		// basic FM synthesis:
		snd = SinOsc.ar( c + mod );

		// but let's add more oscilators with similary modulated frequencies
		snd = snd + ( LFPulse.ar(c + mod * LFNoise1.kr(7/6).range(0.99,1.01) ) * LFNoise1.ar(1/3).range(0.8,1) );
		snd = snd + ( LFTri.ar(c + modp * LFNoise1.kr(7/6).range(0.99,1.01) ) * LFNoise1.ar(1/3).range(0.8,1) );

		snd = Splay.ar(snd, center:LFNoise1.kr(1/10));
		snd = HPF.ar(
			LPF.ar(
				WhiteNoise.ar(2) + Dust2.ar(300, mul:10),
				EnvGen.ar(Env.perc(0, 0.05)).exprange(Rand(500,20000),200)
				//* Rand(500,15000)
				//15500
			),
			100
		) * noiseamt + snd;
		snd = LeakDC.ar(snd);
		env = EnvGen.ar(Env.asr(atk, 1, rls, 0), gate, doneAction:2);
		snd = snd * env * amp;

		Out.ar(outBus, snd);
	}).add;


	SynthDef(\disdel, {
		arg inBus, outBus=0, amp=0.5;
		var in, snd, local;

		in = In.ar(inBus, 2);

		snd = in;

		//snd = LocalIn.ar(2) + snd;
		snd = snd[1] + JPverb.ar(snd[0], LFNoise0.kr(1/4).range(1,3));
		snd = snd[0] + JPverb.ar(snd[1], LFNoise0.kr(1/4).range(1,3));
		snd = Splay.ar(snd);

		snd[0] = DelayN.ar(snd[0], 3, LFNoise0.kr(1/4).range(0.5,3));
		snd[0] = Decimator.ar(snd[0], 6000, 11);
		snd[0] = snd[0] + DelayN.ar(snd[0], 3, LFNoise0.kr(1/4).range(0.5,3));
		snd[0] = Decimator.ar(snd[0], 9000, 11);

		snd[1] = DelayN.ar(snd[1], 3, LFNoise0.kr(1/4).range(0.5,3));
		snd[1] = Decimator.ar(snd[1], 12000, 14);
		snd[1] = snd[0] + DelayN.ar(snd[1], 3, LFNoise0.kr(1/4).range(0.5,3));
		snd[1] = Decimator.ar(snd[1], 7000, 14);
		//SndOut.ar(snd.reverse, 0.4);

		snd = snd * LFPulse.ar(LFNoise0.kr([1,1]).range(8,16)).range(LFNoise1.kr(0.2,1),1);

		snd = snd * amp;

		Out.ar(inBus, snd);
		Out.ar(outBus, snd);
	}).add;


	SynthDef(\rev, {
		arg inBus, outBus=0, amp=0.7;
		var snd;

		snd = In.ar(inBus, 2);

		snd = snd + JPverb.ar(snd, 10);

		snd = snd * amp;
		Out.ar(inBus, snd);
		Out.ar(outBus, snd);
	}).add;

	SynthDef(\gran, {
		arg buf;
		var snd;

		snd = GrainBuf.ar(2,
			trigger: Impulse.ar(LFNoise1.kr(1/10!3).exprange(80, 180) * LFNoise0.ar(100).range(0.7,1.1)),
			dur: LFNoise1.ar(1).range(0.08,0.1),
			sndbuf: buf,
			rate:[1,1/2,2],
			pos:LFNoise1.kr(1/40!3).range(0,1),
			pan: LFNoise0.ar(100).range(-1,1)
		);
		snd = LPF.ar(snd, LFNoise1.kr(1/10!3).exprange(500,10000));
		snd = Mix(snd);
		snd = AnalogTape.ar(snd, 1, 1, Lag2.kr(\dist.kr(0.1), 20));
		snd = JPverb.ar(snd, LFNoise1.kr(1/10!2).range(1,10)) + snd;
		snd = Limiter.ar( Mix(snd * 0.3), 0.8 );
		snd = snd * Env.circle([0.5,0.3,0.5],90,\cub).kr;
		snd = snd * Lag2.kr(\amp.kr(0.5), \lagamp.kr(20));

		Out.ar(0, snd);
	}).add;

	SynthDef(\recbuf, {
		arg inBus, bufnum, run=1;

		RecordBuf.ar(
			In.ar(
				inBus, 1),
			bufnum, run: run);
	}).add;

	Pbindef(\fm4p, *[
		instrument: \fm4,
		dur:Pxrand([
			Pseq([2, Pn(1,30), 4, Rest(28)] / 16, 4),
			Pseq([Pn(2,8), Pn(1,16), 4, Rest(28)] / 16, 4),
			Pseq([Pn(2,8), Pn(1,16), 4, Rest(20), Pn(4,2)] / 16, 4),
			Pseq([2, Pn(1,30), 4, Rest(28), Pn(2,16)] / 16, 4),
			Pseq([4, 2, 2, Pn(1,24), 4, Rest(28)] / 16, 4),
			Pseq([4, 2, 2, Pn(1,24), 8, Rest(24)] / 16, 4),
			Pseq([4, 2, 2, Pn(1,24), Pn(3,4), Rest(20)] / 16, 4),
			Pseq([4, 2, 2, Pn(1,24), Pn(4,2), Rest(24)] / 16, 4)
		], inf),
		i:Prand((1..10)*0.1, inf),
		f:Prand((1..10), inf),
		legato:Pwhite(0.1,0.5),
		atk:Pwhite(0,0.01),
		rls:Pwhite(0,0.001),
		octave:4,
		amp:0.02,
		outBus: 0,
	]);

	Pbindef(\fm4p2, *[
		instrument: \fm4,
		dur:2,
		i:1,//Prand((1..10)*0.1, inf),
		f:1, //Prand((1..10), inf),
		//f:5,
		legato:0.1,
		atk:0.01,
		rls:1,
		octave:3,
		degree: 0,
		amp:0.02,
		noiseamt:0,
		outBus: ~revBus,//0, //Pwrand([0, ~disDel], [0.95,0.05], inf)
	]);

	~buf_b.free;
	~buf_b = Buffer.alloc(s, s.sampleRate * 10, 1);
	~buf_c.free;
	~buf_c = Buffer.alloc(s, s.sampleRate * 10, 1);

	1.wait;

	~disdel = Synth(\disdel, [\inBus, ~disdelBus, \amp, 0.2]);
	~recbuf = Synth(\recbuf, [\inBus, ~disdelBus, \bufnum, ~buf_b], addAction:\addToTail);
	~gran = Synth(\gran, [\bufnum, ~buf_b, \amp, 0], addAction:\addToTail);

	0.1.wait;

	~reverb = Synth(\rev, [\inBus, ~revBus]);
	~recbufc = Synth(\recbuf, [\inBus, ~revBus, \bufnum, ~buf_c], addAction:\addToTail);
	~gran_c = Synth(\gran, [\buf, ~buf_c, \amp, 0], addAction:\addToTail);

	// =========================================




	">>> starting timeline, waiting on 4bar border ...".postln;

	Routine({

		Pbindef(\fm4p, *[outBus: 0]).play;
		postln(TempoClock.beats.value);

		16.wait;
		postln(TempoClock.beats.value);

		Pbindef(\fm4p, *[outBus: Pwrand([0, ~disdelBus], [0.7,0.3], inf),]).play;

		16.wait;

		postln(TempoClock.beats.value.mod(8));
		~gran.set(\lagamp, 32, \amp, 8);

		32.wait;

		postln(TempoClock.beats.value.mod(8));
		">>> gran amp set 0".postln;
		s.bind({~gran.set(\lagamp, 0, \amp, 0);});

		2.wait;

		">>> gran amp set 16, lag 32".postln;

		~gran.set(\lagamp, 32, \amp, 12);

		32.wait;

		postln(TempoClock.beats.value.mod(8));
		">>> gran amp set 0".postln;
		Pbindef(\fm4p2).play(quant:1);
		s.bind({~gran.set(\lagamp, 0, \amp, 0) });

		2.wait;

		">>> gran + gran_c fadein".postln;
		~gran.set(\lagamp, 32, \amp, 16);
		~gran_c.set(\lagamp, 32, \amp, 3);

		32.wait;

		">>> gran amp set 0".postln;
		s.bind({~gran.set(\lagamp, 0, \amp, 0)});
		s.bind({~gran_c.set(\lagamp, 0, \amp, 0)});

		2.wait;

		">>> gran + gran_c fadein".postln;
		~gran.set(\lagamp, 32, \amp, 16);
		~gran_c.set(\lagamp, 32, \amp, 4);

		32.wait;

		">>> gran amp set 0".postln;
		s.bind({~gran.set(\lagamp, 0, \amp, 0)});
		s.bind({~gran_c.set(\lagamp, 0, \amp, 0)});

		2.wait;

		">>> gran + gran_c fadein".postln;
		~gran.set(\lagamp, 32, \amp, 16);
		~gran_c.set(\lagamp, 32, \amp, 4);

		64.wait;
		">>> stop recording. stop patterns.".postln;
		s.bind({~gran.set(\lagamp, 0, \amp, 0)});
		s.bind({~gran_c.set(\lagamp, 0, \amp, 1)});
		~recbuf.set(\run, 0); // stop recording
		~recbufc.set(\run, 0); // stop recording
		Pbindef(\fm4p).stop;
		Pbindef(\fm4p2).stop;
		2.wait;
		~gran_c.set(\lagamp, 32, \amp, 8);

		128.wait;
		~gran.set(\lagamp, 64, \amp, 16);
		64.wait;
		~gran.set(\lagamp, 64, \amp, 0);
		32.wait;

		Pbindef(\fm4p2).play;
		s.bind({~gran_c.set(\lagamp, 0, \amp, 4)});

		32.wait;

		~gran_c.set(\lagamp, 32, \amp, 2);

		64.wait;

		Pbindef(\fm4p2).stop;

		~gran_c.set(\lagamp, 16, \amp, 0);


	}).play(quant:4);

}).play;
)
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
