// sc mini 04 : Patterns vs Streams 

s.boot;

MIDIClient.init;

~midiOut = MIDIOut.newByName("Midi Through", "Midi Through Port-0");

~midiOut.latency = 0;

a = Pbind(\degree, Prand([1, 2, 3, [0, 5]], inf), \bend, Pwhite(0, 76, inf));

// chain a midi event into the pattern and play it (see Pchain)

(a <> (type: \midi, midiout: ~midiOut)).play;

(
// use a stream derived from a pattern to control the number of repeats
~reps = Pseries(1, 1, inf).asStream;

p = Pbind(
  \midinote, Pseq([
    Pxrand([51, 53, 55, 58], ~reps),
    Pxrand([72, 75, 77, 79], 4)
  ], inf),
  \sustain, 0.8,
  \dur, 0.15,
  \amp, 0.5,
);

// q = p.play;
)

(p <> (type: \midi, midiout: ~midiOut)).play;

q.stop;
~reps.reset;

// a pattern defines a sequence, but it is not the sequence itself.
// instead, a pattern is a recipe or a blueprint for that sequence.
// a stream is a tangible execution of some pattern.
// we can convert a pattern to a stream using asStream ( a Routine is a type of stream technically ).

x = Pseries(1, 1, inf).asStream;
x.next;
x.value;

// note : the event stream 'q' is independant from the 'p' series stream '~reps'.
// to stop or even reset the event stream 'q' will not reset '~reps'.
// the internal stream will need its own reset message : '~reps.reset' or start over.
