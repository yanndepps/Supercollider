// DreamCrusher
// © Zack Scholl
// Recoded

// --- start --- //
s.options.memSize = 8192 * 256;

s.boot;

s.quit;

s.meter;
s.scope;
s.makeWindow;

FreqScope.new;

s.plotTree;

s.prepareForRecord;
s.record;
s.stopRecording;

// --- 1. Tone --- //
// start with a basic tone ( basic C3 sine wave ) and turn it into a drone
(
x = SynthDef("basic",
	{
		arg hz=131.81, amp=0.5;
		var sig;
		sig = SinOsc.ar(
			freq:hz,
			mul:amp,
		);
		// make two version -> left & right
		sig = sig.dup;
		Out.ar(0, sig);
	}
).play;
)

// change freq & amp while playing
x.set("hz", 65.41*1); // up one octave
x.set("amp", 0.01); // volume down

// --- 2. overtones --- //
// overtones are multiples of fundamental at lower volumes
// make sure to decrease the volume of each increasing frequency by
// dividing the amp by a multiple of 2.
(
x = SynthDef("basic_w_overtones",
	{
		arg hz=131.81, amp=0.5;
		var sig;

		// drone zone
		sig = Mix.ar([
			SinOsc.ar(
				freq: hz,
				mul: amp,
			),
			SinOsc.ar(
				freq: hz*2,
				mul: amp/2,
			),
			SinOsc.ar(
				freq: hz*4,
				mul: amp/4,
			)
		]);

		// spread the signal
		sig = Splay.ar(sig);

		// sound
		Out.ar(0, sig);
	}
).play;
)

// --- 3. different oscillators --- //
(
x = SynthDef("basic_w_overtones_varsaw",
	{
		arg hz=131.81, amp=0.5;
		var sig;

		// drone zone
		sig = Mix.ar([
			SinOscFB.ar(
				freq: hz,
				mul: amp,
			),
			VarSaw.ar(
				freq: hz*2,
				mul: amp/2,
			),
			VarSaw.ar(
				freq: hz*4,
				mul: amp/4,
			)
		]);

		// spread signal
		sig = Splay.ar(sig);

		// sound
		Out.ar(0, sig);
	}
).play;
)

x.set("hz", 65.41*1.0);

// --- 4. modulation --- //
// mod will bring in organic wavering to the drone.
// here we'll use a randomly oscillating sine wave with a long period.
(
x = SynthDef("basic_modulation",
	{
		arg hz=131.81, amp=0.5;
		var sig;

		// drone zone
		sig = Mix.ar(
			VarSaw.ar(
				freq: Lag.kr(hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
				width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
				mul: amp,
			) +
			VarSaw.ar(
				freq: Lag.kr(2*hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
				width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
				mul: amp/2,
			) +
			VarSaw.ar(
				freq: Lag.kr(4*hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
				width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
				mul: amp/4,
			)
		);

		// spread signal
		sig = Splay.ar(sig);

		// pan
		sig = Balance2.ar(sig[0], sig[1], SinOsc.kr(LFNoise0.kr(0.1).range(0.05,0.2))*0.1);

		// sound
		Out.ar(0, sig);
	}
).play;
)

// --- 5. filter & effects --- //
// feedback & drunken walk type modulation
(
x = SynthDef("dreamcrusher",
	{
		arg hz=131.81, amp=0.5;
		var local, ampcheck, sig;

		// oscillator part
		sig = Mix.ar(
			VarSaw.ar(
				freq: Lag.kr(hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
				width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
				mul: amp,
			) +
			VarSaw.ar(
				freq: Lag.kr(2*hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
				width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
				mul: amp/2,
			) +
			VarSaw.ar(
				freq: Lag.kr(4*hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
				width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
				mul: amp/4,
			)
		);

		// spread signal
		sig = Splay.ar(sig);

		// pan
		sig = Balance2.ar(sig[0], sig[1], SinOsc.kr(LFNoise0.kr(0.1).range(0.05,0.5))*0.1);

		// feedback
		ampcheck = Amplitude.kr(sig);
		sig = sig * (ampcheck > 0.02); // noise gate
		local = LocalIn.ar(2);
		local = OnePole.ar(local, 0.4);
		local = OnePole.ar(local, -0.08);
		local = Rotate2.ar(local[0], local[1], 0.2);
		local = DelayN.ar(local, 0.3, VarLag.kr(LFNoise0.kr(0.1).range(0.15,0.3),1/0.1,warp:\sine));
		local = LeakDC.ar(local);
		sig = ((local + sig) * 1.25).softclip;

		// filter with drunken walk modulation
		sig = LPF.ar(sig, VarLag.kr(LFNoise0.kr(0.3).range(ArrayMin.kr([hz,80]),16000),1/0.3,warp:\sine));

		// feedback
		LocalOut.ar(sig * VarLag.kr(LFNoise0.kr(2).range(0.9,1.2),1/2,warp:\sine));

		// panning
		sig = Balance2.ar(sig[0] * 0.2,sig[1]*0.2,SinOsc.kr(LFNoise0.kr(0.1).range(0.05,0.2))*0.1)*amp;

		// send it out
		Out.ar(0, sig);
	}
).play;
)

x.set("hz", 65.41*1.0);

// --- moog ladder filter --- //
(
x = SynthDef("dreamcrusher",
	{
		arg hz=131.81, amp=0.5;
		var local, ampcheck, sig;

		// oscillator part
		sig = Mix.ar(
			VarSaw.ar(
				freq: Lag.kr(hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
				width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
				mul: amp,
			) +
			VarSaw.ar(
				freq: Lag.kr(2*hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
				width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
				mul: amp/2,
			) +
			VarSaw.ar(
				freq: Lag.kr(4*hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
				width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
				mul: amp/4,
			)
		);

		// spread signal
		sig = Splay.ar(sig);

		// pan
		sig = Balance2.ar(sig[0], sig[1], SinOsc.kr(LFNoise0.kr(0.1).range(0.05,0.5))*0.1);

		// feedback
		ampcheck = Amplitude.kr(sig);
		sig = sig * (ampcheck > 0.02); // noise gate
		local = LocalIn.ar(2);
		local = OnePole.ar(local, 0.4);
		local = OnePole.ar(local, -0.08);
		local = Rotate2.ar(local[0], local[1], 0.2);
		local = DelayN.ar(local, 0.3, VarLag.kr(LFNoise0.kr(0.1).range(0.15,0.3),1/0.1,warp:\sine));
		local = LeakDC.ar(local);
		sig = ((local + sig) * 1.25).softclip;

		// moog filter
		sig = MoogLadder.ar(sig,
			VarLag.kr(LFNoise0.kr(5).range(80,800),1/5,warp:\sine),
			VarLag.kr(LFNoise0.kr(5).range(0,1.0),1/5,warp:\step)
		);

		// feedback
		LocalOut.ar(sig * VarLag.kr(LFNoise0.kr(2).range(0.9,1.2),1/2,warp:\sine));

		// panning
		sig = Balance2.ar(sig[0] * 0.2,sig[1]*0.2,SinOsc.kr(LFNoise0.kr(0.1).range(0.05,0.2))*0.1)*amp;

		// send it out
		Out.ar(0, sig);
	}
).play;
)

x.set("hz", 65.41*1.0);
x.set("amp", 1.0);

// --- end --- //