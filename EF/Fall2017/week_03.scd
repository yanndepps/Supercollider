// 01. We take a function with UGens ...
s.boot;
s.meter;
s.scope;
FreqScope.new;
s.plotTree;

(
~tone = {
	arg freq=500, amp=0.5, gate=0;
	var sig, env;
	env = EnvGen.kr(
		Env.asr,
		gate,
		doneAction:2
	);
	sig = SinOsc.ar(freq, 0, amp);
	sig = sig * env;
	sig!2;
}
)

x = ~tone.play;
x.set(\gate,1);
x.set(\gate,0);

x = ~tone.play(args:[\freq, exprand(200, 2000)]);
x.set(\gate, 1, \amp, 0.2);
x.set(\freq, exprand(48, 440));
x.set(\gate, 0);
x.free;

// ... convert the mess and create a SynthDef !
// make sure to excplicitly specify the output !
(
SynthDef.new(
	\pureTone,
	{
		arg freq=500, amp=0.5, gate=1, out=0;
		var sig, env;
		env = EnvGen.kr(
			Env.asr,
			gate,
			doneAction:2
		);
		sig = SinOsc.ar(freq, 0, amp);
		sig = sig * env;
		Out.ar(out, sig);
	}
).add;
)

x = Synth.new(\pureTone, [\out,0, \freq,800]);
x.set(\gate,0);
x.set(\amp, 0.05);

// 02. Iterations :
// do : returns its receiver unchanged

a = {rrand(10,50)}!8;

(
a =a.do({
	arg num;
	num.linexp(10,50,1000,2000).postln;
})
)
a;
// collect : returns a new modified collection based on what its function returns

(
a =a.collect({
	arg num;
	num.linexp(10,50,1000,2000).postln;
})
)
a;

//

(
SynthDef.new(
	\pureTone,
	{
		arg freq=500, amp=0.5, gate=1, out=0;
		var sig, env;
		env = EnvGen.kr(
			Env.asr,
			gate,
			doneAction:2
		);
		sig = SinOsc.ar(freq, 0, amp)!2;
		sig = sig * env;
		Out.ar(out, sig);
	}
).add;
)
Synth.new(\pureTone);

// generate random midi note and create a synth
// 60.midicps;

a = {rrand(40,80)}!8;

(
a.do({
	arg noteNum;
	Synth.new(\pureTone,[
		\freq, noteNum.midicps,
		\amp, 0.05,
	]);
});
)

(
a = {rrand(40,80)}!8;
~synths = a.collect({
	arg noteNum;
	Synth.new(\pureTone,[
		\freq, noteNum.midicps,
		\amp, 0.05,
	]);
});
)

(
~synths.do({
	arg synth;
	synth.set(\freq, rrand(40,80).midicps);
});
)

~synths.do({arg i; i.set(\gate, 0)});

~synths[1].set(\gate, 0);

s.freeAll;

// A class called Routine :

(
Routine.new({
	"hello".postln;
	wait(1);
	"goodbye".postln;
}).play;
)

//

(
a = {rrand(40,80)}!8;
~synths = a.collect({
	arg noteNum;
	Synth.new(\pureTone,[
		\freq, noteNum.midicps,
		\amp, 0.05,
	]);
});
)

// change the notes one by one

(
Routine.new({
	~synths.do({
		arg synth;
		synth.set(\freq, rrand(48,72).midicps);
		"changed".postln;
		0.5.wait;
	});
}).play;
)

// fade the synths one by one

(
Routine.new({
	~synths.do({
		arg synth;
		synth.set(\gate,0);
		"changed".postln;
		1.wait;
	});
}).play;
)

// loop and change all notes at once, repeat

(
Routine.new({
	(1..10).do({ // also 10.do
		~synths.do({
			arg synth;
			synth.set(\freq, rrand(40,80).midicps);
			"changed".postln;
		});
		rrand(0.1,0.5).wait;
	});
}).play;
)

~synths.do({arg i; i.set(\gate,0)});

~synths.do({arg synth, index; [synth, index].postln});

// 03.

(
SynthDef.new(
	\pureTone2,
	{
		arg amp=0.5, gate=1, out=0;
		var sig, env, temp;
		sig = 0;
		env = EnvGen.kr(
			Env.asr,
			gate,
			doneAction:2
		);
		10.do({
			arg i;
			temp = SinOsc.ar({ExpRand.new(200,2000)!2}, 0, amp);
			sig = sig + temp;
		});
		sig = sig * env;
		Out.ar(out, sig);
}).add;
)

// drone version with x harmonics
(
SynthDef.new(
	\droneTone,
	{
		arg freq=50, amp=0.5, gate=1, out=0;
		var sig, env, temp;
		sig = 0;
		env = EnvGen.kr(
			Env.asr,
			gate,
			doneAction:2
		);
		16.do({
			arg i;
			temp = SinOsc.ar((i+1)*freq*LFNoise1.kr(2).exprange(0.98, 1.01), 0, amp);
			// temp = temp * LFNoise1.kr(2).exprange(0.05, 1);
			// temp = temp * LFSaw.kr(Rand(0.5, 2)).exprange(0.01, 1);
			temp = temp * LFSaw.kr(1).exprange(0.01, 1);
			sig = sig + temp;
		});
		sig = sig * env;
		Out.ar(out, sig!2);
}).add;
)

x = Synth.new(\droneTone, [\amp, 0.05]);
x.set(\freq, 30);

// 04. some conditional logic syntax :

1 == 2;

[0,1].choose == 1;

(
if(
	[0,1].choose == 1,
	{"we picked 1".postln},
	{"we picked 0".postln}
);
)

//

(
a = {rrand(40,80)}!8;
~synths = a.collect({
	arg noteNum;
	Synth.new(\pureTone,[
		\freq, noteNum.midicps,
		\amp, 0.05,
	]);
});
)
// turn each odd synth down (1,3,5,7)
(
~synths.do({
	arg synth, index;
	if(
		index.odd,
		{synth.set(\gate,0)},
		{ }
	);
});
)
// pure harmonic serie, detuned
(
~synths.do({
	arg synth, index;
	synth.set(\freq, (index+1)*50*exprand(0.98,1.02))
});
)
// close them all
~synths.do({arg i; i.set(\gate,0)});

// 04. trigger arguments

(
SynthDef.new(
	\pureTri,
	{
		arg freq=500, amp=0.5, t_gate=0, out=0;
		var sig, env;
		env = EnvGen.kr(
			Env.perc,
			t_gate
		);
		sig = LFTri.ar(freq, 0, amp)!2;
		sig = sig * env;
		Out.ar(out, sig);
	}
).add;
)

x = Synth.new(\pureTri);

(
r = Routine({
	inf.do({
		x.set(\t_gate, 1, \freq, rrand(200,440));
		0.2.wait;
	});
}).play;
)

r.stop;

// 05. collection
m = (1..100).select({arg i; i.isPrime});

for(3, 8, {arg i; i.squared.postln});

// an online Q&A :

~gaof = 5;

(
SynthDef.new(\synth1,
	{
		arg freq = 300, aof = 3, amp = 0.5, out=0;
		var sig, env, amposc;
		sig = SinOsc.ar(freq);
		env = EnvGen.kr(Env.perc(0.01, 3), doneAction: 2);
		amposc = SinOsc.kr(aof, pi/2).range(0.1, 1);
		sig = sig * amp * amposc * env;
		Out.ar(out, sig!2);
	}
).add;
)

(
Pdef(
	\test,
	Pbind(
		\instrument, \synth1,
		\dur, 1/2,
		\stretch, 60/60*4,
		\aof, ~gaof,
		\freq, 280,
	)
).play;
)

// use Pbindef to change a variable on the fly

(
Pbindef(
	\test,
	\instrument, \synth1,
	\dur, 1/2,
	\stretch, 60/60*4,
	\aof, ~gaof,
	\freq, 280,
).play;
)

Pbindef(\test, \aof, 5, \freq, Pseq([300,450,600].mirror/1.25,inf), \dur, 1/16);

Pbindef(\test).stop;

//  --- END
