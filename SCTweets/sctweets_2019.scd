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
// tweets by redFrik : part_03
// 26.04.20
play{ar(FreeVerb,ar(Splay,ar(SinOscFB,ar(DegreeToKey,as(b=[1,3,5,8,10],LocalBuf),ar(Duty,(e=[3,2/3,4,3/2,2])/(12**ar(a=LFTri,b*c=0.021)),0,ar(a,b*c)*7+20+Dseq(b%(ar(a,b*c)*5+6),inf))).midicps,ar(a,c/b)+1/3,ar(Decay2,ar(Impulse,e@@b),c,d=ar(a,b/999)%1)*d)),0.1,1)}


// 04.04.20
play{d=ar(a=SinOscFB,kr(Pitch,ar(b=LFPulse,ar(b,1/[8,9]+ar(b,0.1)).lag(ar(a,1/11)/2+1/9)*4/3+1**ar(b,1/[9,8])*ar(b,1/11,0,1/4,99,99)).lag(ar(a,1/[5,4]).max/9).sum)[0],ar(b,1/[ar(b,1/9)+2,3]).lag/4+0.3);ar(HPF,d+ar(PitchShift,d/2,2,[3,2]-ar(b,1/[18,17]).lag),9)/2}

// 04.03.20
play{ar(Splay,o=ar(BPF,ar(Normalizer,ar(v=SinOsc,(b=(tanh(pi)..f=tab(Char).ascii)*pi*pi)*f,c=b.reciprocal,ar(v,c).max)+ar(AllpassC,ar(LocalIn,f),e=floor(f%pi),ar(v,c/f)/f+e/e,e,e),e/e,c),ar(v,c).exprange(f,e**f*f));ar(LocalOut,o.rotate);o).sin};s.scope(e).style=e

// 26.12.19
play{c=ar(e=SinOsc,0,pi**ar(SinOscFB,ar(Duty,b=("00".size.."0000000".size).reciprocal,0,Dseq("0 0 00 0 0 000  _0 0 0 00 00 00000+  !".ascii,inf)),ar(e,d=$0.ascii.reciprocal).max*0.cos.sin));ar(LeakDC,ar(Splay,c+ar(PitchShift,c,e=0.cos.cos,b.reciprocal,d,d,b)))*e}

// 11.12.19
play{a=VarSaw;ar(LeakDC,ar(LPF,ar(Splay,ar(b=CombN,ar(b,cos(ar(a,[11-1,11<<1,11,11>>1,11+1]**ar(a,11.1,1,1/11,1,1.11111111))*ar(a,d=1/(1..11)/1,d,1/11,ar(a,1.11/d,1,1.1-d,11),1)),d,d+1/(111>>1),ar(a,d*11/111,1,1/(c=1+1),1,1.1/c,d).max,1/c),c,c/11/d)),11111)).sin}

// 20.11.19
play{c=ar(RHPF,ar(CombN,ar(a=SinOsc,e=(f=[2,2.2])/22)/2*ar(LocalIn,2),2,2,g=2<<2),[22,2]*222,e*2);ar(LocalOut,d=ar(Splay,ar(RLPF,ar(a,2.2**ar(t=ToggleFF,ar(p=LFPulse,2,[2.2,2],e))*22*2.22,ar(t,c-e).lag*g)*ar(p,2,f),g**ar(a,e/2/2)*2222/2,ar(a,e)+2/2pi)+c).tanh);d}

// 27.08.19
play{r=ar(Splay,(ar(a=LFTri,{|i|i+3.33+ar(a,3/3333)}!3%3*33*(3/3pi+kr(c=LFPulse,3e-3*3)),3,_+3!3).reduce('*').tanh*[3,333*ar(a,3/3333),33])).sin+ar(a,3*3**[3.3,3]+(ar(a,[3,pi])),3,ar(c,pi)/3*ar(a,3e-3))/3;r+sum({|i|ar(b=PitchShift,r,3/33,3/3+i*3,3/33,3/33)}!3)/3}

// 24.06.19
play{ar(Splay,ar(RLPF,ar(a=VarSaw,ar(a,(c=4/4/4)/4,c,c).max*4+44,4,ar(a,[4,4/44,c*4]).abs),44*44,c)*ar(Line,dur:4)+ar(PitchShift,ar(CombC,b=ar(a,f=ar(a,d=c*4/44.4,c,-4.sin,4).max.ceil*44+44,4,ar(a,[44-4,4,44+4]/4.44))/4,c,c*4/f+d),4-c,[4+4+4,4*4,4+4],c,c,c+c))/4}

// 11.06.19
play{b=[f=9.sqrt,9.999];c=ar(e=PitchShift,ar(a=SinOscFB,lag(9.9*b*if(ar(a,ar(a,9/999))>ar(a,9/99),f,9/b)*if(ar(a,9/99)<ar(a,99/9999),b/9,f)),d=ar(a,b/99).max,ar(a,b/9)*d),9/b,9/b.sqrt,b/999,b/99);ar(HPF,ar(Splay,ar(GVerb,c*d*d*d,99,9,9/999)/9+ar(e,c,f/9,f/9)),9)}

// 07.06.19
do([LFTri,LFSaw,LFPar],{|a,i|play{c=round(ar(a,1/b=[4,2,1,3,5])*b,ar(a,b/9)>0);Splay ar:(x=ar(AllpassC,ar(SinOscFB,c**2*(ar(a,0.02,i)>0+1*50),ar(a,c/9)%1,max(ar(a,1/b*ar(a,b/99,i)))*ar(a,0.01,i)),1,c.wrap(0.5,1),2);x+ar(BPF,x,i*99+400,1e-3,ar(a,0.04,i)+1*9))/3}})

// 07.05.19
play{ar(Splay,ar(AllpassN,ar(RLPF,ar(VarSaw,f=kr(DegreeToKey,LocalBuf.newFrom(Scale.yu(Tuning.pythagorean).semitones),kr(a=LFTri,b=(-7..6)+0.7*2/666,b,kr(a,b))*9+9%32,12,1,24).midicps,0,kr(a,b)+1/2,kr(AmpComp,f)*kr(a,b,b)*b*9),f.lag2(1/b%1)*3),0.3,0.2-b,3)).tanh}

// 10.04.19
play{a=SinOsc;ar(HPF,ar(Splay,ar(CombC,ar(a,ar(Duty,c=2**ar(a,b=[1,2,6,3]+(ar(a,0.0345)<0)),0,Dseq(99*ar(a,1/b,0,b/3,b*(ar(a,0.0234)<0+1)).round,inf)),b,ar(a,1.5/c).max(ar(a,0.0123,0,0.5,-0.5))),1,7-b/12*(ar(a,c<0.6)%1+0.1),2**ar(a,ar(a,0.1,0,0.1),b,9))),9).tanh}

// 12.03.19
play{a=VarSaw;Splay ar:ar(BLowPass,ar(a,kr(a,b=(1..15)/151,b,1/5.15,1,1.5).ceil*kr(Select,kr(a,1/15,1/5,b,5).ceil+5/5,[51*1.5,51,151]).lag(b)+kr(a,5+b)*kr(a,b,b,b,b/5,[1.5,5,1]),b,kr(a,b)+5/15,kr(a,5-b,b,b,5,5)>1.515),1515**(kr(a,1-b/5)/15+1+b),1.5**kr(a,b)/5)/5}

// 05.03.19
play{a=LFSaw;ar(Splay,c=ar(VarSaw,round(1+ar(a,1/b=(1..9))/19+1.9**b+91*if(ar(a,1/19)+1>1,1,1.9).lag,91+ar(a,b/9+1)).lag,b/9,1/19);c+ar(CombN,ar(RHPF,c*ar(a,1/91,b/9).lag,91*1.9*b,9/19),1,b/9,9)+ar(RLPF,(f=ar(a,9.1))+1<ar(a,91)+c*f,19*19,ar(a,f)+1.9/9)/1.9).tanh}

// 31.01.19
a=play{|n=48|x=perform(LFTri,\kr,_);perform(BLowPass,\ar,perform(Pulse,\ar,perform(Duty,\kr,1/8,0,Dseq([1,8,13,1,13,1,11,6,1,8,1,13,1,11,1,13]+n,inf).midicps)+[0,0.4],x.(1/9)/6+0.2),2**x.(0.1)*400,x.(1/7)/7+0.3).tanh};MIDIIn.connectAll.noteOn={|i,c,n|a.set(\n,n)}

// 14.01.19
play{LocalOut ar:d=MoogFF.perform(\ar,PitchShift.perform(\ar,LocalIn ar:2,1.5,0.5)+Splay.perform(\ar,VarSaw.perform(\ar,(a=LFSaw.perform(\ar,_)).(1/b=[2,5,1,6,3])>0/4+1.25**b*99,0,a.(b/9)%1)*HPF.perform(\ar,a.(a.(1/b).round+1/2)>0,a.(b/33)*4+8)),a.(1/9)+2*4e3);d}
