// synth definitions

// AKJ --------------------------------------------------------
SynthDef(\akjDisChord, {
	arg freq=300, amp=0.1, out=0, gate=1;
	var snd, env;

	freq = [freq,freq*1.01];

	snd = LFPar.ar(freq) * 0.3
	+ (LFTri.ar(freq*16/19, mul:0.3))
	+ (Pulse.ar(freq*21/40, mul:0.1))
	+ (SinOsc.ar(freq/8.01, mul:4).clip2(0.3));
	

	env = Linen.kr(gate, attackTime:1, releaseTime:3, doneAction:2);
	snd = Splay.ar(snd);
	snd = snd * env * amp;
	Out.ar(out, snd);
}).add;

SynthDef(\akjBaz, {
	arg freq=300, amp=0.1, out=0, gate=1;
	var snd, env;

	//freq = [freq, freq*2.02, freq*1.98, freq];
	snd = SinOsc.ar(freq/4, mul:0.7)!2;
	//snd = snd * [1, 0.1, 0.1, 1];
	snd = snd * Lag.ar(LFPulse.ar(freq/8.02, 0.5).range(1,0),0.005);
	snd = snd.softclip(0.5) * 1.5 ;
	
	env = Linen.kr(gate, 0,1,0, 2);
	//snd = (snd + (snd.wrap2 * 0.54)).softclip;

	snd = snd * env * amp;
	
	Splay.ar(snd);
	Out.ar(out, snd);
	//LFPulse.ar(0.275, width:0.25).range(0,1);

}).add;

SynthDef(\akjClick, {
	arg out=0, gate=1, freq=440, amp=0.1, releaseTime=0.1;
	var snd, env;

	snd = LFPulse.ar([freq, freq * 2], width: LFNoise1.ar(0.1).exprange(0.001,0.004));
	snd = snd + (WhiteNoise.ar(1) * snd);
	snd = HPF.ar(snd, 200);
    //snd = Limiter.ar((snd * 5));

	env = EnvGen.ar(Env.perc(0,releaseTime));
	
	snd = snd * env * amp * Linen.kr(gate, 0, 1, releaseTime, 2);
	snd = Splay.ar(snd);
	Out.ar(out, snd);
}).add;


// SHIPPO -----------------------------------------------------------

SynthDef(\shippo, {
	arg amp=0.1, gate=1, out=0, freq=100;
	var snd, env, rev;
	freq = [freq/2, freq * 0.99, freq * 1.51];
	snd = Pulse.ar(	freq	* LFNoise1.ar(1/10).range(1,1.03), mul:0.4 )
	; //* Lag.ar(LFPulse.ar(1/5, iphase:0.98, width:0.1));
	snd = Splay.ar(snd,spread:0.6);
	snd = LPF.ar(snd, LFNoise1.ar(1/4).exprange(500,10000));
	env = EnvGen.kr(Env.adsr(0.001,0,1, 0.1, 1), gate, doneAction:0);
	snd = snd * env;
	snd = snd;
	rev = Array.fill (16, {
		CombL.ar(
			snd,
			0.2,
			LFNoise1.ar(1/3).range(0.98,1.02) * rrand(0.01, 0.3),
			10)
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



// S1 DISTORTED DRONE -----------------------------------------------------
SynthDef(\s1Dist, {
	arg freq=440, gate=1, out=0, amp=0.1, d1 = 5, d2 = 1, d3=5, ffreq=200;
	var snd = Saw.ar([freq, freq*1.01]);
	var env = Linen.kr(gate, releaseTime: 0.1, doneAction:2);
	snd = snd + SinOsc.ar([freq*0.99, freq]);
	snd = snd + Pulse.ar([freq*0.99, freq]);
	
	snd = snd.clip2(LFNoise1.ar(0.3).range(0.3,0.8)) * d1;
	snd = snd.wrap2(LFNoise1.ar(0.3).range(0.3,0.8)) * d2;
	snd = snd.fold2(LFNoise1.ar(0.3).range(0.3,0.8)) * d3;
	snd = LeakDC.ar(snd);
	snd = LPF.ar(snd, ffreq);
	snd = Limiter.ar(snd);
	snd = Splay.ar(snd);
	Out.ar(out, snd*env*amp);
}).add;


// twoChPad -----------------------------------------------------------------------------------
SynthDef(\twoChPad, {
	arg out=0, gate=1, amp=1, alag=10;
	var sum, snd0, snd1, snd2, env, gen, faderosc, numosc;

	numosc = 10; 
	env = Env.adsr(20, 0, 1, 30, 1, \sin);
	gen = EnvGen.kr(env, gate, doneAction:2);

	faderosc = SinOsc.ar(1/60).range(-1,2).min(1).max(0);

	snd0 = Array.fill(numosc, {
		var freq, local;
		freq = [100,150,300,400] * 0.5;
		local = Saw.ar(rrand(freq, freq * 1.03 ) * LFNoise1.kr(0.3).range(1, 1.03), -10.dbamp);
		local = Mix(local);
	});
	snd0 = Splay.ar(snd0);
	snd0 = faderosc * snd0;
	snd0 = LPF.ar(snd0, LFNoise1.ar(0.06).exprange(300,10000));
	snd0 = CombL.ar(snd0, 1, LFNoise1.ar(0.05).range([0.5,0.65],[0.53,0.68]), 15, -1.dbamp) + snd0;

	snd1 = Array.fill(numosc, {
		var freq, local;
		freq = [100,150,300,400] * 0.8;
		local = Saw.ar(rrand(freq, freq * 1.03 ) * LFNoise1.kr(0.3).range(1, 1.03), -10.dbamp);
		local = Mix(local);
	});
	snd1 = Splay.ar(snd1);
	snd1 = (0-faderosc+1) * snd1;	
	snd1 = LPF.ar(snd1, LFNoise1.ar(0.07).exprange(300,10000));
	snd1 = CombL.ar(snd1, 1, LFNoise1.ar(0.05).range([0.77,0.65],[0.80,0.68]), 15, -1.dbamp) + snd1;

	snd2 = WhiteNoise.ar * LFPulse.ar(0.06, width:0.02) * -25.dbamp;
	snd2 = HPF.ar(snd2, 2000);
	snd2 = snd2 + Dust.ar(LFNoise1.ar(0.1).range(1,100), mul:0.2);
	
	sum = snd0 + snd1;
	sum = sum * gen + snd2;
	sum = sum * Lag.kr(amp, alag);
	Out.ar(out, sum);
}).add;


// LCM noise -----------------------------------------------------------------

Ndef(\lcmnoise, {
	arg amp1=0, amp2=1;
	var snd, revchain;
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
	revchain = snd * Lag.ar(
		in: LFPulse.ar(
			freq: LFNoise0.ar(1).exprange(0.01,2),
			width: 0.001),
		lagTime: 0.1)
	* LFNoise1.ar(1).range(10,10000);
	
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
	//snd = LPF.ar(snd.softclip, LFNoise1.ar(0.1).exprange(10000,20000)) * 0.8;
});


// -------------------------------

SynthDef(\param, { arg freq = 100, sustain, amp, out=0;
	var sig;
    sig = LFPar.ar(freq: freq,
        mul: EnvGen.kr(Env.perc(0, sustain, 0.5), doneAction:2) * amp);
	sig = Splay.ar(sig);
	Out.ar(out, sig);
}).add;

// -------------------------------

SynthDef(\blipo, { | out, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1, sustain, attack=0.1 |
    var audio = Blip.ar(freq * (SinOsc.kr(3).range(1,1.01)), nharms, amp);
    var env = Linen.kr(gate, attackTime: attack, releaseTime: sustain, doneAction: Done.freeSelf); 
    OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
}).add;

// -------------------------------

Ndef(\gcdmod, {
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
	j = Limiter.ar(LPF.ar(HPF.ar(j, 100), LFNoise1.kr(0.1).exprange(200,18000)), 0.5, 0.55);
	j = j * LFPulse.ar([2.2,4.4]*2, 0.96, width:LFNoise1.ar(0.2).range(0.8,0.95)).range(LFNoise1.ar(0.1).range(0,1),1);
	j = j + LFPulse.ar([2.2,4.4], 0.96, mul: LFNoise1.kr(1/10).range(0,0.5) * Line.kr(0,1,30));
	j = LeakDC.ar(j);
	
	// Out.ar(0, j * EnvGate())
});

// low rumble 0 ------------------------------------
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
// "LFTri bass drum kick" - by luka@lukaprincic.si
SynthDef(\tribd, {
	arg out=0, gate=1, freq=77, amp=0.1;
	var snd,snd1, aenv, fenv, senv;

	fenv = Env(levels:[2, 1.2, 0], times: [0.1, 0.4]).kr;
	freq = [freq,freq*2] * fenv;
	freq = freq.max(10);

	snd = LFTri.ar(freq) + SinOsc.ar(freq) * [1,0.3];
	snd1 = SinOsc.ar(190, mul:3) * EnvGen.ar(Env.perc(releaseTime:0.1), gate) ;
	snd = snd.sum * 0.9;
	snd = LPF.ar(snd, freq * 4);

	snd = snd + RLPF.ar( BrownNoise.ar(1),
		Env(levels:[2000,500,90], times:[0.01,0.05]).kr, 0.3 );

	snd = snd + ( BPF.ar(WhiteNoise.ar(0.5), 3000) 
		* Env([1,1,0], [0.004,0.005]).kr );
	snd = snd + ( BPF.ar(WhiteNoise.ar(0.5), 7000) 
		* Env([1,1,0], [0.003,0.001]).kr );
	
	aenv = Env([1,1,0], [0.2,2], curve: -9).kr;
	snd = snd1 + snd * aenv;
	snd = Limiter.ar(snd, 8);
	
	senv = Linen.kr(releaseTime: 0.1, gate: gate, doneAction: Done.freeSelf);
	snd = LeakDC.ar(snd);
	snd = snd * amp * senv;
	snd = Pan2.ar(snd, pos:0);
	snd = snd.clip2;
	Out.ar(out, snd);
}).add;


// -------------------------------------------------------------------
// reverb effect SynthDef
SynthDef("reverbo", { arg outBus = 0, inBus, wet = 0.1;
	var input = In.ar(inBus,2);
	var rev = JPverb.ar(input * wet, t60:6, damp:0.5);
    Out.ar(outBus, input + (rev));
}).add;


SynthDef(\verbDelayFX, {
	arg inBus, outBus, revWet=0.8, dlyWet=0.8, feedback = 0.5, lag = 10 ;
	
	var snd = In.ar(inBus, 2);
	var verb = JPverb.ar(snd);
	var delay = Greyhole.ar(snd, feedback: feedback);
	revWet = Lag.kr(revWet, lag);
	dlyWet = Lag.kr(dlyWet, lag);
	snd = snd + (verb * revWet) + (delay * dlyWet) * 0.5;
	
	Out.ar(outBus, snd);
}).add;


SynthDef(\dlywrangler, {
	arg out=0, in, wet=0.1;
	var snd, dly2;
	snd = In.ar(in,2);
	dly2 = CombN.ar(HPF.ar(snd,300), 1, [0.5,0.77], 5, mul:LFNoise1.kr(0.1).range(0.8,0.3));
	snd = CombN.ar(snd, 1, Lag.ar(LFNoise0.ar(1).range(0.01,0.1),0.1), 3, mul:wet) + snd;
	snd = Limiter.ar(snd, 0.8);
	snd = snd + dly2;
	Out.ar(out, snd);
}).add;