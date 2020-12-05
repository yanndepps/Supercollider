s.boot;

s.quit;

s.makeWindow;

s.meter;

s.scope;

FreqScope.new;

s.plotTree;

//---
// separate function definition from execution
(
f = {
	var sig;
	sig = SinOsc.ar(220);
	// amplify the signal and softclip it ( basic waveshaping )
	sig = sig * 8;
	sig = sig.softclip;
	sig = Pan2.ar(sig, 0, 0.2);
}.play;
)

(
f = {
	arg freq = 220, boost = 4;
	var sig;
	sig = SinOsc.ar(freq);
	// amplify the signal and softclip it ( basic waveshaping )
	sig = sig * boost;
	sig = sig.softclip;
	sig = Pan2.ar(sig, 0, 0.06);
};
)

x = f.play;

// dynamically change values using set
x.set(\freq, 300);
x.set(\freq, exprand(50, 800));

// convert from midi to cycles per second
// 21 to 108 on the piano
60.midicps;
72.midicps;

x.set(\freq, 60.midicps);
x.set(\freq, (35,37..79).choose.midicps);

x.release(3);

x.free;

// init the sound with desired values
x = f.play(args: [\freq, 440]);

//---
x = f.play(args: [\freq, (40,45..70).choose.midicps]);

a = [];

// run multiple times to add more synth
a.add(f.play(args: [\freq, (40,45..70).choose.midicps]));

// how many synth do we have
a.size;

// iterate through the array
a.do({ arg n; n.release(3) });

// another way
(
a = [];
12.do({
	a = a.add(f.play(args: [\freq, (40,42..70).choose.midicps]));
});
)

s.scope;

a.do({ arg n; n.release(exprand(1, 10)) });

// ---

(
f = {
	arg freq = 220, boost = 4, pan = 0, amp = 0.1;
	var sig;
	sig = SinOsc.ar(freq);
	// amplify the signal and softclip it ( basic waveshaping )
	sig = sig * boost;
	sig = sig.softclip;
	sig = Pan2.ar(sig, pan, amp);
};
)

(
a = [];
12.do({
	a = a.add(
		f.play(
			fadeTime: exprand(3,6),
			args: [
			\freq, ((32,39..85).choose - ([0,2,4].choose)).midicps,
			\boost, exprand(1,8),
			\pan, rrand(-0.8, 0.8),
			\amp, exprand(0.04, 0.1)
			]
		);
	);
})
)

a.do({ arg n; n.release(exprand(1, 10)) });

// Env

(
Env.new(
	[0, 1, 0.2, 0.2, 0],
	[1, 2.5, 2, 3],
	[2, -8, 0, -4]
).plot;
)

(
f = {
	arg freq = 220, boost = 4, pan = 0, amp = 0.1;
	var sig, env;
	env = EnvGen.ar(
		Env.new(
			[0, 1, 0.2, 0.2, 0],
			[1, 2.5, 2, 3],
			[2, -8, 0, -4]
		),
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	// amplify the signal and softclip it ( basic waveshaping )
	sig = sig * boost;
	sig = sig.softclip;
	sig = Pan2.ar(sig, pan, amp);
	sig * env;
};
)

x = f.play;

12.do{ x = f.play(args: [\freq, exprand(50, 500)]) };

// ar vs kr
// ar UGen run at the sample rate
s.sampleRate;

// kr have a lower resolution
s.options.blockSize;

(
{
	[
		SinOsc.ar(10),
		SinOsc.kr(10)
	]
}.plot(0.1);
)