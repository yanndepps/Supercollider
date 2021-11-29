// --- Basics : ProxySpace Basics --- //
// always use protection
StageLimiter.activate;

// 1. Proxies & Patching
// in ProxySpace, live code much like patching a modular synth

// a pair of sine waves
{SinOsc.ar([400, 500], 0, 0.1)}.play;

// stop the server
Server.hardFreeAll;

// make the sine wave with a named proxy
/*
Proxies work on a couple of naming conventions, one is:
~foo123 (has to start with a lowercase letter)
or:
p[\name]
*/

~sine1 = {SinOsc.ar([400, 500], 0, 0.1)};

// p[\sine2] = {SinOsc.ar([85, 80], 0, 0.1)};

// play those sine waves
~sine1.play;

// p[\sine2].play;

// change the freq of those sine waves instantly
~sine1 = {SinOsc.ar([500, 600], 0, 0.1)};

// add a fade to ProxySpace
p.fadeTime = 3;

// we can also assign individual fade times to proxies
~sine1.fadeTime = 3;

// change the freqs again and hear a change
~sine1 = {SinOsc.ar([200, 300], 0, 0.1)};

// make a second sine wave and play it alongside the first
~sine2 = {SinOsc.ar([350, 450], 0, 0.1)};
~sine2.play;

// add modulation to the second sine wave
~sine2 = {SinOsc.ar([350+Saw.kr(1,100), 450+Saw.kr(0.99,100)], 0, 0.1)};

// stop the two sine waves
// stops can also be faded
~sine1.stop;
~sine2.stop(2);

// make two modulated saw waves
~saw = {Saw.ar([LFNoise1.kr(0.1).range(8,12), LFNoise1.kr(0.1).range(8,12)], 2)};

// amplitude -> modulate the original second sine with the saw
~sine2 = {SinOsc.ar([350, 450], 0, 0.1 * ~saw)};
~sine2.play;

// frequency -> modulate the sine wave with the say
~sine2 = {SinOsc.ar([350, 450] * ~saw, 0, 0.1)};
~sine2.play;

// we can combine proxies in a new proxy for modulation
~modSine = {~sine2 * ~saw};
~modSine.play;

// mix in other proxies
~modSine = {Mix.ar([~sine1 * ~saw, ~sine2]) * ~saw};

// create an effects proxy, to send other proxies to
// note the multichannel expansion in ~delay
~delay = {CombN.ar(~modSine, 0.2, [0.2, 0.21], 2, 1)};
~delay.play;

// create another effects proxy, just for fun
~decimator = {Decimator.ar(~delay, 2205, 10)};
~decimator.play;

// when we create a new proxy, the old one will always keep going !
// it keep adding more and more layers until we stop some ones
~modSine.stop;
~delay.stop;
~decimator.stop;

/*

Note, if you .stop a proxy, it will keep running in proxyspace, but it won't be sounding (but if it is affecting any other proxies it will still do so).

This means that if you have any particularly CPU intensive proxies running but not sounding, or affecting any other proxies, and you don't intend to use that proxy again, you should use the .free method to kill them completely:

i.e. (don't evaluate these now)
~modSine.free
~delay.free

*/

// we can plug any part of the proxy chain into any other part ( but not a proxy into itself )
// plugging the end of the effects chain back into the frequency of the
// first sine wave will bring some nice modulations
~sine1 = {SinOsc.ar([200, 300] * ~decimator, ~delay * ~saw, 0.4 * ~decimator)};
~sine1.play;
~sine1.stop;

// free all proxies in ProxySpace
p.clear;

// --- END --- //
