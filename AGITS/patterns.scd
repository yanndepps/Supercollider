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

// End of Part II










