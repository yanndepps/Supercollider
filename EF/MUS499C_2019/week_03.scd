// Week 03 : Audio Coding With SuperCollider
s.boot;
// Synth & SynthDef

(
   x = {
        arg freq = 80;
        var sig, freqCtrl;
        // scale up/down by a 1/4 of a semitone. make 8 noise generators.
        freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25, 0.25).midiratio;
        // do not multichannel expansion on an array. use Splay instead of !
        sig = VarSaw.ar(freqCtrl) * 0.2;
        // spread those frequencies accross stereo
        sig = Splay.ar(sig);
    }.play;
)

x.set(\freq, 120);
x.free;

// return a number which can be multiplied by a frequency to affect a change in semitone.
// 400 * 2.midiratio;

// SynthDef = description of a synth. Synth = execution of that synth. To remember :
// 1. give it a symbolic name : \name
// 2. explicitely specify what the ouput signal of the SynthDef is going to be : Out.ar(bus, channelArray)
// 3. add the SynthDef to the server : .add

// 01. describe a synth 
(
    SynthDef.new(\sawtone, {
        arg freq = 80, amp = 0.2;
        var sig, freqCtrl;
        freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25, 0.25).midiratio;
        sig = VarSaw.ar(freqCtrl) * amp;
        // now we sum the frequencies -> monophonic signal
        sig = Splay.ar(sig).sum;
        Out.ar(0, sig);
    }).add;
)
// 02. run it, passing argument names and values. the synth can added as many times as needed
x = Synth.new(\sawtone, [\freq, 110, \amp, 0.05]);
y = Synth.new(\sawtone, [\freq, 220, \amp, 0.02]);
z = Synth.new(\sawtone, [\freq, 440, \amp, 0.01]);

z.set(\freq, 440);

x.free;
y.free;
z.free;

// or all at the same time 
(
x = Synth.new(\sawtone, [\freq, 110, \amp, 0.05]);
y = Synth.new(\sawtone, [\freq, 220, \amp, 0.02]);
z = Synth.new(\sawtone, [\freq, 440, \amp, 0.01]);
)

// how to add 8 outs stereo channels
s.options.numOutputBusChannels = 8;
s.reboot;
s.meter;

(
    SynthDef.new(\sawtone, {
        arg freq = 80, amp = 0.2, out = 0;
        var sig, freqCtrl;
        freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25, 0.25).midiratio;
        sig = VarSaw.ar(freqCtrl) * amp;
        // now we sum the frequencies -> monophonic signal
        sig = Splay.ar(sig).sum;
        Out.ar(out, sig);
    }).add;
)

x = Synth.new(\sawtone, [\freq, 110, \amp, 0.05, \out, 0]);

// make it stereo again and send to bus 0
// sc will automagically spread the signal (0..1..etc)
(
    SynthDef.new(\sawtone, {
        arg freq = 80, amp = 0.2, out = 0;
        var sig, freqCtrl;
        freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25, 0.25).midiratio;
        sig = VarSaw.ar(freqCtrl) * amp;
        sig = Splay.ar(sig);
        Out.ar(out, sig);
    }).add;
)

y = Synth.new(\sawtone, [\freq, 60, \amp, 0.05, \out, 0]);

// 25.57

// add an envolope
(
    SynthDef.new(\sawtone, {
        arg freq = 80, amp = 0.2, out = 0;
        var sig, freqCtrl, env;
        env = EnvGen.kr(
            Env.new([0, 1, 0], [2, 2], [2, -2]),
            doneAction:2
        );
        freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25, 0.25).midiratio;
        sig = VarSaw.ar(freqCtrl) * env * amp;
        sig = Splay.ar(sig);
        Out.ar(out, sig);
    }).add;
)

(
    e = Synth.new(\sawtone, [\freq, 1000, \amp, 0.05, \out, 0]);
    f = Synth.new(\sawtone, [\freq, 400, \amp, 0.05, \out, 0]);
    g = Synth.new(\sawtone, [\freq, 200, \amp, 0.05, \out, 0]);
)

// Db Maj7
// turn a value in midi note
37.midicps;
(
    [49, 56, 60, 65]
)

// iterative methods :
// do will evaluate the function once for each item in the collection that it's the receiver
// do is the message passed to the receiver

(
    [49, 56, 60, 65].do({
        // declare an argument to access these values : value, index
        arg note, index;
        // note.postln;
        // ( note + 12 ).postln;

        // the value and its order in the collection.
        [note, index].postln;
    })
)

// all together
(
    [49, 56, 60, 65].do({
        arg note, index;
        Synth.new(\sawtone, [\freq, ( note - 0 ).midicps]);
    })
)

// a random array of clusters rounded to the nearest mult of 5
(
    ({rrand(40,90).round(5)-3}!8).do({
        arg note, index;
        Synth.new(\sawtone, [\freq, ( note - 0 ).midicps]);
    })
)

// add an asr env and hold it open

(
    SynthDef.new(\sawtone, {
        arg freq = 80, amp = 0.12, gate = 1, out = 0;
        var sig, freqCtrl, env;
        env = EnvGen.kr(
            Env.asr(2,1,2,[2,-2]),
            gate,
            doneAction:2
        );
        freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25, 0.25).midiratio;
        sig = VarSaw.ar(freqCtrl) * env * amp;
        sig = Splay.ar(sig);
        Out.ar(out, sig);
    }).add;
)

(
    [49, 56, 60, 65].do({
        arg note, index;
        Synth.new(\sawtone, [\freq, ( note - 2 ).midicps]);
    })
)


// collect returns a modified collection which is filled 
// by the last line in the collect function.

(
    SynthDef.new(\sawtone, {
        arg freq = 80, amp = 0.12, gate = 1, out = 0, rel = 2;
        var sig, freqCtrl, env;
        env = EnvGen.kr(
            Env.asr(2,1,rel,[2,-2]),
            gate,
            doneAction:2
        );
        freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25, 0.25).midiratio;
        sig = VarSaw.ar(freqCtrl) * env * amp;
        sig = Splay.ar(sig);
        Out.ar(out, sig);
    }).add;
)

(
    var rand = rrand(-7,7);
    x = [49, 56, 60, 65].collect({
        arg note, index;
        Synth.new(\sawtone, [\freq, ( note + rand ).midicps]);
    })
)

// access individual items in the array
x[0].set(\gate, 0);

// access the whole array 
(
    x.do({
        arg syn;
        syn.set(\gate, 0, \rel, rrand(2,10));
    });
)

// Routine : a routine is a function that can be played and asked to wait periodically.
// Functions that can return in the middle and then resume where they left off.
(
    Routine.new({
        "hi".postln;
        1.wait;
        "bye".postln;
    }).play;
)

// fork is a shortcut that take a function and wrap it in a Routine 

(
    {
        "hi".postln;
        1.wait;
        "bye".postln;
    }.fork;
)


(
    Routine.new({
        x = [49, 56, 60, 65].collect({
            arg note, index;
            1.wait;
            Synth.new(\sawtone, [\freq, ( note - 3 ).midicps]);
        });
   }).play;
)

(
    Routine.new({
        x.do({
            arg syn;
            syn.set(\gate, 0, \rel, 2);
            1.wait;
        });
    }).play;
)


// or in reverse order 
(
    Routine.new({
        x.reverse.do({
            arg syn;
            syn.set(\gate, 0, \rel, 2);
            1.wait;
        });
    }).play;
)

// Control Structure : if 
(
    SynthDef.new(\sawtone, {
        arg freq = 80, amp = 0.25, out = 0;
        var sig, freqCtrl, env;
        env = EnvGen.kr(
            Env.perc,
            doneAction:2
        );
        freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25, 0.25).midiratio;
        sig = VarSaw.ar(freqCtrl) * env * amp;
        sig = Splay.ar(sig);
        Out.ar(out, sig);
    }).add;
)

(
    if(
        [0,1].choose == 1,
        {
            e = Synth.new(\sawtone, [\freq, 400, \out, 0]);
        },
        {
            "no sound ...".postln;
        }
    );
)

// we can^'t use if inside of a SynthDef : there is no such thing as true and false because
// of the endless ongoing signal generated by a SynthDef. use the UGen Select instead, which is 
// basicall an index pointer in the array.
// a (stupid) example :
(
    SynthDef.new(\test, {
        arg coin = 0;
        var sig, freq;
        freq = Select.kr(coin, [350, 1200]);
        sig = SinOsc.ar(freq!2) * EnvGen.kr(Env.perc, doneAction:2) * 0.2;
        Out.ar(0, sig);
    }).add;
)

Synth.new(\test, [\coin, 1]);

// also see : if statement in a SynthDef in the doc/repo

// randomness by overriding the default values :
(
    SynthDef.new(\test, {
        arg freq = 90;
        var sig;
        sig = SinOsc.ar(freq!2) * EnvGen.kr(Env.perc, doneAction:2) * 0.2;
        Out.ar(0, sig);
    }).add;
)

Synth.new(\test, [\freq, [350, 1200].choose]);

// or using if :
Synth.new(\test, [\freq, if([0,1].choose.postln == 0, {350}, {1200})]);

//
({rrand(1,20)}!5).sum;
