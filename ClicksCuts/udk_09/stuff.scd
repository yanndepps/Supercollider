s.boot

//test with mic
{AllpassN.ar(SoundIn.ar, 1, 0.4, 4)!2}.play;
{CombN.ar(SoundIn.ar, 1, 0.4, 4)!2}.play;

//test with file
b= Buffer.read(s, "/home/depps/Musique/Samplz/folderkits/s/c/mono_n_sc_pads_013.wav");

{Splay.ar(AllpassN.ar(PlayBuf.ar(b.numChannels, b, loop:0), 1, 0.4, 4))}.play;
{CombN.ar(PlayBuf.ar(1, b, loop:0), 1, 0.2, 2)!2}.play;

//detecting when echo is done and the sound is silent
(
a= {
    var snd= PlayBuf.ar(b.numChannels, b);
    var efx= CombN.ar(snd, 0.25, 0.25, 2);
    DetectSilence.ar(efx, doneAction:2);
    Splay.ar(efx);
}.play;
a.onFree({
    "done!".postln;
    NetAddr("127.0.0.1", 12345).sendMsg(\done); //send to processing
});
)

//or with the AllpassN
(
a= {
    var snd= PlayBuf.ar(b.numChannels, b);
    var efx= AllpassN.ar(snd, 0.25, 0.25, 2);
    DetectSilence.ar(efx, doneAction:2);
    Splay.ar(efx);
}.play;
a.onFree({
    "done!".postln;
    NetAddr("127.0.0.1", 12345).sendMsg(\done); //send to processing
});
)

//or with reverb

(
a= {
    var snd= PlayBuf.ar(b.numChannels, b);
    var efx= GVerb.ar(snd, 300, 5, 0.5, 0.9, 50, 1, 0.9, 0.9);
    DetectSilence.ar(efx, doneAction:2);
    Splay.ar(efx);
}.play;
a.onFree({
    "done!".postln;
    NetAddr("127.0.0.1", 12345).sendMsg(\done); //send to processing
});
)

//or this variant

(
a= {
    var snd= PlayBuf.ar(b.numChannels, b);
    var efx= Mix.fill(8, {snd= snd+AllpassN.ar(LPF.ar(snd, 10000.rand), 0.4, 0.4.rand, 3)});
    DetectSilence.ar(efx, doneAction:2);
    Splay.ar(efx);
}.play;
a.onFree({
    "done!".postln;
    NetAddr("127.0.0.1", 12345).sendMsg(\done); //send to processing
});
)