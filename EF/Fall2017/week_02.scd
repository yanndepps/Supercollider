///////////////////////////////////////////////////////////////////////////////////////////
// --- Enveloppes and doneActions, randomness, Arrays, ServerOptions, Conditional logic --- //
//////////////////////////////////////////////////////////////////////////////////////////
s = Server.local.boot;
s.boot;

// hard quit in case :
// Server.killAll;

// SinOsc.browse;

// range method :
{SinOsc.ar(20).range(10, 20)}.plot(0.2);

// without the range method :
{SinOsc.ar(20, 0, 5, 15)}.plot(0.2);
// [-1, 1] mul:5 --> [-5, 5]
// [-5, 5] add:15 --> [10, 20]

// mapping values from one range to anther :
// linlin, linexp, explin, expexp, lincurve, curvelin

[1, 2, 3, 4, 5, 6, 7, 8, 9].plot;
// mapping values, linearly spaced :
[1, 2, 3, 4, 5, 6, 7, 8, 9].linlin(1,9,100,200);
[1, 2, 3, 4, 5, 6, 7, 8, 9].linexp(1,9,100,200).plot;
[1, 2, 3, 4, 5, 6, 7, 8, 9].explin(1,9,100,1000).plot;

(
{
	var freq, sig;
	freq = LFTri.ar(8).linexp(-1,1,100,2000);
}.plot(0.4);
)

[1,2,3,4,5,6,7,8,9].lincurve(1,9,-10,20,-5).plot;
[1,2,3,4,5,6,7,8,9].lincurve(1,9,-10,20,5).plot;

// Enveloppes : control the duration of the sound by molulating its properties ... amp and more.
// negatives numbers changes the curve quickly at first, than slowly !
e = Env.new([0,1,0.5,0], [1,2,5], [4,0,-4] ).plot;

//
(
{
	var sig, env;
	env = EnvGen.kr(
		Env.new([0,1,0], [0.02,1.5], [0, -2])
	);
	sig = SinOsc.ar(440)!2;
	sig = sig * env * 0.2;
}.play
)

//

s.plotTree;
s.freeAll;

// doneActions :

(
f = {
	arg freq=500, atk=0.02, rel=1.5, relCurve=(-2);
	var sig, env;
	env = EnvGen.kr(
		Env.new([0,1,0], [atk, rel], [0, relCurve]),
		doneAction:2
	);
	sig = SinOsc.ar(freq)!2;
	sig = sig * env * 0.2;
};
)

f.play(args:[\freq, exprand(110, 440), \atk, exprand(0.001, 0.5), \rel, 2, \relCurve, -4]);

// we can also swap EnvGen for Line :

(
f = {
	arg freq=500, atk=0.02, rel=1.5, relCurve=(-2);
	var sig, env;
	env = Line.kr(1,0,3,doneAction:2);
	sig = SinOsc.ar(freq)!2;
	sig = sig * env * 0.2;
}.play;
)

// we don't always have to use Env.new... :

(
f = {
	arg freq=500, atk=0.02, rel=1.5, relCurve=(-2), gate=1;
	var sig, env;
	env = EnvGen.kr(
		Env.adsr(atk, 0.3, 0.2, rel),
		gate,
		doneAction:2
	);
	sig = SinOsc.ar(freq)!2;
	sig = sig * env * 0.2;
};
)

~sound = f.play(args:[\freq, exprand(100, 1000)]);
~sound.set(\gate, 0);

// here we replace the arg freq by a variable of the same name, and then
// we assign this variable an EnvGen that will control the frequency and create a strict glissando :

(
f = {
	arg atk=0.001, rel=5, relCurve=(-5);
	var sig, env, freq;
	env = EnvGen.kr(
		Env.new([0,1,0], [atk, rel], [0, relCurve]),
		doneAction:2
	);
	freq = EnvGen.kr(
		Env.new([200,800,400], [0.2,0.2], [3,-3])
	);
	sig = SinOsc.ar(freq)!2;
	sig = sig * env * 0.2;
}.play(fadeTime:0);
)

// we can use Arrays, Float but also Symbols in order to define curves of our enveloppes :
Env.new([0,1,0], [1,1], \sine).plot;
Env.new([0,1], [1], \sine).plot;

// Randomness
// ! is a shortcut for .dup: receiver duplicates a value so many times : 4!5 -> [ 4, 4, 4, 4, 4 ]
// rrand(1,100)!5; -> [ 57, 57, 57, 57, 57 ]
// {rrand(1,100)}!5; -> [ 16, 83, 11, 69, 95 ]


// Arrays : --> ordered collections of things

x = [1,6, 9.3, 100, 0.001]
x.reverse

// declare an array of size n :
x = Array.newClear(4);
x = Array.fill(6, {exprand(1,100).round});

// same numbers :
x = Array.fill(6, exprand(1,100).round);

// increment by n number : a quick way to generate arithmetic series
x = Array.series(10, 100, 220);

// geometric series :
x = Array.geom(10, 2, 3);

// syntax shortcuts

(1..13);
(1,1.5..13);


// access items :
x = Array.fill(6, {exprand(1,100).round});
x.at(3);
x[0];
x.squared;
x.size;
x.sum;
x.mean;

x = [1, 2, 3];
x = x.add(rrand(1,100));
x.size;
x[7];

// Arrays on the server : the server interprets arrays as multichannel signals (multichannel expansions)

(
{
	var sig;
	sig = [
		SinOsc.ar(500, 0, 0.2),
		PinkNoise.ar(0.2)
	];
	sig = sig * [
		LFPulse.kr(5),
		SinOsc.kr(0.5).range(0,1);
	];
}.play;
)

{SinOsc.ar([400,700], 0, [0.5,0.2])}.play;
s.meter;


// 8 channels outputs propagated by sine :

s.options.numOutputBusChannels = 8;
s.reboot;
s.meter;

(
{
	var sig, amp;
	amp = SinOsc.kr((0.1,0.2..0.8)).range(0,0.1);
	sig = SinOsc.ar(300, 0, amp);
}.play;
)


// --- END

s.sampleRate;
s.options.blockSize;   // 64 samples at once
{LFPulse.ar(50)}.plot(0.035,minval:-0.1,maxval:1.1).plotMode_(\plines);
l={LFPulse.kr(50)}.plot(0.035,minval:-0.1,maxval:1.1).plotMode_(\plines);
l.editMode=true;
l.value;


{LFPulse.ar(50) * SinOsc.ar(517)}.plot(0.035,minval:-1.1,maxval:1.1).plotMode_(\plines);
{LFPulse.kr(50) * SinOsc.ar(517)}.plot(0.035,minval:-1.1,maxval:1.1).plotMode_(\plines);


44100/64;
// 1 sample for every 64 samples ... kr to ar

s.quit;

// --- VERY END
