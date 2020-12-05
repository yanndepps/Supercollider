s.boot;

s.quit;

s.makeWindow;

s.meter;

s.scope;

FreqScope.new;

s.plotTree;

// Essentials UGens
// oscillators: band-limited ( antialiasing )
SinOsc, Saw, Pulse, Blip

// oscillators: non-band-limited 
// ( optimal for low freq, will alias at high freqs )
LFSaw, LFPulse, LFTri, VarSaw

// noise generators 
WhiteNoise, PinkNoise, LFNoise0, LFNoise1

// filters: lo/hi pass ( R=resonant ), lo/hi shelf, band pass/reject
LPF, HPF, RLPF, RHPF, BlowShelf, BHiShelf, BPF, BRF
( also BEQSuite )

// triggers
Impulse, Dust, Trig

// envelopes
Line, XLine, EnvGen

// sample playback
PlayBuf, BufRd

// delays
DelayN, DelayL, DelayC, // no feedback
CombN, CombL, CombC // with feedback

// stereo panners/balancers
Pan2, Balance2

// play a function
// fill the function with unit generators ( UGen )

{ SinOsc.ar }.play;

~sine = { SinOsc.ar!2 }.play;
~saw = { Saw.ar!2 }.play;

// using arguments
~sine = { SinOsc.ar(300, 0, 1, 0) }.plot(0.02);
~sine = { SinOsc.ar(300, pi, 1, 0) }.plot(0.02);
~sine = { SinOsc.ar(300, pi/2, 1, 0) }.plot(0.02);
~sine = { SinOsc.ar(300, 3pi/2, 1, 0) }.plot(0.02);

// using only the args we want 
~sine = { SinOsc.ar(freq:300, mul:0.2)!2 }.play;

~sine.free;
~saw.free;

(
~vib = {
  var sig, vib;
  vib = SinOsc.ar(6, 0, 20, 300);
  sig = SinOsc.ar(vib, mul:0.2)!2;
}.play;
)

(
~vib = {
  var sig, vib;
  vib = SinOsc.ar(6).range(280, 320);
  sig = SinOsc.ar(vib, mul:0.2)!2;
}.play;
)

(
~vib = {
  var sig, mod;
  mod = LFSaw.ar(1).range(0, 500);
  sig = Pulse.ar(200 + mod, 0.5, 0.1)!2; 
}.play;
)

~vib.free;

// binaural
(
x = {
  var sig;
  sig = SinOsc.ar([300, 302]);
  sig = sig * 0.2;
}.play;
)

(
y = {
  var sig;
  sig = SinOsc.ar([400, 402]);
  sig = sig * 0.2;
}.play;
)

(
z = {
  var sig;
  sig = SinOsc.ar([250, 250.5]);
  sig = sig * 0.2;
}.play;
)

x.free;
y.free;
z.free;
