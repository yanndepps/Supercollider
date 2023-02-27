/*
	johchow.

	inspired by frequency modulation synthesis
	and innovations in computer music by John Chowning.

	!!! - IMPORTANT - !!!

	YOU NEED PortedPlugins (https://github.com/madskjeldgaard/portedplugins)
	and DEIND UGens from sc3-plugins (https://github.com/supercollider/sc3-plugins)
	for this code to work in your SuperColider.

	copyright by Luka Prinčič <luka@lukaprincic.si>

	published under the conditions of Peer Production Licence
	https://civicwise.org/peer-production-licence/
	(see the bottom of this document for human readable summary)


*/
(
s.waitForBoot({

	Routine({

		"\n\n\n".postln;
		">>> hello, welcome to Chowning! ------------------------------------------- ".postln;

		// set
		s.latency = 0.08;
		s.volume = -1;

		// function to tell us where we are on the timeline
		~postbeats = { ("    (" + TempoClock.default.beats.mod(64) + "/" + TempoClock.default.beats.mod(8) + ")" ).postln;};

		b.free;
		b = Buffer.alloc(s, s.sampleRate * 10, 1);

		SynthDef(\fm5, {
			arg f=10, i=0.5, gate=1, freq=120, amp=0.1, outBus=0, rls=2;
			var c, m, d, snd;

			c = freq;
			m = c * f;
			//d = 1200;
			//m  = i * d;
			d = m / i;

			// basic FM synthesis:
			snd = SinOsc.ar( c + SinOsc.ar(m, mul: d) );

			// envelope:
			snd = snd * EnvGen.ar(Env.perc(releaseTime:rls, curve:-10), gate, doneAction:2);

			Out.ar(outBus, snd!2 * amp * 3);
		}).add;


		// reverb synthdef
		SynthDef(\revfx, { |inBus, outBus = 0, wet = 0.3, amp = 0.2|
			var snd, rev;

			snd = In.ar(inBus, 2);

			snd = AnalogTape.ar(snd,
				LFNoise1.kr(1/5).range(0.5,1),
				LFNoise1.kr(1/5).range(0.5,1),
				LFNoise1.kr(1/5).range(0.5,1) );
			snd = LPF.ar(snd, LFNoise1.kr(1/5).exprange(500,15000));
			rev = Greyhole.ar(snd, [1.4,2.05], feedback:0.9, modDepth:0.6, modFreq: 0.5) * wet + snd;
			rev = Splay.ar(rev);
			rev = rev * amp;

			OffsetOut.ar(outBus, rev);
		}).add;

		SynthDef(\fmkick, {
			arg gate=1, rls=1, amp=0.1, freq=190, outBus=0, fxBus, fxwet=0;
			var snd, square; //, env, fenv;

			//env = ;
			//fenv = EnvGen.ar(Env.perc(0.001, rls), gate, doneAction:2);
			//
			freq = freq * EnvGen.ar(Env.perc(0.01, rls, 1, -10));
			square = Pulse.ar(freq*2 + 20, mul:0.2);
			freq = freq * SinOsc.ar(freq/1.2, mul:3);
			snd = SinOsc.ar(
				freq: freq,
				mul: EnvGen.ar(Env.perc(0.001, rls, 1, 10))
			);


			snd = snd + square;
			snd = LeakDC.ar(snd);
			snd = snd + WhiteNoise.ar(EnvGen.ar(Env.perc(0.00001, 0.01), levelScale:0.4));
			snd = LPF.ar(snd, freq: EnvGen.ar(Env.perc(0.0001, rls, 20000, -4)) + 50);
			snd = HPF.ar(snd, 20);

			snd = snd * EnvGen.ar(Env([1,1,0], [rls, 0.1]));
			snd = snd * EnvGen.ar(Env.cutoff, gate, doneAction:Done.freeSelf);
			snd = Splay.ar(snd * amp);

			Out.ar(fxBus, snd * fxwet);
			Out.ar(outBus, snd);
		}).add;

		SynthDef(\glc, {
			arg gate=1, amp=0.1, outBus=0, rls=0.01, pan=0;
			var glc;

			glc = WhiteNoise.ar(LFNoise0.kr(3).range(0,3))
			+ Pulse.ar(LFNoise0.kr(8).range(1000,10000), mul:LFNoise0.kr(2).range(0,3));
			glc = glc * EnvGen.kr(Env.cutoff(rls), gate, doneAction:2);


			//* LFPulse.ar(LFNoise0.kr(3).range(0.01,10), width:LFNoise0.kr(5).range(0.01,0.1)).range(0,0.6);
			glc = RLPF.ar(in:glc, freq:LFNoise1.kr(5).exprange(300,10000), rq:LFNoise1.kr(5).range(0.2,0.9),
				//mul:LFNoise0.kr(1/2).exprange(0.1,0.9)
			);
			glc = Decimator.ar(glc, 8000, 8);
			glc = LPF.ar(glc, 8000);

			glc = Pan2.ar(glc * amp, pan);

			Out.ar(outBus, glc * amp);

		}).add;

		SynthDef(\phpHatSnare, {
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

		SynthDef(\envnoise, {
			arg gate=1, amp=0.1, outBus=0, atk=8, crv=8, bpff=2000;
			var snd;

			snd = ClipNoise.ar(EnvGen.ar(Env.asr(atk, 1, 0, crv), gate, doneAction:Done.freeSelf));
			snd = BPF.ar(snd, bpff);
			snd = Pan2.ar(snd, LFNoise1.kr(1, mul:0.7));

			Out.ar(outBus, snd * amp);
		}).add;

		SynthDef(\dlywrangler, {
			arg outBus=0, inBus, wet=0.1;
			var snd, dly2;
			snd = In.ar(inBus,2);
			dly2 = CombN.ar(HPF.ar(snd,300), 1, [0.5,0.77], 5, mul:LFNoise1.kr(0.1).range(0.8,0.3));
			snd = CombN.ar(snd, 1, Lag.ar(LFNoise0.ar(2).range(0.01,0.1),0.1), 3, mul:wet) + snd;
			snd = Decimator.ar(snd, LFNoise1.kr(1).range(8000,22000), 0.2, 1.5) + (snd*0.5);
			snd = AnalogTape.ar(snd,  1, 1);
			snd = Compander.ar(snd, snd,
				thresh: 0.9,
				slopeBelow: 1,
				slopeAbove: 0.01,
				clampTime:  0.01,
				relaxTime:  0.01);
			snd = BHiShelf.ar(snd, 3000, 0.2, 5);
			Out.ar(outBus, snd * Line.ar);
		}).add;

		SynthDef(\gran, {
			var snd;

			snd = GrainBuf.ar(2,
				trigger: Impulse.ar(LFNoise1.kr(1/10!3).exprange(80, 180) * LFNoise0.ar(100).range(0.7,1.1)),
				dur: LFNoise1.ar(1).range(0.08,0.1),
				sndbuf: b,
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
			snd = snd * Lag2.kr(\amp.kr(0.5), 20);

			Out.ar(0,snd * 0.2);
		}).add;

		SynthDef(\recbuf, {
			arg inBus, bufnum;

			RecordBuf.ar(
				In.ar(
					inBus, 1),
				bufnum);
		}).add;

		~revFXbus1.free;
		~revFXbus1 = Bus.audio(s, 2);

		~manglebus1.free;
		~manglebus1 = Bus.audio(s, 2);

		s.sync;
		"--- loaded SynthDefs, created Busses ...".postln;

		wait(1);

		//~reverb1.free;
		~reverb1 = Synth(\revfx, [\inBus, ~revFXbus1, \wet, 0.4], addAction:\addToTail);

		"--- recording to buffer ...".postln;
		~recbuf = Synth(\recbuf, [\inBus, ~revFXbus1, \bufnum, b], addAction:\addToTail);

		//~dlywrangler.free;
		~dlywrangler = Synth(\dlywrangler, [\inBus, ~manglebus1], addAction:\addToTail);

		s.sync;

		"--- created FX Synths ...".postln;

		wait(1);



		//~recbuf.free

		// clear everything

		Pbindef(\fmP).clear;
		Pbindef(\fmPt).clear;
		Pbindef(\fmPq).clear;
		Pbindef(\fmPe).clear;
		Pbindef(\fmPb).clear;

		Pbindef(\fmkickP).clear;
		Pbindef(\phpSnareP).clear;
		Pbindef(\glcP).clear;

		"--- cleared patterns ...".postln;
		"--- waiting for 8th bar to start patterns Routine ...\n".postln;

		wait(1);

		Routine({

			"--- start patterns Routine ...".postln;
			"--- starting FM pattern fmP ...".postln;


			Pbindef(\fmP, *[
				instrument: \fm5,
				dur:1,
				degree: 0,
				octave: 3,
				i: Pwhite(0.4,0.6),
				f: Pdup(44, Pseq([4,5,6,7,8,9,10, Prand((4..18), inf)])),
				outBus: ~revFXbus1,
				amp: Pseg([0.05,0.3,0.05], 22, \lin, inf),
			]).play(quant:4);

			~postbeats.();
			wait(32);

			"--- starting FM pattern fmPt ...".postln;

			Pbindef(\fmPt, *[
				instrument: \fm5,
				dur:1.5,
				degree: 6,
				octave: 3,
				i: Pwhite(0.2,0.9),
				f: Pdup(33, Prand((4..18)/4, inf)),
				outBus: ~revFXbus1,
				amp: Pseg([0.05,0.3,0.05], 15, \lin, inf),
			]).play(quant:4);

			~postbeats.();
			wait(32);

			"--- starting FM pattern fmPq...".postln;

			Pbindef(\fmPq, *[
				instrument: \fm5,
				dur:1/3,
				degree: 6,
				rls:1,
				octave: 5,
				i: Pwhite(0.4,0.7),
				f: Pdup(12, Pn(Pshuf([1,2,3,4]*2,4))), //Pdup(18, Prand((4..18)/4, inf)),
				outBus: ~revFXbus1,
				amp: Pseg([0.05,0.3,0.05], 29, \lin, inf) * 0.2,
			]).play(quant:4);

			"--- starting granulator ...".postln;
			~gran = Synth(\gran, [\amp, 1]);

			~postbeats.();
			wait(32);

			"--- raising volume - gran amp 7 ...".postln;
			~gran.set(\amp, 7);

			~postbeats.();
			wait(40);

			"--- envnoiseP slide in ...".postln;

			Pbindef(\envnoiseP, *[
				instrument: \envnoise,
				atk:8,
				crv:8,
				dur: Pseq([8]),
				amp:0.2,
				bpff: 500,
				legato: 1
			]).play(quant:8);

			~postbeats.();
			wait(8);

			"--- starting FM pattern fmPe and fmPb ...".postln;

			Pbindef(\fmPe, *[
				instrument: \fm5,
				dur:1/8,
				legato: 0.5,
				rls: Pseq([0.2,0.1,0.1,0.1],inf),
				degree: 6,
				octave: 9,
				i: Pseg([0.4,0.6,0.4], 10, \lin, inf),
				f: 5.8, //Pdup(64, Prand((4..18)/4, inf)),
				outBus: ~manglebus1,
				amp: Pseg([0.05,0.3,0.05], 15, \lin, inf) * 0.05,
			]).play(quant:4);

			Pbindef(\fmPb, *[
				instrument: \fm5,
				dur:Pseq([Rest(1/2),Pn(8)]),
				degree: 0,
				octave: 2,
				rls:10,
				i: 1,
				f: 1,
				outBus: 0,
				amp: 0.1,
			]).play(quant:8);

			~postbeats.();
			wait(32);

			"--- fm pause...".postln;

			~recbuf.free;

			Pbindef(\fmP).stop;
			Pbindef(\fmPt).stop;
			Pbindef(\fmPq).stop;

			~postbeats.();
			wait(16);

			"--- envnoiseP ...".postln;

			Pbindef(\envnoiseP, *[
				instrument: \envnoise,
				atk:8,
				crv:8,
				dur: Pseq([8]),
				amp:0.2,
				bpff: 500,
				legato: 1
			]).play(quant:8);

			"--- ~recbuf ...".postln;
			// restart recording into buffer for granulator
			~recbuf = Synth(\recbuf, [\inBus, ~revFXbus1, \bufnum, b], addAction:\addToTail);

			~postbeats.();
			wait(8);

			"--- starting fm+beats ...".postln;

			Pbindef(\fmP, *[
				f: Pdup(44, Prand((4..18), inf)),
				amp: Pseg([0.05,0.3,0.05], 22, \lin, inf),
			]).play(quant:8);
			Pbindef(\fmPt).play(quant:8);
			Pbindef(\fmPq).play(quant:8);

			Pbindef(\glcP, *[
				instrument: \glc,
				dur:1/8,
				legato: Pseq([0.3,0.1,0.9], inf),
				amp: Pseq([0.3,0.1,0.2], inf),
				outBus: ~manglebus1,
				manglewet: Pseg([0.001, 0.2, 0.05, 0.5], [8,0], \exp, inf),
				setmangle: Pfunc({ |ev|
					s.bind{
						~dlywrangler.set(\wet, ev.manglewet)
					}
				})

			]).play(quant:8);

			Pbindef(\fmkickP, *[
				instrument: \fmkick,
				dur: 2,
				freq: 100 * Pwhite(0.8,1.3),
				amp:0.5,
				rls:  Pwhite(0.4,0.7),
				outBus:0,
				fxBus: ~manglebus1,
				fxwet: Pwhite(0.1,0.5),
			]).play(quant:8);

			~postbeats.();
			wait(40); // ================= <

			Pbindef(\envnoiseP, *[
				instrument: \envnoise,
				atk:4,
				crv:8,
				dur: Pseq([Rest(4),4]),
				amp:0.2,
				bpff: 2500,
				legato: 1
			]).play(quant:4);

			~postbeats.();
			wait(4);


			"--- beats pause ...".postln;

			Pbindef(\fmkickP).stop;
			Pbindef(\glcP).stop;


			"--- return beats on next 8 bar ...".postln;

			Pbindef(\glcP, *[
				manglewet: Pseg([0.001, 0.3, 0.05, 0.7], [8,0], \exp, inf),
			]).play(quant:8);

			Pbindef(\fmkickP, *[
				dur: Pseq([Pn(1,7), 3/4, 1/4,
					1, 1/2, 3/2, 1, 1, 1, 1, 3/4, 1/4],inf)
			]).play(quant:8);

			Pbindef(\phpSnareP, *[
				instrument: 'phpHatSnare',
				dur: Pseq([ Rest(1), Pn(2)]),
				rls: Pwhite(0.3,0.6),
				amp:0.11,
				bpa: 0,
				lpa: 3,
				hpa: 1,
				legato:0.1,
				outBus: ~manglebus1
			]).play(quant:8);

			~postbeats.();
			wait(28);



			"--- envnoise slidein ...".postln;
			Pbindef(\envnoiseP, *[
				instrument: \envnoise,
				atk:8,
				crv:12,
				dur: Pseq([8]),
				amp:0.2,
				bpff: 3500,
				legato: 1
			]).play(quant:8);

			wait(6);

			"--- beats pause II ...".postln;
			Pbindef(\fmkickP).stop;
			Pbindef(\glcP).stop;
			Pbindef(\phpSnareP).stop;

			~postbeats.();
			wait(2);

			"--- return beats II on next 8 bar ...".postln;

			Pbindef(\glcP).play(quant:8);
			Pbindef(\phpSnareP).play(quant:8);

			Pbindef(\fmkickP, *[
				instrument: \fmkick,
				dur: Pseq([
					Pwrand([
						Pseq([3/4, 4/4, 3/4]),
						Pseq([3/4, 7/4]),
						Pseq([1/4, 2/4, 3/4, 4/4]),
						Pseq([1/4, 1/4, 1/4, 7/4])
					], [0.7, 0.1, 0.1, 0.1]),
					Pconst(6/4, Pwrand([1/4, 1/8, 1/2, Pn(1/6,3)], [0.3,0.1,0.5,0.1],inf))
				], inf),
				freq: 100 * Pwhite(0.8,1.3),
				amp:0.4,
				rls:  Pwhite(0.4,0.7),
				outBus:0,
				fxBus: ~manglebus1,
				fxwet: Pwhite(0.1,0.5),

			]).play(quant:8);

			~postbeats.();
			wait(8);


			Pbindef(\envnoiseP, *[
				instrument: \envnoise,
				atk:4,
				crv:8,
				dur: Pseq([Rest(4),4]),
				amp:0.2,
				bpff: 5500,
				legato: 1
			]).play(quant:4);

			~postbeats.();
			wait(7);

			"--- beats pause 3 ...".postln;

			Pbindef(\fmkickP).stop;
			Pbindef(\glcP).stop;
			Pbindef(\phpSnareP).stop;

			"--- return beats 3".postln;

			Pbindef(\fmkickP).play(quant:8);
			Pbindef(\glcP).play(quant:8);
			Pbindef(\glcP, *[
				manglewet: Pseg([0.01, 0.5, 0.1, 0.9], [8,0], \exp, inf),
			]).play(quant:8);
			Pbindef(\phpSnareP, *[
				instrument: 'phpHatSnare',
				dur: Pseq([
					Rest(1),
					5/4,
					Pconst(7/4, Prand([Rest(1/4),1/4,1/2,1/8,1,1/2],inf)),
				], inf),
				rls: Pwhite(0.3,0.6),
				amp:0.1,
				bpa: 0,
				lpa: 3,
				hpa: 1,
				legato:0.1,
				outBus: ~manglebus1
			]).play(quant:8);

			"--- ~gran.set(\amp, 3);".postln;
			~gran.set(\amp, 3);

			~postbeats.();
			wait(17);

			"--- ~gran.set(\dist, 1);".postln;
			~gran.set(\dist, 1);

			~postbeats.();
			wait(16);

			"--- ~gran.set(\dist, 2);".postln;
			~gran.set(\dist, 2);

			~postbeats.();
			wait(16);

			"--- ~gran.set(\dist, 4);".postln;
			~gran.set(\dist, 4);

			~postbeats.();
			wait(24);

			"--- envnoise slidein ...".postln;
			Pbindef(\envnoiseP, *[
				instrument: \envnoise,
				atk:16,
				crv: -3,
				dur: Pseq([16]),
				amp:0.1,
				bpff: 7500,
				legato: 1
			]).play(quant:8);

			~postbeats.();
			wait(16);

			"--- ~gran.set(\dist, 3);".postln;
			~gran.set(\dist, 3);


			"--- stop everything. wait.".postln;

			Pbindef(\fmP).stop;
			Pbindef(\fmPt).stop;
			Pbindef(\fmPq).stop;
			Pbindef(\fmPe).stop;
			~recbuf.free;

			Pbindef(\fmkickP).stop;
			Pbindef(\phpSnareP).stop;
			Pbindef(\glcP).stop;

			~postbeats.();
			wait(32);

			"--- ~gran.set(\dist, 1);".postln;
			~gran.set(\dist, 1);

			~postbeats.();
			wait(24);

			"--- ~gran.set(\amp, 0);".postln;
			~gran.set(\amp, 0);

			~postbeats.();
			wait(3);
			Pbindef(\fmPb).stop;

			~postbeats.();
			wait(64);

			~postbeats.();
			// END OF ROUTINE /////////////////////////// ------------------------
			"<<< end of pattern Routine ---------------------------------.".postln;
		}).play(quant:8);
		//"<<< end of primary Routine ---------------------------------.".postln;
		// reached when pattern Routine starts, in fact.
	}).play;

}) // end wait for boot
)
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
/*
    PEER PRODUCTION LICENCE
	(https://civicwise.org/peer-production-licence-_-human-readable-summary/)

	You are free to:
    Share — copy and redistribute the material in any medium or format
    Adapt — remix, transform, and build upon the material

	Under the following terms:

	Attribution — You must give appropriate credit, provide a link to the
	license, and indicate if changes were made. You may do so in any reasonable
	manner, but not in any way that suggests the licensor endorses you or your
	use.

	ShareAlike — If you remix, transform, or build upon the material, you must
	distribute your contributions under the same license as the original.

	Non Capitalist — The commercial exploitation of this work is only allowed to
	cooperatives, organizations and non-profit groups, to organizations of
	self-managed workers, and where there are no exploitative relationships. Any
	surplus or surplus obtained by the exercise of the rights granted by this
	License on the Work must be distributed by and among the workers.

	Understanding that:

	Disclaimer — Some of these conditions may not apply if permission is
	obtained from the copyright holder.

	Public Domain — When the work or any of its elements is in the public domain
	according to the applicable law, this situation will not be affected by the
	license.

	Other rights — The following rights are not affected by the license in any
	way:

    	The rights derived from legitimate uses or other limitations recognized
		by law are not affected by the foregoing.

		The moral rights of the author.

		Rights that other people may hold over the work itself or its use, such
		as image or privacy rights.

	Notice — When reusing or distributing the work, you must make the terms of
	the license of this work very clear. The best way to do it is to link to
	this page.

	FULL LICENCE: https://civicwise.org/peer-production-licence/

*/
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
