// continuous
// paused at 15.23
(
~stream = Pwhite(50, 70, 5).asStream;
)

(
~stream.next.debug("next value");
)

(
~pattern = Pwhite(50, 70, 5);
~pattern.asStream.all.debug("all values");
)

// pwhite generates numbers, pbind generates events
(
~eventpattern = Pbind(
	\instrument, \default,
	\midinote, Pwhite(50, 70, 5),
	\dur, 0.1,
);
)

(
~eventpattern.asStream.next(());
)

(
~eventpattern.play;
)


(
var white = Pwhite(50, 70, 20).asStream;
var values = white.all.debug("white");
values.plot;
Pbind(
	\instrument, \default,
	\midinote, Pseq(values, 1),
	\dur, 0.3).play;
)

(
var brown = Pbrown(50, 70, 1, 20).asStream;
var values = brown.all;
values.plot;
Pbind(
	\instrument, \default,
	\midinote, Pseq(values, 1),
	\dur, 0.3).play;
)

(
var pg = Pgbrown(50, 70, 0.1, 20).asStream;
var values = pg.all;
values.plot;
Pbind(
	\instrument, \default,
	\midinote, Pseq(values.round(1), 1),
	\dur, 0.3).trace.play;
)

// discrete
(
Prand([0.5, 0.25, 0.125], 10).asStream.all.debug("Prand");
)
(
Pxrand([0.5, 0.25, 0.125], 10).asStream.all.debug("Pxrand");
)
(
Pwrand([0.5, 0.25, 0.125], [0.5, 1, 2].normalizeSum, 10).asStream.all.debug("Pwrand");
)


// other useful patterns
(
// Pn repeats other patterns
Pbrown(20, 50, 1, 200).asStream.all.plot;
Pn(Pbrown(20, 50, 1, 20), 10).asStream.all.plot;

// Pseq sequences values or patterns
Pseq([Pwhite(10, 30, 30), Pbrown(40, 60, 1, 30)],2).asStream.all.plot;

Pseq([1,2,7], 3).asStream.all.debug("pseq");

)

///////////////////////////////////////////////////////////////////
MIDIClient.sources

(
if (MIDIClient.initialized.not) { MIDIClient.init; };
~midiout = MIDIOut.newByName("Gestionnaire IAC", "Tidal1");
)

(
~midiout.noteOn(0, 65, 80);
)

(
~midiout.noteOff(0, 65);
)

















(
var randompiano;

randompiano = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 0,
	\midinote, Pwhite(20,100,inf).trace(prefix:"pwhite: "),
	\dur, Pwhite(0.1, 0.4, inf),
	\amp, Pwhite(0.1, 0.9, inf),
);

//~player = randompiano.play;
//~player = Ppar([randompiano, randompiano]).play;
~player = Ppar([randompiano, randompiano, randompiano]).play;

CmdPeriod.doOnce({
	16.do({
		| value |
		~midiout.allNotesOff(value);
	});
});
)


(
var slowpiano = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 0,
	\midinote, Prand([
		Pwhite(20, 30, 2),
		Pwhite(30, 60, 3),
		Pwhite(80, 95, 4),
		Rest(1),
		Pfunc{ 0.7.coin.if { var note = 50.rrand(60); [note, note+12] } { nil }; }
	], inf),
	\dur, Prand([1.0, 0.5, 0.25, 0.125], inf),
	\amp, Pbrown(0.4, 0.9, 0.05, inf),
);

~player = slowpiano.play;

CmdPeriod.doOnce({
	16.do({
		| value |
		~midiout.allNotesOff(value);
	});
});

)

(
var slowpiano = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 0,
	\midinote, Prand([
		Pwhite(20, 30, 2),
		Pwhite(30, 60, 3),
		Pwhite(80, 95, 4),
		Rest(1),
		Pfunc{ 0.7.coin.if { var note = 50.rrand(60); [note, note+12] } { nil }; }
	], inf),
	\dur, Prand([1.0, 0.5, 0.25, 0.125], inf),
	\amp, Pbrown(0.4, 0.9, 0.05, inf),
);

var fastpiano = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 0,
	\midinote, Pn(
		Prand([
			Pbrown(20, 80, 4.rrand(1), 30.rrand(10)),
			Pseq([Rest(1)], 1)], 1), inf),
	\dur, Prand([0.25, 0.125], inf),
	\amp, Pbrown(0.4, 0.9, 0.05, inf),
	\legato, Pn(Pbrown(0.2, 1.0, 0.05, 20), inf)
);

//~player = slowpiano.play;
//~player = Ppar([slowpiano, fastpiano]).play;
~player = Ptpar([0, slowpiano, 10, fastpiano]).play;

CmdPeriod.doOnce({
	16.do({
		| value |
		~midiout.allNotesOff(value);
	});
});

)




(
var slowpiano = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 0,
	\midinote, Prand([
		Pwhite(20, 30, 2),
		Pwhite(30, 60, 3),
		Pwhite(80, 95, 4),
		Rest(1),
		Pfunc{ 0.7.coin.if { var note = 50.rrand(60); [note, note+12] } { nil }; }
	], inf),
	\dur, Prand([1.0, 0.5, 0.25, 0.125], inf),
	\amp, Pbrown(0.4, 0.9, 0.05, inf),
);

var fastpiano = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 0,
	\midinote, Pn(
		Prand([
			Pbrown(20, 80, 4.rrand(1), 30.rrand(10)),
			Pseq([Rest(1)], 1)], 1), inf),
	\dur, Prand([0.25, 0.125], inf),
	\amp, Pbrown(0.4, 0.9, 0.05, inf),
	\legato, Pn(Pbrown(0.2, 1.0, 0.05, 20), inf)
);

var strings = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 1,
	\midinote, Pn(Pgbrown(60, 75, 0.3, 3.rrand(6)), inf),
	\dur, Pseq([
		Pseq([0.25, 0.5, 0.25], 2),
		Pwrand([1, 0.5, 2, 4], [1,1,1,0.2].normalizeSum, 4.rrand(1))], inf),
	\amp, Pn(Pbrown(0.5, 0.8, 0.05, 5), inf)
);

var brass = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 2,
	\midinote, Pbrown(60, 80, 5, inf),
	\dur, Prand([0.25, 0.125, 2], inf),
	\amp, Pn(Pbrown(0.6, 0.9, 0.05, 7), inf)
);

var percussion = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 9,
	\midinote, Pwhite(32, 60, inf),
	\dur, Pwrand([
		Pseq(0.125!8),
		Pseq(0.125!4 ++ [0.5]),
		Pseq([0.5] ++ (0.25!2))],
	[1, 3, 10].normalizeSum, inf),
	\amp, Pwhite(0.7, 0.9, inf)
);

~player = Ptpar([0, slowpiano, 10, fastpiano, 30, strings, 40, brass, 40, percussion]).play;

CmdPeriod.doOnce({
	16.do({
		| value |
		~midiout.allNotesOff(value);
	});
});

)

///////////////////////////////////////////////////////////////////////////////////////////

(
var slowpiano, fastpiano, strings, brass, percussion, gong, bpm, tempoclock, newtempo, timeline;

if (MIDIClient.initialized.not) { MIDIClient.init; };
~midiout = MIDIOut.newByName("INTEGRA-7", "INTEGRA-7 MIDI 1");
slowpiano = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 0,
	\midinote, Prand([
		Pwhite(20, 30, 2),
		Pwhite(30, 60, 3),
		Pwhite(80, 95, 4),
		Rest(1),
		Pfunc{ 0.7.coin.if { var note = 50.rrand(60); [note, note+12] } { nil }; }
	], inf),
	\dur, Prand([1.0, 0.5, 0.25, 0.125], inf),
	\amp, Pbrown(0.4, 0.9, 0.05, inf),
);

fastpiano = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 0,
	\midinote, Pn(
		Prand([
			Pbrown(20, 80, 4.rrand(1), 30.rrand(10)),
			Pseq([Rest(1)], 1)], 1), inf),
	\dur, Prand([0.25, 0.125], inf),
	\amp, Pbrown(0.4, 0.9, 0.05, inf),
	\legato, Pn(Pbrown(0.2, 1.0, 0.05, 20), inf)
);

strings = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 1,
	\midinote, Pn(Pgbrown(60, 75, 0.3, 3.rrand(6)), inf),
	\dur, Pseq([
		Pseq([0.25, 0.5, 0.25], 2),
		Pwrand([1, 0.5, 2, 4], [1,1,1,0.2].normalizeSum, 4.rrand(1))], inf),
	\amp, Pn(Pbrown(0.5, 0.8, 0.05, 5), inf)
);

brass = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 2,
	\midinote, Pbrown(60, 80, 5, inf),
	\dur, Prand([0.25, 0.125, 2], inf),
	\amp, Pn(Pbrown(0.6, 0.9, 0.05, 7), inf)
);

percussion = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 9,
	\midinote, Pwhite(32, 60, inf),
	\dur, Pwrand([
		Pseq(0.125!8),
		Pseq(0.125!4 ++ [0.5]),
		Pseq([0.5] ++ (0.25!2))],
	[1, 3, 10].normalizeSum, inf),
	\amp, Pwhite(0.7, 0.9, inf)
);

gong = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiout,
	\chan, 9,
	\midinote, Pseq([57], inf),
	\dur, Pseq([1], inf),
	\amp, 1.0
);

bpm = 60;
tempoclock = TempoClock(bpm/60.0);
newtempo = {
	| tempo |
	Pbind(
		\type, \set,
		\dur, 0.1,
		\mykey, Pfunc{ tempoclock.tempo = tempo; ("Set new tempo"+tempo).postln; }
	);
};

timeline = ScTimeline();
timeline.schedBeat(0, 60, slowpiano, "piano slow", Color.red);
timeline.schedBeat(90, 182, slowpiano, "piano slow", Color.red);
timeline.schedBeat(20, 182, fastpiano, "piano fast" , Color.red);
timeline.schedBeat(60, 140, strings, "strings", Color.blue);
timeline.schedBeat(90, 182, brass, "brass 1", Color.yellow.darken(0.7));
timeline.schedBeat(130, 182, brass, "brass 2", Color.yellow.darken(0.5));
timeline.schedBeat(160, 182, brass, "brass 3", Color.yellow.darken(0.3));
timeline.schedBeat(90, 182, percussion, "percussion", Color.gray);
timeline.schedBeatNumber(176, 1, newtempo.(tempoclock.tempo * 0.9), "tempo", Color.black);
timeline.schedBeatNumber(177, 1, newtempo.(tempoclock.tempo * 0.8), "tempo", Color.black);
timeline.schedBeatNumber(178, 1, newtempo.(tempoclock.tempo * 0.7), "tempo", Color.black);
timeline.schedBeatNumber(179, 1, newtempo.(tempoclock.tempo * 0.7), "tempo", Color.black);
timeline.schedBeatNumber(180, 1, newtempo.(tempoclock.tempo * 0.6), "tempo", Color.black);
timeline.schedBeatNumber(181, 1, newtempo.(tempoclock.tempo * 0.5), "tempo", Color.black);
timeline.schedBeatNumber(182, 1, newtempo.(tempoclock.tempo * 0.5), "tempo", Color.black);
timeline.schedBeatNumber(183, 1, gong, "gong", Color.magenta);
timeline.plot;
timeline.play(tempoclock);

CmdPeriod.doOnce({
	16.do({
		| value |
		~midiout.allNotesOff(value);
	});
});

)
