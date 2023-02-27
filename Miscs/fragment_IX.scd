(

/*
Code to reproduce this piece:
https://frankchannel.bandcamp.com/track/fragment-ix
*/

s.waitForBoot{

~maxharm = 14;
SynthDef(\textureSynth, { |freq=440, numharm=4, clip=1, amp=1, outbus=100|
	var out, src, env, amps;

	// mutes
	amps = {|i| i<numharm}!~maxharm;
	amps = amps.collect{|item, i| item/(i+1)};

	// envelope
	env = EnvGen.ar(Env([0,1,0.5,0.1,0.01], [0.1,1,0.1,1], [1,-4,-4,-1]), timeScale:Rand(2,6), levelScale:0.5, doneAction:2);

	// source
	src = PinkNoise.ar(0.5);
	out = src * env;

	// filter
	out = RLPF.ar(out, (1..~maxharm)*freq, Rand(0.001, 0.01), mul:amps);
	out = Mix.new(out);

	// effects
	out = (out*2).tanh;
	out = out.clip2(clip);

	// spatialization
	out = Pan2.ar(out);
	Out.ar(outbus, amp * out);
}).add;

SynthDef(\bassSynth, { |freq, amp=1, timeScale=1, outbus=20|
	var m1 = SinOsc.ar(8, mul:freq*(1-(2**(0.2/12))), add:freq);
	var m2 = SinOsc.ar(2, mul:0.5, add:0.75);
	var e = EnvGen.ar(Env([0, 1, 0.05, 0], [0.1, 1, 1], [1,-2,-4]), timeScale:timeScale, doneAction:2);
	var o = e * Blip.ar(m1, 6, mul:m2);
	//var o = e * Pulse.ar(m1, 0.2, mul:m2);
	o = RLPF.ar(o, 8*freq, 0.25);

	Out.ar(outbus, Pan2.ar(amp * o));
}).add;

SynthDef(\rev, {|inbus=0, outbus=0, roomsize=200, revtime=10, damping=0.5|
	var in = In.ar(inbus,2);
	var fx = GVerb.ar(in, roomsize, revtime, damping);
	Out.ar(outbus,fx);
}).add;

Server.default.sync;

~scale = [0,2,5,9,12,14];
~root = 38+12;

// ********
// sequence
// ********

~bassGroup = Group.new;
~bassVerb = Synth(\rev, [\inbus, 20, \revtime, 0.25], target:~bassGroup);

~bassPatA = Pbind(\instrument, \bassSynth,
	\freq, Pdup(1, Pseq((26 + [0,2,5,9]).midicps,4)),
	\dur, 2,
	\timeScale, 2,
	\amp, 0.25,
	\group, ~bassGroup,
	\addActon, \addToHead);

~textGroup = Group.new;
~textVerb = Synth(\rev, [\inbus, 100, \revtime, 6], target:~textGroup);

~textPatA = Pbind(\instrument, \textureSynth,
	\pat, Prand((0..~scale.size-1),60),
	\freq, Pcollect({|i| (~root + ~scale[i]).midicps}, Pdup(1,Pkey(\pat))),
	\numharm, Prand((1..4), inf),
	\dur, 1,
	\amp, 0.25,
	\clip, 1,
	\group, ~textGroup,
	\addAction, \addToHead);

~textPatB = Pbind(\instrument, \textureSynth,
	\pat, Prand((0..~scale.size-1),60),
	\freq, Pcollect({|i| (~root + ~scale[i]).midicps}, Pdup(2,Pkey(\pat))),
	\numharm, Prand((4..8), inf),
	\dur, 1,
	\amp, 0.25,
	\clip, 0.5,
	\group, ~textGroup,
	\addAction, \addToHead);

~textPatC = Pbind(\instrument, \textureSynth,
	\pat, Prand((0..~scale.size-1),60),
	\freq, Pcollect({|i| (~root + ~scale[i]).midicps}, Pdup(1,Pkey(\pat))),
	\numharm, Prand((8..14), inf),
	\dur, 1,
	\amp, 0.25,
	\clip, 0.25,
	\group, ~textGroup,
	\addAction, \addToHead);

Pdef(\bass, Pseq([~bassPatA],8)).play;
Pdef(\text, Pseq([~textPatA, ~textPatB, ~textPatC, ~textPatA], 1)).play;
};
)
