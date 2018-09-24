s.boot;

// {PinkNoise.ar(0.2!2)}.play


(
var num;
num = 5;
num = num * 2;
)

~number = 5;
~number / 3;

2.class;
7.08.class;
[1,2,3].class;

receiver.method;

w = Window.new;
w.front;
w.background = Color.rand;
w.close;

x = {1 + 4.5};
~result = x.value;

(
~myFunc = {
	var val;
	val = 6;
	val = val.squared;
}
)
~myFunc.value;

(
~myArgFunc = {
	arg val;
	val = val.squared;
}
)
~myArgFunc.value(6);


(
~myArgFunc = {
	arg val1, val2;
	(val1 + val2) / 2;
}
)
z = ~myArgFunc.value(5,3);
z;

// ---

s.boot;

(
x = {
	arg mute = 1;
	var sig;
	sig = SinOsc.ar(100, 0, 0.1, 0.8)!2;
	sig = sig * mute;
}.play;
)

(
y = {
	var sig;
	sig = PinkNoise.ar(0.02, 0)!2;
}.play;
)

"hello"!3!5;

x.free;
y.free;
x.set(\mute, 0);
x.set(\mute, 0.2);

(
a = {
	arg mute = 1;
	var sig;
	sig = SinOsc.ar(exprand(200,1000), 0, 0.05, 0)!2;
	sig = sig * mute;
}.play;
)
(
b = {
	arg mute = 1;
	var sig;
	sig = SinOsc.ar(exprand(200,1000), 0, 0.05, 0)!2;
	sig = sig * mute;
}.play;
)
(
c = {
	arg mute = 1;
	var sig;
	sig = SinOsc.ar(exprand(200,1000), 0, 0.05, 0)!2;
	sig = sig * mute;
}.play;
)
a.free;
b.free;
c.free;


s.meter;
s.scope;
FreqScope.new;
s.plotTree;

// ---

(
x = {
	arg sawFreq, ampFreq;
	var sig, freq, amp;
	amp = SinOsc.ar(ampFreq, 0).exprange(0.001, 0.25);
	// freq = LFSaw.ar(sawFreq, 0).exprange(65, 220);
	freq = LFTri.ar(sawFreq, 0).range(65, 220);
	// freq = LFNoise0.kr(16).exprange(65, 220);
	sig = SinOsc.ar(freq, 0, amp, 0)!2;
}.play;
)

x.set(\sawFreq, 3, \ampFreq, 303);
x.free;


s.scope;

{LFSaw.ar(4, 0).range(65, 220)}.plot(2);
{LFSaw.ar(4, 0).exprange(65, 220)}.plot(2);
{LFNoise0.kr(16).exprange(65, 220)}.plot(2);

// --- end of week 01 ---
