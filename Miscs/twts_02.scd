// Boot
s.options.memSize = 8192 * 256; // increase this if "alloc failed" messages

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
// tweets by redFrik : part_02
// ---> from 26.08.19

play{r=ar(Splay,(ar(a=LFTri,{|i|i+3.33+ar(a,3/3333)}!3%3*33*(3/3pi+kr(c=LFPulse,3e-3*3)),3,_+3!3)
	.reduce('*')
	.tanh*[3,333*ar(a,3/3333),33]))
	.sin+ar(a,3*3**[3.3,3]+(ar(a,[3,pi])),3,ar(c,pi)/3*ar(a,3e-3))/3;
	r+sum({|i|ar(b=PitchShift,r,3/33,3/3+i*3,3/33,3/33)}!3)/3}

// ---

play{ar(Splay,ar(RLPF,ar(a=VarSaw,ar(a,(c=4/4/4)/4,c,c).max*4+44,4,ar(a,[4,4/44,c*4]).abs),44*44,c)*ar(Line,dur:4)+ar(PitchShift,ar(CombC,b=ar(a,f=ar(a,d=c*4/44.4,c,-4.sin,4).max.ceil*44+44,4,ar(a,[44-4,4,44+4]/4.44))/4,c,c*4/f+d),4-c,[4+4+4,4*4,4+4],c,c,c+c))/4}

// ---

play{b=[f=9.sqrt,9.999];c=ar(e=PitchShift,ar(a=SinOscFB,lag(9.9*b*if(ar(a,ar(a,9/999))>ar(a,9/99),f,9/b)*if(ar(a,9/99)<ar(a,99/9999),b/9,f)),d=ar(a,b/99).max,ar(a,b/9)*d),9/b,9/b.sqrt,b/999,b/99);ar(HPF,ar(Splay,ar(GVerb,c*d*d*d,99,9,9/999)/9+ar(e,c,f/9,f/9)),9)}

// ---

do([LFTri,LFSaw,LFPar],{|a,i|play{c=round(ar(a,1/b=[4,2,1,3,5])*b,ar(a,b/9)>0);Splay ar:(x=ar(AllpassC,ar(SinOscFB,c**2*(ar(a,0.02,i)>0+1*50),ar(a,c/9)%1,max(ar(a,1/b*ar(a,b/99,i)))*ar(a,0.01,i)),1,c.wrap(0.5,1),2);x+ar(BPF,x,i*99+400,1e-3,ar(a,0.04,i)+1*9))/3}})

// ---

play{ar(Splay,ar(AllpassN,ar(RLPF,ar(VarSaw,f=kr(DegreeToKey,LocalBuf.newFrom(Scale.yu(Tuning.pythagorean).semitones),kr(a=LFTri,b=(-7..6)+0.7*2/666,b,kr(a,b))*9+9%32,12,1,24).midicps,0,kr(a,b)+1/2,kr(AmpComp,f)*kr(a,b,b)*b*9),f.lag2(1/b%1)*3),0.3,0.2-b,3)).tanh}

// ---

play{a=SinOsc;ar(HPF,ar(Splay,ar(CombC,ar(a,ar(Duty,c=2**ar(a,b=[1,2,6,3]+(ar(a,0.0345)<0)),0,Dseq(99*ar(a,1/b,0,b/3,b*(ar(a,0.0234)<0+1)).round,inf)),b,ar(a,1.5/c).max(ar(a,0.0123,0,0.5,-0.5))),1,7-b/12*(ar(a,c<0.6)%1+0.1),2**ar(a,ar(a,0.1,0,0.1),b,9))),9).tanh}

// ---

play{a=VarSaw;Splay ar:ar(BLowPass,ar(a,kr(a,b=(1..15)/151,b,1/5.15,1,1.5).ceil*kr(Select,kr(a,1/15,1/5,b,5).ceil+5/5,[51*1.5,51,151]).lag(b)+kr(a,5+b)*kr(a,b,b,b,b/5,[1.5,5,1]),b,kr(a,b)+5/15,kr(a,5-b,b,b,5,5)>1.515),1515**(kr(a,1-b/5)/15+1+b),1.5**kr(a,b)/5)/5}

// ---

play{a=LFSaw;ar(Splay,c=ar(VarSaw,round(1+ar(a,1/b=(1..9))/19+1.9**b+91*if(ar(a,1/19)+1>1,1,1.9).lag,91+ar(a,b/9+1)).lag,b/9,1/19);c+ar(CombN,ar(RHPF,c*ar(a,1/91,b/9).lag,91*1.9*b,9/19),1,b/9,9)+ar(RLPF,(f=ar(a,9.1))+1<ar(a,91)+c*f,19*19,ar(a,f)+1.9/9)/1.9).tanh}

// ---

a=play{|n=48|x=perform(LFTri,\kr,_);perform(BLowPass,\ar,perform(Pulse,\ar,perform(Duty,\kr,1/8,0,Dseq([1,8,13,1,13,1,11,6,1,8,1,13,1,11,1,13]+n,inf).midicps)+[0,0.4],x.(1/9)/6+0.2),2**x.(0.1)*400,x.(1/7)/7+0.3).tanh};MIDIIn.connectAll.noteOn={|i,c,n|a.set(\n,n)}

// ---

play{LocalOut ar:d=MoogFF.perform(\ar,PitchShift.perform(\ar,LocalIn ar:2,1.5,0.5)+Splay.perform(\ar,VarSaw.perform(\ar,(a=LFSaw.perform(\ar,_)).(1/b=[2,5,1,6,3])>0/4+1.25**b*99,0,a.(b/9)%1)*HPF.perform(\ar,a.(a.(1/b).round+1/2)>0,a.(b/33)*4+8)),a.(1/9)+2*4e3);d}

// ---

play{f={|...a|LFTri.perform(\ar,*a)};g=DelayN.perform(\ar,_);c=Splay ar:GVerb.perform(\ar,Splay ar:HPF.perform(\ar,f.(2/b=8.fib.mirror)>f.(1/b),f.(1/b/2)+1.03*3e3),b,5,*f.(1/6.fib/12)+1/2);c+f.(54,[0,1],RLPF.perform(\ar,d=g.(c),999))+RHPF.perform(\ar,g.(d),99)/8}

// ---

play{x={|z...y|perform(z,*y)};Splay ar:({|i|(b=x.(a=SinOscFB,f=\ar,x.(e=Duty,f,i+1/9,0,Dseq(9.fib%8,inf))/c=1/x.(e,f,1+i/8,0,Dstutter(24,Dseq(99/(1..4),inf))).lag(4),x.(a,f,c)))*x.(CombN,f,b,1,i/99+0.1)/8+x.(Ringz,f,x.(Pulse,f,4/9,i/19.4,c),b+1*99,c).tanh/4}!20)}

// ---

play{a=SinOsc;c=VarSaw;Splay ar:perform(a,x=\ar,0,perform(BRF,x,perform(c,x,perform(c,x,perform(a,x,b=(6..1)*2.1)*b,0,7-b/9)>0+(perform(a,x,1/b)>perform(a,x,0.1/b)+1)*[99,198]*b/9,0,perform(c,x,b/48)+1/2),2**perform(c,x,b/24)*488,0.4)*perform(a,x,0.012,b,2pi))/2}

// ---

play{a=LFTri;c=perform(Splay,x=\ar,perform(Resonz,x,perform(VarSaw,x,5,0,d=perform(a,x,0.15,b=(1..5)),perform(EnvGen,x,Env.perc(f=15e-4,0.05,d,d*5),perform(a,x,b/1.5))),1.5**b*(50*perform(a,x,0.015,b/5).round+150),d+1.15*f,150));c+perform(PitchShift,x,c,1.5,0.5)}

// ---

play{a=VarSaw;b=(2..6)/4;c={|f,v|Splay ar:perform(BBandPass,\ar,perform(CombC,\ar,perform(a,\ar,f*b+perform(a,\ar,4,0,0.4,v/14),0.4,perform(a,\ar,b/40)+1/4),2,perform(a,\ar,perform(a,\ar,b/4e4)+1*b/4,b/400).lag+1,4)/v,4**b*44%1e4,9).tanh};c.(140,14)+c.(1400,144)}

// ---

play{a=SinOsc;f={|...x|1.5**perform(a,\ar,*x)};Splay ar:({|i|l=perform(a,\ar,f.(i+5/150)<1).abs.round(0.5);y=perform(VarSaw,\ar,1.5**l*(f.(l/155,0,5).ceil*50.05),0,f.(l*f.(l/50))-0.55,max(f.(i+1/500.05)-1,0));y+perform(PitchShift,\ar,y*f.(0.1),0.5,5,0.05,1)}!15)}

// ---

play{q=SinOsc;a={|x...y|perform(x,\ar,*y)};Splay ar:a.(CombN,c=a.(q,0,a.(Blip,1/f=(1..8),888/a.(q,1/88,0,2,3).ceil*a.(Duty,a.(q,1/8)>0+2*1/8,0,Dseq([8,88,888],inf)))*188),1,8-f/8,8)/8+a.(CombN,a.(GVerb,a.(BPF,8*e=c.mean,88,1/8),88),1,1)+a.(q,88,0,a.(q,0,e)<0/88)}

// ---

play{a=SinOsc;e=EnvGen.ar(Env.perc(5e-3,0.2),t=a.ar([7.992,8]));f={|i|Demand.ar(t[i],0,Dseq([Dseq('@BGIJB@IGBJI'.ascii,240),Dseq('@LEGJLEG'.ascii,120),Dseq('EGJL'.ascii,60)])).midicps}!2;x=a.ar(f,a.ar(1/[12,9])/4+1*a.ar(f,e*pi))*e/2;FreeVerb2.ar(x@0,x@1,0.1,1,0)}

// ---

play{a=LFTri;Splay ar:Pulse.ar(wrap((1..4)/(a.ar(2/3)<0+3)**a.ar(b=a.ar(1/[4,3])).ceil.lag*99*[2,3,4,8,1],20,1e3),2-b/3)%1}

// ---> to 26.10.17