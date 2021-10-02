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
(
x = {
  arg freq=110, amp=0.1; // args for frequency and amplitude
  var snd; // a variable to hold the waveform
  snd = Array.fill(3, { 
    arg i;
    var snd2;
    var freq2=freq*(2**i);
    snd2=PulseDPW.ar(freq:freq2, mul:1/(2**i), width:0.5);
  });
  // add in a mixer
  snd=Mix.ar(snd);
  // spread the sound across the stereo field
  snd=Splay.ar(snd);
  // pass the sound through a Moog-inspired VCF, using the 
  // mouse's X position to modulate the cutoff frequency
  snd=MoogFF.ar(snd, LinExp.kr(MouseX.kr(), 0, 1, 100, 12000));
  // send the sound to a bus, applying amplification
  Out.ar(0, snd*amp);
}.play;
)

// bank of modulators -> rrand(lo, hi) will generate an unique value on init
(
{
  {
    LFTri.kr(LFNoise0.kr(rrand(10/60, 100/3)).range(10/60, 100/3))
  }!4;
}.plot(1);
)

// and use the first one in the bank to do pulse width and volume modulation
// each run will sound a bit different, because rrand init differently each time

(
x = {
  arg freq=110, amp=0.1; // args for frequency and amplitude
  var snd; // a variable to hold the waveform
  snd = Array.fill(8, { 
    arg i;
    var snd2;
    var freq2=freq*(2**i);
    var modBank=(LFTri.kr(LFNoise0.kr(rrand(1/10,1)).range(1/10,1)))!8;
    var modAmp=modBank[0].range(0.2,0.5); // convert to correct range
    var modWidth=modBank[1].range(0.2,0.8);
    snd2=PulseDPW.ar(
      freq:freq2, 
      mul:1/(2**i), 
      width:0.5
    );
  });
  snd=Mix.ar(snd);
  snd=Splay.ar(snd);
  Out.ar(0, snd*amp);
}.play;
)
