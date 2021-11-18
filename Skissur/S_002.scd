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
Ndef(\q3).xset(\freq, rrand(80, 440), \pan, rrand(-1.0, 1.0));

// slot 1 -> fx : index 0 is the source
(
Ndef(\q3)[1] = \filter -> { 
  |in, shiftAmt=1|
  FreqShift.ar(in, shiftAmt)
}
)

// also apply wet amount to slot 1
Ndef(\q3).xset(\shiftAmt, 200, \wet1, 0.65);
