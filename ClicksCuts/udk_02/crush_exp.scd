s.boot;

// downsample 1000hz
{Latch.ar(SoundIn.ar, Impulse.ar(1000))!2}.play;

// downsample with mouse control
{Latch.ar(SoundIn.ar, Impulse.ar((SampleRate.ir*MouseX.kr(0, 0.5)).poll))!2}.play;

// downsample with delay
{Latch.ar(DelayN.ar(SoundIn.ar, 2, 2), Impulse.ar((SampleRate.ir*MouseX.kr(0, 0.5)).poll))!2}.play;

// downsample with echo
{Latch.ar(CombN.ar(SoundIn.ar, 0.25, 0.25, 2), Impulse.ar((SampleRate.ir*MouseX.kr(0, 0.5)).poll))!2}.play;

// bit reduction
{SoundIn.ar.round(0.5**3)!2}.play;

// bit reduction with mouse control
{SoundIn.ar.round(0.5**MouseX.kr(0.01, 10).poll)!2}.play;

// ring modulation 400hz
{SoundIn.ar*SinOsc.ar(400)!2}.play;

// ring modulation with mouse control
{SoundIn.ar*SinOsc.ar(MouseX.kr(1, 1000).poll)!2}.play;

// ring mod with delay
{DelayN.ar(SoundIn.ar, 2, 2)*SinOsc.ar(MouseX.kr(1, 1000).poll)!2}.play;

// ring mod with echo
{CombN.ar(SoundIn.ar, 0.25, 0.25, 2)*SinOsc.ar(MouseX.kr(1, 1000).poll)!2}.play;

// downsample & bit reduce with mouse x/y
{Latch.ar(CombN.ar(SoundIn.ar, 0.25, 0.25, 2).round(0.5**MouseX.kr(0.01, 10)), Impulse.ar((SampleRate.ir*MouseY.kr(0, 0.5))))!2}.play;

// same with fx in different order
{CombN.ar(Latch.ar(SoundIn.ar.round(0.5**MouseX.kr(0.01, 10)), Impulse.ar((SampleRate.ir*MouseY.kr(0, 0.05)))), 0.25, 2)!2}.play;

// +ring mod
{CombN.ar(Latch.ar((SoundIn.ar*SinOsc.ar(MouseX.kr(1, 1000, 1))).round(0.5**MouseY.kr(0.01, 10)), Impulse.ar((SampleRate.ir*MouseY.kr(0, 0.5)))), 0.25, 0.25, 2)!2}.play;

// same with samples ...

// edit to match any soundfile
b = Buffer.read(s, "/Users/yanndepps/Documents/Musik/samplz/Dirts/H_ISO/Hainbach - Isolation Loops (soundpack) - 44 Test Equipment.wav");

// downsample 1000hz
{Latch.ar(PlayBuf.ar(b.numChannels, b, 1, loop:1), Impulse.ar(1000))}.play;

// downsample with mouse control
{Latch.ar(PlayBuf.ar(b.numChannels, b, 1, loop:1), Impulse.ar((SampleRate.ir*MouseX.kr(0, 0.5)).poll))}.play;

// downsample with delay
{Latch.ar(DelayN.ar(PlayBuf.ar(b.numChannels, b, 1, loop:1), 2, 2), Impulse.ar((SampleRate.ir*MouseX.kr(0, 0.5)).poll))}.play;

// downsample with echo
{Latch.ar(CombN.ar(PlayBuf.ar(b.numChannels, b, 1, loop:1), 0.25, 0.25, 2), Impulse.ar((SampleRate.ir*MouseX.kr(0, 0.5)).poll))}.play;

// bitreduction
{PlayBuf.ar(b.numChannels, b, 1, loop:1).round(0.5**3)}.play;

// bitreduction with mouse control
{PlayBuf.ar(b.numChannels, b, 1, loop:1).round(0.5**MouseX.kr(0.01, 10).poll)}.play;

// ring modulation 400hz
{PlayBuf.ar(b.numChannels, b, 1, loop:1)*SinOsc.ar(400)}.play;

// ring mod with mouse control
{PlayBuf.ar(b.numChannels, b, 1, loop:1)*SinOsc.ar(MouseX.kr(1, 1000).poll)}.play;

// ring mod with delay
{DelayN.ar(PlayBuf.ar(b.numChannels, b, 1, loop:1), 2, 2)*SinOsc.ar(MouseX.kr(1, 1000).poll)}.play;

// ring mod with echo
{CombN.ar(PlayBuf.ar(b.numChannels, b, 1, loop:1), 0.25, 0.25, 2)*SinOsc.ar(MouseX.kr(1, 1000).poll)}.play;

// downsample & bitreduce with mouse control
{Latch.ar(CombN.ar(PlayBuf.ar(b.numChannels, b, 1, loop:1), 0.25, 0.25, 2).round(0.5**MouseX.kr(0.01, 10)), Impulse.ar((SampleRate.ir*MouseY.kr(0, 0.5))))}.play;

// same but fx in different orders
{CombN.ar(Latch.ar(PlayBuf.ar(b.numChannels, b, 1, loop:1).round(0.5**MouseX.kr(0.01, 10)), Impulse.ar((SampleRate.ir*MouseY.kr(0, 0.5)))), 0.25, 0.25, 2)}.play;

// +ring mod
{CombN.ar(Latch.ar((PlayBuf.ar(b.numChannels, b, 1, loop:1)*SinOsc.ar(MouseX.kr(1, 1000, 1))).round(0.5**MouseX.kr(0.01, 10)), Impulse.ar((SampleRate.ir*MouseY.kr(0, 0.5)))), 0.25, 0.25, 2)}.play;

// extra_01 : changing playback speed with mouse
{PlayBuf.ar(b.numChannels, b, MouseX.kr(-1, 2).poll, loop:1).round(0.5**MouseY.kr(1, 16))}.play;

// extra_02 : crusher as a general fx - XFade2 with MouseX crossfades between 'dry' & 'wet' sound
(
{
	var src, efx;
	src = PlayBuf.ar(b.numChannels, b, 1, loop:1);   // soundfile
	//src = SoundIn.ar!2;   // mic or line up
	efx = src.round(0.5**4);
	efx = Latch.ar(efx, Impulse.ar(1000));
	efx = efx + CombN.ar(efx, 0.25, 0.25, 2);
	XFade2.ar(src, efx, MouseX.kr(-1, 1));
}.play;
)

// end