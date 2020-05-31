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
// 02.01.17
play{a=SinOsc;Splay ar:a.ar(b=(1..7)/7,a.ar(b/77)+1*7**a.ar(777*b,77**a.ar(b+a.ar(b/77,a.ar(b)/7,77*a.ar(b/77,b,b*7)))))/2}

// 07.01.17
play{Splay ar:HPF.ar(BLowPass.ar(LFTri ar:c=[1,3,5,6],Duty.ar(c+1/16,0,Dseq(LFTri.ar(1/c/8)>0*3+c*99,inf)),1e-3)/12,9).sin}

// 09.01.17
play{a=SinOscFB;Out.kr(8,c=a.ar(1/4)>0*a.ar(3/4,1,99,199).round(20)+DelayN.ar(In kr:[9,8],2,2)%[72,64]);a.ar(c**2,c.lag%1)}

// 11.01.17
play{a=LFTri;Splay ar:CombC.ar(a.ar(2**a.ar(1/6**(1..6))*99)*Decay.ar(HPZ1.ar(a.ar(#[2,3])<0),c=a.ar(98)%1/3),2,c.lag+1,6)}

// 13.01.17
play{a=SinOsc;a.ar(0,a.ar(99,9**a.ar(1/8,lagud(a.ar(1/[2,12])<0*2**a.ar(a.ar(3)>0*150),1/50,1/5)*5))+a.ar(1/[6,7]),3).tanh}

// 15.01.17
play{a=SinOsc;Splay ar:a.ar(Slope.ar(SinOscFB.ar((5..1)/2**a.ar(1/(5..9)+1,99*c=a.ar(1/(9..5))).round(1.005)*99,c+1/2)))/2}

// 18.01.17
play{a=SinOsc;LocalOut ar:c=a.ar(99,LocalIn.ar(9)*a.ar((1..9)/99-98,0,a.ar(97/round(a.ar(1/32)+2.2).lag)*pi));Splay ar:c/2}

// 18.01.17
play{a=SinOsc;GVerb.ar(FreqShift.ar(c=a.ar([2,3]/8)%0.5,a.ar(1/[9,5]).round(c>0.125)+1*[3,2]*99).tanh/2,200,9,1,1,9,1,0.1)}

// 24.01.17
play{Ringz.ar(c=Spring.ar(TDuty ar:Dseq(b=[3,3,2,2,2,1,2,2,2]/3,inf))/9,50*Duty.ar(c+1/[6,3],0,Dseq(c.lag>0+[2,4]/b,inf)))}

// 05.02.17
play{a=SinOscFB;AllpassN.ar(a.ar(2**(a.ar([4,3])>0)*(a.ar(1/16)>0+2*(a.ar(1/[32,48])>0*20+99)),a.ar(1/63.9)+2/3),3,3,60)/3}

// 11.02.17
play{a=SinOscFB;Splay.ar({|i|Formant.ar(a.ar(i+1/150).round+1+i*99+a.ar([3,2]),b=i+2*99,b,a.ar(i+1/130).max(0)).tanh}!8)/3}

// 24.02.17
play{a=SinOsc;b=(9..1)*4.0015;Splay ar:a.ar(0,a.ar(2/b)*3+4**a.ar(a.ar(b/8)/2+(a.ar(1/33)>0+8*b))*6,4**a.ar(1/b,b)).tanh/2}

// 08.03.17
play{a=LFSaw;tanh(GrainFM.ar(1,a.ar([0.5,0.6]),16,a.ar(5)*a.ar(0.015)+1*98,round(2**a.ar(4),0.5)*99,2**a.ar(1/[8,9])*8)/2)}

// 09.03.17
play{RecordBuf.ar(BPF.ar(Saw.ar((d=LFSaw.ar(1/9))>0+1/3*99)+c=GrainBuf.ar(2,d,24,b=LocalBuf(3e4).clear,-2),99,4).mean,b);c}

// 11.04.17
play{a=Formant;Splay.ar(a.ar(a.ar(b=(1..12)/8,b/3.5+80,999-b/9)+3*50,a.ar(b/3,2.5,5)>0+1*300,a.ar(b/5,2,3)>0*1200)/3).tanh}

// 12.04.17
play{a=Pulse;Splay.ar({|i|i=2**i;Formant.ar(*{|j|j+5.5**a.ar(j+0.75/i).lag(0.12)+a.ar(1.3/i,1/3)*99}!3)*a.ar(4/i)}!8).tanh}

// 14.04.17
play{a=LFSaw;Splay.ar(Formant.ar(*[2**round(a.ar(b=1/(1..12)),a.ar(8,b)<0/4+1),4**a.ar(b/12)+2,3**a.ar(b/4)*3]*99)/2).tanh}

// 02.05.17
play{a=SinOscFB;AllpassN ar:a.ar(midicps(Duty.ar(c=a.ar(1/[12,8])+3/24,0,Dseq([0,8,5,1,5,4,5]*round(c*18),inf))+60),c*2)/2}

// 16.05.17
play{a=LFTri;e=a.ar(2**a.ar(1/5)).round(a.ar(1/8)/3);GVerb.ar(HPF.ar(SinOsc.ar(e**[99,150],BPF.ar(e%1,500))/6,9),99,5,0.1)}

// 29.05.17
play{a=LFSaw;Splay ar:SinOscFB.ar(round(2**a.ar(b=(1..8)/128)*256,64),c=a.ar(b)%1,RLPF.ar(a.ar(1/b/32),500,1.01-c)).clip/2}

// 04.06.17
play{a=SinOscFB;Splay ar:a.ar(4**a.ar(b=0.01/(2..6))*99,c=a.ar(1-b*8,1/2)+1/2,Decay.ar(c>0.99512*a.ar(c+1/b),1/2)/22).tanh}

// 08.06.17
play{a=SinOsc;a.ar(RLPF.ar(a.ar(9+c=1.1**a.ar([6,8]),a.ar(c/9)%a.ar(a.ar(c/14)*999))>0.99*999,c/4+1*99,a.ar(c/9)/19+0.06))}

// 19.06.17
play{a=SinOscFB;Splay.ar({|i|a.ar(1+i).max(c=a.ar(8-i/8))*a.ar(a.ar(i-2.1)%a.ar(9,1)+(a.ar(1)>0/3+1.83)**i+99,c+1/4)}!8)/2}

// 04.07.17
play{a=SinOscFB;c=a.ar(1-a.ar(1/[3,2]).round(0.5)+InFeedback.ar(0,2));a.ar(2**a.ar(1-c).round(1-c)*400,c.abs,c.lag*c).tanh}

// 08.07.17
play{a=LFSaw;Splay.ar({|i|VarSaw.ar(round(a.ar(c=i/48)*a.ar(b=c/72)*8+9,i%9+1)*25+c,c,a.ar(3,i)+1/3,a.ar(b,i/pi)%1)/2}!30)}

// 03.08.17
play{a=VarSaw;Splay ar:AllpassC.ar(9**(c=a.ar(0.1/b=[9,4,3,6]/4)+1/9)*a.ar(round(a.ar(c/3)+b,b)*99,0,c),1,c+9/99,9).tanh/2}

// 06.08.17
play{a=SinOsc;b=Duty;c={Dseq([5,1,3,2],1/0)};a.ar(b.ar(e=1/[8,4],0,c.()*b.ar(e/4,0,c.()))*b.ar(1/e,0,c.()*28.8))*a.ar(e/9)}

// 10.08.17
play{a=LFSaw;Splay ar:CombN.ar(GVerb.ar(a.ar(a.ar(b=(9..1)/99,b)+1*99,b,a.ar(a.ar(b)>b)>0.9),99,1,b*9,b)/19,1,b/9.9,9,0.9)}

// 22.08.17
play{LocalOut.ar(b=HPF.ar(Saw.ar([50,99],9e3**lag(Saw.ar([9,8])+LocalIn.ar(2),LFTri.ar(1/[19,18])/19+0.09)).cos,9));b.tanh}

// 25.08.17
play{a=SinOsc;c=a.ar(999**(a.ar(3)*a.ar([3,1]/8)%1),a.ar(0.03,a.ar(98)*a.ar(0.02,[0,1],3),4));c+a.ar(99,c*a.ar(0.01)*12)/3}

// 28.08.17
play{a=LFSaw;sum({|i|AllpassN.ar(RHPF.ar(Saw.ar(a.ar(1/[99,100]).round(1/8)**2*8),2**i*[99,50],0.01),1,i+1/9,9)/9}!8).tanh}

// 02.09.17
play{a=LFTri;c=Klank.ar(`[[12,4,3,9,10]*2*99],a.ar(5*b=[1,9/8]),b)*d=a.ar(b/8);a.ar(b*2).sum<0*SinOscFB.ar(b*99,d+1/2)+c/2}

// 04.09.17
play{a=LFSaw;Splay.ar(MoogFF.ar(a.ar(a.ar(9,2/b=(1..9)))>0.05*GrayNoise.ar(999)*a.ar,2**a.ar(b/3.55).round*b*99,3.5)).tanh}

// 01.10.17
play{a=LFTri;Splay ar:BHiPass4.ar(BLowPass4.ar(a.ar(b=[4,16,3])*a.ar(b*b),8**a.ar(b/50).round*99),3**a.ar(1/b)*99,0.1).sin}

// 22.10.17
play{a=VarSaw;HPF.ar(BLowPass4.ar(a.ar((a.ar([7,6])<0+b=a.ar(c=1/[31,23]))>1+1*99,0,1-b/2)%b,4**a.ar(c)*666,0.08).sin/2,9)}

// 26.10.17
play{a=LFTri;Splay ar:Pulse.ar(fold((2..5)/(a.ar(0.1)>0+2)**a.ar(b=a.ar(2/(9..7))).ceil.lag*99*[3,1,8,2,4],9,999),2-b/5)/2}

// 26.10.17
play{a=LFTri;Splay ar:Pulse.ar(wrap((1..4)/(a.ar(2/3)<0+3)**a.ar(b=a.ar(1/[4,3])).ceil.lag*99*[2,3,4,8,1],20,1e3),2-b/3)%1}

// 19.11.17
play{a=SinOsc;e=EnvGen.ar(Env.perc(5e-3,0.2),t=a.ar([7.992,8]));f={|i|Demand.ar(t[i],0,Dseq([Dseq('@BGIJB@IGBJI'.ascii,240),Dseq('@LEGJLEG'.ascii,120),Dseq('EGJL'.ascii,60)])).midicps}!2;x=a.ar(f,a.ar(1/[12,9])/4+1*a.ar(f,e*pi))*e/2;FreeVerb2.ar(x@0,x@1,0.1,1,0)}
