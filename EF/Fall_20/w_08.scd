// register a keyboard macro using the following command: :qa vap C-c C-c q.
// the macro is stored in @a. Type @a to summon it.

s.options.numBuffers = 1024 * 64; // increase if you need to load more samples

s.boot;

s.quit;

s.makeWindow;

s.meter;

s.scope;

FreqScope.new;

s.plotTree;

// mul and add being a bit cumbersome, we use the method range(0, 1) instead

(
x = {
  var sig, freqs, amps;
  amps = Array.fill(16, { LFNoise1.kr(1).range(0, 1) });
  freqs = Array.exprand(16, 50, 1000).round(50);
  freqs = freqs * Array.rand(16, 0.99, 1.01); // chorus fx, detune slightly
  sig = Pulse.ar(freqs, mul:amps);
  sig = Splay.ar(sig);
  sig = sig * 0.15;
}.play;
)

x.free;

(
{
  [
    LFNoise1.ar(500, mul:1),
    LFNoise1.ar(500, mul:0.2),
    LFNoise1.ar(500, mul:5),
  ]
}.plot(0.05);
)

(
{
  [
    LFNoise1.ar(500, add:0),
    LFNoise1.ar(500, add:1),
    LFNoise1.ar(500, add:-2),
  ]
}.plot(0.05);
)
// ---

(
~oval_1 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/HBH/00033_HBH.wav");
~oval_2 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/HBH/00213_HBH.wav");
~oval_3 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/HBH/00094_HBH.wav");
)

~oval_1.bufnum;

(
x = {
  var sig;
  sig = PlayBuf.ar(
    2,
    ~oval_3.bufnum,
    BufRateScale.ir(~oval_3.bufnum),
    doneAction:2
  );
  sig = sig * 0.3!2;
}.play;
)

// --- Transition from function.play to synthDef
// make arguments and gives them sense with values

(
SynthDef.new(\pb, {
  arg buf=0, rate=1, t_trig=1, spos=0, loop=0, da=2, out=0, amp=0.5;
  var sig;
  sig = PlayBuf.ar(
    2, // 1.
    buf, 
    BufRateScale.ir(buf) * rate,
    t_trig,
    spos,
    loop,
    da
  );
  sig = sig * amp;
  Out.ar(out, sig);
}).add;
)

Synth.new(\pb, [\buf, ~oval_3, \rate, 0.60]);

// 1. we can't dynamically modulate the number of channels at runtime !
// we really should create two synthDef, one for stereo files, one for monos.

(
x = Synth.new(\pb, [
  \buf, ~oval_3, 
  \spos, ~oval_3.numFrames * 0.0, 
  \loop, 1,
  \rate, 0.5
]);
)

x.free;

(
x = 5.collect({
  arg n;
  Synth.new(\pb, [
    \buf, ~oval_3, 
    \spos, ~oval_3.numFrames * 0.0, 
    \loop, 1,
    \rate, ( n/10 ).midiratio,
    \amp, 0.2
  ]);
});
)

x.do({ arg n; n.free });

// use wait() if using a looping process !

(
r = Routine.new({
  loop{
    Synth.new(\pb, [
      \buf, [ ~oval_3, ~oval_2 ].choose, 
      \spos, 0, 
      \loop, 0,
      \da, 2,
      \rate, rrand(-12.0, 5.0).midiratio,
      \amp, 0.25
    ]);
    wait(1/3);
  }
}).play;
)

// will stop the routine, not the sound
r.stop;

// add an emplitude envelope

(
SynthDef.new(\pbenv, {
  arg buf=0, rate=1, t_trig=1, spos=0, loop=1, da=0, atk=0.01, sus=0.1, rel=0.01, out=0, amp=0.5;
  var sig, env;
  env = EnvGen.ar(
    Env.new(
      [ 0, 1, 1, 0 ],
      [ atk, sus, rel ],
      [ 0, 0, 0 ]
    ),
    doneAction:2
  );
  sig = PlayBuf.ar(
    2, // 1.
    buf, 
    BufRateScale.ir(buf) * rate,
    t_trig,
    spos,
    loop,
    da
  );
  sig = sig * env;
  sig = sig * amp;
  Out.ar(out, sig);
}).add;
)

(
x = Synth.new(\pbenv, [
  \buf, ~oval_3, 
  \spos, ~oval_3.numFrames * 0.0, 
]);
)

(
var semi = -24;
r = Routine.new({
  loop{
    Synth.new(\pbenv, [
      \buf, ~oval_3, 
      \spos, rrand( ~oval_3.numFrames * 0.2, ~oval_3.numFrames * 0.3 ), 
      \atk, 0.001, // 0.2
      \sus, 0,
      \rel, 0.08, // 0.2
      \rate, semi.midiratio,
      \amp, 0.2
    ]);
    semi = semi + 1;
    if (
      semi > 0,
      { semi = rrand( -12, -2 ) }
    );
    wait([ 0.4, 0.2, 0.1 ].choose);
    // wait(rrand(0.05, 0.3));
  }
}).play;
)

r.stop;

// TGrains

(
{
  var sig;
  sig = TGrains.ar(
    2,
    Impulse.ar(60),
    ~oval_3.bufnum,
    BufRateScale.ir(~oval_3) * MouseX.kr(-12, 12, 0).midiratio,
    MouseY.kr(0, ~oval_3.duration, 0),
    0.08,
    0,
    0.8,
    4,
  );
}.play;
)

// ---
