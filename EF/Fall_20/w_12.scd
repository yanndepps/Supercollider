// week_12
// real time pattern controls & GUI
// 51.23

s.boot;

// --- 1. Start --- //

(
SynthDef.new(\blip, {
  |freq=300, amp=0.5, pan=0, out=0, atk=0.002, sus=0, rel=0.2, atkcrv=1, relcrv=(-10)|
  var sig, env;
  env = EnvGen.ar(
    Env.new([0, 1, 1, 0], [atk, sus, rel], [atkcrv, 0, relcrv]),
    doneAction:2
  );
  sig = SinOsc.ar(freq);
  sig = sig * env;
  sig = Pan2.ar(sig, pan, amp);
  Out.ar(out, sig);
}).add;
)

Synth(\blip, [\freq, 200, \rel, 3, \amp, 0.2]);

(
p = Pbind(
  \instrument, \blip,
  \dur, Pseq([1/8], inf),
  \note, Pseq([0, 3, 5, 10, 14], inf),
  \gtranspose, 0,
  \root, Pdefn(\blip_root, 0), 
  \amp, Pseq([0.8, Pgeom(0.3, 0.9, 7)]),
  \atk, 0,
  \sus, 0,
  \rel, Pexprand(0.2, 2, inf),
  \relcrv, -12,
  \pan, Pseq([0, 0.5, 0, -0.5], inf),
);
)

q = p.play;
q.stop;

// use Pdefn
Pdefn(\blip_root, 1);

// or wrap the whole sequence into à Pdef
// we can overwrite the pattern as it's playing

(
Pdef(\p,
  Pbind(
    \instrument, \blip,
    \dur, Pseq([1/8], inf),
    \note, Pseq([0, 3, 5, 10, 14], inf),
    \gtranspose, 0,
    \root, 0, 
    \amp, Pseq([0.8, Pgeom(0.3, 0.9, 7)]),
    \atk, 0,
    \sus, 0,
    \rel, Pexprand(0.2, 2, inf),
    \relcrv, -12,
    \pan, Pseq([0, 0.5, 0, -0.5], inf),
  );
);
)

Pdef(\p).play;
Pdef(\p).stop;

// Pbindef is a combination of Pdef and Pbind

(
Pbindef(\p,
  \instrument, \blip,
  \dur, Pseq([1/8], inf),
  \note, Pseq([0, 3, 5, 10], inf),
  \gtranspose, 0,
  \root, 0, 
  \amp, Pseq([0.8, Pgeom(0.3, 0.9, 7)]),
  \atk, 0,
  \sus, 0,
  \rel, Pexprand(0.2, 2, inf),
  \relcrv, -12,
  \pan, Pseq([0, 0.5, 0, -0.5], inf),
);
)

Pbindef(\p).play(quant:2);

// we quantize the Pbindef changes too
Pbindef(\p, \root, 1).quant_(2);

Pbindef(\p).stop;

// --- 2. GUI --- //
w = Window.new();
w.front;
// close is destructive
w.close;

// control the amp of our synth

(
SynthDef.new(\blip, {
  |freq=300, amp=0.5, pan=0, out=0, gate=1|
  var sig, env;
  env = EnvGen.ar(
    Env.asr,
    gate,
    doneAction:2
  );
  sig = SinOsc.ar(freq);
  sig = sig * env;
  sig = Pan2.ar(sig, pan, amp);
  Out.ar(out, sig);
}).add;
)

x = Synth.new(\blip, [\amp, 0.1]).register;
x.isPlaying;
x.free;

(
Window.closeAll;
w = Window.new("a window", Rect.new(50, 100, 300, 500))
.front
.alwaysOnTop_(true)
.background_(Color.new255(51, 168, 216, 255));

// slider
~sl = Slider.new(
  w,
  Rect(20, 20, 30, 150);
).action_({
  // get its actual value
  arg view;
  view.value.postln;
  // control amp value
  if (
    x.isPlaying,
    { x.set(\amp, view.value/4) }
  );
});

// button
~btn = Button.new(w, Rect(60, 20, 70, 30))
.states_([
  ["start"],
  ["stop"]
])
.action_({
  arg view;
  if (
    view.value == 1,
    { x = Synth.new(\blip, [\amp, ~sl.value/4]).register },
    { x.set(\gate, 0) },
  )
});
)

w.close;

// mvc -> model view control paradigm
