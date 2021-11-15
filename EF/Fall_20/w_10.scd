// week 10
// Patterns, Stream and Events -> part 01

s.boot;

// start

(
SynthDef.new(\blip, {
  arg freq=300, amp=0.4, pan=0, out=0;
  var sig, env;
  env = EnvGen.ar(Env.perc(0.002, 0.2), doneAction:2);
  sig = SinOsc.ar(freq);
  sig = sig * env;
  sig = Pan2.ar(sig, pan, amp);
  Out.ar(out, sig);
}).add;
)

Synth(\blip);

// 1. Routine
// a convenient way of building a function that can be played
(
r = Routine.new({
  "hi".postln;
  1.wait;
  "hello".postln;
  2.wait;
  "bye".postln;
});
)

r.play;

// a non real-time version of playing this Routine
r.next;

// examples
(
r = Routine.new({
  Synth(\blip, [\freq, 200]);
  0.3.wait;
  Synth(\blip, [\freq, 300]);
  0.6.wait;
  Synth(\blip, [\freq, 400]);
});
)

r.play;
r.reset;

(
r = Routine.new({
  200.wait;
  300.wait;
  400.wait
});
)

Synth(\blip, [\freq, r.next]);

r.reset;

// are wait and yield the same ?
(
r = Routine.new({
  200.yield;
  300.yield;
  400.yield
});
)

// give next number
(
r = Routine.new({
  var i = 0;
  loop {
    i.yield;
    i = i + 1;
  }
});
)

r.next;
r.reset;
// return x number of values
r.nextN(10);
r.nextN(50);

// return all values in one dice

(
r = Routine.new({
  var i = 0;
  50.do {
    i.yield;
    i = i + 1;
  }
});
)

r.all;

// Pseries output an arithmethic serie
// Pseries( start, step, length )
p = Pseries(0, 1, inf);
// convert pattern to a stream
q = p.asStream;
q.next;

// 2. Patterns are like blueprints for a sequence of some kind.
// stream is the actual state oriented execution.
// patterns are stateless.
// multiple stream derived from the same pattern
r = p.asStream;

q.nextN(8);
r.next;

// Pseq takes an array of things and a number of repeat
p = Pseq([1, 14, 200, 97], inf).asStream;
p.nextN(10);

// Prand chooses randomly
p = Prand([1, 14, 200, 97], inf).asStream;
p.nextN(10);

// Pxrand guarantee you never get the same item twice in a row
p = Pxrand([1, 14, 200, 97], inf).asStream;
p.nextN(10);

// Pshuf chooses a random order from an array, and repeat it over and over again
p = Pshuf([1, 14, 200, 97], inf).asStream;
p.nextN(10);

// we can nest patterns
p = Pseq([1, 2, 3, Prand([100, 200, 300], 1)], inf).asStream;
p.nextN(20);

// doing math with patterns
p = ( Pseq([1, 2, 3], inf) * Pseq([100, 200], inf) ).asStream;
p.nextN(20);

// Brownian
// press 'm' on a plot to change its render
{BrownNoise.ar}.plot(0.002);

// Pfunc -> define your own functions
p = Pfunc({sin(rrand(10, 20).sqrt + 4)}).asStream;
p.nextN(20);

// 3. Pbind
// Event is a type of collection -> Object used to store information
//

(
p = Pbind(
  \instrument, \blip,
  \dur, 0.2,
  \freq, Pseq([200, 300, 400], inf),
);
)

x = p.play;
x.play;
x.pause;
x.resume;
x.step;
x.reset;

// fill an Event with informations
// Event are not ordered collections the way Arrays are
// items are organized by key -> value
// an Event is a collection of key/value pair.

e = Event.new;
e.add(\foo -> 5);
e.add(\bar -> 12);
e.add(\more_stuff -> 101);
// retreive info
e.at(\foo);

// another way of declaring and populating an Event
e = (foo: 5, bar: 12, more_stuff: 101);

e.at(\foo);
e[\foo];
// we can treat the keys in the Event as methods
e.foo;

// make a 'sandwich' prototype Event
~sw = ();
~sw.add(\bread -> "wheat");
~sw.add(\toasted -> true);
~sw.add(\mayo -> false);

~sw.mayo;

// action to be taken in response to a play message
// all events are expected to have a 'play' key, which is a function
(
~whoami = (
  name: 'yann',
  play: {("my name is " ++ \name.envirGet).postln}
);
)

~whoami.play;

// a default Event contains a huge amount of keys pre-defined
().play;

// --- END --- //
