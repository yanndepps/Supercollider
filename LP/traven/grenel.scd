(
/* *******************************************************************

	Grenel Cycles (Limbo For Corrupt Politicians)
	copyright 2021 by Luka Prinčič
	distribution and re-use allowed under conditions of PP:BY-SA-NC 
	(Peer Production: Attribution - ShareAlike - NonCapitalist) Licence

	****************************************************************** */

s.waitForBoot({
	fork({
		
		"-----------------------------------------".postln;


		// buffers/samples --

		~b1 = Buffer.read(s, PathName.new(thisProcess.nowExecutingPath).pathOnly +/+ "pe4enkata_beatbox.wav");
		~b2 = Buffer.read(s, PathName.new(thisProcess.nowExecutingPath).pathOnly +/+ "pe4enkata_diggity.wav");

		s.sync;

		// busses --

		~revBus = Bus.audio(s, 2);
		~dlyBus = Bus.audio(s, 2);

		s.sync;


		// syntdefs --
		
		SynthDef(\grenel, {
			arg outBus = 0, gate = 1, amp = 0.1, buf, pos = 0, atk = 1, rls = 1, rand = 0, frq = 0.1, rate = 1, ffreq = 450;
			var snd, gfreq = 200;
			snd = GrainBuf.ar(
				numChannels: 2,
				trigger: Impulse.ar(gfreq * LFNoise0.ar(gfreq).range(1, 0.8) ),
				dur: 0.2,
				sndbuf: buf,
				rate: rate,
				pos:
				( LFNoise1.kr(frq).range(0,0.2) * rand ) +
				( SinOsc.kr(frq).range(0,0.03) * (rand-1).abs )
				+ pos
				* LFNoise0.ar(gfreq).range(1, 0.999), // rand position a bit
				pan: LFNoise1.ar(0.5) * 0.5
			);
			snd = LPF.ar(in: snd, freq: LFNoise1.ar(0.1).exprange(ffreq,15000));
			snd = snd * EnvGen.kr(Env([0,1,0], [atk,rls], [3,-3], 1), gate, doneAction:Done.freeSelf);
			snd = snd * amp;

			Out.ar(outBus, snd);
		}).add;

		SynthDef(\revfx,
			{
				arg inBus, outBus, amp=1, revtime=10;
				var input, snd;

				input = In.ar(inBus, 2);
				snd = GVerb.ar(input.sum, 100, revtime, drylevel:0, mul:-6.dbamp, add:input);
				snd = snd * amp;
				
				Out.ar(outBus, snd);
			}
		).add;

		SynthDef(\dlyfx,
			{
				arg inBus, outBus, amp=1, dry=1, wet= -8.dbamp;
				var input, snd;

				input = In.ar(inBus, 2);
				snd = input * dry + CombN.ar(input, 1, [0.33,0.44], 5, mul:wet);
				snd = snd * amp;
				
				Out.ar(outBus, snd);
			}
		).add;


		s.sync;





		// reverb
		~revfx = Synth(\revfx, [\inBus, ~revBus, \outBus, 0, \amp, -5.dbamp], addAction:\addToTail);

		// delay fx
		~dlyfx = Synth(\dlyfx, [\inBus, ~dlyBus, \outBus, 0, \amp, -5.dbamp], addAction:\addToTail);

		s.sync;
		
		Pbind(*[ // GRANULATOR 1
			instrument:\grenel,
			pos: Pseq([ // a certain sequence. a love.
				Pn(0.5, 2),
				[0.5,0.4],
				Pn([0.4], 2),
				[0.4,0.6], 
				Pn([0.6], 2),
				[0.6,0.24], 
				Pn([0.24], 2),
				[0.72, 0.24], 
				Pn([0.72], 2),
				[0.7, 0.72], 
				Pn([0.7], 2),
				[0.55, 0.7], 
				Pn([0.55], 2),
				[0.75, 0.55],
				Pn([0.75], 2),
				[0.66, 0.75], 
				Pn([0.66], 2),
				[0.11, 0.66],
				Pn([0.11], 2),
				[0.5, 0.11], // 30 * 30sec =  15min
				Pn([0.5], 2), // 1 min
			]),
			rate: [0.25, 0.5, 1],
			dur: 30,
			legato:0.95,
			atk: 4,
			rls: 10,
			buf: ~b2,
			amp: -15.dbamp,
			outBus: ~revBus,

			// debug:
			postln: Pfunc({arg e; postln("G1 pos:" + e.pos)})
		]).play;

		
		Pbind(*[ // GRANULATOR 2
			instrument:\grenel,
			pos: Pwhite(0.1,0.9),
			rate: [0.5,1,1],
			ffreq: 9000,
			dur: Pseq([Rest(6 * 30), Pn(Pseq([Rest(30), 30]), 32-6)]),
			legato:1,
			atk: 7,
			rls: 0.1,
			buf: ~b1,
			rand: Pwhite(0.1, 1, 32-5),
			frq: Prand([1, 1/2, 1/4], inf),
			amp:-26.dbamp,
			outBus: ~dlyBus,

			// debug:
			postln: Pfunc(
				{
					arg e;
					postln("G2 pos:"
						+ e.pos.round(0.01)
						+ " rand:"
						+ e.rand.round(0.01)
						+ " dur:"
						+ e.dur
						+ " frq:"
						+ e.frq)
				})
		]).play;

	})
})
)