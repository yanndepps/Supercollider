// Boot
// increase this if "alloc failed" messages
s.options.memSize = 8192 * 256;

s.boot;

s.quit;

// GUIs
s.meter;

s.scope;

FreqScope.new;

s.plotTree;

// record
s.prepareForRecord;

s.record;

s.stopRecording;

// ---
// 01.02.13
r{inf.do{|i|Ndef(\,{VarSaw.ar(Duty.ar(1/12,0,Dseq((12..0)*(i%63+99)),2)*[1,1.01],0,i/9%9/9)/9}).play.spawn;wait(1/3)}}.play

// 03.02.13
{|i|play{a=Duty.ar(b=1/24,0,Dseq(Dshuf({b.linrand}!8,16+i),99));Pan2.ar(BPF.ar(Saw.ar(c=a+i+1*99,a*3),c*2,0.6)*5,i/4-1)}}!9

// 11.02.13
play{a=LFNoise1;BPF.ar(Splay.ar(SinOsc.ar(0,a.ar((999,888..111),a.ar(1/(9..1),a.ar({|i|i+1/(9-i)}!9,99))))/4),1500,a.ar+1)}

// 21.02.13
play{a=Pulse;d=Splay.ar(a.ar(Duty.ar(c=a.ar(b=(6..1),b/7.5)/8+1,0,Dseq(b*c+c.lag3(9)*66,inf))))/9;d+GVerb.ar(d.mean,25,25)}

// 13.03.13
play{BPF.ar(SinOsc.ar(Duty.ar(1/300,0,Dseq([Dseq([a=1270,b=2225],2e2),Drand([[1070,a],[2025,b]],[1e3,2e3])],inf))),1500,3)}

// 15.03.13
play{a=LFTri.ar(1/[8,7]).abs;CombC.ar(Pulse.ar(Duty.ar(a+0.1/9,0,Dseq([Dshuf((1..9)*99,7),3e3],inf)).lagud(*a/6),a),1,a,5)}

// 23.03.13
fork{999.do{|i|unixCmd("afplay -v"+5.0.rand+" -r"+(9.rand+1)+Platform.resourceDir+/+"sounds/a11wlk01.wav");wait(0.5.rand)}}

// 02.04.13
OSCFunc({|m|a.set(\f,m[4]-0.555%4)},'/');a=play{|f=55|SendPeakRMS.kr(x=SinOsc.ar(f.lag(5)*[155,555]*f,5**f),9*f,5,'/');x/5}

// 28.04.13
play{a=LFTri;CombN.ar(VarSaw.ar(Select.kr(a.kr(1/[7,8])*a.kr(1/9,0,99),(60..79).midicps),0,a.kr(1/[3,4])%1),1,1/[5,6],8)/4}

// 28.04.13
play{a=SinOsc;CombN.ar(a.ar(Select.kr(a.kr(1/[8,7])*a.kr(1/30,0,9),(56,62..98).midicps),0,a.ar(1/[4,3])),1,1/[6,5],9).tanh}

// 28.04.13
play{a=LFPar;BLowPass.ar(a.ar(Select.kr(a.kr(1/[3,4],0,64*a.kr(5)),(60..67).midicps)),a.kr(0.04)+5*500,a.kr(1/[5,6])+1.01)}

// 28.04.13
play{a=SinOsc;a.ar(a.ar(1/[8,12])>0.9+1*[400,404],InFeedback.ar([1,0]).lagud(a.ar(b=1/(1..6)).mean,a.ar(b*1.25).mean)*4pi)}

// 28.04.13
play{a=SinOsc;a.ar(a.ar(4)>0.2+1*[99,98],InFeedback.ar([1,0]).lagud(a.ar(0.1).abs/5,a.ar(a.ar(1/99)).abs)*a.ar([301,303]))}

// 29.04.13
play{a=SinOsc;a.ar(a.ar(1/[8,9])*4+[400,202],CombC.ar(InFeedback.ar([1,0]).lagud(a.ar(1/9)+1/88,a.ar(1/8)+1/99),1,0.08,9))}

// 30.04.13
play{a=SinOsc;c=HPF.ar(a.ar([1,4/3],HPF.ar((1..9).sum{|x|Pan2.ar(a.ar(1/x)>0.5,a.ar(666/x))},5)),5);GVerb.ar(c,99,9)/7+c/4}

// 30.04.13
play{a=LFTri;distort(LeakDC.ar(a.ar(LeakDC.ar((1..9).sum{|x|Pan2.ar(a.ar(1/x)>0.51,a.ar(a.ar(x+1)*9.99+1200/x))})*4e3))/9)}

// 30.04.13
play{a=LFTri;RLPF.ar(LeakDC.ar(a.ar(LeakDC.ar((1..9).sum{|x|Pan2.ar(a.ar(1/x,x/3)>0.3333,a.ar(666/x))})*999)).distort,3e3)}

// 30.04.13
play{a=SinOsc;LeakDC.ar(a.ar(LeakDC.ar((1/[1,2,4,3,9]).mean{|x|Pan2.ar(a.ar(x*9)>0.6,a.ar(a.ar(x/9)+a.ar(x)*666))})%1*4e3))}

// 30.04.13
play{a=SinOsc;LeakDC.ar(a.ar(LeakDC.ar((1/(1,3..9)).mean{|x|Pan2.ar(a.ar(x)<a.ar(x*9),a.ar(a.ar(x/3)*3e3))})%0.5-0.25*2e3))}

// 01.05.13
{|k|play{a=SinOsc;Mix({|i|LeakDC.ar(Pan2.ar(a.ar(1/9+i,0,j=a.ar(i+1/99)),a.ar(i+1+k*(j.ceil*39+39),a.ar(k+2),j)))}!9)/3}}!2

// 02.05.13
play{a=SinOsc;HPF.ar(a.ar(HPZ1.ar(Amplitude.ar(InFeedback.ar(0,2)*9,0,a.ar(2)%1/6)*8e3),Decay2.ar(a.ar(0.5005)>0.93)),9)/2}

// 11.05.13
play{a=LFSaw;Splay.ar(RLPF.ar(Blip.ar(Duty.ar(1,a.ar(a.ar(1)*9+99),a.ar(7)>(a.ar(12)*0.3+0.6)*8+9),17),(1..12)*99,6e-3))/4}

// 11.05.13
play{a=LFSaw;mean({|i|Ringz.ar(Blip.ar(a.ar(i+1/[3,4])>(a.ar(i+1/8)+1)*25+50,i+[2,3])*a.ar(i+1/50,i/25),i+1*99,0.1)}!50)/5}

// 13.05.13
play{a=Pulse;a.ar(a.ar(a.ar(1,b=(1..8)/9,9,8e3),a.ar(2/3,1/9).lag(a.ar(1)*9),a.ar(b/9,0.6,9,99),250),b/(a.ar(4)+4)).mean!2}

// 13.05.13
play{a=Pulse;a.ar(a.ar(a.ar(1,b=(1..8)/9,99,9e3),a.ar(b,0.4).lag(2),a.ar(0.2*b,0.1,9,99).lag(1),300),b/(a.ar(4)+4)).mean!2}

// 14.05.13
play{a=LFSaw;b=a.ar(1/64)*8+9;Splay.ar({|i|a.ar(round(a.ar(i+1/32/b,i/40)+1**2*2e3+50,50),0,a.ar(i/16/b,i/48).min(0))}!64)}

// 17.05.13
play{a=LFTri;b=a.ar([199.99,200]);BPF.ar(b+DelayC.ar(b+a.ar(399.9),1,a.ar(1/99,[0,0.05])/99),999,0.1,5)};s.scope(2).style=2

// 23.05.13
play{a=LFPar;Splay.ar({|i|Pluck.ar(GrayNoise.ar(a.ar(i=i+1)),a.ar(i/2)%a.ar(i/3/2),1,i*pi/3e3,3,a.ar(i/9,i,0.499,0.5))}!6)}

// 25.05.13
play{a=LFTri;LFPulse.ar(a.ar(Duty.ar(1/8,0,Dswitch([Dseq((1..8),4),Dseq([60,1,2],[4,3])]/2,Dseq([0,1],99))*99),0,3e3,300))}

// 18.06.13
play{Mix({|i|BPF.ar(a=Pulse;a.ar(i+[50,a.ar(1/16).lag2(i)+2*99]@@i,a.ar(j=i+1)*a.ar(j)+a.ar(1/12).lag3(10)),j*500)}!8)/3!2}

// 18.06.13
play{Splay.ar({|i|HPF.ar(a=Pulse;a.ar(a.ar(i+4/32).lag3(0.1,8-i)+1*99,a.ar(j=i+1)*a.ar(i+8/j)+a.ar(8/j).lag3(8)),50)}!8)/2}

// 13.07.13
play{l=LocalBuf(b=1e4,2);{|i|BufWr.ar(a=LFTri.ar(i+1*[8,19.2]),l,a/[i+1]*b)}!3;LPF.ar(PlayBuf.ar(2,l,1/9,1,0,1).clip2,b)/2}

// 13.07.13
play{l=LocalBuf(b=3e3).clear;{|i|BufWr.ar(LFTri.ar(i+1*99),l,LFSaw.ar(i).lag(LFSaw.ar(1/9)+1)*b)}!6;PlayBuf.ar(1,l,loop:1)}

// 13.07.13
play{a=LFTri;l=LocalBuf(b=600,9).clear;BufWr.ar(a.ar(c=(3..11)*3.5),l,a.ar(9/c,c/99)*b);Splay.ar(PlayBuf.ar(9,l,loop:1)/2)}

// 14.07.13
play{a=LFTri;l=LocalBuf(c=99,20).clear;RecordBuf.ar(a.ar(c=(1..20)),l);GVerb.ar(HPF.ar(IndexL.ar(l,a.ar(c/45)).sum,9)/9,1)}

// 14.07.13
play{f=LFCub.ar(_);e=f*16+16;BufWr.ar(PanAz.ar(c=32,f.(4.008),f.(9)),l=LocalBuf(c,c),e.(4));Splay.ar(BufRd.ar(c,l,e.(99)))}

// 14.07.13
play{f=LFPar.ar(_);e=f*31+31;BufWr.ar(PanAz.ar(c=64,f.(5.04),f.(3)),l=LocalBuf(c,c),e.(1));Splay.ar(BufRd.ar(c,l,e.(200)))}

// 14.07.13
play{f=LFTri.ar(_);e=f*4e3+4e3*f.(1.2).abs;BufWr.ar(f.([3,4]),l=LocalBuf(8e3,2).clear,e.(1/9));COsc.ar(l,99,f.(1/[7,8]))/4}

// 21.07.13
play{o=CombC.ar(Limiter.ar(HPF.ar(LocalIn.ar(2),9)+Impulse.ar(1/3,1/[4,5])),4,LFTri.ar(0.02)*1.9+2,9,0.9);LocalOut.ar(o);o}

// 22.07.13
a=SinOsc;Ndef.clear.new(\,{a.ar(b=[98,99],Ndef.ar(\).lag3(Ndef.ar(\)%2/b),a.ar(1/b))});Ndef(\y,{a.ar(b+1,Ndef.ar(\))}).play

// 27.07.13
play{a=SinOscFB;Splay.ar({|i|Pan2.ar(a.ar(a.ar(b=1.995**i,0.5/b)+(a.ar(2/b,a.ar(b))*999),a.ar(b*1.01)),a.ar(pi/b,2))}!9/4)}

// 29.07.13
play{a=LFTri;b=[3,4,8];Splay.ar(Formlet.ar(a.ar(b*99+99),a.ar(b).round(a.ar(0.05).round(1/3))*99+200,1,a.ar(b/6.011)%1)/9)}

// 29.07.13
play{a=SinOsc;b=(4.002,9..99);mean(Pan2.ar(c=a.ar(b),c))>mean(a.ar(d=1/99)/b)*Splay.ar(a.ar(b%round(a.ar(d/b*8,b,12))*99))}

// 29.07.13
play{a=LFTri;b=(1..9).pyramid;LeakDC.ar(Pan2.ar(a.ar(d=6.01/b),a.ar(99*b),a.ar(d)%1)+Ringz.ar(a.ar(d)<d,60,0.07)).sum.tanh}

// 29.07.13
play{b=(1,3.075..16);a=SinOsc;GVerb.ar(Splay.ar(a.ar(1/b,3*a.ar(b*Duty.ar(b,0,Dseq(b+23,inf).midicps).lag(2))).tanh/5),90)}

// 27.08.13
a=SinOscFB;play{LeakDC.ar(Splay.ar(RHPF.ar(PinkNoise.ar(a.ar(b=1/(1..32),b)),a.ar(a.ar(b,b),1.35)+1/b*50,0.009,b))).tanh/2}

// 02.09.13
{|i|Pmono(\default,\dur,Pseq(1/[i=i+0.999,Pn(Pseq(b=(2..8)*i),Pseq(b))],inf),\amp,1/b,\freq,Pseq([b,b*i/4]*99,inf)).play}!8

// 16.11.13
play{a=SinOscFB;c=a.ar([50,99],0.4);RecordBuf.ar(InFeedback.ar(0,2)+c/3,b=LocalBuf(8e4,2).clear);BufRd.ar(2,b,a.ar(c)*6e4)}

// 19.11.13
play{c=CombN.ar(InFeedback.ar(0,2),1,1/8,2.4,1.4);LeakDC.ar(SinOscFB.ar(Pitch.kr(c).flop[0]-0.2+(d=c.abs.lag(0.032)),1-d))}

// 19.11.13
play{a=SinOscFB;a.ar(Pitch.kr(CombN.kr(InFeedback.ar([1,0]),1,1/[2,3])).flop[0]*a.ar(1/[3,4],0.1,0.3,1.2),a.ar(1/[4,5])/2)}

// 19.11.13
play{a=LFPulse;a.ar(Pitch.kr(CombN.ar(InFeedback.ar([1,0]),4,4,8)).flop[0]*a.ar([6,3],0,a.ar(1.99)/8+0.3,1.2),0,a.ar(1)/2)}

// 19.11.13
play{a=SinOsc;LeakDC.ar(a.ar([1,2],a.ar(Pitch.kr(CombN.ar(InFeedback.ar([1,0]),5,[4.8,4.7])).flop[0]-4)*2pi*a.ar(1/16)))/2}

// 22.11.13
play{CombC.ar(BLowPass.ar(Limiter.ar(LeakDC.ar(InFeedback.ar([1,0]))),2e3)+Impulse.ar(0),1,LFTri.ar(1/[6,8])*0.4+0.5)*0.99}

// 25.11.13
play{a=LFTri;BufWr.ar(a.ar(b=[303,404]),l=LocalBuf(64,2).clear,a.ar(b*a.ar(99/b)));BufRd.ar(2,l,a.ar(b+2)*a.ar(0.01)*12)/4}

// 25.11.13
play{a=LFTri;Splay.ar(Pulse.ar(b=(101,202..1010)/2,RHPF.ar(a.ar(99/b)*0.9%1,a.ar(9/b,b).linexp(0,1,4,1e4),a.ar(5/b)+1.5)))}

// 26.11.13
30.do{|i|play{b=13.fib;Resonz.ar(Splay.ar(Blip.ar(i+1/b,19)*ClipNoise.ar),i*[50,60]+400,LFTri.ar(1/[20,30]*i,i/9)/9+0.13)}}

// 26.11.13
play{GVerb.ar(Splay.ar(SinOsc.ar(0,Blip.ar(a=(1..5),99)*99,Blip.ar(a+2.5,a).lag2(LFSaw.ar(1/(a+2.25),2/a)+1)))/3,99,6,0.7)}

// 26.11.13
play{a=SinOsc;c=a.ar(0,a.ar(b=[2,3])*400,a.ar(b/4.1));c+a.ar(b*99*Amplitude.ar(c,0,1/7))+GrayNoise.ar(CombN.ar(c,1,b/3))/2}

// 27.11.13
play{b=(1..4);Splay.ar(CombN.ar(SinOsc.ar(1/b,Spring.ar(LFPulse.ar(pi/b),99*b,1.3e-3)*LFTri.ar(0.13/b,0,pi,2pi)),1,1/4,2))}

// 27.11.13
play{a=LFCub;b=(1..8);sum(CombN.ar(SinOsc.ar(c=2/b,a.ar(ceil(a.ar(c)*a.ar(1/b,0,75)).round(75),0,a.ar(0.1/c)*9)),1,1/5))/9}

// 03.12.13
a=LFTri;Ndef(\a,{CombC.ar(Ndef(\).ar,1,a.ar([2,3])/8+0.2,8)+8&(a.ar(1/[3,2])*7)});Ndef(\,{a.ar(Ndef(\a).ar*[99,199])}).play

// 04.12.13
a=LFPar;play{Out.ar(5,a.ar(1)|a.ar(5)+RLPF.ar(x=Pan2.ar(InFeedback.ar(5),SinOsc.ar(5.5)),3e3,a.ar(1/25)/2+1.7));x*a.ar(99)}

// 04.12.13
SynthDef(\,{|f|Out.ar(0,LFPar.ar(f)*EnvGate()!2)}).add;PmonoArtic(\,\legato,c=Pn(Pshuf(6/8.fib,8)),\dur,c/22,\f,400/c).play

// 04.12.13
{|i|SynthDef(i,{|f|Out.ar(i,Saw.ar(f)*EnvGate())},0.123456).add;Pmono(i,\dur,c=Pn(Pshuf(i*4+4/8.fib,8))/20,\f,15/c).play}!2

// 12.12.13
play{a=LFTri;b=(1..8)+0.505;Splay.ar(a.ar(a.ar(1/(101-b))+1*99|a.ar(a.ar(1/b,1/b,pi,a.ar(1/b)+9)/b,1/b,404,404))*3).tanh/2}

// 13.12.13
play{a=LFTri;b=(1..5);Splay.ar(a.ar(b*99+round(a.ar(2/b)*40,40),b,a.ar(a.ar(0.5/b),b,a.ar(1/b,b,a.ar(2**b,b,pi)))).asin)/2}

// 13.12.13
play{a=SinOsc;GVerb.ar(a.ar(1+round(a.ar(0.01),c=[1,2]/3)*99*round(a.ar(c/2)+2))*a.ar(a.ar(c))*a.ar(c/4,0,a.ar(1/c)),99)/4}

// 20.12.13
play{Splay.ar(Formant.ar(RLPF.ar(Blip.ar(b=[4,0.5,8,16],LFSaw.ar(1/b,0,c=99,c),c,64),c,SinOsc.ar(b,b,0.5,0.6)).midicps,c))}

// 29.12.13
play{c=LFTri;mean({|i|Splay.ar([a=Saw.ar(i/98+99),DelayC.ar(a,2,c.ar(i/97+c.ar(i+1/(c.ar(i/96)*2e3+2e3),i/9,9))+1),a])}!9)}

// 30.12.13
play{c=SinOsc;mean({|i|Splay.ar({|j|CombC.ar(c.ar(j+1*99),1,c.ar(a=i*2+j/12)/2+0.5)*c.ar(i+j*99+99)*c.ar(a/3)}!8)}!8).tanh}

// ------------------------------------------------------------------------------------------------------------------------
