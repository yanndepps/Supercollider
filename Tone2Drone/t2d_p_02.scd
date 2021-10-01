// Tone to Drone Part 02 : modulation
// dynamically change different parts of the sounds.

s.boot;
s.meter;
s.plotTree;
s.freqscope;

// Lesson 8
// UGens can be used as an audio rate signal with '.ar', but most UGens
// can also be used as a control rate signal with '.kr'.
// contol rate signal are not fast enough to generate audio, but they can be used
// to modulate any parameter.
(
{
  SinOsc.ar(220+SinOsc.kr(1, mul:20)).dup*0.1;
}.play;
)

// Lesson 9 - generating modulation sources
// stepped randomness -> using LFNoise0 to generate steps
(
{
  LFNoise0.kr(freq:10)
}.plot(1);
)

(
{
  var mod = LFNoise0.kr(freq:10, mul:20);
  SinOsc.ar(220+mod).dup*0.1;
}.play;
)

// random oscillations -> modulate modulations
(
{
  SinOsc.kr(freq:LFNoise0.kr(freq:3)*6);
}.plot(1);
)

(
{
  var mod = SinOsc.kr(freq:LFNoise0.kr(freq:3)*6, mul:20);
  SinOsc.ar(220+mod).dup*0.1;
}.play;
)

// drunken walk -> use VarLag to slew the LFNoise
(
{
  VarLag.kr(LFNoise0.kr(20), 1/20, warp:\sine);
}.plot(1);
)

(
{
  var mod = 20*VarLag.kr(LFNoise0.kr(2), 1/20, warp:\sine);
  SinOsc.ar(220+mod).dup*0.1;
}.play;
)

// Change the scale of any modulation using range(low, hi)
(
{
  SinOsc.kr(freq:LFNoise0.kr(freq:3)*6).range(0, 100);
}.plot(1);
)

// when dealing with frequencies, it's useful to use exponential mappings
// this spends a lot of time in inaudible range :
(
{
  LFTri.kr(10).range(10, 20000);
}.plot(1);
)

// whereas, this helps to keep it close to audible :
(
{
  LinExp.kr(LFTri.kr(10), -1, 1, 10, 20000);
}.plot(1);
)

// Lesson 10 -> a drone with modulation
// a Pulse waveform with 3 oscillators at frequencies spaced across 3 octaves :
