s.boot;

s.quit;

s.makeWindow;

s.meter;

s.scope;

FreqScope.new;

s.plotTree;

//---

x = [1,2,3,4];
x.size;
// return at index x
x.at(0);
// syntax shortcut
x[0];
x.put(2, 500);

x = x.add(6000);
x = x.insert(1, "hi");

x = [404, 321, 843, 110, 777];
x.scramble;
x = x.reverse;
x = x.sort;
x = x.mirror2;

x = [404, 321, 843, 110, 777];
x = x.rotate(1);

x = [404, 321, 843, 110, 777];
x = x.choose;

x + 2;
x * 2;

[404, 321, 843, 110, 777].squared;
[404, 321, 843, 110, 777].odd;
[404, 321, 843, 110, 777].isPrime;

// collect, do, select, reject, any
x = [404, 53, 321, 3, 843, 110, 777];
x.select({ arg n; n.isPrime; });
x.reject({ arg n; n.isPrime; });
x.any({ arg n; n.isPrime; });

(
[10, 30, 60, 90, 300].do({
	arg n;
	n.squared.postln;
});
)

// print both item + index
(
[10, 30, 60, 90, 300].do({
	|n, i|;
	|n, i|.postln;
});
)

// an empty array of size 5
x = Array.new(5);
// an array of size 8, start at 5, increment by 2
x = Array.series(8, 5, 2);
// opposite direction
x = Array.series(8, 5, -2);
// start at 2, double it each time
x = Array.geom(8, 2, 2);
// interpolation between two values
x = Array.interpolation(8, 100, 150);

x = Array.fill(7, { "hello".scramble });

// Randomness
10.rand;
10.do({ 10.rand.postln });

// provide a range
rrand(1, 100);
exprand(1, 100).round(1);
// both values have to be either positive or negative with exprand

Array.exprand(8, 1, 100);
Array.fill(8, { rand(1, 100) });

// shortcut 1 to 100 with increment of one ( default )
(1..100)

// by increment of 3
(1,4..100)

(
x = Array.exprand(16, 200, 2000).round(200);
x = x.sort;
// x = x.sort.reverse;
x.do({
	arg n, i;
	{
		var sig;
		var amp;
		amp = (1/(i+1));
		amp = amp * 0.1;
		amp.postln;
		sig = SinOsc.ar(n);
		sig = sig * amp;
		sig!2;
	}.play;
});
)

(
~fn = {
	arg freq = 300;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * 0.05;
	sig!2;
};

~sounds = x.collect({
	arg n, i;
	~fn.play(args: [\freq, n]);
});
)

~sounds.do({ arg n; n.set(\freq, exprand(90, 900)) });
