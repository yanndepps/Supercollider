// Tone to Drone Part 01 : first steps + tones

s.boot;
s.meter;
s.plotTree;
s.freqscope;

// print
"I love SuperCollider".postln;

// parens make it easy to run multiple lines of code
(
"I love SuperCollider".postln;
"SuperCollider loves me".postln;
)

// disorder of operation : no order of operation in SC
(
( 100 + 2 / 2 ).postln; // ?
( 100 + ( 2 / 2 ) ).postln; // forces order of operations using parens
)

// assign variables using letters a-z or wiwth ~varName
// create a function stored in a var
(
a = { "I love SuperCollider".postln; };
~someVar = { "SuperCollider loves me".postln; };
)

// run the 1st function
a.value; // .value evaluates the function stored in "a"

// run the 2nd function
~someVar.value;

// functions can have arguments and variables; both are similar except
// that args can be passed into function's call.

(
a = {
  arg name; // args must be defined first
  var something; // vars defined next
  something = "SuperCollider";
  ( name++", do you like "++something++"?" ).postln;
};
)

// execute the function
a.value("yann");

// a function that generates a sine wave
// the UGen is called SinOsc

(
{
  SinOsc.ar(freq:220);
}.plot(0.02); // plot it for x seconds
)

// now play it

(
{
  SinOsc.ar(freq:220);
}.play;
)

// add an argument and save the synth into a variable

(
x = {
  arg freq = 220;
  SinOsc.ar( freq:freq );
}.play;
)

// now run and change the sound

x.set(\freq, 440);
x.set(\freq, 60.midicps); // .midicps converts midi note to frequency ( cycles per second )
x.free; // stop the synth

// --- 11 --- //
// UGens constantly generate numbers
// but they can also be treated like numbers
// for example, add volume

(
x = {
  arg freq = 220, amp = 0.5;
  SinOsc.ar( freq:freq ) * amp;
}.play;
)

// lower the volume
x.set(\amp, 0.1);
// raise the volume and set the frequency
x.set(\amp, 0.7, \freq, 440);
// free the synth
x.free;

// --- 12 --- //
// UGens have all sorts of parameters
// SinOsc happens to have one that gets multiplied, called "mul"

(
x = {
  arg freq = 220, amp = 0.5;
  SinOsc.ar( freq:freq, mul:amp );
}.play;
)

x.free;

// --- 13 --- //
// "Out" will output the result to the bus
// bus "0" is the audio out

(
x = {
  arg freq = 220, amp = 0.5;
  var snd;
  snd = SinOsc.ar( freq:freq, mul:amp );
  Out.ar(0, snd);
}.play;
)

x.free;

// --- 14 --- //
// multichannel expansion : means that SC will automagically generate
// multiple UGens when a parameter has an array and assign each UGen to
// an audio channel ( e.g. left and right speakers ).

(
x = {
  arg freq = 220, amp = 0.5;
  var snd;
  snd = SinOsc.ar( freq:[ freq, freq*2 ], mul:[ amp, amp/2 ] );
  Out.ar(0, snd);
}.play;
)

// lower freq at higher volume in left ear
// higher freq at lower volume in right ear

x.free;

// --- 15 --- //
// sometimes we do not want multichannel expansion
// we can mix down to a single channel using the Mix.ar UGen
// and split across the left/right using Splay

(
x = {
  arg freq = 220, amp = 0.5;
  var snd;
  snd = SinOsc.ar( freq:[ freq, freq*2, freq*4 ], mul:[ amp, amp/2, amp/8 ] );
  snd = Mix.ar( snd ); // mixes the three channels into one
  snd = Splay.ar( snd );
  Out.ar( 0, snd );
}.play;
)

x.free;

// Lesson 6 - Polyphony
// define a synth
(
SynthDef('coolsynth', {
  arg freq=220, amp=0.1;
  var snd;
  snd=SinOsc.ar(freq:[freq, freq*2, freq*4], mul:[amp, amp/2, amp/8]);
  snd=Mix.ar(snd);
  snd=Splay.ar(snd);
  Out.ar(0, snd);
}).add;
)

// create multiple instances of it
(
x = Synth('coolsynth', [\freq, 60.midicps]);
y = Synth('coolsynth', [\freq, 62.midicps]);
z = Synth('coolsynth', [\freq, 65.midicps]);
)

// each can be set later
(
x.set(\freq, 58.midicps);
y.set(\freq, 62.midicps);
z.set(\freq, 67.midicps);
)

(
x.set(\freq, 60.midicps);
y.set(\freq, 62.midicps);
z.set(\freq, 65.midicps);
)

// free them all
(
x.free;
y.free;
z.free;
)

// Lesson 7 - Additive Synthesis
// you can treat UGens like numbers
// add them together and make a new oscillator

(
SynthDef('coolsynth', {
  arg freq=119, amp=0.1;
  var snd;
  // mix directly
  snd=Mix.ar(SinOsc.ar(freq:[freq, freq*2, freq*4], mul:[amp, amp/2, amp/8]));
  // add some harmonic from a saw wave
  snd=snd+(0.1*Mix.ar(Saw.ar(freq:[freq, freq*2, freq*3, freq*4], mul:[amp, amp/2, amp/3, amp/4])));
  snd=Splay.ar(snd);
  Out.ar(0, snd);
}).add;
)

// another and more versatile way of doing the same :

(
SynthDef('coolsynth', {
  arg freq=119, amp=0.1;
  var snd;
  // mix directly
  snd=Mix.ar(Array.fill(4, {arg i; SinOsc.ar(freq:freq*(2**i), mul:amp/(2**i))}));
  // add some harmonic from a saw wave
  snd=snd+(0.1*Mix.ar(Array.fill(4, {arg i; Saw.ar(freq:freq*(i+1), mul:amp/(i+1))})));
  snd=Splay.ar(snd);
  Out.ar(0, snd);
}).add;
)

// create multiple instances of it
(
x = Synth('coolsynth', [\freq, 60.midicps]);
y = Synth('coolsynth', [\freq, 62.midicps]);
z = Synth('coolsynth', [\freq, 65.midicps]);
)

// each can be set later
(
x.set(\freq, 58.midicps);
y.set(\freq, 62.midicps);
z.set(\freq, 67.midicps);
)

(
x.set(\freq, 60.midicps);
y.set(\freq, 62.midicps);
z.set(\freq, 65.midicps);
)

// free them all
(
x.free;
y.free;
z.free;
)

// Lesson 8 - Control rate vs audio rate
