// a simple fm synth with a percussive env, to work through the Tidal Patterning tutorials

(
SynthDef(\simplefm, {
  arg out, sustain, pan=0.5, note=60, pitchval=1, pitchenv=0.01, detune=1, gain, fmfreq=1, fmamt=1;
  var env, freq, sig, glide, fm;
  env = EnvGen.ar(Env.perc(0.001, sustain, gain), doneAction:2);
  glide = XLine.kr(pitchval, 1, pitchenv);
  freq = note.midicps * detune * glide;
  fm = SinOsc.ar(freq * fmfreq, 0, fmamt);
  sig = LeakDC.ar(SinOsc.ar(freq*fm, 0, env));
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan));
}).add;
)
