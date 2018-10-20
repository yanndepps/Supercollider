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









