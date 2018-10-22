// Sound Synthesis and Processing
// Unit Generators : UGens
// A unit generator is an object that generates sound signals or control signals,
// that are always calculated in the server.
// Instant Theremin
{SinOsc.ar(freq: MouseX.kr(300, 2500), mul: MouseY.kr(0, 1))}.play;
// a snapshot of the waveform :
{SinOsc.ar(freq: 880, mul: 0.1)}.plot;
{Saw.ar}.plot;
{Pulse.ar}.plot;
// replace .play by .scope for a representation of the waveform in realtime

// Audio rate, control rate
// Ugen are nearly always followed by the messages .ar or .kr (audio rate and control rate)
// Control rate unit generators are used for low frequency or slowly changing control signals.
// Control rate unit generators produce only a single sample per control cycle and therefore
// use less processing power than audio rate unit generator.
// Assuming the computer is running at the common sampling rate of 44100Hz, the oscillator will
// generate 44100 samples per second to send out to the loudspeaker.
// A couple of differences with control rates :
// ° The amount of numbers generated per second is much smaller : (44100/64 64=control period)
// ° The signal generated with .kr is normally used to control parameters of other signals.
// The numbers generated are generally between -1 and 1 or 0 and 1; therefore UGens can be
// divided in two categories : unipolar UGens and bipolar UGens.

// The poll method :
{SinOsc.kr(1).poll}.play;
{LFPulse.kr(1).poll}.play;
{LFNoise0.ar(1).poll}.play;

// UGen arguments
// the mul arg stands for "multiplier" and is essentially the amplitude of the waveform.
// 0.5 means multipliyng the waveform by half, plays half of the maximum amplitude.
// if we don't name the args expicitly, we have to provide them in the exact order.
// if we do name them explicitly, we can put them in any order, even skip some in the middle.

// Scaling ranges:
// How the LFNoise0 is used to control frequency, step-by-step :
{SinOsc.ar(freq: LFNoise0.kr(10).range(500, 1500), mul: 0.1)}.play;
// breaking it down :
{LFNoise0.kr(1).poll}.play;
{LFNoise0.kr(1).range(500, 1500).poll}.play;
{LFNoise0.kr(10).range(500, 1500).poll}.play;

// Scale with the method range :
// the method range rescales the output of UGen. where LFNoise0 produces number between
// -1 and +1 (bipoar), the .range takes this output and scales it to whatever low and high
// values we provide as arguments.

// Scale with mul and add :
{SinOsc.kr(1).range(100, 200).poll}.play;
// same as :
{SinOsc.kr(1, mul:50, add: 150).poll}.play;
// or :
{LFPulse.kr(1).range(100, 200).poll}.play;
// same as :
{LFPulse.kr(1, mul: 50, add: 150).poll}.play;

// linlin and friends :
// for any other arbitrary scaling of ranges, use the methods linlin, linexp, explin, expexp
// their names hint at what they do : comvert a linear range to another linear range (linlin),
// linear to exponential (linexp), etc.
// a bunch of numbers :
a = [1, 2, 3, 4, 5, 6, 7];
// rescale to 0-127, linear to linear
a.linlin(1, 7, 0, 127).round(1);
// rescale to 0-127, linear to exponential
a.linexp(1, 7, 0.01, 127).round(1);

// Stopping individual synths :
a = {Saw.ar(LFNoise2.kr(8).range(1000, 2000), mul: 0.2)}.play;
b = {Saw.ar(LFNoise2.kr(7).range(100, 1000), mul: 0.2)}.play;
c = {Saw.ar(LFNoise0.kr(15).range(2000, 3000), mul: 0.1)}.play;
a.free;
b.free;
c.free;

// The set message :
// just like any function, arguments specified at the beginning of a synth function are
// accessible by the user. This allows to change synth params on the fly.
// The message set is used for that purpose :
x = {| freq = 440, amp = 0.1 | SinOsc.ar(freq, 0, amp)}.play;
x.set(\freq, 784);
x.set(\amp, 0.5);
x.set(\freq, 932, \amp, 0.2);
x.free;

// Audio Buses :
// are used for routing audio signals. SC has 128 by default.
// the first eight (0-7) are by default reserved to be the ouput channels of the sound card.
// the next eight (8-15) are reserved for the inputs. The other ones are free to use in any way
// for example to route audio signals from one UGen to another.

// Out and In UGens :
{Out.ar(1, SinOsc.ar(440, 0, 0.1))}.play;
// The Out UGen takes care of routing signals to specific buses.
// The first argument to Out is the target bus (above: 1=right channel)
// The second argument is the actual signal we want to "write" into that bus.
// One simple example of and audio bus being used for an effect :
// start the effect :
f = {Out.ar(0, BPF.ar(in: In.ar(55), freq: MouseX.kr(1000, 5000), rq: 0.1))}.play;
// start the source :
n = {Out.ar(55, WhiteNoise.ar(0.5))}.play;
// The routing from above : noise synth -> bus 55 -> filter synth

// Multichannel Expansion :
{Out.ar(0, Saw.ar(freq: [440, 570], mul: Line.kr(0, 1, [1, 15])))}.play;
// If we use an array anywhere as one of the arguments of a UGen, the entire patch
// is duplicated. The number of copies created is the number of items in the array.
// These duplicated UGens are sent out to as many adjacent buses as needed, starting
// from the bus specified as the first argument of Out.ar.
// busy tone simulation :
a = {Out.ar(0, SinOsc.ar(freq: [800, 880], mul: LFPulse.ar(2)))}.play;
a.free;

// The Bus object :
// audio buses and multichannel expandion :
// turn reverb on :
r = {Out.ar(0, FreeVerb.ar(In.ar(55, 2), mix: 0.5, room: 0.9, mul: 0.4))}.play;
// feed the busy tone into the reverb bus :
a = {Out.ar(55, SinOsc.ar([800, 880], mul: LFPulse.ar(2)))}.play;
a.free;
r.free;

// The Bus object does the job of choosing an available bus and keeping track of it :
// Create the bus :
~myBus = Bus.audio(s, 2);
// Turn on the reverb, read from myBus :
r = {Out.ar(0, FreeVerb.ar(In.ar(~myBus, 2), mix: 0.5, room: 0.9, mul: 0.4))}.play;
// Feed the busy tone into ~myBus :
b = {Out.ar(~myBus, SinOsc.ar([800, 880], mul: LFPulse.ar(2)))}.play;
// Free both synths :
r.free; b.free;

// Panning :
// is the spreading of an audio signal into a stereo or multichannel sound field.
// a mono signal bouncing :
p = {Pan2.ar(in: PinkNoise.ar, pos: SinOsc.kr(2), level: 0.1)}.play;
p.free;

// A sawthooth wave goes through a very sharp bandpass filter :
(
x = {
	var lfn = LFNoise2.kr(1);
	var saw = Saw.ar(freq: 30, mul: LFPulse.kr(freq: LFNoise1.kr(1).range(1, 10), width: 0.1));
	var bpf = BPF.ar(in: saw, freq: lfn.range(500, 2500), rq: 0.01, mul: 20);
	Pan2.ar(in: bpf, pos: lfn);
}.play;
)
x.free;

// Mix and Splay :
// use multichannel expansion to generate complex sounds, mix it down to mono or stereo.
// 5 channels ouput :
a = {SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1)}.play;
a.free;
// mix it down to mono :
b = {Mix(SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1))}.play;
b.free;
// mix it down to stereo, spread evenly from left to right :
c = {Splay.ar(SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1))}.play;
c.free;

// fun with Splay :
(
d = {arg fundamental = 100;
	var harmonics = [1, 2, 3, 4, 5, 6, 7, 8, 9];
	var snd = BPF.ar(
		in: Saw.ar(32, LFPulse.ar(harmonics, width: 0.1)),
		freq: harmonics * fundamental,
		rq: 0.01,
		mul: 20);
	Splay.ar(snd);
}.play;
)
d.set(\fundamental, 65);
d.free;

// Playing an audio file :




















