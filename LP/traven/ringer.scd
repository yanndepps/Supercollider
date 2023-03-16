(
/* ********************************************************************

	Ringer of Shkmeris Mta (Libido & Revolution)

	copyright 2021 by Luka Prinčič
	distribution and re-use allowed under conditions of PP:BY-SA-NC 
	(Peer Production: Attribution - ShareAlike - NonCapitalist) Licence

   ******************************************************************** */

s.waitForBoot({
	fork({
		"-----------------------------------------".postln;
		// load samples
		~shkmeris.free;
		~shkmeris = Buffer.readChannel(s,
			PathName.new(thisProcess.nowExecutingPath).pathOnly
			+/+ "trio_mandili_shkmeris_mta_60s.wav",
			channels:1);

		"-> loaded buffers ...".postln;

		s.sync;

		// SynthDefs ---------------------------------------------------

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
				snd = snd + WhiteNoise.ar(0.3);
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

		SynthDef(\revfx,
			{
				arg inBus, outBus = 0;
				var snd, input;

				input = In.ar(inBus,2);
				snd = GVerb.ar(input.sum, 100);

				Out.ar(outBus, snd);	
			}
		).add;

		SynthDef(\beep_sus,
			{
				arg outBus = 0, freq=440, gate=1, amp=0.1, sawamp = 0.1;
				var snd;

				snd = Pulse.ar(freq) + LFTri.ar(freq/ Rand(1.99,2.01)) + Saw.ar(freq * Rand(1.99,2.01), mul:sawamp);
				snd = snd * EnvGen.kr(Env.cutoff, gate, doneAction:Done.freeSelf);
				snd = snd * amp;
				
				Out.ar(outBus, snd);
			}
		).add;

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

		SynthDef(\grenel,
			{
				arg outBus = 0, gate = 1, amp = 0.1, buf, pos = 0,
				atk = 1, rls = 1, rand = 0, frq = 0.1, rate = 1, ffreq = 450;
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
					pan: LFNoise1.ar(0.5) * 0.9
				);
				snd = LPF.ar(in: snd, freq: LFNoise1.ar(0.1).exprange(ffreq,15000));
				snd = snd * EnvGen.kr(Env([0,1,0], [atk,rls], [3,-3], 1), gate, doneAction:Done.freeSelf);
				snd = snd * amp;

				Out.ar(outBus, snd);
			}
		).add;

		SynthDef(\subCut,
			{
				arg cutoff=85, inBus, outBus;
				var snd, in;
				in = In.ar(inBus, 2);
				snd = HPF.ar(in, cutoff);
				Out.ar(outBus, snd);
			}
		).add;

		SynthDef(\limiter,
			{
				arg cutoff=70, amp = 0.5, threshold = 0.5, inBus, outBus ;
				var snd, in;
				in = In.ar(inBus, 2);
				snd = Limiter.ar(in, threshold) * amp;
				Out.ar(outBus, snd);
			}
		).add;

		"-> loaded SynthDefs ...".postln;

		s.sync;

		// busses
		~fxBus = Bus.audio(s, 1); 
		~fxBus2 = Bus.audio(s, 1);
		~dlyBus = Bus.audio(s, 2);
		~revBus = Bus.audio(s, 2);
		~subBus = Bus.audio(s, 2);
		~limitBus = Bus.audio(s, 2);

		"-> created busses ...".postln; 

		s.sync;


		// Pbinds ---------------------------------------------------------

		~granG = Pbind(*[
			instrument: \grenel,
			buf: ~shkmeris,
			dur: 14,
			frq: 0.01,
			rate: [0.983, 0.983/2,  0.983*2],
			amp:0.07 * [1, 1.5, 0.2],
			ffreq: 3000,
			pos: Pstutter(2, Pxrand([ 0.98, 0.81, 0.78, 0.77, 0.751, 0.689,
				0.639, 0.62, 0.61, 0.52, 0.46, 0.3, 0.2 ], inf), inf),
			legato:1.1,
			outBus: ~dlyBus,
		]);

		~beepP = Pbind(*[
			instrument: \beep_sus,
			dur: 0.2, // quintuplets
			legato: 0.01,
			scale: Scale.minor,
			degree: Pseq([[-7,0], Pxrand([2,4,5,6],6)], inf), // 7 quintuplets
			detune: Pseg([0,1,3,1,0], 5, \cub, inf),
			mtranspose: Pseq([Pn(0, 7*3), Pn(2, 7*3), Pn(-2, 7*4)],inf),
			sawamp: Pseg([0,1,0], 40, \lin, inf),
			outBus: ~fxBus2,
			amp:0.1	
		]);

		~ringP = Pbind(*[
			instrument: 'ringer',
			dur: 5,
			scale: Scale.minor,
			degree: Pseq([0,Prand([2,-2]), Prand([5,4])], inf),
			octave: [4,5,6],
			amp:    [2,2,1] * 0.2,
			detune: Pxrand([0,1,2,3], inf),
			legato: 1,
			outBus: ~fxBus
		]);


		~bassP = Pbind(*[
			instrument: \beep_sus_filt,
			dur: Pseq([Pn(0.5, 112), Pn(0.4, 140)], inf),
			octave: Pseq([Pn([3,4],28), Pn([5,4],28), Pn([6,4],28)], inf),
			scale: Scale.minor,
			degree: Pseq([Pn(Pwrand([0,14],[0.95,0.05]),7),7],inf) * Pwhite(0.999,1.001),
			outBus:~dlyBus,
			legato: Pwhite(0.4,0.7),
			fq: Pseg([0.9,0.6,0.9], 17, \lin, inf),
			amp:0.07,
			ffreq: Pseg([500,2000,500], 10, \exp, inf),
			pan:0
		]);

		~kickP = Pbind(*[
			instrument: 'kick',
			dur: 1,
			degree:0,
			octave:[2,3],
			amp: [1,0.3] * 0.12,
			release: [0.9, 0.3],
			legato:0.6,
			outBus: ~limitBus,
		]);

		~hhP = Pbind(*[
			instrument: 'mhh1',
			dur: Pseq([Prand([1,2]),2,Prand([1,3,Pn(1/2,2)])] * 0.2, inf),
			rls: Pwrand([0.5, 2.5], [0.9,0.1], inf),
			bpa: 0.6,
			lpa: 0.1,
			hpa: 1,
			legato:0.1,
			pan: Pwhite(-0.2,0.2),
			outBus: ~subBus,	
		]); 

		~snP = Pbind(*[
			instrument: 'mhh1',
			dur: Pseq([Prand([4,6]),4,3] * 0.2, inf),
			rls: Pwrand([1, Pwhite(0.5,3.5)], [0.9,0.1], inf),
			bpa: 0,
			lpa: 2,
			hpa: 0,
			legato:0.1,
			outBus: ~subBus,
		]);

		"-> loaded Pbindefs ...".postln; 

		s.sync;

		// load fx to buses
		~fx = Synth(\deciverbfx, [\inBus, ~fxBus, \outBus, ~subBus], addAction: \addToTail);
		~fx2 = Synth(\deciverbfx, [\inBus, ~fxBus2, \outBus, ~subBus], addAction: \addToTail);
		~dly = Synth(\fxdly, [\inBus, ~dlyBus, \outBus, ~subBus], addAction: \addToTail);
		~rev = Synth(\revfx, [\inBus, ~revBus, \outBus, ~subBus], addAction: \addToTail);
		~subCut = Synth(\subCut, [\inBus, ~subBus, \outBus, ~limitBus], addAction: \addToTail);
		~limiter = Synth(\limiter, [\inBus, ~limitBus, \outBus, 0], addAction: \addToTail);

		"-> instantiated fx Synths ...".postln;

		
		// FINAL TIMELINE/SONG SEQUENCE
		s.sync;

		"-> starting final timeline / song sequence ...".postln; 
		
		Pseq([
			
			Pfindur(14, Ppar([
				Pbindf(~kickP),
			])),
			
			Pfindur(28, Ppar([
				Pbindf(~kickP),
				Pfindur(27, Pbindf(~snP)),		
			])),
			
			Pfindur(27.5, Ppar([
				Pbindf(~kickP),
				Pbindf(~snP),		
				Pbindf(~hhP),		
			])),
			
			Rest(0.5),

			Pfindur(28  , Ppar([
				Pbindf(~beepP),
			])),
			
			Pfindur(28, Ppar([
				Pbindf(~beepP),
				Pbindf(~kickP),		
			])),
			
			Pfindur(28, Ppar([
				Pbindf(~beepP),
				Pbindf(~kickP),		
				Pbindf(~snP),
			])),

			Pfindur(28, Ppar([
				Pbindf(~beepP),
				Pfindur(27, Ppar([
					Pbindf(~kickP),		
					Pbindf(~snP),
					Pbindf(~hhP),]))
			])),


			Pfindur(28, Ppar([
				Pbindf(~beepP),
				Pbindf(~granG, *[pos: 0.77]),
				Pbindf(~kickP),				
			])),

			Pfindur(8*14, Ppar([
				Pbindf(~bassP),
				Pbindf(~beepP),
				Pbindf(~kickP),
				Pbindf(~snP),
				Pbindf(~hhP),
				Pbindf(~granG, *[ pos:
					Pseq([0.52, 0.77, 0.2, 0.46 ], inf)
				]),
				Pbindf(~ringP, *[ dur:Pseq([Rest(4*14), Pn(7)])] )
				
			])),
			

			Pfindur(8*14, Ppar([
				Pfindur(4*14, Pbindf(~bassP)),
				Pbindf(~kickP),
				Pfindur(6*14, Pbindf(~snP)),
				Pbindf(~granG, *[ pos:
					Pseq([0.52, 0.77, 0.2, 0.46 ], inf)
				]),
				Pbindf(~ringP, *[ dur: 7] )
				
			])),


			Rest(6),
			
			Pfunc({ "-> final timeline / song sequence end.".postln; }),
			Pfunc({ CmdPeriod.run;}),
			
			//Pfunc({s.quit})
			
			
		]).play;
	})
});
)
