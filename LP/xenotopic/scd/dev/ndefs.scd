//
//
// NDEFSSSSSSSSSSSSSSSSSS ///////////////////////////////////////////////////////
//

(
Ndef(\gran, {
	var gfreq=150, snd;
	snd = GrainBuf.ar( numChannels: 2,

		// 28 !! solo
		// 36
		// 13 / 14,15,16,17,18,26,
		//sndbuf: ~granBfr.at([13,14,15,17]),
		//sndbuf: ~granBfr.at(26),
		//sndbuf: ~granBfr.at(36),
		sndbuf: ~granBfr.at([15,17,36,26]),

		trigger: Impulse.ar(gfreq
			* LFNoise0.ar(gfreq).range(1,1.1)),
		dur: 0.05,

		//rate: [1,0.77],
		rate: 1,
		pos:
		//SinOsc.ar(1/10).range(0.01, 0.95)
		LFTri.ar(1/10).range(0.01, 0.95)
		* LFNoise1.ar(gfreq).range(0.98, 1),

		pan: LFNoise1.ar(gfreq).range(-1,1),
		mul: 0.2
	);
	snd = LPF.ar(snd, LFNoise1.ar([1/7,1/8,1/9]).exprange(100,10000));
	//snd = LPF.ar(snd, LFNoise1.ar(1/7).exprange(1000,10000));
	snd = Mix(snd);
	snd = JPverb.ar(HPF.ar(snd,80), 6) * 0.3 + snd;
	snd = Limiter.ar(snd, 0.9);
	snd * \amp.kr(0).lag3(\amplag.kr(20));
}).play;
)
Ndef(\gran).fadeTime = 3;
Ndef(\gran).set(\amp, 0, \amplag, 30);
Ndef(\gran).set(\amplag, 1, \amp, 1);

Ndef(\gran).play
Ndef(\gran).stop
Ndef(\gran).clear



(
Ndef(\gran, {
	var gfreq=150, snd;
	snd = GrainBuf.ar( numChannels: 2,
		// pe4enkata
		sndbuf: ~granBfr.at(47),

		trigger: Impulse.ar(gfreq
			* LFNoise0.ar(gfreq).range(1,1.1)),
		dur: 0.1,

		//rate: [1,0.77],
		rate: 1,
		pos:
		//SinOsc.ar(1/10).range(0.01, 0.95)
		LFTri.ar(1/120).range(0.11, 0.35)
		* LFNoise1.ar(gfreq).range(0.97, 1),

		pan: LFNoise1.ar(gfreq).range(-1,1),
		mul: 0.2
	);
	//snd = LPF.ar(snd, LFNoise1.ar([1/7,1/8,1/9]).exprange(100,10000));
	snd = LPF.ar(snd, LFNoise1.ar(1/7).exprange(1000,10000));
	snd = Mix(snd);
	snd = JPverb.ar(HPF.ar(snd,80), 6) * 0.3 + snd;
	snd = Limiter.ar(snd, 0.9);
	snd * \amp.kr(0).lag3(\amplag.kr(20));
}).play;
)
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

(
Ndef(\eyeLiners,
	{
		var fold,wrap, snd, dly, rev;

		fold = LFNoise1.kr(1/2).range(0.8,1);
		wrap = LFNoise1.kr(1/2).range(0.8,1);

		snd = LFTri.ar(
			freq:	Array.fill(6, {
				(LFNoise0.kr(1/30).range(1,4).asInteger.lag(0.2) * 2 + 62).midicps * LFNoise1.kr(1/10).range(1,1.02)
			} ) )
			.fold( -1 * fold, fold )
		.wrap(-1*wrap,wrap)
		* LFPulse.kr(
				freq: LFNoise1.kr(1/ Array.fill(6, {rrand(2,4)} )).range(5,0.1),
				width:LFNoise1.kr([1/2,1/3]).range(0.1,0.2)).lag(0.01);

		snd = LPF.ar(snd, LFNoise1.kr(Array.fill(6, {1 / rrand(1,20)})).exprange(1500,8000));
		snd = Splay.ar(snd);
		snd = Limiter.ar(snd);
		rev = JPverb.ar(snd, 5);
		dly = CombL.ar(snd, 1, [0.4,0.6] * LFNoise1.kr(1/10).range(1.5,1.8), 10, mul:0.6);
		snd = snd + rev + dly;
		//snd = snd + dly;
		snd = snd * -6.dbamp;
		snd = snd * \amp.kr(0).lag(\amplag.kr(10));

	})
)
Ndef(\eyeLiners).set(\amplag, 1, \amp, 0)
Ndef(\eyeLiners).set(\amplag, 30, \amp, 0)

Ndef(\eyeLiners).play
Ndef(\eyeLiners).stop
Ndef(\eyeLiners).clear
Ndef(\eyeLiners).free
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////


(
// additional UGens needed:
// AnalogTape, LockheartWavefolder and AnalogVintageDistortion are from
// "ported plugins" https://github.com/madskjeldgaard/portedplugins
// JPverb is in sc3-plugins

Ndef(\dysphoria1, {
	var snd,freq=\freq.kr((30).midicps);
	var noise;

	noise = WhiteNoise.ar * LFPulse.kr(freq * [0.5,2],0,0.01).range(0,0.3);
	noise = BPF.ar(noise, LFNoise0.kr([1/5,1/4]).exprange(1000,5000).lag(1));
	noise = Splay.ar(noise, LFNoise1.ar(1/3).range(-1,1));

	freq = [freq,freq*1.01];
	snd = Pulse.ar(freq);
	snd = snd + Pulse.ar(freq*2.001,LFNoise1.ar(1/3).range(0.01,0.05));
	snd = LeakDC.ar(snd);
	snd = AnalogTape.ar(snd, 0.9, LFNoise1.kr(1/4).range(0,1), 0.5,0,2);
	snd = snd.fold(-0.5,0.9);
	snd = LockhartWavefolder.ar(snd[0] * LFNoise1.kr(1/4).range(1,10), 4) +
	((LockhartWavefolder.ar(snd[1] * LFNoise1.kr(1/4).range(1,10), 4)) * [-1,1]);
	snd = RLPF.ar(
		in: snd,
		freq: LFNoise1.ar(1/4).exprange(50,\maxCutoff.kr(2100).lag(5))
		* LFPulse.kr(4).range(0.8,1) * LFPulse.kr(6).range(0.6,1) * LFPulse.kr(8).range(0.5,1),
		//freq: 100,
		rq: LFNoise1.ar(1/3).range(0.1,0.9));

	snd = snd + noise;

	snd = AnalogVintageDistortion.ar(snd,0,1, oversample:3);
	snd = LeakDC.ar(snd);
	snd = snd * LFPulse.ar(1/1, width:0.2).range(0.2,1).lag(0.001);
	snd = JPverb.ar(snd*0.4, 10, 0, 5, low:0.2) + snd;
	snd = Limiter.ar(snd*1, 0.9) * \amp.kr(0).lag(\amplag.kr(5));

	snd;
})
)

Ndef(\dysphoria1).play
Ndef(\dysphoria1).stop
Ndef(\dysphoria1).clear

Ndef(\dysphoria1).quant=4

Ndef(\dysphoria1).set(\amplag, 30, \amp, 0 )
Ndef(\dysphoria1).set(\maxCutoff, 80)
Ndef(\dysphoria1).set(\freq, (30).midicps)


Ndef(\test).set(\maxCutoff,9000);
Ndef(\test3).set(\maxCutoff,9000);
Ndef(\test).set(\maxCutoff,500);
Ndef(\test).set(\maxCutoff,90);

Ndef(\test).control
r=Routine

(
var a, b;
a = Prand([38,35,34,32,30,27], inf);
b = a.asStream;
fork({
	10.do({
		b.postln;
		Ndef(\test).set(\freq,b.midicps);
		b.next;

		[2,4,3].choose.wait;});
}))

Ndef(\test).set(\freq,38.midicps);
Ndef(\test).set(\freq,35.midicps);
Ndef(\test).set(\freq,34.midicps);

Ndef(\test).set(\freq,32.midicps);
Ndef(\test).set(\freq,30.midicps);
Ndef(\test).set(\freq,27.midicps);



Ndef(\test).set(\freq,(32+12+12+12).midicps);

/////////////////////////////////////////////////////////////////////////////////////////////

(
TempoClock.tempo = 60/60;
Ndef(\hypertext404, {
	var snd, glc, freq;

	// frequency/ies
	freq = ([29,55] + 12 + (\freqoctave.kr(0) * 12)).midicps;

	//postln(freq);
	//freq = ([29,55] + 12 + (0 * 12)).midicps;

	// oscialtors
	snd = Pulse.ar(freq, mul:LFNoise1.kr(1/3).range(0.5,1))
	+ SinOsc.ar(freq/4, mul:LFNoise1.kr(1/3).range(0.2,0.6))
	+ LFTri.ar(freq.reverse/2, mul:LFNoise1.kr(1/3).range(0.2,0.6));

	// breat/pulse-cutter
	snd = snd * LFPulse.kr(4).lag(0.01).range(0.8,1) * LFPulse.kr(6).lag(0.001).range(0.1,1) * LFPulse.kr(8).lag(0.001).range(0.1,1);

	snd = RLPF.ar(snd, freq.mean * LFNoise1.kr(1/4).range(0.5,2), LFNoise1.kr(1/3).range(0.4,0.8));
	snd = snd +	RLPF.ar(Dust.ar(10, mul:0.3), freq:LFNoise1.kr(5).range(100,4000), rq:LFNoise1.kr(5).range(0.1,0.9));

	// SATURATE!                                        _______
	snd = AnalogTape.ar(snd * LFNoise0.kr(1/4).exprange(\saturationMin.kr(0.1),\saturationMax.kr(1)), 0.5, SinOsc.kr(1/4).range(0,1), 1, 0, 3);

 	snd = Limiter.ar(snd, 0.7);
	snd = Splay.ar(snd, 0.5);
	snd = JPverb.ar(snd, 4, lowcut:1000) * 0.7 + snd;

	glc = WhiteNoise.ar(LFNoise0.kr(3).range(0,3))
	+ Pulse.ar(LFNoise0.kr(8).range(1000,10000), mul:LFNoise0.kr(2).range(0,3))
	* LFPulse.ar(LFNoise0.kr(3).range(0.01,10), width:LFNoise0.kr(5).range(0.01,0.1)).range(0,0.1);
	glc = RLPF.ar(in:glc, freq:LFNoise1.kr(5).exprange(300,10000), rq:LFNoise1.kr(5).range(0.2,0.9), mul:LFNoise0.kr(1/2).exprange(0.1,0.9) );
	glc = Pan2.ar(glc, LFNoise0.kr(1).range(-1,1));

	snd = snd + glc;
	snd = Limiter.ar(snd, 0.9);
	snd = snd * \amp.kr(0).lag(\amplag.kr(20))
});

Ndef(\hypertext404).quant = 4;
Ndef(\hypertext404).fadeTime = 0.01;
)


Ndef(\hypertext404).play
Ndef(\hypertext404).set(\amplag, 2, \amp, 0)
Ndef(\hypertext404).set(\amplag, 30, \amp, 0)
Ndef(\hypertext404).set(\amplag, 20, \amp, 1)
Ndef(\hypertext404).set(\freqoctave, 0)
Ndef(\hypertext404).set(\saturationMin, 0.1,\saturationMax, 2)
Ndef(\hypertext404).stop
Ndef(\hypertext404).clear




//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////



b = Buffer.alloc(s, s.sampleRate * 10, 1)
Ndef(\recbuf, {RecordBuf.ar(\in.ar(0!2).at(0), b)})
Ndef(\recbuf, {RecordBuf.ar(\in.ar(0!2).at(0), b)})

(
Ndef(\input, {
	var snd = SoundIn.ar([0,1]);

	snd = Decimator.ar(snd, LFNoise1.kr(0.1).range(5000, 20000),
		mul: LFNoise1.kr(0.1).range(0.05,0.3), add:snd);

    snd = Greyhole.ar(in:snd, delayTime:0.5, damp:0.5, size:10,
		diff:0.7, feedback:0.5, modDepth:1, modFreq:LFNoise1.kr(1/2).range(0.4,1)) * LFNoise1.ar(0.1).range(0.1,1)

	+ snd ;

	Limiter.ar(snd, 0.8)
})
)
Ndef(\input).fadeTime = 8
Ndef(\input).play(fadeTime:8)

Ndef(\recbuf) <<>.in Ndef(\input)
b.plot

// GRANULATE THE CONTENTS OF THE BUFFER
(
Ndef(\gran, {
	var snd = GrainBuf.ar(2,
		trigger: Impulse.ar(LFNoise1.kr(1/10!3).exprange(80, 180) * LFNoise0.ar(100).range(0.7,1.1)),
		dur: LFNoise1.ar(1).range(0.08,0.1),
		sndbuf: b,
		rate:[1,1/2,2], pos:LFNoise1.kr(1/20!3).range(0,1),
		pan: LFNoise0.ar(100).range(-1,1)
	);
	snd = LPF.ar(snd, LFNoise1.kr(1/10!3).exprange(500,10000));
	snd = Mix(snd);
	snd = JPverb.ar(snd, LFNoise1.kr(1/10!2).range(1,10)) + snd;
	Limiter.ar(Mix(snd*0.7), 0.8) * Env.circle([0.5,0.3,0.5],90,\cub).kr * 0.01;
})
)
Ndef(\gran).fadeTime = 30
Ndef(\gran).play


Ndef(\gran).end(30) // fadeout
Ndef(\gran).stop // stop immediately
