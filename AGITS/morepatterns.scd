// More Pattern tricks
// Chords : write them as lists (comma-separated values enclosed in square brackets)
(
Pbind(
	\note, Pseq([[0, 3, 7], [2, 5, 8], [3, 7, 10], [5, 8, 12]], 3),
	\dur, 0.15,
	\legato, 0.4;
).trace.play;
)

// strum
(
Pbind(
	\note, Pseq([[-7, 3, 7, 10], [0, 3, 5, 8]], 2),
	\dur, 1,
	\legato, 0.4,
	\strum, 0.2
).trace.play;
)

// Scales (only works with \degree)
(
Pbind(
	\scale, Scale.harmonicMinor,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 1),
	\dur, 0.15;
).trace.play;
)

// list of all available scales:
Scale.directory;

// chromatic note in between scale degrees :
(
Pbind(
	\scale, Scale.harmonicMinor,
	\degree, Pseq([0, 1, 2, 3, 3.1, 4], 1),
	\dur, 0.15;
).play;
)

// Transposition
// use \ctranspose to achieve chromatic transposition. will not work with \freq
(
Pbind(
	\note, Pser([0, 2, 3, 5, 7, 8, 11, 12], 11),
	\ctranspose, -12,
	\dur, 0.15,
	\legato, 0.8;
).play;
)

// Microtones
Pbind(\note, Pseq([0, 0.5, 1, 1.5, 1.75, 2], 1)).play;
Pbind(\midinote, Pseq([60, 69, 68.5, 60.25, 70], 1)).play;

// Tempo
// values provided in \dur are in number of beats (1=one beat, 0.5=half a beat, ...)
// the default is 60BPM
// to play at a different tempo, create a new TempoClock:
(
Pbind(
	\degree, Pseq([0, 0.1, 1, 2, 3, 4, 5, 6, 7]),
	\dur, 1;
).play(TempoClock(120/60)); // 120 beats over 60 seconds: 120BPM
)

// if you omit an argument, it will use a built-in default value
// in the case above, the default repeats for Pseq is 1.

// Rests
// the number inside Rest is the duration of the rest in beats.
// Rests can go anywhere in the Pbind, not just in the \dur line.
(
Pbind(
	\degree, Pwhite(0, 10),
	\dur, Pseq([0.1, 0.1, 0.3, 0.6, Rest(0.3), 0.25], inf);
).play;
)

// Playing two or more Pbinds together:
// simply enclose all of them within a single code block
(
Pbind(
	\freq, Pn(Pseries(110, 111, 10)),
	\dur, 1/2,
	\legato, Pwhite(0.1, 1)
).play;
Pbind(
	\freq, Pn(Pseries(220, 222, 10)),
	\dur, 1/4,
	\legato, Pwhite(0.1, 1);
).play;
Pbind(
	\freq, Pn(Pseries(330, 333, 10)),
	\dur, 1/6,
	\legato, 0.1
).play;
)

// use {}.fork to play Pbinds in a time-ordered fashion
// basic fork example:
(
{
	"one thing".postln;
	2.wait;
	"another thing".postln;
	1.5.wait;
	"one last thing".postln;
}.fork;
)

// a more interesting one:
(
t = TempoClock(76/60);
{
	Pbind(
		\note, Pseq([[4, 11], [6, 9]], 32),
		\dur, 1/6,
		\amp, Pseq([0.05, 0.03], inf)
	).play(t);

	2.wait;

	Pbind(
		\note, Pseq([23, 21, 25, 23, 21, 20, 18, 16, 20, 21, 23, 21], inf),
		\dur, Pseq([0.25, 0.75, 0.25, 1.75, 0.125, 0.125, 0.80, 0.20, 0.125, 0.125, 1], 1),
		\amp, 0.1,
		\legato, 0.5
	).play(t);

}.fork(t);
)

// to see : Ppar, Pspawner, Routine

// Using Variables
// vars allow you to refer to any chunk of data in a flexible and concise way
c = [0, 2, 3, 5, 7, 8, 11, 12];
Pbind(\note, Pseq(c, 1), \dur, 0.15).play;
Pbind(\note, Prand(c, 6), \dur, 0.15).play;
Pbind(\note, Pslide(c, 5, 3, 1), \dur, 0.15).play;

// ...


















































