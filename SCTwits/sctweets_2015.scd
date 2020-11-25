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
// 12.03.15
play{a=LFPulse;f=SinOsc;b=a.ar(a.ar(4/3)*4).lag2(0.01);Splay.ar(f.ar(d=lag(99**b*a.ar(c=2/(6..9))))+f.ar(d*b/c,b*d,1-c))/4}

// 29.03.15
play{a=LFSaw;Splay ar:HPF.ar(MoogFF.ar(a.ar(50*b=(0.999..9))-Blip.ar(a.ar(b)+9,b*99,9),a.ar(b/8)+1*999,a.ar(b/9)+1*2),9)/3}

// 29.04.15
play{a=LFPulse;b=(1..9);Splay.ar(CombN.ar(a.ar(b*99*a.ar(b)).reduce('&'),2,2/b,2))+BPF.ar(a.ar(4)*4,a.ar(2)+[1,2]*99,0.12)}

// 06.05.15
play{Splay.ar(CombC.ar(PinkNoise.ar(Ringz.ar(LFSaw.ar(b=(1..9)/16),b*999,1.25)),1,1/(b*999)*(LFTri.ar(b/120,b*2)%1),3))/99}

// 10.05.15
play{a=LFSaw;Splay.ar(Pluck.ar(a.ar(30*c=(5..7))*a.ar(b=1/[25,14]),a.ar([3,2]),0.02,a.ar(c/66)+1/7,9,a.ar(1/c)%1,3).sin)/2}

// 23.06.15
a=SinOsc;play{CombC.ar(a.ar(Duty.ar(1/b=[4,3],0,Dseq(9.fib.pyramid*99,inf)))*a.ar(b/9),1.01,a.ar(b/999).abs+0.01,9).tanh/2}

// 28.06.15
play{a=LFTri;Splay.ar(a.ar(Duty.ar(b=1/[1,4,6,8,11],c=a.kr(b/98),Dseq(Select.kr(a.kr(b/99)+c*5,1/b+59),inf).midicps)+c)/2)}

// 28.06.15
play{a=LFPulse;Splay.ar(a.ar((99*b=[1,4,5,8])*lag(a.ar(a.ar(4/b)+a.ar(9-b/9)*50))+b)/2)+Mix(GrayNoise.ar(a.ar(b,0,0.1))/9)}

// 01.07.15
play{a=SinOsc;Splay.ar(a.ar(CompanderD.ar(Duty.ar(c=a.ar(b=(1,3..13),b,b,b),0,Dseq(b,inf)),5,4,3,c)*99,a.ar(b*9)*9,2)).sin}

// 04.07.15
play{a=LFTri;BufWr.ar(e=a.ar(12/c=1/(9..5)),b=LocalBuf(4e4,5).clear,a.ar(e%c)*1e5,0);Splay.ar(BufRd.ar(5,b,a.ar(1)*1e4,0))}

// 10.07.15
r{inf.do{|i|a=play{Duty.ar(3e-3*[b=i%99/99,1-b],0,Dseq(i.asInt.asDigits(2,8),8))*Saw.ar(99+[b,0])/2};0.2.wait;a.free}}.play

// 19.07.15
play{a=LFCub;Splay.ar(Limiter.ar(Formlet.ar(Logistic.ar(3.9,b=(7..4)),a.ar(b)+a.ar(b/7)*800+999,c=a.ar(b/99)%1/50,c*2)/9))}

// 26.08.15
play{a=LFTri;Splay.ar(CombC.ar(a.ar(Duty.ar(b=0.11/(1..6),0,Dseq(" #SuperCollider ".ascii.midicps,inf))),4,a.ar(b/9)%a.ar(b)*4%4,5)/6).tanh}

// 27.08.15
play{a=SinOsc;Splay.ar(a.ar(Shaper.ar(' #SuperCollider '.ascii as:LocalBuf,Blip.ar(0.011,c=(2..4)),a.ar(a.ar(c)>0*a.ar(1/c)>0*99))*c)).tanh}

// 01.09.15
play{a=LFTri;b=Splay.ar(Decay2.ar(a.ar(c=' #SuperCollider '.ascii),a.ar(1/4)%0.2,a.ar(3/c)%1/99,a.ar(3*c)/9).sin)/15;b+GVerb.ar(b,99,4,0.9)}

// 03.09.15
play{a=LFSaw;Splay.ar(a.ar((c=(1..9)/8)**a.ar(c,c,1,a.ar(0.21)%1).reduce('bitXor')*Duty.ar(4,0,Dseq([33,10,40]*9,inf))))/4}

// 04.09.15
play{a=LFSaw ar:_;sum({|i|Pan2.ar(a.(a.(i+1/99)/9+1.25**i*9+99),a.(i+1/98))}!23)/6+LPF.ar(a.(a.(0.009)*9)>0*a.([50,51]))/4}

// 05.09.15
play{a=LFSaw;Pan2.ar(AllpassC.ar(a.ar(1/c=(1..9))>0.9*a.ar((d=a.ar(0.075))>0/3+1*c*99),1,c/9,d*4+4),a.ar(1/c/9)).sum.lag*8}

// 23.09.15
play{a=LFPulse;CombC.ar(DynKlank.ar(`[midicps(a.ar(1/b=(1..9)*1.5)*b+50),2e-4,b/9],e=a.ar(d=[2,3]/.t b)),2,2-LPF.ar(e,50))}

// 30.09.15
r{inf.do{|i|j=i.div(100)+1;x={Splay.ar(Blip.ar(i*j%(99..96)+1,i*j%(98..95)+1))*5}.play(s,0,6);0.12.wait;x.release(8)}}.play

// 06.11.15
play{a=LFTri;Splay.ar(a.ar((b=(d=a.ar(0.1)<0)+(2..8)/(d+2))*99)+Ringz.ar(a.ar(b/2)>0,b*99,5**a.ar(a.ar(0.01)+2-b)/4)).tanh}

// 10.11.15
play{a=Blip;b=a.ar([6,5]/2).round(a.ar(1.01))%1;HPF.ar(b+AllpassC.ar(PitchShift.ar(b,1,2,c=0.03),2,a.ar(c,[2,3])/2+1,3),9)}

// 10.11.15
play{a=LFSaw;AllpassC.ar(Mix(a.ar(Latch.ar(a.ar(1.50055,[0,5e-4]!2),a.ar([15,4,2]))*[999,400,150]))/4,3,2-a.ar(0.1,[0,1]))}

// 22.11.15
play{a=SyncSaw;GVerb.ar(Limiter.ar(HPF.ar(Mix(a.ar(99*b=(1..8),b*2.01)%a.ar(b/64,a.ar([4,8,14],b/4)+1).max(0)),9))/2,70,4)}

// 23.11.15
r{inf.do{|i|play{MoogFF.ar(SyncSaw.ar([7,8],[5,10,12,20,24]*10@@(i*2)),4e3*e=Line.ar(0,pi,10,1,0,2).sin)*e/3};1.wait}}.play

// 23.11.15
play{a=SinOsc;c=a.ar|a.ar(1,[0,a ar:1e-4],2);Splay ar:HPF.ar(c+CombC.ar(RLPF.ar(c,b=12.fib*112,0.01),3,a.ar(2/b)+2,5)/4,9)}

// 24.11.15
play{a=SinOsc;CombN.ar(a.ar([0,1],a.ar(Duty.ar(c=0.5/b=2.1,0,Dseq(3*' #SuperCollder 0'.ascii,inf)))*a.ar(0.01)*4,a.ar(b,b)<0),1,c*3,9).tanh}

// 24.11.15
play{a=VarSaw;CombN.ar(tanh(a.ar(99*b=[6,9])*3+a.ar(a.ar(0.39/b)>0+1*50,0,a.ar(1/27),a.ar(1/3)*18)+(a.ar(3)>0*9)),1,1,4)/2}

// 24.11.15
play{a=LFSaw;(c=HPF.ar(a.ar(b=1/16)+a.ar(b/4)+a.ar(b/3)*9|(e=a.ar(b,d=[0,1])*99),9,e/9).sin)+PitchShift.ar(c,b,e>>5%2+1)/3}

// 02.12.15
play{a=Blip;a.ar(c=a.ar(a.ar(1.23,4.5),6,7,8.9)+a.ar(0.123,[4,5],67,8))*a.ar(a.ar(1,[2,3],4,5),6)+a.ar([7,8]*9,1/c*23.4)/5}

// 02.12.15
play{a=Blip;a.ar(c=a.ar(9.87,6/5,4,[3,2])>a.ar(8/76,5/432,a.ar([7,6],5.4,3,2),1))*a.ar(a.ar(6,5,4,3),2)>a.ar([5,4],3210/c)}

// 07.12.15
play{a=SinOsc;RLPF.ar(a.ar(c=Duty.ar(0.1,0,Dseq((0!9++' #SuperCollider '.ascii.midicps).pyramid(10),inf)),a.ar(c.lag(1/[33,99]))*6),3500)/2}

// 09.12.15
play{a=LFPulse;CombN.ar(Splay.ar(a.ar(a.ar([1,3])+a.ar(1/[20,30])+a.ar(1/b=[8,9])+a.ar(a.ar(1/12,1/3)*99*b)*(1..5)*50)/2))}

// 11.12.15
play{a=SinOsc;c=Decay2;CombN ar:a.ar(a.ar(b=(1..6)).sum*9+99,sum(c.ar(t=a.ar(10/b).sum>[1,2]*a.ar)*b),c.ar(t,0.02,0.2))/20}

// 14.12.15
play{a=LFSaw;SelectXFocus.ar(a.ar([9,99]*c=a.ar(9**a.ar(9)*99))*9,a.ar(Sweep.ar(a.ar((1..9)),c)*9e4%9e2),a.ar(1/9)/9).tanh}

// 18.12.15
play{a=Saw;GVerb.ar(a.ar(25*b=(8..2))).mean.lag2(c=LFSaw.ar(a.ar([33,99])+2)+1/99)+mean(a.ar(8/b,a.ar(b))|a.ar(c+2)).sin/3}

// 19.12.15
play{a=LFTri;Splay.ar(a.ar(1/99)*sin(LPF.ar(Pulse.ar(2,a.ar(b=a.ar(1e-4)+1/(8..2))),500,a.ar(b/3)+1*8))%sin(a.ar(4))).tanh}

// 24.12.15
play{a=SinOsc;(d=Splay.ar(a.ar(c=a.ar(b=(1..6)/2).div(4/b)+(e=a.ar(b/99)*2+3).round*99)).sin)+a.ar(c*1.5,e/d,0.7/e).mean/2}
