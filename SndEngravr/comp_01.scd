// an approach to composing melody : part_01
// ©SoundEngraver

// Boilerplate for a basic midi setup
(
// boot the server
s.boot;
// start proxyspace
p = ProxySpace.push(s);
// start tempo clock
p.makeTempoClock;
// give proxyspace a tempo
p.clock.tempo = 2;
Task({
	3.wait;
	d = Dictionary.new;
	3.wait;
	MIDIClient.init;
	3.wait;
	"Setup Done".postln;
	5.wait;
	d[\m] = MIDIOut.newByName("Gestionnaire IAC", "Tidal1").latency_(0.2555);
	"Midi setup".postln;
}).start;
)

// Tempo

(
t = TempoClock(64/60).permanent_(true);
t.schedAbs(t.nextBar, (t.beats.postln; 1));
)

t.schedAbs(t.nextBar, (t.tempo_(128/60); nil));
t.stop;


// Melody 1
// natural minor scale degrees : [ 0, 2, 3, 5, 7, 8, 10 ]

(
~midiPattern = Pbindef(\midiperc,
	\type, \midi,
	\dur, Pwrand([
		Pseq([3/1, 1/2, 1/4], 1),
		Pseq([1/4, 1/4, 1/4], 1),
	], [0.35, 0.65], inf),
	\amp, Pwhite(0.1, 0.5, inf),
	\midicmd, \noteOn,
	\midiout, d[\m],
	\chan, 0,
	\midinote, Pfuncn({
		var notes = Scale.minor.degrees.collect(_+[0]).flat+60;
		notes.scramble[0];
	}, inf),
	\atk, 0.001,
	\sustain, 0.1,
	\rel, 0.1,
).play(t, quant: 4);
)

// Midsection

(
~midiPattern = Pbindef(\midiperc,
	\type, \midi,
	\dur, Pwrand([
		Pseq([3/1, 1/2, 1/4, 1/4], 1),
		Pseq([1/4, 1/4, 1/4], 1),
	], [0.35, 0.65], inf),
	\amp, Pwhite(0.1, 0.5, inf),
	\midicmd, \noteOn,
	\midiout, d[\m],
	\chan, 0,
	\midinote, Pfuncn({
		var notes = Scale.minor.degrees.collect(_+[0]).flat+64;
		notes.scramble[0..rrand(0, 4)]; // syntax for harmony
	}, inf),
	\atk, 0.001,
	\sustain, 0.1,
	\rel, 0.1,
).play(t, quant: 4);
)

// Melody 2

(
~midiPattern = Pbindef(\midiperc,
	\type, \midi,
	\dur, Pseq([
		Pseq([1, 0.5, 0.25, 0.25, 0.5, 1, 0.5], 1) * 2,
		Pseq([0.125, 0.125, 0.25, 0.5, 0.25, 0.5, 0.25], 2) * 2,
		Pseq([1, 0.5, 0.25, 0.25, 0.5, 0.5, 0.25, 0.25, 0.5], 1) * 2,
	],inf),
	\amp, Pwhite(0.1, 0.5, inf),
	\midicmd, \noteOn,
	\midiout, d[\m],
	\chan, 0,
	\midinote, Pfuncn({64 + Scale.minor.degrees.choose}, inf),
	/*\midinote, Pfuncn({
		var notes = Scale.minor.degrees.collect(_+[0]).flat+60;
		notes.scramble[0];
	}, inf), */
	\atk, Pwhite(0.001, 0.01, inf),
	\sustain, Pwhite(0.1, 0.33, inf),
	\rel, Pwhite(0.01, 0.1, inf),
).play(t, quant: 4);
)

// --------