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
// Rooutine & SynthDef

(
f = {
	arg freq = 100;
	var sig;
	sig = Pulse.ar(freq * [ 1, 1.01 ], 0.5, 0.04);
	sig = sig + SinOsc.ar(freq * 1.5 * [ 1, 1.004 ], 0, 0.15);
	sig = sig + BrownNoise.ar(0.04!2);
	sig = sig * Line.ar(0, 1, 10);
};
)

x = f.play;
x.free;

// different arguments
x = f.play(args:[\freq, 1250]);

// update an argument while it's playing with set
x.set(\freq, 250);

// smoothly exit
x.set(\gate, 0, \fadeTime, 5);

// convert a regular function to a SynthDef
(
SynthDef.new(\ocean, {
	arg freq = 100;
	var sig;
	sig = Pulse.ar(freq * [ 1, 1.01 ], 0.5, 0.04);
	sig = sig + SinOsc.ar(freq * 1.5 * [ 1, 1.004 ], 0, 0.15);
	sig = sig + BrownNoise.ar(0.04!2);
	sig = sig * Line.ar(0, 1, 10);
	// we need to specify the output system in use
	Out.ar(0, sig);
	// add does the building of the ugen function and push that info to the server
}).add;
)

// and to actually execute that sound
x = Synth.new(\ocean);
x.free;

// and modify the args of the new synth
x = Synth.new(\ocean, [ \freq, 250 ]);

// update an arg by using set
x.set(\freq, 180);
x.free;

// we now need to add an env
(
SynthDef.new(\ocean, {
	arg freq = 100, gate = 1, atk = 3, rel = 3;
	var sig, env;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, [ 1, -1 ]),
		gate,
		doneAction:2
	);
	sig = Pulse.ar(freq * [ 1, 1.01 ], 0.5, 0.04);
	sig = sig + SinOsc.ar(freq * 1.5 * [ 1, 1.004 ], 0, 0.15);
	sig = sig + BrownNoise.ar(0.04!2);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\ocean, [ \atk, 0.02 ]);
x.set(\freq, 40);

// an 8s fade out
x.set(\gate, 0, \rel, 8);

// make our synth completely mono sent to bus 0
(
SynthDef.new(\ocean, {
	arg freq = 100, gate = 1, atk = 3, rel = 3, pan = 0, out = 0;
	var sig, env;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, [ 1, -1 ]),
		gate,
		doneAction:2
	);
	sig = Pulse.ar(freq, 0.5, 0.04);
	sig = sig + SinOsc.ar(freq * 1.5, 0, 0.15);
	sig = sig + BrownNoise.ar(0.04);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;
)

a = [];

a = a.add( Synth.new(\ocean, [ \pan, -0.5 ]) );
a = a.add( Synth.new(\ocean, [ \freq, 150, \pan, 0.5 ]) );
a = a.add( Synth.new(\ocean, [ \freq, 230, \pan, 0 ]) );

a.do({ arg synth; synth.set(\gate, 0, \rel, 5) });

// ---
// Routines
// is a type of function that can be played in which you can include wait time

(
r = Routine.new({
	"hello".postln;
	wait(1);
	"how are you?".postln;
	wait(3);
	"good bye".postln;
});
)

r.play;
// play the routine again from the beginning
r.reset;
// or stop it
r.stop;
// give me the next thing
r.next;

// ---
// remove any sustain env

(
SynthDef.new(\ocean, {
	arg freq = 100, gate = 1, atk = 0.01, rel = 1, pan = 0, out = 0;
	var sig, env;
	env = EnvGen.kr(
		Env.new([ 0, 1, 0 ], [ atk, rel ], [ 0, -4 ]),
		doneAction:2
	);
	sig = Pulse.ar(freq, 0.5, 0.04);
	sig = sig + SinOsc.ar(freq * 1.5, 0, 0.15);
	sig = sig + BrownNoise.ar(0.04);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;
)

Synth(\ocean, [ \pan, -0.5 ])

(
Routine.new({
	Synth(\ocean, [ \freq, 60.midicps, \pan, rrand(-0.5, 0.5) ]);
	wait(0.5);
	Synth(\ocean, [ \freq, 62.midicps, \pan, rrand(-0.5, 0.5) ]);
	wait(0.5);
	Synth(\ocean, [ \freq, 67.midicps, \pan, rrand(-0.5, 0.5) ]);
}).play;
)

// ---

(
r = Routine.new({
	inf.do{
		Synth(\ocean, [ \freq, rrand(48, 72).midicps, \pan, rrand(-0.5, 0.5) ]);
		wait(exprand(0.02, 0.5));
	};
});
)

r.reset; r.play;
r.stop;

// we can use lopp instead of inf

(
r = Routine.new({
	{
		Synth(\ocean, [ \freq, rrand(48, 72).midicps, \pan, rrand(-0.5, 0.5) ]);
		wait(exprand(0.02, 0.5));
	}.loop;
}).play;
)

r.stop;

// fork is a method defined for a function which creates and plays a Routine

(
r = {
	{
		Synth(\ocean, [ \freq, rrand(48, 72).midicps, \pan, rrand(-0.5, 0.5) ]);
		wait(exprand(0.02, 0.5));
	}.loop;
}.fork;
)

r.stop;

// we can NOT use wait outside of Routine
// ---

(
r = Routine.new({
	{
		var num;
		num = rrand(48, 72);
		3.do{
			Synth(\ocean, [ \freq, num.midicps, \pan, rrand(-0.5, 0.5) ]);
			wait(0.15);
		};
		3.do{
			Synth(\ocean, [ \freq, rrand(48, 72).midicps, \pan, rrand(-0.5, 0.5) ]);
			wait(0.15);
		};
	}.loop;
});
)

r.play;
r.stop;

// --- END