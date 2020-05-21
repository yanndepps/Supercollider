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

// ---


