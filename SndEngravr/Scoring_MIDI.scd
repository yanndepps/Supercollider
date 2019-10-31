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
	\chan, 2,
	\midinote, 59,
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
	\chan, 1,
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

(
Pbindef(\myHarmony,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, Pseq([
		Pseq([
			[0,3,7]+51,
			[0,3,7]+51,
			[0,5,9]+51,
			[0,3,10]+51,
		], 2),
        Pseq([
            [3,7,10]+51,
            [3,7,10]+51,
            [5,9,12]+51,
            [5,9,12]+51,
        ], inf),
	], inf),
    \dur, Pseq([
        Pseq([Rest(1)], 32), // 32 beats of silence
        Pseq([4], 8), // chords ar 4 beats in length, iterated 8 times
        Pseq([4], 8),
    ], inf),
    \amp, 1,
    \atk, 0.01,
    \rel, 1
).play(t);
)


Pbindef(\myHarmony).stop;
Pbindef(\myHarmony).play;


t.schedAbs(t.nextBar, {t.tempo_(120/60);nil});
t.stop;


//////// Score ////////
(
Pbindef(\myKick,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 2,
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
	\chan, 3,
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
	\chan, 2,
	\midinote, 49, // 49
	\dur, Pseq([
		Pseq([Rest(4)],8),
		Pseq([Rest(0.5),0.5],64),
	],inf),
	\amp, 0.5,
	\atk, 0.01,
	\rel, 1
).play(t);

Pbindef(\myBass,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 1,
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

Pbindef(\myHarmony,
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, Pseq([
		Pseq([
			[0,3,7]+51,
			[0,3,7]+51,
			[0,5,9]+51,
			[0,3,10]+51,
		], 2),
        Pseq([
            [3,7,10]+51,
            [3,7,10]+51,
            [5,9,12]+51,
            [5,9,12]+51,
        ], inf),
	], inf),
    \dur, Pseq([
        Pseq([Rest(1)], 32), 
        Pseq([4], 8), 
        Pseq([4], 8),
    ], inf),
    \amp, 1,
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

Pbindef(\myHarmony).stop;
Pbindef(\myHarmony).play;

Pbindef(\myBass).stop;
Pbindef(\myBass).play;

t.stop;

//////// End ////////
