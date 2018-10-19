// the pattern family
s.boot;

// Pbind :
Pbind(\degree, Pseries(0, 1, 30), \dur, 0.05).play;
// Pbind is a member of the Pattern family. The capital P in Pbind and Pseries stands for Pattern.
Pbind(\degree, 0).play;
// Pbind uses \dur to specify durations in seconds:
Pbind(\degree, 0, \dur, 0.5).play;

// Pseq :
Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 1), \dur, 0.2).play;
// all that Pseq needs in order to play a sequence is :
// a list of items between square brackets
// a number of repetitions
// use of a Pseq to control durations
(
Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 5),
	  \dur, Pseq([0.2, 0.1, 0.1, 0.2, 0.2, 0.35], inf)
).play;
)

// Pbind accepts other ways of specifying pitch, not just scale degrees.
// use \note for twelve chromatic notes (0=middle C)
// use \midinote for midi note numbering (60=middle C)
// use \freq to specify frequencies directly
// play A4 :
Pbind(\degree, 5).play;
Pbind(\note, 9).play;
Pbind(\midinote, 69).play;
Pbind(\freq, 440).play;

// amp and legato, define the amplitude of events, and the amount of legato between notes
(
Pbind(
	\degree, Pseq([0, -1, 2, -3, 4, -3, 7, 11, 4, 2, 0, -3], 5),
	\dur, Pseq([0.2, 0.1, 0.1], inf),
	\amp, Pseq([0.7, 0.5, 0.3, 0.2], inf),
	\legato, 0.8
).play;
)

// Prand
// instead of playing through the list in sequence, Prand picks a random item from
// the list every time
(
Pbind(
	\degree, Prand([2, 3, 4, 5, 6], inf),
	\dur, 0.15,
	\amp, 0.2,
	\legato, 0.1
).play;
)

// Pwhite
// is an equal distribution random number generator (white noise)
// Pwhite(100, 500) -> random num between 100 and 500
(
Pbind(
	\freq, Pwhite(261, 493),
	\dur, Prand([0.15, 0.25, 0.3], inf),
	\amp, 0.2,
	\legato, 0.3
).trace.play;
)

// Pwhite takes only a low and high boundary: Pwhite(low, high)
// random nums will be chosen within that range
// Prand takes in a list of items and a number of repeats: Prand([x,y,z], repeats)
// random items will be chosen from the list
// TIP:
// a Pwhite with two integer nums will generate only integers. for floating point nums
// write: Pwhite(0, 1.0) and get everything in between.

// a Pbind stops playing when the shortest internal pattern has finished playing
// (as determined by the repeats argument of each internal pattern)

// Expanding Pattern Vocabulary
// Pser
(
Pbind(
	\note, Pser([0, 2, 3, 5, 7, 8, 11, 12], 11),
	\dur, 0.15;
).trace.play;
)

// Pxrand
(
p = Pbind(
	\note, Pxrand([0, 2, 3, 5, 7, 8, 11, 12], inf),
	\dur, Pwhite(0.15, 0.25),
	\legato, 0.8;
).trace.play;
)

// Pshuf
(
p = Pbind(
	\note, Pshuf([0, 2, 3, 5, 7, 8, 11, 12], 6),
	\dur, 0.15,
	\legato, 0.8;
).trace.play;
)

// Pslide (takes 4 args : list, repeats, length, step)
(
p = Pbind(
	\note, Pslide([0, 2, 3, 5, 7, 8, 11, 12], 7, 3, 1),
	\dur, 0.15,
	\legato, 0.8
).trace.play;
)

// Pseries (takes 3 args : start, step, length)
(
p = Pbind(
	\note, Pseries(0, 2, 15),
	\dur, 0.15,
	\legato, 0.8;
).trace.play;
)

// Pgeom (takes 3 args : start, grow, length)
(
p = Pbind(
	\note, Pseq([0, 2, 3, 5, 7, 8, 11, 12], inf),
	\dur, Pgeom(0.1, 1.1, 25),
	\legato, 0.4;
).trace.play;
)

// more pattern objects :
// http://doc.sccode.org/Tutorials/A-Practical-Guide/PG_01_Introduction.html

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

// ascending-descending scale
~scale = [0, 1, 2, 3, 4, 5, 6, 7];
~durs = [0.4, 0.2, 0.2, 0.4, 0.8, 0.2, 0.2, 0.2];
(
Pbind(
	\degree, Pseq(~scale),
	\dur, Pseq(~durs)
).play;

Pbind(
	\degree, Pseq(~scale.reverse - 7),
	\dur, Pseq(~durs)
).play;
)

// Pbind as a musical score
// Pbind is a kind of musical score, a recipe for making sounds, a set of instructions
// to realize a musical passage.
// In order for the score to become music, we need to give it to a player
// Definition of the score :
(
p = Pbind(
	\midinote, Pxrand([57, 62, 64, 65, 67, 69], inf),
	\dur, 1/7
); // no .play here !
)
// ask for the score to be played
p.play;

// Calling .play on a Pbind generates an EventStreamPlayer.
// Storing EventStreamPlayers into vars allows us to access them later
// to start and stop patterns individually.
// Define the score:
(
var myDurs = Pseq([Pn(1, 5), 3, Pn(1, 5), 3, Pn(1, 6), 1/2, 1/2, 1, 1, 3, 1, 3], inf) * 0.4;

~upperMelody = Pbind(
	\midinote, Pseq([69, 74, 76, 77, 79, 81, Pseq([81, 79, 81, 82, 79, 81], 2), 82, 81, 79, 77, 76, 74, 74], inf),
	\dur, myDurs
);

~lowerMelody = Pbind(
	\midinote, Pseq([57, 62, 61, 60, 59, 58, 57, 55, 53, 52, 50, 49, 50, 52, 50, 55, 53, 52, 53, 55, 57, 58, 61, 62, 62], inf),
	\dur, myDurs
);
)
// play the two together
(
~player1 = ~upperMelody.play;
~player2 = ~lowerMelody.play;
)
// stop them separetely
~player1.stop;
~player2.stop;
// other available message :
~player1.resume;
~player1.reset;
~player1.play;
~player1.start; // same as .play

// END of Part II

















































