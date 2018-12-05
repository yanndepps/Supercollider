// envelopes and doneAction

s.boot;

s.plotTree;

(
x = {
	var sig, env;
	env = Line.kr(1, 0, 1, doneAction:2);
	sig = Pulse.ar(ExpRand(30, 500))*env;
}.play;
)

x.free;
s.freeAll;

(
{
	var sig, env;
	env = XLine.kr(1, 0.01, 1, doneAction:2);
	sig = Pulse.ar(ExpRand(30, 500))*env;
}.play;
)

(
{
	var sig, env;
	env = Line.kr(1, -40, 1, doneAction:2);
	sig = Pulse.ar(ExpRand(30, 500))*env.dbamp;
}.play;
)

0.125.ampdb;

(
{
	var sig, freq, env;
	env = XLine.kr(1, 0.01, 2, doneAction:2);
	freq = XLine.kr(880, 110, 1, doneAction:0);
	sig = Pulse.ar(freq)*env.dbamp;
	sig!2;
}.play;
)

// ---

(
{
	var sig, env;
	env = EnvGen.kr(Env.new, doneAction:2);
	sig = Pulse.ar(ExpRand(30, 110)) * env;
	sig!2;
}.play;
)

Env.new([0, 1, 0.2, 0], [0.5, 1, 2]).plot;

Env.new([0.01, 1, 0.2, 0.01], [0.5, 1, 2], \exp).plot;

// use a third array of numbers to specify segment curvatures
Env.new([0.01, 1, 0.2, 0.01], [0.5, 1, 2], [5, -3, 0]).plot;

// new env in action
(
{
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0.01, 1, 0.2, 0.01],
		[0.5, 1, 2],
		[5, -3, 0]),
	doneAction:2);
	sig = Pulse.ar(ExpRand(30, 90)) * env;
	sig!2;
}.play;
)

// gate can be set as a trigger to reset the envelope
(
x = {
	arg t_gate=1;
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0.01, 1, 0.2, 0.01],
		[0.5, 1, 2],
		[5, -3, 0]), t_gate, doneAction:2);
	sig = Pulse.ar(LFPulse.kr(8).range(300, 400)) * env;
	sig!2;
}.play;
)

x.set(\t_gate, 1);

x.free;
s.freeAll;

// adsr
(
x = {
	arg gate=0;
	var sig, env;
	env = EnvGen.kr(Env.adsr, gate);
	sig = VarSaw.ar(SinOsc.kr(16).range(300, 400)) * env;
	sig!2;
}.play;
)

x.set(\gate, 1);

// a second adsr env control the frequency modulation of the osc sound source
(
x = {
	arg gate=0, hf=300;
	var sig, env, freq;
	freq = EnvGen.kr(Env.adsr(1), gate, 200, 0.1);
	env = EnvGen.kr(Env.adsr, gate);
	sig = VarSaw.ar(SinOsc.kr(freq).range(100, hf)) * env;
	sig!2;
}.play;
)

x.set(\gate, 1);
x.set(\hf, 220);
x.free;

// --- end of part04