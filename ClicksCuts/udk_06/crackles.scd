// crackles
s.boot;

b.free;

b = Buffer.read(s,"/Users/yanndepps/Documents/Musik/samplz/Dirts/H_EMF/EMF_30.wav");
b = Buffer.read(s,"/Users/yanndepps/Documents/Musik/samplz/Dirts/H_EMF/EMF_32.wav");
b = Buffer.read(s,"/Users/yanndepps/Documents/Musik/samplz/Dirts/H_EMF/EMF_48.wav");

b.plot;

(   //move the mouse to the right hand side (>0.5) to trigger a 'glitch'
{
    PlayBuf.ar(2, b, 1, MouseX.kr(0, 1)>0.5, 2000, loop: 1);
}.play;
)

(   //automatic trigger a 'glitch' every 0.5 second (twice/sec)
{
    PlayBuf.ar(2, b, 1, Impulse.kr(2), 2000, loop: 1);
}.play;
)

(   //move the mouse to set the speed of the automatic trigger
{
    PlayBuf.ar(2, b, 1, Impulse.kr(MouseX.kr(1, 100)), 6000, loop: 1);
}.play;
)

//same as above but with additional control over offset (where in the sound file the 'glitch' should jump to)

(
{
    PlayBuf.ar(2, b, 1, MouseX.kr(0, 1)>0.5, MouseY.kr(0, BufFrames.ir(b)-1), loop: 1);
}.play;
)

(
{
    PlayBuf.ar(2, b, 1, Impulse.kr(2), MouseY.kr(0, BufFrames.ir(b)-1), loop: 1);
}.play;
)

(
{
    PlayBuf.ar(2, b, 1, Impulse.kr(MouseX.kr(1, 100)), MouseY.kr(0, BufFrames.ir(b)-1), loop: 1);
}.play;
)

//to make it sound less 'metallic' and more 'natural', try adding some randomness to both the trigger rate and trigger offset.

(
{
    PlayBuf.ar(2, b, 1, Impulse.kr(MouseX.kr(1, 100)+LFNoise2.kr(1, 1)), MouseY.kr(0, BufFrames.ir(b)-1)+LFNoise2.kr(1, 50), loop: 1)!2;
}.play;
)

//

(
{
    var trigger= Impulse.ar(MouseY.kr(0.1, 100, 1)+LFNoise1.kr(0.1));
    var offset= MouseX.kr(0, BufFrames.ir(b)-1);
    var src= PlayBuf.ar(1, b, 1, trigger, offset, 1);
    Pan2.ar(src, LFNoise2.kr(1, 0.5));
}.play
)


//same but press mouse button to start stuttering
(
{
    var trigger= Impulse.ar(MouseY.kr(0.1, 100, 1)+LFNoise1.kr(0.1));
    var offset= MouseX.kr(0, BufFrames.ir(b)-1);
    var src= PlayBuf.ar(1, b, 1, trigger, offset, 1);
    var src2= PlayBuf.ar(1, b, 1, 1, 0, 1);
    Pan2.ar(XFade2.ar(src2, src, MouseButton.kr(-1, 1, 0.2)), LFNoise2.kr(1, 0.5)); //0.2 is xfade time
}.play
)

//or the same but stutters when you press the key 'J'
(
{
    var trigger= Impulse.ar(MouseY.kr(0.1, 100, 1)+LFNoise1.kr(0.1));
    var offset= MouseX.kr(0, BufFrames.ir(b));
    var src= PlayBuf.ar(1, b, 1, trigger, offset, 1);
    var src2= PlayBuf.ar(1, b, 1, 1, 0, 1);
    Pan2.ar(XFade2.ar(src2, src, KeyState.kr(38, -1, 1, 0.2)), LFNoise2.kr(1, 0.5)); //0.2 is xfade time
}.play
)

