s.boot;

//try whistling
{SinOsc.ar(Pitch.kr(SoundIn.ar)[0])!2}.play;

//constantly rising
{SinOsc.ar(Pitch.kr(SoundIn.ar)[0]+5)!2}.play;

//constantly falling
{SinOsc.ar(Pitch.kr(SoundIn.ar)[0]-5)!2}.play;


//more falling - works really well in a big group of laptops
{SinOsc.ar(Pitch.kr(SoundIn.ar)[0]-15)!2}.play;

//harsher sounds and some different settings for pitch tracker
{Pulse.ar(Pitch.kr(SoundIn.ar, 400, 50, 4000, downSample:10)[0]-15)!2}.play;

//lag control with mouse
{Pulse.ar(Pitch.kr(SoundIn.ar).lag(MouseX.kr(0, 1))[0]-25)!2}.play;

//with 1sec delay and no addition (no +5)
{SinOsc.ar(Pitch.kr(DelayN.ar(SoundIn.ar, 1, 1))[0])!2}.play;

//delay with increasing frequency
{SinOsc.ar(Pitch.kr(DelayN.ar(SoundIn.ar, 1 ,1))[0]+15)!2}.play;

//different delaytimes in left and right channel
{SinOsc.ar(Pitch.kr(DelayN.ar(SoundIn.ar, 1, [1, 0.9])).flop[0]+15)}.play;

//with lag
{SinOsc.ar(Pitch.kr(DelayN.ar(SoundIn.ar, 1, 1)).lag(0.2)[0])!2}.play;

//lag3 is overshooting
{SinOsc.ar(Pitch.kr(DelayN.ar(SoundIn.ar, 1, 1)).lag3(0.2)[0])!2}.play;

//with reverb effect
{GVerb.ar(SinOsc.ar(Pitch.kr(SoundIn.ar)[0]), 90)}.play;

//crazy
{SinOsc.ar(0, SinOsc.ar(Pitch.kr(SoundIn.ar)[0]/MouseX.kr(1, 9))*2pi)!2}.play;

//demo posting the hasFreq flag. this will detect 'clean' pitched sounds
{Pitch.kr(SoundIn.ar)[1].poll; DC.ar(0)}.play;

//and with clar flag set to 1 you get 'clarity' - how 'clean' the sound is
{Pitch.kr(SoundIn.ar, clar:1)[1].poll; DC.ar(0)}.play;

