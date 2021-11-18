// recoded live stream from mads kjeldgaard
// LiveCoding using Ndefs
// 25.25

s.boot;

// slot 0 -> synth
(
Ndef(\q3, {
  |freq=444, pan=0|
  var sig = LFTri.ar(freq) * 0.5;
  sig = Pan2.ar(sig, pan);
  sig = sig * 0.45;
}).play;
)

// cross fade
Ndef(\q3).fadeTime = 2;

// abruptly change the frequency
Ndef(\q3).set(\freq, rrand(80, 500));

// less abrupt change
Ndef(\q3).xset(\freq, rrand(80, 440), \pan, rrand(-0.5, 0.5));

// slot 1 -> fx : index 0 is the source
// FreqShift

// (
// Ndef(\q3)[1] = \filter -> { 
//   |in, shiftAmt=1|
//   FreqShift.ar(in, shiftAmt)
// }
// )

// PitchShift
(
Ndef(\q3)[1] = \filter -> {
  |in, pitchy=0.5, pitchDisp=0.1, timeDisp=0.1|
  PitchShift.ar(in, 0.25, pitchy, pitchDisp, timeDisp);
}
)

// also apply wet amount to slot 1
Ndef(\q3).xset(\wet1, 0.5);

// get and use a GUI
Ndef(\q3).gui;

// change the range of the pitch from min value to max value
// add to the global dictionary of specifications
Spec.specs[\freq]; // default spec for the freq param

Spec.add(\pitchy, [0.25, 10.0, \lin, 0.0, 0.5, "piii"]);

Spec.specs[\pitchy];

// also one can add to local dictionary using addSpec( ... ) ( part of JitLib )
// Ndef(\q3).addSpec( ... )

// make a copy of our Ndef
Ndef(\q3).play
Ndef(\q3).copy(\q4);

// add changes to our new Ndef
Ndef(\q4).xset(\freq, rrand(250, 500), \pan, rrand(-1.0, 1.0)).play;
Ndef(\q3).xset(\freq, 80, \wet1, 0.9);

// add a control pattern to the very bottom of our signal chain
// use the pattern to control whatever parameters come before
// here : randomly change freq value every 4 beats
// we can use both \pset and \xset, the later will fade in and out

Ndef(\q3).fadeTime = 10;

(
Ndef(\q3)[999] = \pset -> Pbind(
  \dur, Pseq([4, 7, 5, 8]), 
  \freq, Pwhite(100, 500),
  \timeDisp, 0.0,
  \pitchDisp, 0.0,
  \pitchy, Prand([0.5, 2.5, 1.0, 0.75], inf),
  \pan, Pwhite(-1.0, 1.0),
);
)

// add LFOs and Mappings
Ndef(\q4).play;

Ndef(\squank, { |lfofreq=0.1| LFSaw.kr(lfofreq) });

// nodeproxy role : add a pattern to the first LFO
Ndef(\squank)[999] = \xset -> Pbind(\dur, Pwhite(1.0, 8.0), \lfofreq, Pwhite(0.01, 10));

// add a second LFO
Ndef(\squank2, { |lfofreq=5.0| LFSaw.kr(lfofreq).linlin(-1.0, 1.0, 40, 2500) });

// map the first LFO to the second one
Ndef(\squank2).map(\lfofreq, Ndef(\squank));

// add a third LFO
Ndef(\squank).copy(\squankTheThird);

// patch the LFO
Ndef(\q4).map(\pitchy, Ndef(\squank), \freq, Ndef(\squank2));
Ndef(\q4).xset(\wet1, 0.85);

// map our 3rd LFO
Ndef(\q4).xmap(\pan, Ndef(\squankTheThird));
