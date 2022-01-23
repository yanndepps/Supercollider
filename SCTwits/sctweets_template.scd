//////////////////////////////
// -- start
//////////////////////////////
s.options.memSize = 8192 * 256;

s.boot;

s.quit;

s.meter;
s.scope;
s.makeWindow;

FreqScope.new;

s.plotTree;

s.prepareForRecord;
s.record;
s.stopRecording;

//////////////////////////////
// -- general
//////////////////////////////

//tweet0212
play{{|i|RecordBuf.ar(Limiter.ar(HPF.ar(Warp1.ar(1,b=LocalBuf(9e3).clear,c=LFSaw.ar(d=1.0009,i).max,1/d)+(c>0/3),9)),b)}!2}

{SinOsc.ar*0.1}.play;
"{SinOsc.ar*0.1}.play".size; // max 140 char

//////////////////////////////
// -- tweet #1
//////////////////////////////

play{SinOsc.ar([400, 404], 0, 0.1)};

play{SinOsc.ar([400, 404] + SinOsc.ar([0.5, 0.6], 0, 50), 0, 0.1)};

play{SinOsc.ar([4000, 4004] + SinOsc.ar([10.5, 10.6], 0, 1500), 0, 0.1)};

play{SinOsc.ar([4000, 4004] + SinOsc.ar([10.5, 10.6], 0, 1500) + SinOsc.ar(0.1, 0, 5000, 1000), 0, 0.1)};

play{SinOsc.ar([4000, 4004] + SinOsc.ar([100.5, 10.6], 0, 1500) + SinOsc.ar(0.1, 0, 5000, 1000), 0, SinOsc.ar(2)+SinOsc.ar(3))};

"play{SinOsc.ar([4000, 4004] + SinOsc.ar([100.5, 10.6], 0, 1500) + SinOsc.ar(0.1, 0, 5000, 1000), 0, SinOsc.ar(2)+SinOsc.ar(3))}".size;

// optimizing
a=SinOsc;
play{a.ar([4000, 4004]+a.ar([100.5,10.6],0,1500)+a.ar(0.1,0,5000,1000),0,a.ar(2)+a.ar(3))};

// easy to replace main oscillator
a=LFSaw;play{a.ar([4000, 4004]+a.ar([100.5,10.6],0,1500)+a.ar(0.1,0,5000,1000),0,a.ar(2)+a.ar(3))};

// LFTri
// LFPar
// LFCub
// Blip
// LFPulse
// VarSaw


a=Blip;play{a.ar([4000, 4004]+a.ar([100.5,10.6],0,1500)+a.ar(0.1,0,5000,1000),0,a.ar(2)+a.ar(3))};

a=LFPulse;play{a.ar([4000, 4004]+a.ar([100.5,10.6],0,1500)+a.ar(0.1,0,5000,1000),0,a.ar(2)+a.ar(3))};

// two simple effects to add -> tanh & CombN
a=SinOsc;play{a.ar([4000,4004]+a.ar([100.5,10.6],0,1500)+a.ar(0.1,0,5000,1000),0,a.ar(2)+a.ar(3)*5).tanh};

{SinOsc.ar([40, 44], 0, SinOsc.ar(0.1)*5).tanh}.play;

a=Blip;play{CombN.ar(a.ar([400,404]+a.ar([10.5,1.6],0,150)+a.ar(0.1,0,500,100),0,a.ar(2)+a.ar(3)))};

// math & bitwise operators
a=SinOsc;play{a.ar([4000,4004]&a.ar([100.5,10.6],0,1500)*a.ar(0.1,0,5000,1000),0,a.ar(2)*a.ar(3))};

// >>
// <<
// *
// /
// %
// |
// &
// >
// <

//////////////////////////////
// -- templates
//////////////////////////////

// shepard tones
play{b=(1..9)*99;Splay.ar(SinOsc.ar(b*LFSaw.kr(-9/b,1,99))*SinOsc.ar(4.5/b))/2};

// drone pieces
play{Splay.ar({|i|SinOsc.ar(i+SinOsc.ar(0.01,a=pi/[2,4,8]@@i,0.1,1)*80+SinOsc.ar(i+1*1e-4+i),a,SinOsc.ar(i+1*1e-3,a)/4)}!9)};

{|i|x=i+6.rand;Pbind(\dur,0.06,\sustain,1,\amp,0.01,\degree,Pgauss(x,sin(x+Ptime()%6/6e3)*9),\pan,Pkey(\degree)-x*9).play}!6;

// annoying ringtone melodies
a=SinOsc;fork{inf.do{|i|play{Pan2.ar(a.ar(i,a.ar(Duty.ar(b=0.1,0,Dseq([0,i%9,2,3,4,0,2,1]*150,9))),b),i%3-1)};wait(i%5+1)}};

a=SinOsc;play{a.ar(0,a.ar(5/3)%1+a.ar(Duty.ar(b=0.15,0,Dseq(a.ar(a.ar(b)/3+0.3).max+1*[[261,440],220,261,349,99,0],inf))))};

a=(1,3..9)*99;fork{inf.do{play{SinOsc.ar(Duty.ar(1/[8,9],0,Dseq(a=wrap(a*9,99,8e3),99)),0,Line.kr(0.2,0,9,1,0,2))};2.wait}};

// massive noise
{|i|play{a=LFPulse;HPF.ar(Ringz.ar(a.ar(a.ar(1/(j=i+1)+a.ar(b=(2..5),0,1/b)*b).sum+1*[89,99]*j),2**i*99,0.42).tanh,9)/5}}!4

play{a=SinOsc;Normalizer.ar(Splay.ar(a.ar(811+b=(2..8),a.ar((c=a.ar(0.1/b,b))<0*9*b+855+(9/b),a.ar(899/b)*2,2).tanh*6,c)))};

play{f=LFPar.ar(1/14).round*20+80;Splay.ar(LFPar.ar({|i|[i+1*f,i*f+(i+1/3)]}!4)>BrownNoise.ar(Pulse.ar({|i|i+1}!4,0.35))/3)};

// minimal techno
a=LFPar;play{Out.ar(5,a.ar(1)|a.ar(5)+RLPF.ar(x=Pan2.ar(InFeedback.ar(5),SinOsc.ar(5.5)),3e3,a.ar(1/25)/2+1.7));x*a.ar(99)};

a=LFPar;play{Splay.ar(GrainFM.ar(1,a.ar(9),a.ar((3..7))%1/9,a.ar(1/(2..8))%1*99,(1..9)*99,a.ar(0.22/(4..6))/2+0.5*9)).tanh};

a=Blip;play{Splay.ar(Formant.ar(a.ar(9/b=(1..9),a.ar(1/b,b)+2*99,b)+1*[99,400,999,50],a.ar(1/4/b,a.ar(0.2/b,b))*99*b)).sin};

play{CombN.ar(SinOsc.ar(Saw.ar(3,64,99),Saw.ar([3,4],Saw.ar(1,32,128),Duty.ar(1,0,flop(Dseq([0,8,1,5])*[1,4,8]))))/9,1,1/6)};

//////////////////////////////
// -- tweet #2
//////////////////////////////

play{SinOsc.ar(0,SinOsc.ar([400,404])*2pi)};
play{SinOsc.ar(0,SinOsc.ar([400,404])*3)};
play{SinOsc.ar(0,SinOsc.ar([400,404])*15)};
play{SinOsc.ar(0,SinOsc.ar([400,404])*SinOsc.ar(0.1)*2pi)};
play{SinOsc.ar(0,SinOsc.ar([400,404])*SinOsc.ar(SinOsc.ar(0.1))*2pi)};
play{SinOsc.ar(0,SinOsc.ar([400,404])*SinOsc.ar(SinOsc.ar(0.1)*40)*2pi)};
play{SinOsc.ar(0,SinOsc.ar([50,51])*SinOsc.ar(SinOsc.ar(0.1)*40)*2pi)};

//with main oscillator as a variable:
a=SinOsc;play{a.ar(0,a.ar([400,404])*a.ar(a.ar(0.1)*40)*2pi)}

a=VarSaw;play{SinOsc.ar(0,a.ar([100,101])*a.ar(a.ar(0.1)*40)*2pi)}

a=Pulse;play{SinOsc.ar(0,a.ar([400,404])*a.ar(CombN.ar(a.ar(0.1))*40)*2pi)}

//////////////////////////////
// -- tricks
//////////////////////////////