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
// 09.01.16
play{a=Blip;z=sum(a.ar(b=9/(1..9),303)*a.ar(b/5-4,2.5));{|i|z=z+AllpassC.ar(z,1,i+1/b/9,a.ar(b/9,2),b/9)}!9;Splay ar:z.sin}

// 10.01.16
play{a=LFSaw;Splay.ar((c=Resonz.ar(a.ar(50.1/b=1/(1..8)),500*d=2**a.ar(b/9),a.ar(-4*b)%1))+PitchShift.ar(c,b,d round:b))/2}

// 26.01.16
play{a=SinOsc;b=a.ar(5/(1..5)).ceil.lag(c=a.ar(5e-3)%0.05);Splay.ar(a.ar(5**b*((5..1)*50),c*b*5555,1+a.ar(1/50+c)-b)).tanh}

// 26.01.16
play{a=SinOscFB;AllpassN.ar(a.ar(98.5+c=(Amplitude.ar(d=InFeedback.ar)<a.ar(f=1/[9,8.9])).lag(f/9)+d,d+f,c),1,f*3,20).tanh}

// 26.01.16
play{a=SinOsc;b=(a.ar(c=0.015)/9<a.ar(5/(1..7))).varlag(c);Splay.ar(a.ar(2-b**ceil(a.ar(b)*5+6),b)+BrownNoise.ar(b%1)).sin}

// 12.02.16
play{a=SinOsc;HPF.ar(Splay ar:a.ar(TwoPole.ar(a.ar(2**b=(3..8)*(a.ar(0.05).round/4+1))>c=a.ar(1.1/b),b*99,c%0.5+0.5))/2,9)}

// 19.02.16
play{a=SinOsc;HPF.ar((c=Splay.ar(a.ar(b=(19..-9)*50.01)*(1.2**a.ar((1..5)*3/4*(a.ar(1/b).floor*3+1)))&b)%1)+a.ar(9/c),9)/3}

// 20.02.16
play{a=SinOsc;Splay ar:a.ar(Duty.ar(b=1/[1,8,2],0,Dseq(' #SuperCollider '.ascii.pyramid*9**1.0595/2,inf)),a.ar(b)*lag(a.ar(0-b)<0.9)*5e3)/3}

// 20.02.16
play{a=SinOsc;CombN.ar(a.ar(a.ar(a.ar(1/[2,3])<0+1)**a.ar(1+a.ar(1+a.ar(1/6)*99)*666).lag(a.ar([1.55,1])%1)*99),1,0.9,3)/3}

// 04.03.16
play{a=LFSaw;VOsc3.ar({|i|Buffer.alloc(s,1024).sine1(i+c=(3..1))}!2@0,*c+round(d=a.ar([2,[3,1]]))*(a.ar(d*5)>0)/2*99).tanh}

// 11.03.16
play{a=LFTri;Splay.ar(Blip.ar([60,65,53,67,80].midicps,(b=(1..5))**ModDif.ar(a.ar(1),a.ar(2),a.ar(4))*a.ar(1/b/9)*9)).tanh}

// 11.03.16
play{a=LFSaw;Splay ar:RLPF.ar(a.ar(a.ar(b=1/2**(2..6))>0*3+15/b),pi**a.ar(a.ar(b)+1*b)*999+(a.ar(a.ar(b*9)*9)*99)/2,0.2)/5}

// 12.03.16
play{a=LFSaw;Splay ar:a.ar(CombN ar:DegreeToKey.ar(as(b=[1,3,6,8,10],LocalBuf),a.ar(a.ar(1/b/99)/pi)*12+18+b).midicps)*0.6}

// 18.03.16
play{a=LFTri;Splay.ar(FBSineC.ar(2**a.ar(pi/b=7.fib).ceil*99*(2**b)%((c=a.ar(b/99)+1)*4e3),c+0.1,a.ar(1/b/20)+1,1.02,7)/3)}

// 24.03.16
play{a=LFCub;Splay.ar(a.ar(b=2/(2..9))%a.ar(b/5)*a.ar(2**a.ar(b/8)>0+1*2*(b*[300,303]-(a.ar(b/9)>0*50).lag2))*a.ar(b/6,b))}

// 18.04.16
play{a=SinOscFB;Splay.ar(AllpassN.ar(a.ar(999*b=1/(a.ar(1/(4..9))>0*[1,4,2,3]+4),a.ar(a.ar(b)>0,b,b)%1).tanh/2,1,b.lag,4))}

// 18.04.16
play{a=SinOscFB;Splay.ar(a.ar(a.ar(b=1/(2..6),1)<b*500+99)/5+a.ar(999*b,a.ar(a.ar(b,1)<0.1+1,1)%b,a.ar(0.1-b,1).min(0)))/2}

// 29.04.16
play{a=LFTri;RHPF.ar(Splay ar:SinOsc.ar(a.ar(c=[6,14,4])%a.ar(c),a.ar(c-1)+1**a.ar(c/9)*4,a.ar(1/c)>0*99),99,0.3).tanh*0.6}

// 05.05.16
play{a=LFSaw;a.ar((b=a.ar(1/3))+1**a.ar(b)*(99+c=[0,1]))%a.ar(b*99,c)%a.ar(1/32)+a.ar(a.ar(b)*4e4%2e3,0,a.ar(6,c)>0.9/2)/2}

// 08.05.16
play{a=Blip;GVerb.ar(HPF.ar(a.ar(a.ar(1/4,8).ceil+1*[99,9])*a.ar(1.01,ceil(2**a.ar(1/16)*4))>(a.ar(1/128)/4),9)/9,9,2,0.9)}

// 09.05.16
play{a=LFSaw;HPF.ar(Splay.ar(Saw.ar(midicps(':>AEH.'.ascii-ceil(2**a.ar((1..5)/32))))%a.ar(1!2++6)%a.ar(2,[1,2]/8,2)),9)/2}

// 09.05.16
play{a=SinOscFB;Splay.ar(a.ar(SelectX.ar(a.ar(0.1)%(a.ar(b=(1..4)))*(c=b+8),DC ar:':.UODD.Ed'.ascii.midicps),a.ar(1/c)))/2}

// 13.05.16
play{GVerb.ar(sum(SinOscFB.ar(33*b=(1..50),lagud(t=Impulse.ar(b/49),5e-3,0.2)*99,t.lagud(7e-3,1))),299,9,0.01,0.5,6,1,1,1)}

// 14.05.16
play{a=SinOsc;AllpassC.ar(a.ar(b=[99,98],c=a.ar(12))+a.ar(c>0*8*b,0,a.ar(1/b)),1,a.ar(1/[3,4])%1,8,a.ar(1/64,[0,1])*3).sin}

// 18.05.16
play{a=LFSaw;Pluck.ar(a.ar(a.ar(1/16)+2*99,0,a.ar([2,3]/4)*6).sin,a.ar([6,4])%a.ar([4,6]),1,a.ar(5/[4,6])%(1/[2,3]),2)/9%1}

// 27.05.16
play{a=Saw;RecordBuf.ar(a.ar(d=[2,4,8,3,6])%a.ar(9)/6,b=LocalBuf(3e3,5).clear);Splay.ar(Shaper.ar(b,a.ar(d*32+a.ar(d/8))))}

// 29.05.16
fork{(f={|a|play{Pan2.ar(SinOscFB.ar(Duty.kr(d=1/i=a@0,0,Dseq(a*99/2),2),b=Saw.kr(i))/5,b)};2.wait;f.(a+3/d%9)}).((4..12))}

// 30.05.16
play{a=SinOsc;Mix(a.ar({|x|a.ar(x+1/[6,8]).round/2+1*99*{|x|Duty.kr(1/x,0,Dseq(fib(x+1)-1,inf))}.(x+2).lag(0.02)}!8)).tanh}

// 31.05.16
play{a=SinOsc;AllpassC.ar(HPF.ar(reduce(a.ar([600,500,99,50,8/3])*a.ar(0.1/(9..5)),\hypot)/2,9),1,a.ar(1/[80,90])/3+0.5,5)}

// 07.06.16
play{a=SinOscFB;HPF.ar(CombN.ar(a.ar(sum({|i|a.ar(2**(1/8)**i,i/8,a.ar(i+8/8))>a.ar(i+[2,3]/88)}!8)*88,a.ar(1/18,1))),8)/3}

// 15.06.16
play{a=SinOscFB;Splay.ar({|i|a.ar(1+(c=a.ar(i+1/[6,4])/(a.ar(1/[8,9])+1.5))**i+i*99,d=c%DelayN.ar(c),d.lag3(c%1/99))}!4)/3}

// 26.06.16
play{b=XFade2;a=SinOscFB;a.ar(b.ar(a.ar(1).ceil*36,a.ar(2).round*2+4*12,a.ar(1/[4,12]))+8*4,c=a.ar([2,3])%1,c*a.ar(1,1/3))}

// 28.06.16
play{a=LFSaw;b=Formant;b.ar(round(a.ar(1/16),c=3**a.ar([2,3],[0,1]))+3*33*ceil(c),3**c.lag*66,3**c*99)*b.ar(c+3,1-c*3e3)/4}

// 28.06.16
play{a=LFSaw;b=Formant;b.ar(round(a.ar(1/16),c=3**a.ar([2,3],[0,1]))+3*33*ceil(c),3**c.lag*66,3**c*99)+b.ar(c+3,1-c*3e3)/4}

// 02.07.16
play{a=SinOsc;Splay ar:CombN.ar(a.ar(Out.kr(0,b={|i|Duty.kr(i+1/9,0,In.kr(i+1%4)+Dseq(8.fib,inf)%9)}!4);b*99,b*2),1,1/3)/2}

// 17.07.16
play{a=SinOsc;b=Spring;c=a.ar((4..2)/64)%1;CombN ar:a.ar(0,b.ar(b.ar(b.ar(a.ar([2,3])>0,4,c@0/4),9,c@1/3),24,c@2/3)*9)*0.7}

// 31.07.16
play{a=SinOscFB;LocalOut kr:d=a.ar(Duty.kr(LocalIn kr:8,a.kr(1/16,1),Dseq((1..8)*50,inf)),a.kr(1/(1..8))+1/2);Splay ar:d/2}

// 05.08.16
play{a=SinOsc;GVerb.ar(sum(RHPF.ar(a.ar(3.5-b=(8..2),a.ar(4/b)*99)>0*a.ar(b*99)*(9-b),a.ar(1/b/2)+2*666,0.4)).tanh/5,99,2)}

// 17.08.16
play{a=SinOsc;Splay ar:a.ar(Duty.ar(1/b=(2..6),0,Dseq(a.ar(0.1)>0*b+ceil(b*a.ar(3/b))%14*99,inf)),b*b*tanh(a.ar(4/b)*9)|1)}

// 17.08.16
play{HPF.ar(FreeVerb.ar({|i|SinOsc.ar(Duty.ar(i+1/9,0,Dseq((1..8).stutter(32),inf)*Dseq(8.fib,inf)*99))}!2,0.2,1,0.2),9)/2}

// 20.08.16
play{CombN.ar(Blip.ar(Duty.ar(1/[9,8],0,Dseq(\AVVVF.ascii.midicps,inf)/a=2+Blip.ar(3/[8,9],2).round),c=a**a.lag,c+5)).tanh}

// 23.08.16
play{FreqShift.ar(a=Splay.ar(Formlet.ar(Blip.ar(Blip.ar(Blip.ar(2.01,3)>0,b=(1..9))+1,b/8)+2*99,b*50,0.01).tanh),0.01)+a/7}

// 23.08.16
play{a=SinOscFB;GVerb.ar(mean(FreqShift.ar(c=a.ar(a.ar(a.ar(99/b=(1..9),1),1/b)+b*50,1),1/b)+c)/3,200,3,0.5,0.5,9,1,0.7,1)}

// 26.08.16
play{a=SinOscFB;LocalOut ar:c=a.ar(Duty.ar(Trig.ar(LocalIn ar:2,a.ar(b=1/[3,2])+11/2),0,Dseq((1..8),inf))*99,a.ar(b/12));c}

// 09.09.16
play{a=SinOscFB;AllpassC.ar(a.ar(a.ar(8)+3<<a.ar(3/8,0.9,a.ar(5)+1,4.2)*9,a.ar(1/32)+a.ar(7.9,1)),2,a.ar([3,2]/999)+1,4)/2}

// 09.09.16
play{a=SinOscFB;Pluck.ar(a.ar(99+b=[1,2],1),a.ar(8),1,a.ar(b/16)>0/2+2.5-b/99+(b*a.ar(b,1)>(c=3e-3)/2),2,a.ar(c*b,0.4))/12}

// 03.10.16
play{a=LFTri;CombN.ar(a.ar(Duty.ar(c=[4,2]/(a.ar([4,1])>0*4+4),0,Dseries()%a.ar(c,c,42)+1*99).lag3(0.025).max(0)),2,2,4)/2}

// 04.10.16
play{a=SinOscFB;b=AllpassC;b.ar(b.ar(a.ar(a.ar(0.1)<0/2+1*[99,98],a.ar(3e-3)+1/2),2,a.ar(0.9)/2+1,9),2,a.ar(0.91)/2+1,9)/4}

// 30.10.16
play{a=Blip;b=(1..8);Splay.ar(a.ar(a.ar(3.125,b)+a.ar(b/2.45,b)+1*a.ar(8/b,50)+1*99,a.ar(b/pi,b)+b-a.ar(1/4/b,2,4)).sin/2)}

// 06.11.16
play{a=LFSaw;Formlet.ar(Formlet.ar(a.ar(a.ar(c=a.ar([1,2]/32)<0+1)>0+c.lag(c)*99),0,a.ar(3-c/[4,3])+1).sin,99,0,0.01).tanh}

// 06.11.16
play{a=VarSaw;Splay ar:a.ar(Select.ar(a.ar(2.01/b=[0,3,7,5,2,9,10]+0.2)*8,(c=a.ar(0.5/b))>0*12+b+48).midicps,0,c%1).tanh/2}

// 17.11.16
play{a=SinOscFB;Splay.ar(a.ar(13*13*b=(1..3),1/3)*a.ar(b/13,1)/13+a.ar(a.ar(1/(13..3))+133*b,a.ar(b/333,a.ar(b,1)%1)%1))/3}

// 24.11.16
play{a=SinOscFB;Splay ar:a.ar(collect(b=(1..8),{|x,i|[x,i+6/6e3+x]})*60,c=a.ar(b/16/16.16)%1,a.ar([3,6],1,c.lag/3).max(0))}

// 03.12.16
play{a=VarSaw;Splay ar:CombC.ar(a.ar(a.ar(1/b=[2,4,9,3]*9)>0+3*b,0,lag(a.ar(b/2e3)+1/2,1)),1.1,round(a.ar(8/b)%1)+0.1,8)/3}

// 14.12.16
play{a=SinOsc;c=a.ar(b=(1..6)*60,LocalIn.ar(6)*3);LocalOut.ar(Limiter.ar(BPF.ar(c,a.ar(16/b)+3*b),0.66,16/b));Splay ar:c/2}

// 28.12.16
play{a=SinOscFB;Splay ar:a.ar(midicps(c=a.ar(12.fib/round(a.ar(1/[2,4])%1+0.125),1)>0*[9,2,3,0,7,5]+55),a.ar(c/999)+1/2)/3}
