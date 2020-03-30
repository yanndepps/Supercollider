// fm synthesis

s.boot;

{BLowPass4.ar(SinOsc.ar(99, SinOsc.ar(SinOsc.ar([50, 50.1])*200)*MouseX.kr(0, 40)))}.play;

{SinOsc.ar(500, 0, 0.5) + SinOsc.ar(840, 0, 0.5)!2}.play;

{SinOsc.ar([500, 501])}.play;
{SinOsc.ar([500, 499])}.play;
{SinOsc.ar([500, 500.5])}.play;
{SinOsc.ar([500, 502.35])}.play;

// beating sines (binaural beats)
{SinOsc.ar([870, 853])}.play;

// Splay mix lots of oscs into stereo
{Splay.ar(SinOsc.ar([500, 601, 707, 800]))}.play;

// additive synthesis
{SinOsc.ar(500) + SinOsc.ar(8000, 0, 0.1)}.play;

{Splay.ar(SinOsc.ar([400, 500, 600, 700, 800], 0, [0.5, 0.4, 0.3, 0.2, 0.1]))}.play;


{Splay.ar(SinOsc.ar([400, 500, 602, 700, 801], 0, SinOsc.ar([0.1, 0.21, 0.31, 0.405, 0.5])))}.play;

//frequency modulation

{SinOsc.ar(500+ (SinOsc.ar(2)*100))}.play;

{SinOsc.ar(500+ (SinOsc.ar(201)*100))}.play;

{SinOsc.ar(500+ (SinOsc.ar(20)*100))}.play;

{SinOsc.ar([500, 500]+ (SinOsc.ar(20)*(SinOsc.ar(1)*100)))}.play;

{SinOsc.ar([500, 600]+ (SinOsc.ar(20*(SinOsc.ar(1)*10))*100))}.play;

{SinOsc.ar([500, 500] + (SinOsc.ar(4)*400))}.play;

{SinOsc.ar([500, 500] + (SinOsc.ar(SinOsc.ar(0.1)*40)*400))}.play;

{SinOsc.ar([500, 500] + (SinOsc.ar(SinOsc.ar(SinOsc.ar(0.5)*40)*400)*400))}.play;

{Splay.ar(SinOsc.ar([500, 505, 600, 800] + (SinOsc.ar(SinOsc.ar(SinOsc.ar([0.5, 0.6])*[40, 50, 60])*400)*[400, 40, 500])))}.play;


//amplitude modulation / ring modulation
{SinOsc.ar([500, 600])}.play;

{SinOsc.ar(500)*SinOsc.ar(100)}.play;

{SinOsc.ar([500, 600])*SinOsc.ar([103, 200])*SinOsc.ar([402, 500])*SinOsc.ar([801, 900])}.play;


{Splay.ar(SinOsc.ar([500, 600, 700, 800])*SinOsc.ar([0.1, 0.2, 0.3, 0.4])*SinOsc.ar([0.1, 0.2, 0.3, 0.4]+1.1))}.play;