// Boot
// increase this if "alloc failed" messages

s.options.memSize = 8192 * 256;
s.boot;
s.quit;
s.meter;
s.scope;
FreqScope.new;
s.plotTree;

// ---
// 28.03.09
{a=PinkNoise.ar(1!2);50.do{a=BBandStop.ar(a,LFNoise1.kr(0.05.rand).exprange(40,15000),exprand(0.1,2))};LPF.ar(a,1e5)}.play

// 28.03.09
{a=LFTri.ar(1);20.do{a=BAllPass.ar(a,80,1);a=((a+0.02)*LFNoise0.kr(1/2)*8).tanh;a=LeakDC.ar(a,0.995)};a*0.1!2}.play

// 28.03.09
p={|f,a=1|LFPulse.ar(f)*a*[1,1.01]};{p.(p.(100-p.(1/16,20))+p.(2,1+p.(1/4))-0.5*200)+p.(100-p.(1/8,20),p.(8))*0.1}.play

// 29.03.09
{LocalOut.ar(a=CombN.ar(BPF.ar(LocalIn.ar(2)*7.5+Saw.ar([32,33],0.2),2**LFNoise0.kr(4/3,4)*300,0.1).distort,2,2,40));a}.play

// 30.03.09
d={|l,h,f,p|({Ringz.ar(LFPulse.ar(f,p,0.01),exprand(l,h),0.5)}!20).sum};{d.(50,100,2,[0,1/4])+d.(3e3,1e4,4,0)+d.(2e2,3e3,1,0.5)*3e-4!2}.play

// 31.03.09
d={|l,h,f,p,n|sum({Ringz.ar(LFPulse.ar(f,p,0.01),exprand(l,h).round(n),0.5)}!20)};{d.(50,150,[2,1,1],[0,1/4,3/4],[1,40,50])*3e-4!2}.play

// 31.03.09
x=LFPulse;d={|l,h,f,p,n|sum({Ringz.ar(x.ar(f,p,0.01),exprand(l,h).round(n),0.6)}!40)};{d.(30,150,2,[0,0.3],[1,x.kr(1/8)*10+40])*3e-4!2}.play

// 31.03.09
n={|r,f,d=1|2**LFNoise0.kr(1!d,r)*f};{p=n.(4,1e3);CombN.ar(Ringz.ar(LFPulse.ar(1,0,0.01),n.(2,p,80),0.6).sum,8/5,8/5,60)*4e-4!2}.play

// 05.04.09
play{p=PinkNoise.ar(1!2);BRF.ar(p+Blip.ar(p+2,400),150,2,0.1)+LPF.ar(FreeVerb2.ar(*LPF.ar(p+0.2*Dust.ar(0.1),60)++[1,1,0.2,1e4]).tanh,2000)}

// 05.04.09
Ndef('x',{Normalizer.ar(FreqShift.ar(Rotate2.ar(*Ndef('x').ar++1/8).tanh,20*[-3,0.995])+Dust.ar(1!2,0.005),1,0.5)}).play

// 05.04.09
Ndef(\x,{DelayN.ar(BRF.ar(Saw.ar(20!2)*0.01+Rotate2.ar(*(Ndef(\x).ar*2).tanh++0.1),20**LFNoise1.kr(0.6)*500,1),1,1)}).play

// 06.04.09
b=Buffer.read(s,"/home/depps/Musique/Samplz/Dirts/:::");play{t=Impulse.kr(5);PlayBuf.ar(1,b,1,t,Demand.kr(t,0,Dseq(1e3*[103,41,162,15,141,52,124,190],4)))!2}

// 08.04.09
Ndef('x',{x=Ndef('x').ar+0.01;a=BPF.ar(x,6**Latch.ar(x,Dust.ar(x))*200,0.1).sin;9.do{a=AllpassN.ar(a,0.2,{0.2.rand}!2,9)};a+a.mean}).play

// 02.08.09
a=1@2;f=1;w=Window().front.drawHook_({900.do{Pen.line(a*200,(a=(a*(f=f+2e-6)).y.cos+1@a.x)*200)};Pen.stroke});AppClock.play{w.refresh;0.01}

// 07.08.09
p={|f,a=5|GVerb.ar(LFPulse.ar(f)*a)+f};play{tanh(HPF.ar(p.(99-p.(1/2,20)*(1+p.(2,1/5))+p.(4+p.(1/2)),0.5),80,XLine.kr(4e-4,1/8,61,1,0,2)))}

// 21.08.09
Ndef(\,{Limiter.ar(x=LeakDC.ar(Ndef(\).ar)+Impulse.ar(0);x-DelayC.ar(x=x.sum/8,1,1/Tartini.kr(x)[0].lag(1.5)),0.5,0.02*[1,1.1])}).play

// 23.08.09
t=LFTri;play{RLPFD.ar(Trig1.ar(SinOsc.ar(1/8)+1*1.5*t.ar([800,801])+t.ar(1e3),t.ar(1/2).range(1e-4,1/180))*2,2**t.ar(1/[3,4])*1200,0.3,0.6)}

// 27.08.09
Pbind(\dur,0.3,\sustain,1.5,\k,Pstutter(16,Pfunc{rrand(4,10)*10}),\freq,Pfunc{|e|exprand(50,500).round(e.k)},\amp,Pgbrown(0.01,0.1)).play

// 06.12.09
Ndef(\,{LPF.ar(x=DelayN.ar(LeakDC.ar(Ndef(\).ar,1-2e-7)*0.99,1,0.1)+Dust.ar(0.5!2);x+(Trig1.ar(x<(x.mean.lag(30)),4e-3)*0.05),800)}).play

// 06.12.09
Ndef(\,{LPF.ar(x=DelayN.ar(LeakDC.ar(Ndef(\).ar,1-2e-6)*0.99,1,0.01)+Dust.ar(0.5!2);x+(Trig1.ar(x<(x.mean.lag(30)),4e-3)*0.05),800)}).play

// 06.12.09
Ndef(\,{x=DelayL.ar(n=Ndef(\);n.ar,2,LFNoise0.kr(0.03*_!20)+1)+Blip.ar(0.5);LeakDC.ar(LPF.ar(x+x.mean*0.15,4e3)).sin});play{Splay.ar(n.ar)}

// 08.12.09
play{w=LFSaw;a=w.ar(-3,1)+1/2;f=Sweep.ar(0,3).floor;f=(f**3+f%8+4)*(f%3+3)%49*3;CombN.ar(RLPF.ar(w.ar(f)*a,f**a*30,0.3).tanh,5/6,5/6,6)!2}

// 08.12.09
play{PitchShift.ar(CombN.ar(Formant.ar(101,4**LFNoise1.kr(0.5)*450,200),1,0.5,99),1,Duty.kr(4,0,Dseq([[6,8,10],[6,7.2,7]]/8,inf))).sum/25!2}

// 09.12.09
Ndef(\,{x=DelayN.ar(LeakDC.ar(Ndef(\).ar),1,z=1e-2);LPF.ar(Trig1.ar(Amplitude.kr(x,5,120)*1.5+x+z-Dust.ar(2),4e-3)*0.1+x*0.99,1200)}).play

// 09.12.09
play{b=LocalBuf(1e5,2).clear;x=BufRd.ar(2,b,Phasor.ar(0,1,0,1e5))*0.6;BufWr.ar(Blip.ar([1,1.01],10)/5+x,b,LFNoise1.ar(0.2)+1*5e4);x}

// 09.12.09
play{b=LocalBuf(4e5,2).clear;BufCombL.ar(b,LeakDC.ar(LPF.ar(PlayBuf.ar(2,b,16/15,0,0,1),300))+Blip.ar([20,21],1),2,40)/20}

// 17.12.09
play{x=Splay.ar({|i|RLPF.ar(0.6**i*40*Impulse.ar(2**i/32,1/2),4**LFNoise0.kr(1/16)*300,5e-3).sin}!8);2.do{x=FreeVerb2.ar(*x++[0.1,1,1])};x}

// 18.12.09
play{Splay.ar({|i|f=1.9**i/128;BPF.ar(PinkNoise.ar(1!2),4**LFNoise2.kr(1.2**i/16)*300,0.15)*(5**LFNoise2.ar(f)/(i+8)*20)}!15)}

// 19.12.09
play{x=Saw.ar([50,50.1]);8.do{|i|f=2**(8-i);x=BRF.ar(AllpassN.ar(x,1,0.1/(12-i),2),80**TRand.ar(0,1,Impulse.ar(f/32,1/2)).lag(1/f)*80,2)};x}
