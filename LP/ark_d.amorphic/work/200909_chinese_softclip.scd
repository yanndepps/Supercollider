
// evaluate to add a synth recipe to the server
(
SynthDef(\varDsine, {
	arg gate=1, freq=100, amp, pan, out=0, clip=1, release;
	var snd, env, vibrato;

	vibrato =  1 + (
		SinOsc.ar(4)
		* 0.003
		* Env.adsr(0.5, 0, 1, 3, curve:4).kr(2, gate)
	);
	freq = freq * vibrato;
	freq = freq * (0.995 + (LFNoise1.ar(0.5)*0.01));
	env = Env.adsr(0, 0.3, 0.4, 3, 1, -7).kr(2,gate);
	snd = (SinOsc.ar(freq, mul:0.5) * clip).softclip(1) * 0.9;
	snd = LPF.ar(snd, freq * 5); // make it less bright
	snd = snd * env * amp;
	snd = Pan2.ar(snd, pan);

	Out.ar(out, snd);
}).add
)

 
Pdef(\playD).play// start playing the pattern which is not yet defined
Pdef(\playD).fadeTime = 0; //

// define the pattern. it should play.
// make changes and re-evaluate without stopping
( 
Pdef(\playD, {
	Pbind(
		\instrument, \varDsine,
		\dur, Pseq([1/4,1/4,1/8,1/8,1/4,1/4,],inf) * Pseq([0.9,1.1] * 1,inf),
		\octave, [2.99, 4.01, 5, 6.01], // x 4 synths, expanded
		\scale, Scale.gong(\pythagorean),
		//\mtranspose, Prand([Pn(0,30),Pn(1,30),Pn(-1,30),Pn(2,30),Pn(-2,30)],inf),
		\mtranspose, Pstutter(30, Pwalk([0,1,-1,2,-2],1)),
		\degree, Pseq([0,0,1,2,2,0,0,2,4,6,7], inf),
		\clip, Prand([3,50,8,12,16,20,30],inf),
		\detune, 0,
		\legato, 0.1,
		\amp, 0.1,
	);
});
)


( // simple example 
Pdef(\playD, {
	Pbind(
		\instrument, \varDsine,
		\dur, Pseq([1, 2, 1, 4, 3 ] * 0.2,inf), // durations of notes
		\octave, [3,4,5], // octave (3 is pretty low)
		\scale, Scale.minor(\pythagorean), // try Scale.major or Scale.minor
		\mtranspose, Prand([[0,3],[0,2]],inf), // modal transposition, try 1 or 2 or 3
		\degree, Pseq([0,0,1,2,2,0,0,2,4,6,7], inf), // NOTES within a scale
		\clip, Prand([3,50,8,12,16,20,30],inf), // makes different timbre, randomly
		\legato, 0.6, // try anything between 0.1 - 3 or more of you dare
		\amp, 0, // gain/loudness
		\pan, Prand([ { 2.0.rand - 1 } ],inf),
		\out, 0
		//\pan, 0
	);
});
)

Pdef(\playD).clear // stop and clear


// see all scales that you can use
Scale.directory

// see all tunings you can use
Tuning.directory



Env.cutoff(1, 3, 4).plot;
Env.circle([0, 1, 0,0.5,0.2,0.6], [0.01, 0.5, 0.2]).plot