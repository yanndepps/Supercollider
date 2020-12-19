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

// 31.46