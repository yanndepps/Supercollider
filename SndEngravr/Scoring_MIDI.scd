//////// MIDI Setup ////////

MIDIClient.init;

MIDIIn.connectAll;

m = MIDIOut.new(0);
MIDIClient.destinations;


m.noteOn(0,53,64); // channel, note, velocity
m.noteOff(0,53);

m.latency = 0;

(
CmdPeriod.add({
	(0..127).do({
		arg n;
		m.noteOff(0,n);
	});
});
)

(
t = TempoClock(128/60).permanent_(true);
t.schedAbs(t.nextBar, {t.beats.postln;1});
)

t.schedAbs(t.nextBar, {t.tempo_(80/60);nil});
t.stop;

//////// Score Parts ////////

(
Pbindef(\myKick,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, 53,
	\dur, Pseq([
		Pseq([1,1,1,1],3),
		//Pseq([1,Rest(1),0.5,Rest(1),0.25,0.25],1),
	], inf),
	\amp, Pslide([0.5,0.15,0.25,0.35],inf,4,1),
	\atk, 0.001,
	\rel, 0.01
).play(t);
)

Pbindef(\myKick).stop;
Pbindef(\myKick).play;

(
Pbindef(\myRide,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, 51,
	\dur, Pseq([
		Pseq([Rest(1),1,Rest(1),1],3),
		Pseq([Rest(1), 0.25, 0.5, Rest(0.25), 0.5, Rest(1), 0.5],1),
	],inf),
	\amp, 0.75,
	\atk, 0.01,
	\rel, 1
).play(t);
)

Pbindef(\myRide).stop;
Pbindef(\myRide).play;

(
Pbindef(\myPerc,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, 49,
	\dur, Pseq([Rest(0.5), 0.5],inf),
	\amp, 0.5,
	\atk, 0.01,
	\rel, 1
).play(t);
)

Pbindef(\myPerc).stop;
Pbindef(\myPerc).play;

(
Pbindef(\myBass,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, Pseq([
		Pseq([0,\,0,0,\,0,\,0,0,\,0,\,0,\]+39,2),
		Pseq([0,\,0,0,\,0,\,0,0,\,0,\,0,\]+42,1),
		Pseq([0,\,0,0,\,0,\,0,0,\,0,\,0,\]+44,1),
	],inf),
	\dur, Pseq([
		Pseq([0.25, Rest(0.5), 0.25, 0.25, Rest(0.25), 0.25, Rest(0.5), 0.25, 0.25, Rest(0.25), 0.25, Rest(0.25), 0.25, Rest(0.25)], 2),
		Pseq([0.25, Rest(0.5), 0.25, 0.25, Rest(0.25), 0.25, Rest(0.5), 0.25, 0.25, Rest(0.25), 0.25, Rest(0.25), 0.25, Rest(0.25)], 1),
		Pseq([0.25, Rest(0.5), 0.25, 0.25, Rest(0.25), 0.25, Rest(0.5), 0.25, 0.25, Rest(0.25), 0.25, Rest(0.25), 0.25, Rest(0.25)], 1),
	],inf),
    \amp, 0.5,
    \atk, 0.01,
    \rel, 1
).play(t);
)

Pbindef(\myBass).stop;
Pbindef(\myBass).play;

//////// Score ////////
(
Pbindef(\myKick,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, 53, // 53
	\dur, Pseq([
		Pseq([1,1,1,1],3),
		//Pseq([1,Rest(1),0.5,Rest(1),0.25,0.25],1),
	], inf),
	\amp, Pslide([0.5,0.15,0.25,0.35],inf,4,1),
	\atk, 0.001,
	\rel, 0.01
).play(t);

Pbindef(\myRide,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, 51, // 51
	\dur, Pseq([
		Pseq([Rest(1),1,Rest(1),1],3),
		Pseq([Rest(1), 0.25, 0.5, Rest(0.25), 0.5, Rest(1), 0.5],1),
	],inf),
	\amp, 0.75,
	\atk, 0.01,
	\rel, 1
).play(t);

Pbindef(\myPerc,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, 49, // 49
	\dur, Pseq([
		Pseq([Rest(4)],8),
		Pseq([Rest(0.5),0.5],64),
	],inf),
	\amp, 0.5,
	\atk, 0.01,
	\rel, 1
).play(t);
)

Pbindef(\myKick).stop;
Pbindef(\myKick).play;

Pbindef(\myRide).stop;
Pbindef(\myRide).play;

Pbindef(\myPerc).stop;
Pbindef(\myPerc).play;

t.stop;

//////// End ////////