s.boot;

(
// Code to produce this piece: https://frankchannel.bandcamp.com/track/fragment-vi
// From this album: http://frankchannel.bandcamp.com/album/fragments
// Which features SuperCollider on every track

SynthDef(\sine, {|freq=440, amp=0.1, gate=1, sustain=0.1|
	var sig = Splay.ar(SinOsc.ar(freq*[2**(-15/1200), 1, 2**(15/1200)]/3*2));
	var env = EnvGen.kr(Env.perc(1e-5,sustain*3),gate,amp,doneAction:2);
	Out.ar(0, (sig*env*4).softclip/4);
}).add;

// a counter
~counter = {
	arg n=4, palindrome=false;
	var pat;
	if(palindrome,
		{pat = Pn(Pseq((1..n).mirror))},
		{pat = Pn(Pseq((1..n)))}
	);
	pat.asStream;
};

// an accumulator
// 1 -> 1
// 2 -> 1, 2
// 3 -> 1, 2, 3
// n -> 1, .., n
~accumulate = {
	arg x, palindrome=false;
	Pn(
		Plazy({
			var n = x.next();
			var pat;
			if(palindrome,
				{pat = Pseq((1..n).mirror)},
				{pat = Pseq((1..n))}
			);
			pat;
		})
	).asStream;
};

// a repeater
// 1 -> 1
// 2 -> 2, 2
// 3 -> 3, 3, 3
// n -> n, .., n
~repeat = {
	arg x;
	Pn(
		Plazy({
			var n = x.next();
			var pat = Pseq(n!n);
			pat;
		})
	).asStream;
};

// inject rests into a stream
// x = 1, 2, 3, 1, 2, 3, ...
// f(x) = 1, 2, 3, \rest, 1, 2, 3, \rest ...
f = {|x, n=3|
	Pn(
		Plazy({
			Pseq(x.nextN(n)++\rest);
		})
	).asStream;
};

// apply a function to a stream
g = {|x, f|
	Pn(
		Plazy({
			Pseq([f.(x.next)]);
		})
	).asStream;
};

a = Ptuple([
	g.(~repeat.(~counter.(8,true)), {|x| [0, 5, 7, 9, 12].wrapAt(x-1)})
	,f.(g.(~repeat.(~counter.(7)), {|x| [0, 5, 7, 9, 12].wrapAt(x-1)}, 3))
]).asStream;

b = Ptuple([
	g.(~accumulate.(~counter.(8,true)), {|x| [0, 4, 9, 12, 14].wrapAt(x-1)})
	,f.(g.(~accumulate.(~counter.(7)), {|x| [0, 4, 9, 12, 14].wrapAt(x-1)}, 3))
]).asStream;

Pseq([
	Pbind(\instrument, \sine, \legato, 1, \degree, Pfin(32, Pclump(3, a)-5), \dur, 0.125, \sustain, Pkey(\dur)*8, \strum, Pseq([0.125, 0.125/2], inf))
	,Pbind(\instrument, \sine, \legato, 1, \degree, Pfin(32, Pclump(3, b)-2), \dur, 0.125, \sustain, Pkey(\dur)*8, \strum, Pseq([0.125, 0.125/2], inf))
	,Pbind(\instrument, \sine, \legato, 1, \degree, Pfin(32, Pclump(3, a)+2), \dur, 0.125, \sustain, Pkey(\dur)*8, \strum, Pseq([0.125, 0.125/2], inf))
	,Pbind(\instrument, \sine, \legato, 1, \degree, Pfin(32, Pclump(3, b)+0), \dur, 0.125, \sustain, Pkey(\dur)*8, \strum, Pseq([0.125, 0.125/2], inf))
],inf).play(quant:4);
)
