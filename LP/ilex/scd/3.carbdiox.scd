(
/*

		carbdiox.

		!!! - IMPORTANT - !!!

		YOU NEED PortedPlugins (https://github.com/madskjeldgaard/portedplugins)
		and DEIND UGens from sc3-plugins (https://github.com/supercollider/sc3-plugins)
		for this code to work in your SuperColider.

*/

s.waitForBoot({

	Routine({

		// load synthdefs
		SynthDef(\fm4, {
			arg gate=1, outBus=0, amp=0.1, freq=160,
			atk=5, rls=5, f=9, i=0.9;
			var c, m, d, snd, env, mod, modp;

			c = freq; // c = carrier frequency
			m = c * f; // f = ratio (factor) between carrier freq and mod freq
			d = m / i; // index = ratio between depth/distance and mod freq

			c = [c, c * 2, c / 2];

			mod = SinOsc.ar( SinOsc.ar(m, mul:d), mul: d);
			modp = LFPulse.ar( SinOsc.ar(m, mul:d), mul: d);

			// basic FM synthesis:
			snd = SinOsc.ar( c + mod );

			// but let's add more oscilators with similary modulated frequencies
			snd = snd + ( LFPulse.ar(c + mod * LFNoise1.kr(1).range(0.99,1.05) ) * LFNoise1.ar(1/3).range(0.8,1) );
			snd = snd + ( LFTri.ar(c + modp * LFNoise1.kr(1).range(0.99,1.05) ) * LFNoise1.ar(1/3).range(0.8,1) );

			snd = Splay.ar(snd, center:LFNoise1.kr(1/10));
			snd = LeakDC.ar(snd);
			env = EnvGen.ar(Env.asr(atk, 1, rls, 0), gate, doneAction:2);
			snd = snd * env * amp;

			Out.ar(outBus, snd);
		}).add;

		// reverb synthdef
		SynthDef(\revfx, { |inBus, outBus = 0, wet = 0.5, amp = 0.2|
			var snd, rev;

			snd = In.ar(inBus, 2);

			snd = AnalogTape.ar(snd,
				LFNoise1.kr(1/5).range(0.5,1),
				LFNoise1.kr(1/5).range(0.5,1),
				LFNoise1.kr(1/5).range(0.5,1) );
			snd = LPF.ar(snd, LFNoise1.kr(1/30).exprange(500,20000));
			rev = Greyhole.ar(snd, [1.4,2.05], feedback:0.5, modDepth:0.6, modFreq: 0.5) * wet + snd;
			rev = rev + JPverb.ar(rev, 20, 0, 5);
			rev = Splay.ar(rev);
			rev = rev * amp;

			Out.ar(outBus, rev);
		}).add;

		s.sync;

		~fxBus1.free; ~fxBus1 = Bus.audio(s, 2);
		~fxBus2.free; ~fxBus2 = Bus.audio(s, 2);
		~fxBus3.free; ~fxBus3 = Bus.audio(s, 2);

		1.wait;

		//~reverb1.free;
		~reverb1 = Synth(\revfx, [\inBus, ~fxBus1], addAction:\addToTail);
		//~reverb2.free;
		~reverb2 = Synth(\revfx, [\inBus, ~fxBus2], addAction:\addToTail);
		//~reverb3.free;
		~reverb3 = Synth(\revfx, [\inBus, ~fxBus3], addAction:\addToTail);

		~droneP = Pbind(*[
			instrument: \fm4,
			legato:1,
			atk:Pseq([40, Pn(20,7)]),
			rls:Pseq([Pn(20,7), 0]),
			i:Pwhite(0.5,1),
			f:Pseq((1..5).mirror1, inf),
			octave: Pdup(3, Pseq([4, [4,5], 4])),
			degree:-3,
			amp: 0.5,
		]
		);

		1.wait;

		// play it all here:
		Routine({

			~droneP1 = Pbindf(~droneP, *[ outBus: ~fxBus1, dur:Pseq([Pn(60,7), 60]),
				postln: Pfunc({|ev|
					postln(
						"drone 1 ~ dur:" ++ ev.dur +
						"atk:" ++ ev.atk + "rls:" ++ ev.rls +
						"f:" ++ ev.f + "i:" ++ ev.i)
				})] ).play;

			20.wait;

			~droneP2 = Pbindf(~droneP, *[ outBus: ~fxBus2, dur:Pseq([Pn(60,7), 40]),
				postln: Pfunc({|ev|
					postln(
						"drone 2 ~ dur:" ++ ev.dur +
						"atk:" ++ ev.atk + "rls:" ++ ev.rls +
						"f:" ++ ev.f + "i:" ++ ev.i)
				})] ).play;

			20.wait;

			~droneP3 = Pbindf(~droneP, *[ outBus: ~fxBus3, dur:Pseq([Pn(60,7), 20]),
				postln: Pfunc({|ev|
					postln(
						"drone 3 ~ dur:" ++ ev.dur +
						"atk:" ++ ev.atk + "rls:" ++ ev.rls +
						"f:" ++ ev.f + "i:" ++ ev.i)
				})] ).play;


		}).play
	}).play // end of Routine
}) // end of wait for boot.
)


x=(1..5);x++x.reverse

(1..5).mirror1