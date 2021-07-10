// smooth signals with Lag and VarLag
// we often use a 'set' message to change a control value.
// but we may want to slide from one value to the next over a period of time.

s.boot;

// ---

(
SynthDef(\gliss, {
  arg freq=440, gate=1, amp=0.3, out=0;
  var sig, env;
  env = EnvGen.kr(Env.asr, gate, doneAction:2);
  sig = SinOsc.ar(freq)!2;
  sig = sig * amp;
  sig = sig * env;
  Out.ar(out, sig);
}).add;
)

x = Synth(\gliss);
x.set(\freq, 72.midicps);
x.set(\freq, 74.midicps);
x.set(\gate, 0);

// ---
// Lag is a UGen and essentially a type of LowPass filter that causes a signal to 
// interpolate between changes over a period of time.

(
SynthDef(\gliss, {
  arg freq=440, freqlag=1, gate=1, amp=0.3, out=0;
  var sig, env;
  // freq = Lag.kr(freq, 1);
  freq = freq.lag(freqlag);
  env = EnvGen.kr(Env.asr, gate, doneAction:2);
  sig = SinOsc.ar(freq)!2;
  sig = sig * amp;
  sig = sig * env;
  Out.ar(out, sig);
}).add;
)

x = Synth(\gliss);
x.set(\freq, 72.midicps, \freqlag, 0.25);
x.set(\freq, 74.midicps, \freqlag, 3);
x.set(\freq, 80.midicps, \freqlag, 0);
x.set(\gate, 0);

// ---
// in addition to lag time, VarLag accepts a curve value; 
// the behaviour being exactly the same as for enveloppe's curve values:
// 0 is linear, positive values bend the shape so that the value changes slowly
// at first and quickly towards the end, and negative values bend in the opposite 
// way and as this value gets further away from zero the shape of the curve 
// becomes more extreme.

(
SynthDef(\gliss, {
  arg freq=440, freqlag=1, freqcrv=0, gate=1, amp=0.3, out=0;
  var sig, env;
  freq = freq.varlag(freqlag, freqcrv);
  env = EnvGen.kr(Env.asr, gate, doneAction:2);
  sig = SinOsc.ar(freq)!2;
  sig = sig * amp;
  sig = sig * env;
  Out.ar(out, sig);
}).add;
)

x = Synth(\gliss);
x.set(\freq, 220, \freqlag, 2, \freqcrv, 0);
x.set(\freq, 440, \freqlag, 2, \freqcrv, 15);
x.set(\freq, 220, \freqlag, 2, \freqcrv, -15);
x.set(\gate, 0);

// ---
// when applied to pitch, negative curves tend to be more useful: when a value
// changes, a negative curve moves it close to its target quickly and levels off, 
// more of a common way to perform a glissando.

// ---
// Lag can be applied to anything:
// here we lag the amplitude creating a sort of dynamic enveloppe that
// can be controlled stage by stage using set messages 

(
SynthDef(\gliss, {
  arg freq=440, freqlag=1, freqcrv=0, amplag=2, ampcrv=0, amp=0.3, out=0;
  var sig, env;
  freq = freq.varlag(freqlag, freqcrv);
  sig = SinOsc.ar(freq)!2;
  sig = sig * amp.varlag(amplag, ampcrv);
  Out.ar(out, sig);
}).add;
)

x = Synth(\gliss, [\amp, 0]);
x.set(\amp, 0.3, \amplag, 1, \ampcrv, -2);
x.set(\amp, 0, \amplag, 3, \ampcrv, -8);
x.free;

// ---
// here sig is a sample&hold generator, ( random staircase shape ) producing 50
// values per second; we then plot half a second of five different signals smoothed
// by a different lag function.
// we can see how each of these signals become progressively smoother as we lag them
// more aggressively.

(
{
  var sig;
  sig = LFNoise0.kr(50);
  [ 
    sig,
    sig.lag(0.01),
    sig.lag2(0.01),
    sig.lag3(0.01),
    sig.lag3(0.01).lag3(0.01)
  ];
}.plot(0.5, bounds:Rect(100, 200, 1700, 750));
)

// ---
