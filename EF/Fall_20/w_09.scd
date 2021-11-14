// week 09
// FX, Buses, Signal routing
// p:52.27

s.boot;

// start 

(
SynthDef.new(\drops, {
  arg freqMin=100, freqMax=3000, gate=1, amp=0.3;
  var sig, trigEnv, env, freq, trig;

  freq = LFNoise1.kr(0.2!2).exprange(freqMin, freqMax);
  sig = SinOsc.ar(freq);

  trig = Dust.ar(1!2);
  trigEnv = EnvGen.ar(Env.perc(0.002, 0.1), trig);
  sig = sig * trigEnv;

  env = EnvGen.kr(Env.asr(0.01, 1, 1, -1), gate, doneAction:2);
  sig = sig * env * amp;

  Out.ar(0, sig);
}).add;
)

x = Synth.new(\drops);
x.set(\gate, 0);
x.free;

// add a reverb fx

(
SynthDef.new(\drops, {
  arg freqMin=100, freqMax=3000, gate=1, amp=0.3;
  var sig, trigEnv, env, freq, trig, reverb;

  freq = LFNoise1.kr(0.2!2).exprange(freqMin, freqMax);
  sig = SinOsc.ar(freq);

  trig = Dust.ar(1!2);
  trigEnv = EnvGen.ar(Env.perc(0.002, 0.1), trig);
  sig = sig * trigEnv;

  // reverb
  reverb = GVerb.ar(sig, 250, 4);
  // filter out about X hz -> damping
  reverb = LPF.ar(reverb, 900);
  sig = ( sig + reverb ) * 0.5;

  env = EnvGen.kr(Env.asr(0.01, 1, 1, -1), gate, doneAction:2);
  sig = sig * env * amp;

  Out.ar(0, sig);
}).add;
)

x = Synth.new(\drops);
x.set(\gate, 0);
x.free;

// we want a natural reverb decaying -> rm fx from the SynthDef
// modularize the work -> multiple SynthDef, one for each task

(
SynthDef.new(\drops, {
  arg freqMin=100, freqMax=3000, gate=1, amp=0.3, out=0;
  var sig, trigEnv, env, freq, trig;

  freq = LFNoise1.kr(0.2!2).exprange(freqMin, freqMax);
  sig = SinOsc.ar(freq);

  trig = Dust.ar(1!2);
  trigEnv = EnvGen.ar(Env.perc(0.002, 0.1), trig);
  sig = sig * trigEnv;

  env = EnvGen.kr(Env.asr(0.01, 1, 1, -1), gate, doneAction:2);
  sig = sig * env * amp;

  Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
  arg in=0, out=0;
  var sig, reverb;

  // in order to sum together ( dry/wet )
  sig = In.ar(in, 2);
  reverb = In.ar(in, 2);

  reverb = GVerb.ar(reverb, 250, 4);
  reverb = LPF.ar(reverb, 900);
  sig = (sig + reverb) * 0.5;

  Out.ar(out, sig);
}).add;
)

// a bus is basically a signal path
s.options.numOutputBusChannels = 2; // 8
s.options.numInputBusChannels = 2; // 8
s.reboot;
s.options.numOutputBusChannels;
s.options.numInputBusChannels;
s.options.numAudioBusChannels;
s.options.numControlBusChannels;
s.options.numPrivateAudioBusChannels;

s.scope;
s.meter;

r = Synth.new(\reverb, [\in, 48]);
d = Synth.new(\drops, [\out, 48]);
d.set(\gate, 0);
d.free;

// the best way is to use a bus object
~bus = Bus.audio(s, 2);

// n case we want to reset the bus allocation
s.newBusAllocator;

r = Synth.new(\reverb, [\in, ~bus]);
d = Synth.new(\drops, [\out, ~bus]);
d.set(\gate, 0);
d.free;

// 2. Order of execution
r = Synth.new(\reverb, [\in, ~bus]);
d = Synth.new(\drops, [\out, ~bus]);
d.set(\gate, 0);
d.free;
r.free;

// the SynthDef doing the processing must be dwonstream of the one 
// doing the generating ! ( head to tail )
// use target and addAction
d = Synth.new(\drops, [\out, ~bus]);
r = Synth.new(\reverb, [\in, ~bus], s.defaultGroup, \addToTail);
d.set(\gate, 0);
d.free;
r.free;

// but target can be many things
d = Synth.new(\drops, [\out, ~bus]);
r = Synth.new(\reverb, [\in, ~bus], d, \addAfter);
d.set(\gate, 0);
d.free;
r.free;

// using add replace with a new Synth
(
SynthDef.new(\drops2, {
  arg freqMin=100, freqMax=3000, gate=1, amp=0.3, out=0;
  var sig, trigEnv, env, freq, trig;

  freq = LFNoise1.kr(0.2!2).exprange(freqMin, freqMax);
  sig = Pulse.ar(freq);

  trig = Dust.ar(1!2);
  trigEnv = EnvGen.ar(Env.perc(0.002, 0.1), trig);
  sig = sig * trigEnv;

  env = EnvGen.kr(Env.asr(0.01, 1, 1, -1), gate, doneAction:2);
  sig = sig * env * amp;

  Out.ar(out, sig);
}).add;
)

d = Synth.new(\drops, [\out, ~bus]);
r = Synth.new(\reverb, [\in, ~bus], d, \addAfter);
p = Synth.new(\drops2, [\out, ~bus], d, \addReplace);
d.set(\gate, 0);
p.set(\gate, 0);
r.free;

// or fade out and turn on a new synth using addBefore
d = Synth.new(\drops, [\out, ~bus]);
r = Synth.new(\reverb, [\in, ~bus], d, \addAfter);

(
d.set(\gate, 0);
p = Synth.new(\drops2, [\out, ~bus], d, \addBefore);
)

p.set(\gate, 0);
r.free;

// 3. Groups
// Synth and Group are both subclasses of a class call Node
// make our own group
~grp0 = Group.new;
~grp1 = Group.new;
~grp2 = Group.new;

~grp0.free;
~grp1.free;
~grp2.free;

// make and collect 10 groups into one array
~grp = 10.collect({Group.new});
~grp.do({ arg n; n.free });

// Groups make it easy to organize our Synths on the server.
// i.e. a source group, an fx group and modularize your thinkings
// make sure to put those groups in the right order.
~srcGrp = Group.new;
~fxGrp = Group.new(~srcGrp, \addAfter);

d = Synth.new(\drops, [\out, ~bus], ~srcGroup);
p = Synth.new(\drops2, [\out, ~bus, \amp, 0.05], ~srcGroup);
r = Synth.new(\reverb, [\in, ~bus], ~fxGroup);

// fade out all signals inside of group
~srcGrp.set(\gate, 0);

// put a group inside of a group
~testGrp = Group.new(~srcGrp, \addToHead);

// if you have a SynthDef that reads a signal from a bus, expecting some
// other signal to generate that signal, it has to go downstream !

// --- END --- //
