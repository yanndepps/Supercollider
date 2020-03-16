// livecoding using Ndefs

s.boot;

(
    Ndef(\q3, {|freq=444, pan=0|
	var sig = LFTri.ar(freq);
	sig = Pan2.ar(sig, pan);
	sig * 0.45
    }).play;
)

// abrupt changes
Ndef(\q3).set(\freq, rrand(80, 440));

// less abrupt
Ndef(\q3).xset(\freq, rrand(40, 440), \pan, rrand(-1.0, 1.0));

Ndef(\q3).fadeTime = 2;

// add an fx
(
Ndef(\q3)[1] = \filter -> {|in, pitch=0.5, pitchdispersion=0.1, timedispertion=0.1|
	PitchShift.ar(in, 0.25, pitch, pitchdispersion, timedispertion);
}
)

// see nodeproxy roles
Ndef(\q3).xset(\wet1, 0.5);

Ndef(\q3).gui;

Ndef(\q3).play
Ndef(\q3).copy(\q4)
Ndef(\q4).xset(\freq, rrand(40, 220, \pan, rrand(-1.0, 1.0))).play;
Ndef(\q3).xset(\freq, 80, \wet1, 0.9, \pan, 0.0).play

(
Ndef(\q3)[999] = \xset -> Pbind(
	\dur, 4,
	\freq, Pwhite(80, 220)
)
)