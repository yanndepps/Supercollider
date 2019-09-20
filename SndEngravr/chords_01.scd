/// How to compose chords ///
/// stop at 4.17

(
s.boot;
s.meter;
)

s.plotTree;
s.reboot;
s.quit;

// paths
// iterate over all files found in the pathname, including ones in subfolders
(
var myPath;
myPath = PathName.new("/Users/yanndepps/Documents/Musik/samplz/CLUSTER/");
myPath.filesDo{|afile| afile.postln};
)


// load
~note = Buffer.read(s, "/Users/yanndepps/Documents/Musik/samplz/CLUSTER/CLUSTER loops/SLOWS/110 Cinematograph A_C1_.wav");
~note.play;

// chord synth
(
SynthDef(\chords, {
	arg buf=0, atk=0.01, rel=1, c1=(-2), c2=2, amp=1,
	spos=0, rate=1, pan=0, out=0;
	var env, sig;
	env = Env([0, 1, 0], [atk, rel], [c1, c2]).kr(2);
	sig = PlayBuf.ar(2, buf, rate, startPos: spos);
	sig = sig*env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

/* Notes in Semitones
[0,1,2,3,4,5,6,7,8,9,10,11] => [C,C#,D,D#,E,F,F#,G,G#,A,A#,B]
Middle C:60
NOTE: sound source of a bounced audio file of Middle C
*/

(
Pbindef(\cChords,
	\instrument, \chords,
	\buf, ~note,
	\amp, 0.5,
	\dur, 1,
	\rate, Pseq([
		[0,4,7]+0, // I
		[0,4,7]+5, // IV
		[0,4,7]+7, // V
		[0,4,7]+0, // I
	], 2).trace.midiratio,
	\atk, 0.01,
	\rel, 0.33,
	\pan, 0,
).play(t);
)

// inverted (I, IV6, V, I)

(
Pbindef(\cChords,
	\instrument, \chords,
	\buf, ~note,
	\amp, 0.35,
	\dur, 1,
	\rate, Pseq([
		[0,4,7,12]+0,
		[4,7,12]+5, // IV6
		[0,4,7]+7,
		[0,4,7,12]+0,
	], 2).trace.midiratio,
	\atk, 0.3,
	\rel, 1.2,
	\pan, 0,
).play(t);
)

// for some longer sequences

(
Pbindef(\cChords,
	\instrument, \chords,
	\buf, ~note,
	\amp, 0.35,
	\dur, 1,
	\rate, Pseq([
		a=[0,4,7]+0;
		b=[0,4,7]+5;
		c=[0,4,7]+7,
		d=[-3,0,4]+5;
		e=Pswitch([a,b,c,d], Pseq([
			Pseq([0,1,2,0],1),
			Pseq([0,1,3,0],1),
		]),
		);
	], 2).trace.midiratio,
	\atk, 0.3,
	\rel, 1.2,
	\pan, 0,
).play(t);
)

// SawTooth Synth

(
SynthDef(\saw, {
	arg freq=500, amp=0.8, gate=1, out=0;
	var env, sig;
	env = EnvGen.kr(
		Env.asr([2,1,2], [-2,2]),
		gate,
		doneAction:2);
	sig = VarSaw.ar(freq)*env*amp;
	sig = Splay.ar(sig);
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\saw, [\freq, 48.midicps]);
x.set(\gate, 0);

(
x = [60,64,67,70].collect({
	arg note, index;
	Synth(\saw, [\freq, note.midicps, \amp, 0.2]);
})
)

x[0].set(\gate, 0);

/// --- End