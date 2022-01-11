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
// 18.02.11
play{a=LFPar;GVerb.ar(VarSaw.ar(a.ar(1,0,5,a.ar([0.05,0.04],0,50,160).round(50)),0,a.ar(0.2,0,0.5,a.ar(3,0,0.2,0.5)))/8,80)}

// 05.04.11
x=0;{|i|Pbind(\dur,i+1/4,\lag,i/6/6,\octave,i+3,\legato,i+1/6,\degree,Pn(Plazy{x=x+1%6;Pseq(asDigits(x+1*142857))})).play}!6

// 08.04.11
{Splay.ar({|i|l=LFTri.ar(1/6,i/1.5,2.5,3.5).round;SinOsc.ar(142.857*l,lag(l,i-3/6),1-poll(0.142857*l,10/6,"\t\t"))}!6)}.play

// 04.06.11
f=0;{inf.do{|i|f=f+log2(2*i%6+1+floor(f)/(i%5+1))%2;play{SyncSaw.ar(2**f*99+[0,1],i%8+2*52)*Line.kr(0.1,0,1,1,0,2)};0.3.wait}}.r.play

// 14.09.11
play{f=LFPar.ar(1/14).round*20+80;Splay.ar(LFPar.ar({|i|[i+1*f,i*f+(i+1/3)]}!4)>BrownNoise.ar(Pulse.ar({|i|i+1}!4,0.35))/3)}

// 24.09.11
play{x=CombN.ar(Phasor.ar(0,{|i|i+1/20}!22),0.042,0.042);y=Phasor.ar(LPF.ar(x,LFPar.ar(1/99,0,400,500)),x);Splay.ar(y)*0.25}

// 24.09.11
play{x=CombC.ar(Phasor.ar(0,{|i|i+1/4}!5),0.2,LFPar.ar(0.09,0,0.05,0.1).round(0.022));Splay.ar(Phasor.ar(BPF.ar(x,50),x)/4)}

// 25.09.11
play{Splay.ar({|i|SinOsc.ar(i+SinOsc.ar(0.01,a=pi/[2,4,8]@@i,0.1,1)*80+SinOsc.ar(i+1*1e-4+i),a,SinOsc.ar(i+1*1e-3,a)/4)}!9)}

// 17.10.11
play{x = PinkNoise.ar(0.1!2);x+FreqShift.ar(x, [0.15,0.1501])}

// 06.11.11
p={|x,a,f|9.do{x=BAllPass.ar(x*a,f).tanh};x};play{p.(Dust.ar(XLine.kr(1e4,0.01,5)*XLine.kr(0.001,1,0.8)),1.2,50)/2+p.(Impulse.ar(0),2,40)!2}

fork{{play{LPF.ar(PinkNoise.ar,100)*Pulse.ar(XLine.kr(2000,1500,2))*EnvGen.kr(Env.triangle(2),1,1,0,1,2)!2};2.0.rand.wait}!20}

// 19.11.11
play{a=LFCub;n=8;Splay.ar(a.ar({|i|pow(i+1,a.kr(1/n,i/n,1/n,1))}!n*150,0,a.kr({|i|pow(i+1,a.kr(i+0.5/n,i/n))}!n).max(0))/4)}

// 27.11.11
play{PingPong.ar(LocalBuf(3e4,2).clear,Ringz.ar(CuspN.ar*Impulse.kr([9,8]/12)/9,LFPar.kr(1/[3,2]).range(51,[99,17])*9),0.5)}

// 30.12.11
play{a=SinOsc;Splay.ar({|i|i=i+1;a.ar(a.ar(i)+1**a.ar(2**a.ar(i/500)*(9-i))*a.ar(9*i).exprange(90,2**a.ar(i/20)*800))}!5)/4}

// -------------------------------------------------------------------------------------------------------------------------
