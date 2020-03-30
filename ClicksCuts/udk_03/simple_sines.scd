// experiment with simple sines
s.boot;
s.scope;

{SinOsc.ar(400, 0.5*pi)}.play;

{SinOsc.ar(400, 0.5*pi)}.play(fadeTime:1);

// no attack and start sine at 1.0 by setting phase at half-pi
{SinOsc.ar(400, 0.5*pi)}.play(fadeTime:0);

// tune attack and add quick fade out : drum kick
{SinOsc.ar(100, 0.1*pi, Line.ar(1, 0, 0.04)!2)}.play(fadeTime:0);

{GVerb.ar(SinOsc.ar(100, 0.1*pi, Line.ar(1, 0, 0.04)), 50)}.play(fadeTime:0);

{FreeVerb.ar(SinOsc.ar(100, 0.1*pi, Line.ar(1, 0, 0.04)), 0.5)!2}.play(fadeTime:0);

// using sine oscillators as 0/1 rhythm gates
{SinOsc.ar(40) * (SinOsc.ar(1.4)>0.9)!2}.play(fadeTime:0);

{SinOsc.ar(400) * (SinOsc.ar(SinOsc.ar(1.5)*10.8+0.6)>0.9)!2}.play(fadeTime:0);

// multi channel expansion
{SinOsc.ar([400, 800]) * (SinOsc.ar(SinOsc.ar([1.5, 1.75])*10.8+0.6)>0.9)}.play(fadeTime:0);

// using Splay to spread out x channels into the standard two channels stereo field
{Splay.ar(SinOsc.ar([400, 800, 900, 1200]) * (SinOsc.ar(SinOsc.ar([1.5, 1.75])*10.8+0.6)>0.9))}.play(fadeTime:0);

{SinOsc.ar([500, 600]) * (SinOsc.ar([3, 4])>0)}.play;

{Splay.ar(SinOsc.ar([500, 6000, 700, 503, 654]) * (SinOsc.ar([3, 4, 5, 6, 7])>0))}.play;

{SinOsc.ar([50, 70]) * (SinOsc.ar([2, 3])>SinOsc.ar(0.1))}.play(fadeTime:0);


b = [1, 2, 3, 4, 5, 6, 7, 8, 9];
{Splay.ar(SinOsc.ar(b*50) * (SinOsc.ar(b)>0))}.play;

// same as b = 1, 2, 3, 4, 5
b = (1..5);
{Splay.ar(SinOsc.ar(b*50) * (SinOsc.ar(b)>0))}.play;

b = (1..5);
{Splay.ar(SinOsc.ar(b*50) * (SinOsc.ar(2)*SinOsc.ar(0.8)>0))}.play;


b = (1..5);
{Splay.ar(SinOsc.ar(b*50) + SinOsc.ar(b*50) * (SinOsc.ar(3)+ SinOsc.ar(0.8)>0))}.play;

{Splay.ar(SinOsc.ar(b*50) * SinOsc.ar(b*50) * (SinOsc.ar(3)+ SinOsc.ar(0.8)>0))}.play;

{SinOsc.ar(50*SinOsc.ar(LFNoise2.ar(4)*10+30))!2}.play;

{Splay.ar(SinOsc.ar(500*SinOsc.ar(LFNoise2.ar([3,4,5,6,7])*100+300)))}.play;

// the sin(x) function :
{Sweep.ar(0, 1).poll; Silent.ar}.play;

{sin(Sweep.ar(0, 1)).poll; Silent.ar}.play;

{sin(Sweep.ar(0, 2pi*400))}.play;

{SinOsc.ar(400)}.play;