// register a keyboard macro using the following command: :qa vap C-c C-c q.
// the macro is stored in @a. Type @a to summon it.

s.boot;

s.quit;

s.makeWindow;

s.meter;

s.scope;

FreqScope.new;

s.plotTree;

//---
(
x = {
	var sig, env, freqEnv;
	freqEnv = EnvGen.kr(
		Env.new(
			[15000, 500],
			[4],
			[-12]
		),
		doneAction:2
	);
	env = EnvGen.kr(
		Env.new(
			[0,1,0],
			[1,3],
			[0,0]
		),
		doneAction:2
	);
	sig = Saw.ar(80);
	sig = LPF.ar(sig, freqEnv);
	sig = sig * 0.2;
	sig = sig * env;
	sig = sig!2;
}.play;
)

// ---

(
f = {
	arg gate=1;
	var sig, env;
	env = EnvGen.kr(
		Env.adsr(
			0.01, 0.3, 0.5, 1
		),
		gate,
		doneAction:2
	);
	sig = SinOsc.ar(200);
	sig = sig * 0.2;
	sig = sig * env;
	sig = sig!2;
}.play;
)

x = f.play(args: [\gate, 0]);

x.set(\gate, 0);
x.set(\gate, 1);

// in case we do not use doneAction
x.free;

// ---
// use a trigger instead

(
f = {
	arg t_gate=1;
	var sig, env;
	env = EnvGen.kr(
		Env.perc(
			0.01, 0.5
		),
		t_gate,
		doneAction:2
	);
	sig = SinOsc.ar(200);
	sig = sig * 0.2;
	sig = sig * env;
	sig = sig!2;
}.play;
)

x = f.play(args: [\gate, 0]);

x.set(\gate, 1);

// multichannel expension
// the server interprets arrays of signals as multichannel audio

(
x = {
	var sig;
	sig = LFSaw.ar([80, 90, 100, 110, 200]);
	sig = LPF.ar(sig, 1000);
	sig = sig * 0.2;
}.play;
)

// add more audio outputs
s.options.numOutputBusChannels = 8;

// reboot to see the effects
s.reboot;

// look at the new channels
s.meter;

// ---

(
x = {
	var sig;
	sig = LFSaw.ar([80, 81]);
	sig = LPF.ar(sig, 500);
	sig = sig * 0.2;
}.play;
)

// propagate through the expression graph
LFSaw.ar([80, 81])
-->
[ LFSaw.ar(80), LFSaw.ar(81) ]
-->
[ LPF.ar(LFSaw.ar(80), 500), LPF.ar(LFSaw.ar(81), 500) ]
-->
[ LPF.ar(LFSaw.ar(80), 500) * 0.2, LPF.ar(LFSaw.ar(81), 500) * 0.2 ]

[1,2,3,4] * 0.1; // --> [ 0.1, 0.2, 0.3, 0.4 ]

(
x = {
	var sig;
	sig = LFSaw.ar([80, 81]);
	sig = LPF.ar(sig, [ 500, 3000 ]);
	sig = sig * 0.2;
}.play;
)

// ---

(
x = {
	var sig, freqs;
	// an array of size, harmonic series start on 150
	freqs = Array.series(8, 150, 150);
	// the smaller array loops back to accomodate the largest one
	sig = SinOsc.ar(freqs, 0, [ 0.4, 0.05 ]);
	sig = sig * 0.2;
}.play;
)

// one way to collapse multichannels to mono or stereo :
(
x = {
	var sig, freqs;
	freqs = Array.exprand(8, 200, 1200);
	sig = SinOsc.ar(freqs, 0, [ 0.4, 0.05 ]);
	sig = sig.sum;
	sig = sig!2;
}.play;
)

// another way using iteration :
(
x = {
	var sig, freqs;
	freqs = Array.exprand(20, 200, 1200);
	sig = SinOsc.ar(freqs, 0, [ 0.4, 0.03 ]);

	sig = sig.collect({
		arg n; // each individual monophonic SinOsc in the array
		Pan2.ar(n, rrand(-1.0, 1.0));
	})

	sig = sig.sum;
}.play;
)

-->
sig = [ so, so, so, so, so, so, so, so ]
-->
sig = [ [ so, so ], [ so, so ] ... [ so, so ] ].sum
-->
sig = [ so, so ]

// and another way to collapse large multichannel arrays down to stereo format

(
x = {
	var sig, freqs;
	freqs = Array.exprand(50, 40, 1000);
	sig = SinOsc.ar(freqs, 0, [ 0.4, 0.1 ]);
	// Splay will spread this array linearly spaced accross the stereo field ( with amp compensation too )
	sig = Splay.ar(sig);
}.play;
)