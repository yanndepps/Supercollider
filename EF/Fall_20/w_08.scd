// register a keyboard macro using the following command: :qa vap C-c C-c q.
// the macro is stored in @a. Type @a to summon it.

"SC_JACK_DEFAULT_OUTPUTS".setenv("REAPER");

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
// mono
~snd_01 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/ESTU/h2ogmcy/Bell-Hard.wav");
// stereo
~snd_02 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/HBH/Subforsub/12345.wav");
~snd_03 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/HBH/Subforsub/1234.wav");
)

~snd_02.bufnum;

(
x = {
  var sig;
  sig = PlayBuf.ar(
    1,
    ~snd_01.bufnum,
    BufRateScale.ir(~snd_01.bufnum),
    0, 
    0,
    doneAction:2
  );
  sig = sig * 0.8!2;
}.play;
)

// --- Transition from function.play to synthDef
// make arguments and gives them sense with values

(
SynthDef.new(\pb, {
  arg buf=0, rate=1, t_trig=1, spos=0, loop=0, da=2, out=0, amp=0.5;
  var sig;
  sig = PlayBuf.ar(
    2, // a.
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

Synth.new(\pb, [\buf, ~snd_02]);

// a. we can't dynamically modulate the number of channels at runtime !
// we really should create two synthDef, one for stereo files, one for monos.
// mono

(
SynthDef.new(\pb1, {
  arg buf=0, rate=1, t_trig=1, spos=0, loop=0, da=2, out=0, amp=0.5;
  var sig;
  sig = PlayBuf.ar(
    1, // a.
    buf, 
    BufRateScale.ir(buf) * rate,
    t_trig,
    spos,
    loop,
    da
  );
  sig = sig * amp!2; // channel expansion because mono
  // sig = sig!2;
  Out.ar(out, sig);
}).add;
)

// stereo

(
SynthDef.new(\pb2, {
  arg buf=0, rate=1, t_trig=1, spos=0, loop=0, da=2, out=0, amp=0.5;
  var sig;
  sig = PlayBuf.ar(
    2, // a.
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

Synth.new(\pb1, [\buf, ~snd_01]);
Synth.new(\pb2, [\buf, ~snd_02]);

// ---
// loop, rate on and start position

(
x = Synth.new(\pb2, [
  \buf, ~snd_02, 
  \spos, ~snd_02.numFrames * 0.9, 
  \loop, 1,
  \rate, 0.5
]);
)

x.free;

// ---
// drift out of phase
// by a 10th of a semi tone

(
x = 5.collect({
  arg n;
  Synth.new(\pb2, [
    \buf, ~snd_02, 
    \spos, ~snd_02.numFrames * 0.0, 
    \loop, 1,
    \rate, ( n/10 ).midiratio,
    \amp, 0.2
  ]);
});
)

// even more resonance

(
x = 12.collect({
  arg n;
  Synth.new(\pb2, [
    \buf, ~snd_02, 
    \spos, ~snd_02.numFrames * 0.0, 
    \loop, 1,
    \rate, ( n/30 ).midiratio,
    \amp, 0.2
  ]);
});
)

x.do({ arg n; n.free });

// Routines are function that basically allow us to wait 
// whenever we are in a loop, we MUST wait !

(
r = Routine.new({
  loop{
    var buf;
    // buf = [~snd_01, ~snd_02, ~snd_03].choose;
    buf = [~snd_01, ~snd_02, ~snd_03].wchoose([0.45, 0.1, 0.45]);
    if(
      buf.numChannels == 2,
      { 
        Synth.new(\pb2, [
          \buf, buf, 
          \spos, 0, 
          \loop, 0,
          \da, 2,
          \rate, rrand(-12.0, 5.0).midiratio,
          \amp, 0.25
        ]);
      }
      {
        Synth.new(\pb1, [
          \buf, buf, 
          \spos, 0, 
          \loop, 0,
          \da, 2,
          \rate, rrand(-12.0, 5.0).midiratio,
          \amp, 0.25
        ]);
      }
    );
    wait(1/3);
  }
}).play;
)

// avoiding conditional but same as above
(
r = Routine.new({
  loop{
    var buf, def;
    buf = [~snd_01, ~snd_02, ~snd_03].wchoose([0.45, 0.1, 0.45]);
    def = ("pb" ++ (buf.numChannels.asString)).asSymbol;
    Synth.new(def, [
      \buf, buf, 
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
    2, 
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
  \buf, ~snd_02, 
  \spos, ~snd_02.numFrames * 0.0, 
]);
)

(
var semi = -24;
r = Routine.new({
  loop{
    Synth.new(\pbenv, [
      \buf, ~snd_02, 
      \spos, rrand( ~snd_02.numFrames * 0.2, ~snd_02.numFrames * 0.6 ), 
      \atk, 0.2, // 0.2
      \sus, 0,
      \rel, 0.2, // 0.2
      \rate, semi.midiratio,
      \amp, 0.2
    ]);
    // semi = semi + 1;
    // if (
    //   semi > 0,
    //   { semi = rrand( -12, -2 ) }
    // );
    // wait([ 0.4, 0.2, 0.1 ].choose);
    wait(rrand(0.05, 0.3));
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
    Impulse.ar(9),
    ~snd_03.bufnum,
    BufRateScale.ir(~snd_03) * MouseX.kr(-12, 12, 0).midiratio,
    MouseY.kr(0, ~snd_03.duration, 0),
    0.08,
    0,
    0.8,
    4,
  );
}.play;
)

// BufRd : phase can be any audio rate signal
{BufRd.ar(2, ~snd_03, SinOsc.ar(0.5 / ~snd_03.duration).range(0, ~snd_03.numFrames-1))}.play;

{BufRd.ar(2, ~snd_03, Line.ar(0, ~snd_03.numFrames - 1, ~snd_03.duration, doneAction:2))}.play;

{BufRd.ar(2, ~snd_02, XLine.ar(1, ~snd_02.numFrames - 1, ~snd_02.duration, doneAction:2))}.play;

{BufRd.ar(2, ~snd_03, Line.ar(~snd_03.numFrames - 1, 0, ~snd_03.duration, doneAction:2))}.play;

// ---
