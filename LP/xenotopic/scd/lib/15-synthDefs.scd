// SynthDefs ///////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////
// INSTRUMENTS  /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////




// -- GRANULATION -- // -------------------------------------------------------------------

SynthDef(\granPlay, {
	arg outBus = 0, bufnum = 0, gate = 1, rate = 1, amp = 0.1, atk = 4, rls = 4, sul = 1,
	freq = 160, fvar = 1, gdur = 0.1, durvar = 0.01, gpos = 0, posvar = 0.01,
	pitch = 1, pitchvar = 0, width = 1, gain = 0.3, autoPosN=0, autoPosS=0;
	var snd, env, posOsc, posSin;

	posOsc = LFNoise1.kr(1/8) * autoPosN;
	posSin = SinOsc.kr(1/8) * autoPosS;

	env = EnvGen.ar(
		Env.adsr(
			attackTime: atk,
			decayTime: atk,
			sustainLevel: sul,
			releaseTime: rls),
		gate, doneAction:2);

	snd = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(freq + (freq * (fvar * LFNoise2.kr(freq)))), // a UGen?
		dur: gdur + (durvar * LFNoise2.kr(freq)), // in seconds
		sndbuf: bufnum,
		rate: pitch + (pitchvar * LFNoise2.kr(5)), // pitch !! WHAT IS THE SPEED OF VARIATIONS? setable??
		pos: gpos + (posvar * LFNoise2.kr(freq)) + posOsc + posSin, // position 0-1
		interp: 2, // interpolation for pitchshifting
		pan: LFNoise1.kr(10).range(width.neg, width), // if numChannels=2, similar to Pan2, -1 left, +1 right
		maxGrains: 512,
		mul: gain
		);

	snd = snd * env * amp;
	Out.ar(outBus, snd);
}).add;



// -- PLAY BUFFER -- // -------------------------------------------------------------------

SynthDef(\playBuf, {
	arg outBus = 0, bufnum = 0, gate=1, rate=1, start=0.4, atk=0.01, rls=0.01, amp=0.1, sdel=0, hpff=0;
	var env, snd, rscale;

	rscale = BufRateScale.kr(bufnum);

	snd = PlayBuf.ar(1, bufnum, rscale * rate, gate,
		//20000,
		BufDur.kr(bufnum) * BufSampleRate.kr(bufnum) * start,
		0);
	snd = [snd, DelayL.ar(snd,0.2, sdel)];
	snd = HPF.ar(snd, hpff);
	env = EnvGen.ar(Env.adsr(atk, 0,1,rls), gate, doneAction:2);
	snd = snd * env * amp ;

    Out.ar(outBus, snd);
}).add;




// beep. -- // -------------------------------------------------------------------

SynthDef(\beep_sus,
	{
		arg outBus = 0, freq=440, gate=1, amp=0.1, sawamp = 0.1;
		var snd;

		snd = Pulse.ar(freq) + LFTri.ar(freq/ Rand(1.99,2.01)) + Saw.ar(freq * Rand(1.99,2.01), mul:sawamp);
		snd = snd * EnvGen.kr(Env.cutoff, gate, doneAction:Done.freeSelf);
		snd = snd * amp * 0.1;

		Out.ar(outBus, snd!2);
	}
).add;

//

// simplenoise -- // --------------------------------------------------------

SynthDef(\noise,
	{
		arg outBus = 0, freq=440, gate=1, amp=0.1;
		var snd;
		//snd = Pulse.ar(freq) + LFTri.ar(freq/ Rand(1.99,2.01)) + Saw.ar(freq * Rand(1.99,2.01), mul:sawamp);
		snd = PinkNoise.ar(2);
		snd = Dust2.ar(200, mul:4) + snd;
		snd = HPF.ar(snd, 200);
		snd = snd * EnvGen.kr(Env.cutoff, gate, doneAction:Done.freeSelf);
		snd = snd * amp;
		Out.ar(outBus, snd!2);
	}
).add;



// AKJ -- // --------------------------------------------------------
//
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



// darksaw // ------------------------------------------------------
// "--- dark saw synthdef...".postln;
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
	snd = snd * amp * env ;
	OffsetOut.ar(out, snd);
}).add;

/////////////////////////////////////////////////////////////////////////////////////////
// EFFECTS  /////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////


//  LOW PASS FILTER AS BUS EFFECT // ---------------------------------------------------
SynthDef(\lpfFX,
	{
		arg inBus, outBus = 0, cutoff = 500, cutoffLag = 5;
		var snd, input;

		input = In.ar(inBus,2);
		snd = BLowPass4.ar(input, VarLag.kr(cutoff.max(50), cutoffLag, 0, warp:\exp));

		Out.ar(outBus, snd);
	}
).add;


// FEEDBACK DELAY WITH BANDPASS FILTER AND STEREO ROTATION // ----------------------------
SynthDef(\localFeedbackDelay1,
	{
		arg inBus, outBus = 0;
		var snd, input, local;

		input = In.ar(inBus,2);

		local = LocalIn.ar(2) * \amount.kr(0.99);

		local = BPF.ar(local, LFNoise1.kr(0.6).range(450,2000), LFNoise1.kr(0.1).range(0.8,1));
		local = Rotate2.ar(local[0], local[1], 0.23);

		local = AllpassN.ar(local, 0.05, {Rand(0.01,0.05)}.dup, 2);
		local = DelayN.ar(local, 0.3, [0.26,0.19]);
		local = AllpassN.ar(local, 0.05, {Rand(0.03,0.15)}.dup, 2);

		local = LeakDC.ar(local);

		local = local + input;
		LocalOut.ar(local);

		Out.ar(outBus, local);
	}
).add;


// reverb synthdef
SynthDef(\revfx, { |inBus, outBus = 0, wet = 0.3, amp = 0.2|
	var snd, rev;

	snd = In.ar(inBus, 2);
	//snd = BHiShelf.ar(snd, 5000, db:-3);
	rev = GVerb.ar(snd, 100,  taillevel:wet);
	rev = rev * amp;

	OffsetOut.ar(outBus, rev);
}).add;


// SATURATOR + REVERB // -----------------------------------------------------------
SynthDef(\saturator, {
	arg inBus, outBus=0;
	var snd, in, revsnd;

	in = In.ar(inBus, 2);
	//snd = AnalogTape.ar(in * LFNoise1.kr(1/4).range(1,2), 0.5, SinOsc.kr(1/4).range(0,1), 1, 0, 3) * 0.5;
	snd = AnalogTape.ar(in * 2, 0.5, 1, 1, 0, 3) * 0.5;
	snd = snd.sum;
	revsnd = HPF.ar(snd,100);
	snd = GVerb.ar(revsnd, 100, \revtime.kr(6), drylevel:0, earlyreflevel:\earlyreflevel.kr(0.3), taillevel:\taillevel.kr(0.3))
			* 0.5 + snd;
	snd = [snd[0], DelayL.ar(snd[1], 0.2, 0.02)];
	//snd = in; // !! ---------
	//snd = Limiter.ar(snd, 0.9, 0.1);
	snd = snd * \amp.kr(0).lag3(\amplag.kr(10));

	OffsetOut.ar(outBus, snd);
}).add;




