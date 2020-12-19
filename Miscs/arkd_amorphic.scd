(
/*

  __    ___   _      __  ___             __    _      ___   ___   ___   _     _   __
 / /\  | |_) | |_/  / / | | \  __       / /\  | |\/| / / \ | |_) | |_) | |_| | | / /`
/_/--\ |_| \ |_| \ /_/  |_|_/ /_/)     /_/--\ |_|  | \_\_/ |_| \ |_|   |_| | |_| \_\_,

by Luka Prinčič. https://lukaprincic.si


LICENCE? Oh whatever, just take what you need from it, learn,
create, publish. A lot of what's in here has been taken and
learned from others and reworked in one way or another.

For the sake of ___, it's
copyright Luka Prinčič,
released under GNU GPL licence and/or Peer Production Licence

To run this album, you need SuperCollider (3.11 at the time of
writing) and SC3-plugins:

https://supercollider.github.io/
https://supercollider.github.io/sc3-plugins/

Once installed, open this file (it needs to have .scd extension
not .txt) in SCIDE - SuperCollider code editor (development
environment) and choose 'Evaluate file' from 'Language' menu.

Thank you for listening!

Recording of this album is available via Kamizdat record label
under conditions of Creative Commons BY-SA licence.

*/


// -----------------------------------------------------------------------------------

// before boot, raise memory?
#[\internal, \local].do { |s|
	s = Server.perform(s);
	s.options.memSize = 2097152; // 2 gigs
};

Server.default.waitForBoot {
	fork {
		">>> THIS IS THE START, MY FRIEND".postln;

		0.1.wait;

		// prep buses and FX
		"--- prepping bussess ...".postln;

		~mainOut.free;
		~mainOut = Bus.audio(s,2);

		~reverBus.free;
		~reverBus = Bus.audio(s, 2);

		~wranglerBus.free;
		~wranglerBus = Bus.audio(s,2);

		0.1.wait;

		// FX synthdefs
		"--- loading synthdefs for FX...".postln;

		SynthDef(\GreyholeVerb, {
			arg inBus, outBus, revWet=1, feedback = 0.5, lag = 10, dtime = 3, size = 4, diff = 8 ;
			var snd = In.ar(inBus, 2);
			var reverb = Greyhole.ar(snd, dtime, size: size, diff: diff, feedback: feedback);
			revWet = Lag.kr(revWet, lag);
			snd = snd + (reverb * revWet) * 0.5;

			Out.ar(outBus, snd);
		}).add;

		SynthDef(\dlywrangler, {
			arg out=0, in, wet=0.1, wet2=0.4;
			var snd, dly2;

			snd = In.ar(in,2);

			dly2 = CombN.ar(HPF.ar(snd,300),
				1,
				[3/8,5/8] * LFNoise1.kr(0.4).range(0.98,1.02),
				6,
				mul: LFNoise1.kr(0.1).range(0.4,0.1) * 2 * wet2);

			snd = CombN.ar(snd,
				1,
				Lag.ar(LFNoise0.ar(1).range(0.01,0.1),0.1),
				3,
				mul:wet) + snd;

			snd = Limiter.ar(snd, 0.8);
			snd = snd + dly2;

			Out.ar(out, snd);
		}).add;

		SynthDef(\mainOutFx, {
			arg inBus, amp=1, lag=0.5, thresh=0.8, outBus;
			var input, snd;
			input = In.ar(inBus, 2);
			snd = Limiter.ar(input, thresh);
			amp = VarLag.kr(amp+0.000001, lag, 0, \cub) - 0.000001;
			snd = snd * amp;
			snd = snd.softclip;
			Out.ar(outBus, snd);
		}).add;

		0.1.wait;

		// effects
		"--- running effects ...".postln;

		//~greyholeVerb.free;
		~greyholeVerb = Synth(\GreyholeVerb, [\inBus, ~reverBus, \outBus, ~mainOut,
			\revWet, 1], addAction:\addToTail);

		//~dlywrang1.free;
		~dlywrang1 = Synth("dlywrangler",
			[\out, ~mainOut, \in, ~wranglerBus], addAction:\addToTail);

		//~mainOutFx.free;
		~mainOutFx = Synth(\mainOutFx,
			[\inBus, ~mainOut, \outBus, 0], addAction:\addToTail);

		// ---------------------------------------------------------------------------------
		"*** setup done. onto the timeline! ...".postln;

		1.wait;

		//~greyholeVerb.set(\revWet, 0.4);
		~greyholeVerb.set(*[revWet:0.2, feedback:0.7, lag:10, dtime:0.1, size:5, diff:0.707 ]);

		// darksaw
		"--- dark saw synthdef...".postln;
		SynthDef(\softSaw, {
			arg out = 0, freq = 40, oscdetune = 0.1, amp = 1, pan = 0,
			gate = 1, attackTime = 0.1, susLevel = 1.0, releaseTime = 1.0, gainBus;
			var env, snd;
			oscdetune = oscdetune * 0.1;
			amp = amp * 0.4;

			env = Linen.kr(gate, attackTime, susLevel, releaseTime, doneAction:2);

			snd = VarSaw.ar(
				freq: [freq, freq * (1.003 + oscdetune)],
				width: SinOsc.kr(0.01,0.2).range(0.05,0.095));
			snd = snd + VarSaw.ar(
				freq: [(freq*2 * (1.001 - oscdetune)),(freq*2 * (1 + oscdetune))],
				width: SinOsc.kr(0.06,0.8).range(0.2,0.8));
			snd = Balance2.ar(snd.at(0), snd.at(1), pos: pan);
			snd = snd * amp * env  * In.kr(gainBus,1);

			OffsetOut.ar(out, snd);
		}).add;

		~softSawAmpBus.free;
		~softSawAmpBus = Bus.control(s,1);
		~softSawAmpBus.set(1);
		~softSawAmpBusLiner = SynthDef(\linexamp0, { |outBus, lag, val|
			Out.kr(outBus, VarLag.kr(val+0.0001, lag, 0, \cub) - 0.0001)
		}).play(s, [outBus: ~softSawAmpBus, lag: 10, val:0]);

		wait(0.5);

		"--- be back lighter...".postln;

		// -----------------------------------------------
		// be back lighter

		// synthdef
		SynthDef(\param, { arg freq = 100, sustain, amp, out=0;
			var sig;
			sig = LFPar.ar(freq: [freq, freq*2.02]);
			sig = sig * [1,0.2];
			sig = (sig * 4).softclip * 0.8;
			//sig = LPF.ar(HPF.ar(sig, 150), 3000);
			sig = LPF.ar(sig, (freq * 3).min(20000));
			sig = sig * EnvGen.kr(Env.perc(0, sustain, 0.5), doneAction:2) * amp;
			sig = Splay.ar(sig, Rand(0,0.5), 1, Rand(-0.5,0.5));
			Out.ar(out, sig);
		}).add;

		0.2.wait;

		//set main out gain to 0
		~mainOutFx.set(\lag, 0, \amp, 0);
		0.2.wait;

		// start playing starting pattern
		Pbindef(\prand,
			\instrument, \param,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = 0; //rrand(0,11);
					interval = 2;
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}),
			\dur, Prand([1,2,4,8,12,16,4,6,8], inf) / 20,
			\amp, 1.2,
			\sustain, 0.2,
			\out, ~reverBus
		).play;	"    . 1.0".postln;


		// fade in:
		~mainOutFx.set(\lag, 10, \amp, 1);

		30.wait;

		~greyholeVerb.set(*[revWet:0.4, feedback:0.7, lag:10, dtime:0.1, size:5, diff:0.707 ]);

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = 0; //rrand(0,11);
					interval = rrand(2,4);
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}), // - Pstutter(4, Prand([0,1] * 12,inf)),
			\sustain, Prand((2..4)/10,inf),
		); "    . 1.1 - interval rrand 2-4".postln;

		30.wait;

		// --

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = [0,2,4,6].choose; //rrand(0,11);
					interval = rrand(2,4);
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12,24].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12,24].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}) - Pstutter(4, Prand([0,1] * 12,inf)),
			\sustain, Prand((4..6)/10,inf),
		); "    . 1.2 [0,2,4,6].choose".postln;

		1.wait;

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
			\out, ~reverBus,
			\gainBus, ~softSawAmpBus
		).play;

		wait(1);

		~softSawAmpBusLiner.set(\lag, 0, \val, 0);
		wait(0.5);
		~softSawAmpBusLiner.set(\lag, 20, \val, 1);
		wait(0.5);

		// --

		30.wait;

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = rrand(0,11);
					interval = rrand(2,4);
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12,24].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12,24].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}) - Pstutter(4, Prand([0,1] * 12,inf)),
			\sustain, Prand((9..10)/10,inf),
		); "    . 1.3 rrand(0,11), sustain".postln;

		30.wait;

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = 0; //rrand(0,2);
					interval = rrand(2,4);
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12,24].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12,24].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}) - Pstutter(4, Prand([0,1] * 12,inf)),
			\sustain, Prand((3..6)/10,inf),
		); 		"    . 1.4 back to 0".postln;

		~greyholeVerb.set(*[revWet:0.7, feedback:0.7, lag:10, dtime:0.1, size:5, diff:0.707 ]);

		~softSawAmpBusLiner.set(\lag, 20, \val, 0.7);

		30.wait;

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = 0; //rrand(0,2);
					interval = 4; //rrand(2,4);
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12,24].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}), // - Pstutter(4, Prand([0,1] * 12,inf)),
			\sustain, Prand((5..9)/10,inf),
		); 		"    . 1.5 interval 4".postln;

		~greyholeVerb.set(*[revWet:0.5, feedback:0.7, lag:10, dtime:0.1, size:5, diff:0.707 ]);

		~softSawAmpBusLiner.set(\lag, 20, \val, 1.5);

		21.wait;

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = rrand(0,11);
					interval = rrand(2,4);
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12,24].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12,24].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}) - Pstutter(4, Prand([0,1] * 12,inf)),
			\sustain, Prand((9..10)/10,inf),
		); "    . 1.6 rrand0-11".postln;

		30.wait;

		~greyholeVerb.set(*[revWet:0.3, feedback:0.7, lag:10, dtime:0.1, size:5, diff:0.707 ]);

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = 0; //rrand(0,11);
					interval = 2;
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12, 24].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}),
			\sustain, Prand((4..9)/10,inf),
		).play;	"    . 1.7 tone0:0".postln;

		~softSawAmpBusLiner.set(\lag, 20, \val, 0.5);

		10.wait;

		~greyholeVerb.set(*[revWet:0.6, feedback:0.7, lag:10, dtime:0.1, size:5, diff:0.707 ]);

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = 0; //rrand(0,11);
					interval = 2;
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12, 24].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}),
			\sustain, Prand((4..9)/10,inf),
		).play;	"    . 1.8 24".postln;

		10.wait;

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = 0; //rrand(0,11);
					interval = 2;
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12, 24].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12, 24].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}),
			\sustain, Prand((4..9)/10,inf),
		).play;	"    . 1.9 24 & 24".postln;

		10.wait;

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = rrand(0,11);
					interval = rrand(2,4);
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12,24].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12,24].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}) - Pstutter(4, Prand([0,1] * 12,inf)),
			\sustain, Prand((9..10)/10,inf),
		); "    . 1.10 rrand0-11".postln;

		~softSawAmpBusLiner.set(\lag, 60, \val, 0);

		30.wait;

		Pbindef(\sawp0).stop;

		~greyholeVerb.set(*[revWet:0.8, feedback:0.7, lag:10, dtime:0.1, size:5, diff:0.707 ]);

		Pbindef(\prand,
			\midinote, Prout({
				var tone0, tone1, tone2, interval, freq0, delta;
				loop {
					tone0 = 0; //rrand(0,11);
					interval = 2;
					tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12].choose + 0.1;
					tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12].choose;
					freq0 = [tone1,tone2] + 52;
					freq0.yield;
				}
			}),
			\sustain, Prand((2..5)/10,inf),
		).play;	"    . 1.11 tone0".postln;

		10.wait;

		// sure one could use Pseg here:
		Pbindef(\prand, \amp, -1.dbamp); 2.wait;
		Pbindef(\prand, \amp, -2.dbamp); 2.wait;
		Pbindef(\prand, \amp, -3.dbamp); 2.wait;
		Pbindef(\prand, \amp, -4.dbamp); 2.wait;
		Pbindef(\prand, \amp, -5.dbamp); 2.wait;
		Pbindef(\prand, \amp, -6.dbamp); 2.wait;
		Pbindef(\prand, \amp, -7.dbamp); 2.wait;
		Pbindef(\prand, \amp, -8.dbamp); 2.wait;
		Pbindef(\prand, \amp, -9.dbamp); 10.wait;

		Pbindef(\prand).stop;

		// gcd mod ---------------------------------------------------------

		"--- gcdmod...".postln;
		SynthDef(\gcdmod, {
			arg outBus, amp=0.1, gate=1;
			var env;
			var a = TDuty.ar(Dseq((0..3), inf) + 5 * SampleDur.ir);
			var b = TDuty.ar(Dseq((3..0), inf) + 5.01 * SampleDur.ir);
			var mod = 50;
			var t = PulseCount.ar(a) % mod;
			var u = PulseCount.ar(b) % mod;
			var n, j, d, e, c;

			d = LocalIn.ar(2);
			n = gcd(t, u + [0, 1]);
			e = n.linexp(0, mod, 70, 10000);
			j = SinOsc.ar(e);
			LocalOut.ar(j * d);

			c = CombC.ar(j, 1, [0.009,0.007,0.008, 0.006] * LFNoise1.ar([0.01,0.01]).range(1.3,0.7), 30, mul:0.05);
			j = j * LFNoise1.ar(0.2).range(0,0.5) + Splay.ar(c);
			j = Greyhole.ar(j, damp:0.5, diff:0.5 size:4);
			j = Limiter.ar(LPF.ar(HPF.ar(j, 100), LFNoise1.kr(0.1).exprange(200,18000)), 0.7);
			j = j * LFPulse.ar([2.2,4.4]*2, 0.96, width:LFNoise1.ar(0.2).range(0.8,0.95)).range(LFNoise1.ar(0.1).range(0,1),1);
			j = j + LFPulse.ar([2.2,4.4], 0.96, mul: LFNoise1.kr(1/10).range(0,0.5) * Line.kr(0,1,30));
			j = LeakDC.ar(j);

			env = Linen.kr(gate, 0, 1, 0, 2);
			j = j * env * amp;
			Out.ar(outBus, j);
		}).add;

		SynthDef(\dNoz, {
			arg out=0, gate=1, amp=0.1, envattackTime=0.001, release=0.001;
			var snd, env;
			env = Linen.kr(gate, envattackTime, 1, release, doneAction:2);
			snd = WhiteNoise.ar(1);
			snd = snd + SinOsc.ar(SinOsc.kr(10).range(40,60), mul:0.2);
			snd = snd + Pulse.ar(SinOsc.kr(12).range(40,60), mul:0.1);
			snd = snd.clip2(0.8);

			snd = LPF.ar(snd, LFNoise2.ar(0.4).range(60,100), mul:3);

			snd = snd.dup;
			snd[1] = DelayL.ar(snd[1], 0.05, SinOsc.kr(0.2).range(0.001,0.003));
			snd = snd * env * amp;
			Out.ar(out, snd);
		}).add;

		1.wait;

		Pbindef(\gcdmodp,
			\instrument, \gcdmod,
			\dur, Pseq([240]),
			\amp, 0.7,
			\legato, 1,
			\outBus, ~mainOut,
		).play;

		30.wait;

		Pbindef(\dBoz,
			\instrument, \dNoz,
			\dur, Pseq([Rest(5), 10],14),
			\amp, 0.4,
			\legato, 1,
			\out, ~mainOut,
		).play; "--- dBoz dNoz...".postln;

		wait(190);

		"--- akj...".postln;
		// AKJ --------------------------------------------------------
		SynthDef(\akjDisChord, {
			arg freq=300, amp=0.1, out=0, gate=1;
			var snd, env;

			freq = [freq,freq*1.01];
			snd = LFPar.ar(freq) * 0.3
			+ (LFTri.ar(freq*16/19, mul:0.3))
			+ (Pulse.ar(freq*21/40, mul:0.1))
			+ (SinOsc.ar(freq/8.01, mul:4).clip2(0.3));
			env = EnvGen.kr(Env([0,1,0],[20,30], \cub, 1), gate, doneAction:2);
			snd = Splay.ar(snd);
			snd = snd * env * amp;

			Out.ar(out, snd);
		}).add;

		SynthDef(\akjBaz, {
			arg freq=300, amp=0.1, out=0, gate=1;
			var snd, env;

			snd = SinOsc.ar(freq/4, mul:0.7)!2;
			snd = snd * Lag.ar(LFPulse.ar(freq/8.02, 0.5).range(1,0),0.005);
			snd = snd.softclip(0.5) * 1.5 ;

			env = Linen.kr(gate, 0,1,0, 2);

			snd = snd * env * amp;

			Splay.ar(snd);
			Out.ar(out, snd);
		}).add;

		SynthDef(\akjClick, {
			arg out=0, gate=1, freq=440, amp=0.1, releaseTime=0.1;
			var snd, env;

			snd = LFPulse.ar([freq, freq * 2], width: LFNoise1.ar(0.1).exprange(0.001,0.004));
			snd = snd + (WhiteNoise.ar(1) * snd);
			snd = HPF.ar(snd, 200);
			env = EnvGen.ar(Env.perc(0,releaseTime));
			snd = snd * env * amp * Linen.kr(gate, 0, 1, releaseTime, 2);
			snd = Splay.ar(snd);

			Out.ar(out, snd);
		}).add;

		wait(0.2);

		Pbindef(\akjDisChordp, *[
			instrument: \akjDisChord,
			freq:300,
			dur: Pseq([260]),
			legato: 1.1,
			amp: 0.8,
			out: ~mainOut
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
			out: ~mainOut
		]).play;

		wait(60);

		Pbindef(\akjBazp, *[
			instrument: \akjBaz,
			freq: 300,
			dur: 10,
			amp: 0.3,
			legato: 0.20,
			out: ~mainOut
		]).play;

		wait(120);

		Pbindef(\akjClickp).stop;
		Pbindef(\akjBazp).stop;

		wait(30);


		"--- shippo...".postln;
		// SHIPPO -----------------------------------------------------------

		SynthDef(\shippo, {
			arg amp=0.1, gate=1, out=0, freq=100;
			var snd, env, rev;
			freq = [freq/2, freq * 0.99, freq * 1.51];
			snd = Pulse.ar(	freq * LFNoise1.ar(1/10).range(1,1.03), mul:0.4 )
			; // Lag.ar(LFPulse.ar(1/5, iphase:0.98, width:0.1));
			snd = Splay.ar(snd,spread:0.6);
			snd = LPF.ar(snd, LFNoise1.ar(1/4).exprange(500,10000));
			env = EnvGen.kr(Env.adsr(0.001,0,1, 0.1, 1), gate, doneAction:0);
			snd = snd * env;
			snd = snd;
			rev = Array.fill (8, {
				CombL.ar(
					snd,
					0.2,
					LFNoise1.ar(1/3).range(0.98,1.02) * rrand(0.01, 0.3),
					7)
			});
			rev = Splay.ar(rev);
			rev = LeakDC.ar(rev);
			rev = HPF.ar(rev, 100);
			snd = snd + rev;
			snd = Limiter.ar(snd, 0.8);
			snd = snd * amp;
			DetectSilence.ar(snd, doneAction:2);
			Out.ar(out, snd);
		}).add;

		wait(0.1);

		Pbindef(\shippoP, *[
			instrument: \shippo,
			degree: 4,
			octave: 3,
			//dur: Pseq([3,5,10] / 8, inf),
			dur: Pseq([4,8,12] / 8, inf),
			legato:0.3,
			amp: 0.1,
			out: ~mainOut
		]);
		Pbindef(\shippoP).quant(1);
		Pbindef(\shippoP).play;

		Pbindef(\akjDisChordp).stop;

		wait(10);
		Pbindef(\shippoP, \amp, 0.2); wait(3);
		Pbindef(\shippoP, \amp, 0.3); wait(3);
		Pbindef(\shippoP, \amp, 0.4); wait(3);
		Pbindef(\shippoP, \amp, 0.5); wait(3);
		Pbindef(\shippoP, \amp, 0.6); wait(20);

		// midline ---------------------------------------------------------
		"--- sawline ...".postln;
		SynthDef(\sawLine, {
			arg out=0, freq=440, gate=1, amp=1, alag=10;
			var snd, env, gen, numosc;

			numosc = 10;
			env = Env.adsr(20, 0, 1, 30, 1, \sin);
			gen = EnvGen.kr(env, gate, doneAction:2);

			//faderosc = SinOsc.ar(1/60).range(-1,2).min(1).max(0);

			snd = Array.fill(numosc, {
				var local, lfreq;
				lfreq = [freq, freq*2.01, freq/1.99 ];
				//lfreq = [freq, freq * 1.98, freq * 0.51];
				//lfreq = freq;
				local = Saw.ar(rrand(lfreq, lfreq * 1.02 ) * LFNoise1.kr(0.3).range(1, 1.01), -10.dbamp * [0.5, 0.3, 0.3]);
				local = Mix(local);
			});
			snd = Splay.ar(snd);
			snd = LPF.ar(snd, LFNoise1.ar(0.06).exprange(3000,10000));
			snd = CombL.ar(snd, 1, LFNoise1.ar(0.1).range([0.5,0.65],[0.53,0.68]), 15, -1.dbamp) + snd;

			snd = snd * gen;
			snd = snd * Lag.kr(amp, alag);
			Out.ar(out, snd);
		}).add;

		wait(0.5);

		Pbindef(\midlineP,
			\instrument, \sawLine,
			\dur, 8,
			\degree, 6,
			\octave, 7,
			\out, ~reverBus,
			\amp, 0.4,
			\ctranspose, 6-12,
			\scale, Scale.minor(\just),
		).play;

		// --------------------------------------------------------------------

		wait(30);
		Pbindef(\midlineP, \degree, 1);
		wait(20);
		Pbindef(\midlineP, \degree, 4);
		wait(20);
		Pbindef(\midlineP, \degree, 6);
		wait(20);
		Pbindef(\midlineP, \degree, 4);
		wait(10);
		Pbindef(\midlineP, \octave, [5,7]);
		wait(20);
		Pbindef(\shippoP).stop;

		wait(5);

		// --- wrangle mel ------------------------------------------------------
		"--- wranglemel ...".postln;

		SynthDef(\sin1, {
			arg freq=440, out=0, gate=1, amp=0.1, release=0, cutoff=10, rq=0.5;
			var snd, env;

			freq = [freq,freq*1.01];
			env = Linen.kr(gate, attackTime: 0.001, releaseTime: release, doneAction:2);
			snd = SinOsc.ar(freq) + Saw.ar(freq*1.004, mul:0.3) + Pulse.ar(freq*0.996, mul:0.4);
			snd = snd + snd.fold2(0.65);
			snd = (snd * 0.5) + (snd.wrap2(0.64) * 0.5) * 2;
			cutoff = cutoff  * 0.1;
			cutoff = freq.pow(cutoff);
			cutoff = cutoff.max(100);
			cutoff = cutoff.min(18000);
			snd = RLPF.ar(snd, cutoff, rq);
			snd = snd * env;
			snd = snd * amp;

			OffsetOut.ar(out, snd);
		}).add;

		wait(0.5);

		// basics
		Pbindef(\y3,
			\instrument, \sin1,
			\degree, Pseq( [ 0, 2, -1, 5, -2, 6 ], inf),
			\ctranspose, 6-12,
			\octave, 5,
			\scale, Scale.minor(\just),
			\mtranspose, 0,

			\cutoff, Pstutter(16, Pseq([Pseq((13..18)),Pseq((17..12))].min(11),inf)),
			\rq, Prand([0.2,0.3,0.5]*1,inf),
			\legato, Pseq([Prand([1,0.7]), 0.6, 0.9, 0.4, 0.6] * 0.2, inf),
			\release, 0.1,

			\dur, 1/8,
			\amp, [0.2,0.2,0.1] * Pseq([Prand([1,0.7]), 0.8, 0.9], inf) * 0.4,

			\dlywet, Pstutter(8, Pfunc({~dlywrang1.set(\wet, rrand(0, ((0..1) * 0.1).choose ) ) })),
			\out, ~wranglerBus,
		);
		Pbindef(\y3).quant=1;
		Pbindef(\y3).play;

		wait(20);

		Pbindef(\midlineP, \degree, Pseq([6,1,4], inf), \dur, 40 );
		Pbindef(\midlineP, \amp, 0.1 );

		Pbindef(\y3, \cutoff, Pstutter(16, Pseq([Pseq((13..18)),Pseq((17..12))].min(13),inf)));
		Pbindef(\y3, \legato, Pseq([Prand([1,0.7]), 0.6, 0.9, 0.4, 0.6] * 0.3, inf));

		wait(15);

		Pbindef(\y3, \cutoff, Pstutter(16, Pseq([Pseq((13..18)),Pseq((17..12))].min(14),inf)));
		Pbindef(\y3, \legato, Pseq([Prand([1,0.7]), 0.6, 0.9, 0.4, 0.6] * 0.4, inf));

		wait(15);

		Pbindef(\y3, \cutoff, Pstutter(16, Pseq([Pseq((13..18)),Pseq((17..12))].min(15),inf)));
		Pbindef(\y3, \legato, Pseq([Prand([1,0.7]), 0.6, 0.9, 0.4, 0.6] * 0.5, inf));
		Pbindef(\y3, \octave, [4,5]);
		Pbindef(\y3, \degree, Pseq( [ [7,0], 2, -1, Prand([4,5]), Prand([-2,Pseq([2,6])]) ], inf));

		wait(30);

		Pbindef(\y3, \cutoff, Pstutter(16, Pseq([Pseq((13..18)),Pseq((17..12))].min(16),inf)));
		Pbindef(\y3, \legato, Pseq([Prand([1,0.7]), 0.6, 0.9, 0.4, 0.6] * 0.6, inf));
		Pbindef(\y3, \octave, [4,5,6]);
		Pbindef(\y3, \mtranspose, Pstutter(16, Pseq([Pn(0,4), 3,5],inf)));

		wait(30);

		Pbindef(\y3, \mtranspose, Pstutter(16, Pseq([7, Pn(0,3), 3, 5 ],inf)));

		// --- whitenoise hihat ----------------------------------------------------
		"--- wHat ...".postln;

		SynthDef(\wHat, {
			arg outBus=0, amp=0.1, freq=2000, rq=0.5, gate=1, release=0.002, pan=0;
			var snd, env;
			env = EnvGen.kr(Env.cutoff(release), gate, doneAction:2);
			snd = BPF.ar(WhiteNoise.ar, freq, rq, amp);
			snd = HPF.ar(snd, 1000);

			snd = snd * env;

			OffsetOut.ar(outBus, Pan2.ar(snd,pan));
		}).add;

		Pbindef(\wHatp,
			\instrument, \wHat,
			\dur, 1/8,
			\freq, Prand([1,2,3,4] * 300 + 2500, inf),
			\rq, Prand([0.8,0.7,0.6], inf),
			\pan, Prand((1..10) * 0.1 - 0.5,inf),
			\amp, Prand((1..10) * 0.02 + 0.3,inf),
			\outBus, ~mainOut, // wrangler?
			\legato, Pseq([Pn(0.05,7),Prand((1..10)/80+0.05,inf)],inf),
		);

		Pbindef(\wHatp).quant(1);

		wait(22/8);

		Pbindef(\wHatp).play;

		wait(30);

		Pbindef(\midlineP).stop;

		//wait(30);

		Pbindef(\wHatp, \legato, Pseq([	Pseq((1..24)/24,1), Pseq([Pn(0.05,7),Prand((1..10)/80+0.05,inf)],inf)]));
		wait(24/8);

		Pbindef(\y3, \cutoff, Pstutter(16, Pseq([Pseq((13..18)),Pseq((17..12))].min(17),inf)));
		Pbindef(\y3, \legato, Pseq([Prand([1,0.7]), 0.6, 0.9, 0.4, 0.6] * 0.7, inf));
		Pbindef(\y3, \octave, [4,5,6] + Pwrand([0,2,1, 3],[0.7,0.1,0.1,0.1],inf));

		wait(30);

		Pbindef(\y3, \cutoff, Pstutter(16, Pseq([Pseq((13..18)),Pseq((17..12))].min(18),inf)));
		Pbindef(\y3, \legato, Pseq([Prand([1,0.7]), 0.6, 0.9, 0.4, 0.6] * 0.8, inf));
		Pbindef(\y3, \octave, Pstutter(32, Pseq( [5, [4,5], [4,5,6] ], inf), inf) + Pwrand( [0,1,1,-1], [0.7,0.1,0.1,0.1], inf));
		Pbindef(\y3, \dlywet, Pstutter(8, Pfunc({~dlywrang1.set(\wet, rrand(0, ((0..4) * 0.1).choose ) ) })));

		wait(30);

		Pbindef(\y3, \legato, Pseq([Prand([1,0.7]), 0.6, 0.9, 0.4, 0.6] * 0.9, inf));
		Pbindef(\y3, \octave, Pstutter(32, Pseq( [5, [4,5], [4,5,6] ], inf), inf) + Pwrand( [0,1,2,-1], [0.7,0.1,0.1,0.1], inf));

		wait(30);

		Pbindef(\wHatp, \legato, Pseq([	Pseq((1..24)/24,1), Pseq([Pn(0.05,7),Prand((1..10)/80+0.05,inf)],inf)]));
		wait(20/8);
		Pbindef(\wHatp).stop;

		Pbindef(\y3, \legato, Pseq([Prand([1,0.7]), 0.6, 0.9, 0.4, 0.6] * 0.3, inf));
		Pbindef(\y3, \cutoff, Pstutter(16, Pseq([Pseq((13..18)),Pseq((17..12))].min(14),inf)));

		wait(20);

		Pbindef(\y3, \legato, Pseq([Prand([1,0.7]), 0.6, 0.9, 0.4, 0.6] * 0.6, inf));
		Pbindef(\y3, \degree, Pseq( [ 0, 2, -1, 5, -2, 6 ], inf));
		Pbindef(\y3, \octave, [4,5]);
		//Pbindef(\y3, \octave, [4,5,6] + Pwrand([0,2,1, 3],[0.7,0.1,0.1,0.1],inf));
		Pbindef(\y3, \dlywet, Pstutter(8, Pfunc({~dlywrang1.set(\wet, rrand(0, ((3..9) * 0.1).choose ) ) })));

		wait(30);
		~dlywrang1.set(\wet2, 1);
		wait(4);

		Pbindef(\y3).stop;

		wait(4);

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

		wait(0.5);

		Pbindef(\lcmnoip,
			\instrument, \lcmnoise,

			\dur, Pseq([
				Pseq([
					Prand([Pseq([0.01,0.01]),0.02]),
					Pn(0.05,19),
					9.03
				], 20), // 20 x 10
				30]),

			\amp, 1,
			\amp1, Pseq([1,0.1],inf),
			\amp2, Pseq([0.6,1],inf),
			\legato, 1,
			\out, ~mainOut,
		).play;

		160.wait;

		"--- s1distdron...".postln;
		// S1 DISTORTED DRONE -----------------------------------------------------
		SynthDef(\s1Dist, {
			arg freq=440, gate=1, out=0, amp=0.1, ampBus, d1 = 5, d2 = 1, d3=5, ffreq=200, ffreqBus;
			var snd = Saw.ar([freq, freq*1.01]);
			var env = Linen.kr(gate, releaseTime: 0.1, doneAction:2);
			snd = snd + SinOsc.ar([freq*0.99, freq]);
			snd = snd + Pulse.ar([freq*0.99, freq]);

			snd = snd.clip2(LFNoise1.ar(0.3).range(0.3,0.8)) * d1;
			snd = snd.wrap2(LFNoise1.ar(0.3).range(0.3,0.8)) * d2;
			snd = snd.fold2(LFNoise1.ar(0.3).range(0.3,0.8)) * d3;
			snd = LeakDC.ar(snd);

			ffreq = In.kr(ffreqBus, 1);
			ffreq = ffreq.max(20);
			snd = LPF.ar(snd, ffreq);

			snd = Limiter.ar(snd);
			snd = Splay.ar(snd);

			amp = In.kr(ampBus, 1);
			Out.ar(out, snd*env*amp);
		}).add;

		~s1DistAmpBus.free;
		~s1DistAmpBus = Bus.control(s,1);
		~s1DistAmpBus.set(0);
		~s1DistAmpLiner = SynthDef(\linexamp, { |outBus, lag, val|
			Out.kr(outBus, VarLag.kr(val+0.0001, lag, 0, \cub) - 0.0001 * 0.9)
		}).play(s, [outBus: ~s1DistAmpBus, lag: 10, val:0]);

		~s1DistFfreqBus.free;
		~s1DistFfreqBus = Bus.control(s,1);
		~s1DistFfreqBus.set(100);
		~s1DistFfreqLiner = SynthDef(\linexamp, { |outBus, lag, val|
			Out.kr(outBus, VarLag.kr(val+0.0001, lag, 0, \cub) - 0.0001)
		}).play(s, [outBus: ~s1DistFfreqBus, lag: 10, val:200]);

		wait(0.5);

		Pbindef(\s1DistP,
			\instrument, \s1Dist,
			\degree, -1,
			\dur, 2,
			\octave, [2,3],
			\d1, Prand((1..5),inf),
			\d2,  Prand((1..5),inf),
			\d3, 5,
			\legato, 1,
			// needs wrangled delay!
			\out, ~wranglerBus,
			\dlywet, Pstutter(8, Pfunc({~dlywrang1.set(\wet, rrand(0, ((3..6) * 0.1).choose ) ) })),
			\ampBus, ~s1DistAmpBus,
			\ffreqBus, ~s1DistFfreqBus
		).play;

		wait(1);

		~s1DistAmpLiner.set(\lag, 40, \val, 0.4); wait(20);
		~s1DistFfreqLiner.set(\lag, 40, \val, 500); wait(40);
		~s1DistFfreqLiner.set(\lag, 10, \val, 1500); wait(30);
		~s1DistFfreqLiner.set(\lag, 10, \val, 7500); wait(20);
		~s1DistFfreqLiner.set(\lag, 1, \val, 700); wait(10);
		~s1DistFfreqLiner.set(\lag, 5, \val, 2700); wait(10);
		~s1DistFfreqLiner.set(\lag, 1, \val, 400); wait(10);
		~s1DistFfreqLiner.set(\lag, 1, \val, 6400); wait(10);
		~s1DistFfreqLiner.set(\lag, 1, \val, 15400); wait(5);
		~s1DistFfreqLiner.set(\lag, 7, \val, 1000); wait(20);
		~s1DistFfreqLiner.set(\lag, 7, \val, 3000); wait(10);
		~s1DistFfreqLiner.set(\lag, 7, \val, 400); wait(20);
		~s1DistFfreqLiner.set(\lag, 1, \val, 20000); wait(5);


		SynthDef(\dustnoise, {
			arg outBus=0, gate=1, amp=0.1, release=1, density=1;
			var snd, env;

			env = Linen.kr(gate, 0, 1, release, 2);
			snd = WhiteNoise.ar * LFPulse.ar(0.06, width:0.02) * -25.dbamp;
			snd = HPF.ar(snd, 2000);
			snd = snd + Dust.ar(LFNoise1.ar(0.1).range(1,100) * density, mul:0.2);
			snd = Pan2.ar(snd, LFNoise1.kr(0.1).range(-0.5,0.5));
			snd = snd * env * amp;
			OffsetOut.ar(outBus, snd);
		}).add;

		wait(0.5);

		Pbindef(\dustnoiseP,
			\instrument, \dustnoise,
			\amp, 1,
			\dur, 30,
			\legato, 1,
			\release, 0.1,
			\density, 10,
		).play;

		~s1DistFfreqLiner.set(\lag, 7, \val, 1000); wait(20);
		~s1DistFfreqLiner.set(\lag, 20, \val, 300); wait(20);
		~s1DistFfreqLiner.set(\lag, 5, \val, 3300); wait(5);
		~s1DistFfreqLiner.set(\lag, 5, \val, 150); wait(5);

		Pbindef(\dustnoiseP, \density, 4);

		~s1DistAmpLiner.set(\lag, 15, \val, 0.5); wait(15);

		"--- padme ...".postln;
		// padme -----------------------------------------------------------------------------------
		SynthDef(\padme, {
			arg out=0, gate=1, amp=1, alag=10, freq;
			var sum, snd0, env, gen, numosc;

			numosc = 10;
			env = Env.adsr(20, 0, 1, 30, 1, \cub);
			gen = EnvGen.kr(env, gate, doneAction:2);

			snd0 = Array.fill(numosc, {
				var lfreq, local;
				lfreq = [freq, freq * 1.5, freq * 3, freq * 4];
				local = Saw.ar(rrand(lfreq, lfreq * 1.03 ) * LFNoise1.kr(0.3).range(1, 1.03), -10.dbamp);
				local = Mix(local);
			});
			snd0 = Splay.ar(snd0);
			snd0 = LPF.ar(snd0, LFNoise1.ar(0.06).exprange(300,10000));
			snd0 = CombL.ar(snd0, 1, LFNoise1.ar(0.05).range([0.5,0.65],[0.53,0.68]), 15, -1.dbamp) + snd0;

			sum = snd0 * gen;
			sum = sum * Lag.kr(amp, alag);
			Out.ar(out, sum);
		}).add;

		wait(0.2);

		Pbindef(\padmeP,
			\instrument, \padme,
			\freq, Pseq([50, 80],inf),
			\dur, 30,
			\legato, 1.2,
			\amp, 0.9,
			\out, ~mainOut
		).play;

		~s1DistAmpLiner.set(\lag, 20, \val, 0); wait(15);

		Pbindef(\s1DistP).stop;
		~s1DistAmpLiner.free;
		~s1DistFfreqLiner.free;

		wait(30);

		wait(30);
		Pbindef(\dustnoiseP, \density, 1);
		wait(110);

		Pbindef(\padmeP, \freq, Pseq([80],inf));

		wait(20);

		Pbindef(\padmeP, \amp, 0.4);

		Pbindef(\dustnoiseP, \amp, Pseg(Pseq([1,0]), 90, \cub) ); // ???

		// -- Soft dark saw ---------------------------------------
		"--- soft dark saw...".postln;
		Pbindef(\sawp1,
			*[
				instrument: \softSaw,
				dur: 10,
				attackTime: 5,
				releaseTime:5,
				legato:1,
				degree: Pseq([ [-2,3,11,20], [-2,5,7,21] ],inf),
				octave: 3,
				amp: [1,0.5,0.2,0.1] * 0.7,
				out: ~reverBus,
				gainBus: ~softSawAmpBus
			]
		).play;

		wait(1);

		~softSawAmpBusLiner.set(\lag, 0, \val, 0);
		wait(0.5);
		~softSawAmpBusLiner.set(\lag, 20, \val, 1);
		wait(0.5);

		wait(30);
		Pbindef(\padmeP, \amp, 0.2);

		wait(60);
		Pbindef(\padmeP).stop;
		Pbindef(\dustnoiseP).stop;

		wait(30);

		Pbindef(\sawp1,	\amp, [1,0.5,0.2,0.1] * 0.5);

		wait(15);

		~greyholeVerb.set(*[revWet:0.5, feedback:0.8, lag:10, dtime:0.1, size:5, diff:0.707 ]);

		"--- lorenz patterns...".postln;
		// -- lorenz patterns ------------------------------------------
		SynthDef(\blipo, { | out, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1, sustain, attack=0.1 |
			var audio = Blip.ar(freq * (SinOsc.kr(3).range(1,1.01)), nharms, amp);
			var env = Linen.kr(gate, attackTime: attack, releaseTime: sustain, doneAction: Done.freeSelf);
			OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
		}).add;

		wait(0.5);

		~dotsP = Pbind(
			\dur, Pflatten(1, Plorenz() * 1),
			\attack, 0.01,
			\octave, 3,
			\amp, 0.4,
			\nharms, Prand((2..7),500) );

		~linesP = Pbind(
			\dur, Pflatten(1, Plorenz() * 5),
			\attack, 3,
			\octave, Prand([2,3,4],inf),
			\nharms, Prand((1..4),80),
			\amp, 0.3 );

		~highP = Pbind(
			\dur, Pflatten(1, Plorenz() * 5),
			\attack, 3,
			\octave, 5,
			\nharms, Prand((1..3),50),
			\amp, 0.03 );

		// just plays out!
		~lorenzP = Pbindf(
			Ptpar([ 0, ~dotsP, 60, ~linesP, 160, ~highP]),
			\instrument, \blipo,
			\degree, (Pflatten(1, Plorenz()) * 18).asInteger,
			\mtranspose, Prand([Pn(0,24),Pn(2,24),Pn(4,24)], inf),
			\detune, Prand([0,1,0.5,1.5], inf),
			\scale, Scale.major(\pythagorean),
			\legato, Prand((4..7),inf) * 0.2,
			\pan, Prand((-10..10),inf) * 0.1,
			\out, ~reverBus
		).play;

		wait(140);

		~softSawAmpBusLiner.set(\lag, 120, \val, 0);

		wait(120);

		Pbindef(\sawp1).stop;

		while({ ~lorenzP.isPlaying }, { wait(1); });

		wait(10);

		// fade out
		~mainOutFx.set(\lag, 10, \amp, 0);

		wait(5);

		//////////////////////////////////////////////////////////////////////////

		"<<< THIS IS THE END, MY FRIEND.\n---------------------------------\n\n".postln;
		s.freeAll;
		"";
	};

};
);
