// week 11
// Patterns, Streams and Events -> part 02
// 49.06

s.boot;

// start

(
SynthDef.new(\blip, {
  arg freq=300, amp=0.5, pan=0, out=0,
  atk=0.002, sus=0, rel=0.2, atkcrv=1, relcrv=(-10);
  var sig, env;
  env = EnvGen.ar(
    Env.new([0, 1, 1, 0], [atk, sus, rel], [atkcrv, 0, relcrv]),
    doneAction:2
  );
  sig = SinOsc.ar(freq);
  sig = sig * env;
  sig = Pan2.ar(sig, pan, amp);
  Out.ar(out, sig);
}).add;
)

Synth(\blip, [\freq, 200, \rel, 3, \amp, 0.3]);

// patterns and streams

(
p = Pseq([1, 9, 17], 2);
q = p.asStream;
)

q.next;
q.reset;
q.nextN(10);

// events

(
~box = (
  height: 18,
  width: 10.5,
  depth: 4
);
)

~box.at(\width);

~box.play;

(
~box = (
  height: 18,
  width: 10.5,
  depth: 4,
  play: { postln(\height.envirGet * \width.envirGet * \depth.envirGet) }
);
)

~box.play;

// --- 1. Pbind --- //
// generates Events

// a Routine
(
p = Pbind(
  \freq, Pseq([300, 500, 700], inf),
  \amp, Prand([0.1, 0.2], inf),
);
q = p.asStream;
)

q.next(Event.new);
q.nextN(10, Event.new);

// an EventStreamPlayer

(
p = Pbind(
  \freq, Pseq([300, 500, 700], inf),
  \amp, Prand([0.1, 0.2], inf),
);
q = p.play;
)

q.pause;
q.resume;
q.stop;

// using our own SynthDef
// 'dur' is in beat technically 1 -> a quarter note
// when using our own SynthDef, the keys should correspond with the 
// arguments that we declare
// arg are instances of UGens colled 'control'

(
p = Pbind(
  \instrument, \blip,
  \dur, Pseq([0.15, 0.3], inf),
  \freq, Pseq([300, 500, 700], inf),
  \rel, 2,
  \amp, Prand([0.1, 0.2], inf),
);
q = p.play;
)

// we have more choices than \freq to choose 'notes'
// we can think in term of midi note, transpose in semitones, harmonics, scales, etc

(
p = Pbind(
  \instrument, \blip,
  \dur, 0.3,
  \midinote, Pseq([60, 72], inf),
  \ctranspose, Pseq([0, 0, 1, 1, 2, 2], inf),
  \harmonic, Pseq((1!6) ++ (3!6), inf),
  \amp, 0.2,
);
q = p.play;
)

// we can use 'trace' to print events to the console

(
p = Pbind(
  \instrument, \blip,
  \dur, 0.3,
  \note, Pseq([0, 2, 4, 6], inf),
  \gtranspose, 12,
  \root, 2,
  \amp, 0.2,
).trace;
q = p.play;
)

// using scales and degrees
// degree just indexes through scale

(
p = Pbind(
  \instrument, \blip,
  \dur, 0.3,
  \degree, Pseq([0, 2, 1, 3, 2, 4], inf),
  \scale, #[0, 2, 4, 5, 7, 9, 11],
  \amp, 0.2,
);
q = p.play;
)

// --- 2. Env and Gate --- //

(
SynthDef.new(\blip, {
  arg freq=300, gate=1, amp=0.5, pan=0, out=0,
  atk=0.002, sus=0, rel=0.2, atkcrv=1, relcrv=(-10);
  var sig, env;
  env = EnvGen.ar(
    Env.adsr,
    gate,
    doneAction:2
  );
  sig = SinOsc.ar(freq);
  sig = sig * env;
  sig = Pan2.ar(sig, pan, amp);
  Out.ar(out, sig);
}).add;
)

x = Synth(\blip, [\freq, 200, \rel, 3, \amp, 0.2]);
x.set(\gate, 0);

// when we play a Pbind, creating an EventStreamPlayer, and the synths 
// that are created are gated, the EventStreamPlayer will handle setting gate to 0
// BUT it only works if we add an arg called 'gate' and it's being used
// to hold the Env open !

(
p = Pbind(
  \instrument, \blip,
  \dur, Pseq([0.15, 0.3], inf),
  \freq, Pseq([300, 500, 700], inf),
  \amp, Pseq([0.02, 0.03], inf),
  \sustain, 2,
);
q = p.play;
)

q.stop;
s.freeAll;

// --- 3. TempoClock --- //

(
SynthDef.new(\blip, {
  arg freq=300, amp=0.5, pan=0, out=0, atk=0.002, rel=0.2;
  var sig, env;
  env = EnvGen.ar(
    Env.perc(atk, rel),
    doneAction:2
  );
  sig = SinOsc.ar(freq);
  sig = sig * env;
  sig = Pan2.ar(sig, pan, amp);
  Out.ar(out, sig);
}).add;
)

x = Synth(\blip, [\freq, 200, \rel, 0.3, \amp, 0.2]);

// p is the pattern, q is the execution of that pattern
// the shortest pattern drives the whole pattern
// when we play a pattern, it is implicitly schedulded on a tempo clock.
// if not specified otherwise, it default to : TempoClock.default;
// this is a value in beats/seconds -> 60 beats/minute

TempoClock.default;
TempoClock.default.beats;
TempoClock.default.tempo;

(
p = Pbind(
  \instrument, \blip,
  \dur, Pseq([0.2], 10),
  \freq, Pseq([300, 500, 700], 2),
  \amp, Prand([0.02, 0.05], inf),
);
q = p.play;
)

// create a new tempo -> divide by 60 to think in term of beat/minutes
t = TempoClock.new(90/60).permanent_(true); // 90bpm -> 1.5bps
t.beats;

// provide the new tempo -> quarter notes at 90bpm

(
p = Pbind(
  \instrument, \blip,
  \dur, Pseq([1], inf),
  \freq, Pseq([300, 500, 700], inf),
  \amp, Prand([0.02, 0.05], inf),
);
q = p.play(t);
)

// change the tempo while it's running
t.tempo_(120/60);

// --- 4. Sync Two Patterns --- //
// we use quantizing to sync patterns together

t.stop;
q.stop;

t = TempoClock.new(130/60).permanent_(true);

// pattern_01
(
~p1 = Pbind(
  \instrument, \blip,
  \dur, Pseq([0.5], inf), // eighth note
  \note, Pseq([0, 7, 10, 3, 5, 7, 5, 3], inf),
  \amp, 0.2,
  \rel, 0.08,
  \pan, Pseq([-1, 1], inf),
);
~q1 = ~p1.play(t, quant:4);
)
// pattern_02
(
~p2 = Pbind(
  \instrument, \blip,
  \dur, Pseq([1/4], inf),
  \note, Pseq([10, 3, 5, 7], inf),
  \gtranspose, 17,
  \amp, 0.2,
  \rel, 0.08,
  \pan, Pseq([1, -1], inf), // reversed panning
);
~q2 = ~p2.play(t, quant:4);
)

~q2.stop;
~q1.stop;
