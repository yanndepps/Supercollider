// Boilerplate for a basic midi setup
(
// boot the server
s.boot;
// start proxyspace
p = ProxySpace.push(s);
// start tempo clock
p.makeTempoClock;
// give proxyspace a tempo
p.clock.tempo = 2;
Task({
	3.wait;
	d = Dictionary.new;
	3.wait;
	MIDIClient.init;
	3.wait;
	"Setup Done".postln;
	5.wait;
	d[\m] = MIDIOut.newByName("Gestionnaire IAC", "Tidal1").latency_(0.2555);
	"Midi setup".postln;
}).start;
)

(
~midiPattern = Pbind(
	// specifies type of message sent
	\type, \midi,
	// specifies type of midi message
	\midicmd, \noteOn,
	// the midi out used
	\midiout, d[\m],
	// the midi channel
	\chan, 1,
	// the rest of the pattern
	\scale, Scale.minor,
	\degree, Pseq([0,12,8,5],inf),
	\octave, 3,
	\dur, Pwrand([0.25, Pn(0.5, 2)], [0.8, 0.2].normalizeSum, inf),
	// \dur, 0.5,
	\legato, 0.4
)
)
