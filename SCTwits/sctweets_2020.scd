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
// 04.03.20
play{ar(Splay,o=ar(BPF,ar(Normalizer,ar(v=SinOsc,(b=(tanh(pi)..f=tab(Char).ascii)*pi*pi)*f,c=b.reciprocal,ar(v,c).max)+ar(AllpassC,ar(LocalIn,f),e=floor(f%pi),ar(v,c/f)/f+e/e,e,e),e/e,c),ar(v,c).exprange(f,e**f*f));ar(LocalOut,o.rotate);o).sin};s.scope(e).style=e

// 04.04.20
play{d=ar(a=SinOscFB,kr(Pitch,ar(b=LFPulse,ar(b,1/[8,9]+ar(b,0.1)).lag(ar(a,1/11)/2+1/9)*4/3+1**ar(b,1/[9,8])*ar(b,1/11,0,1/4,99,99)).lag(ar(a,1/[5,4]).max/9).sum)[0],ar(b,1/[ar(b,1/9)+2,3]).lag/4+0.3);ar(HPF,d+ar(PitchShift,d/2,2,[3,2]-ar(b,1/[18,17]).lag),9)/2}

// 26.04.20
play{ar(FreeVerb,ar(Splay,ar(SinOscFB,ar(DegreeToKey,as(b=[1,3,5,8,10],LocalBuf),ar(Duty,(e=[3,2/3,4,3/2,2])/(12**ar(a=LFTri,b*c=0.021)),0,ar(a,b*c)*7+20+Dseq(b%(ar(a,b*c)*5+6),inf))).midicps,ar(a,c/b)+1/3,ar(Decay2,ar(Impulse,e@@b),c,d=ar(a,b/999)%1)*d)),0.1,1)}

// 24.10.20
fork{inf.do{a={|i|c=Scale.minor.tuning_(Tuning.mean5);z=sum({ar(Pan2,ar(SinOscFB,kr(o=LFTri,1/99)*9+midicps(12*(3..6).choose+c[c.degrees.choose]),kr(o,1+i/50)+1/2),kr(o,i/70))/2}!d=9.rand);ar(CombN,z).tanh}.play(s,0,9);wait(d*9+3);a.release(12)}}

// 30.10.20
fork{do(inf,{|j|a=play{z=mean({|i|ar(Pan2,ar(o=SinOscFB,kr(o,i+6,1,6-1)+midicps(66-1+Scale.yu.tuning_(Tuning.mean6)[j+i]),kr(o,1+i/6/6).max),kr(o,i+1))}!d=j%6+1);ar(PitchShift,z,1,[1.66+1,1.66],t=1/66,t)/6+z+ar(o,66-1,1,ar(o,6,1).max)/6};wait(d+6);a.release(6)})}

// 03.11.20
fork{do(inf,{|j|a=play{ar(Splay,{|i|ar(Blip,2+ar(b=LFTri,4,i/6,1e-3)**i+1*[1,1,9/8,2/3,0.5,2,3/4]@@(j/2),2**ar(b,i+1/99,i/6)*4,ar(Decay,ar(Impulse,[1,4,6,2,3]@@(j-i),[0,0,i/1.5,i/2]@@(j+i),ar(Sweep,0,0.5)),ar(b,0.01,i/6)+2/4))}!12).tanh/3};4.wait;a.release(14)})}

// 16.12.20
play{ar(HPF,ar(Splay,ar(Pluck,ar(a=VarSaw,[18.1,81.8,1.81]+b=(8..18),1,ar(a,b/81)),ar(a,8/1.818,[1,8/18]),1.8/181.8,ar(a,b/181.8).exprange(1.81/818,1.8/181.8).round(1.81/818),ar(a,1/8,1/b)+8.18*1.8,ar(a,1/81.8).range(1.8** -1,8.1/8.18),ar(a,1.8/b))/1.8),18/1.81)}

// 26.12.20
play{ar(Splay,ar(Pluck,ar(a=SinOscFB,ar(a,b=(15..1)/5)*151.5*ar(a,b).round,ar(a,b/15).max,ar(a,b)+1/5),ar(a,1.51**5),c=1.51/515,d=ar(a,b/15).round.lag.range(c/1.515,c),1.5**ar(a,b,1)*5,1.51**ar(a,b)/5)+(ar(a,ar(a,b/15.1).round/5*1.5/d,e=ar(a,b/15).max,e/1.5)))/5}

// 27.12.20
scope{ar(Splay,ar(HPF,ar(Pluck,ar(WhiteNoise,ar(a=LFTri,b=(2..12)/12)+1/2)+ar(BrownNoise),ar(a,121**ar(a,2/121*b)),2/121,lag2(1/212>ar(a,1/212.1),2/b)/12*1.2+1.2/((Scale.yu(Tuning.just).degreeToFreq(_,121.21,2/12))!b.size),1/2*12/1.2,ar(a,b/12)+1/2),12,1/2.1/2))}

// 16.01.21
Pdef(\b,{|dur,note|Pbind(\instrument,SynthDef(\,{ar(Out,0,ar(SinOscFB,kr(\freq)*[1,2],kr(MouseY),EnvGate())/3)}).add,\dur,dur/3,\note,note+Pseq([-7,2,5]))});Pbind(\type,\phrase,\dur,Pseq((9..1),inf),\note,0-Pseq((12..8),inf),\instrument,\b,\recursionLevel,3).play


// 24.03.21
play{b=(1..9);ar(Splay,ar(a=VarSaw,63*b+ar(a,0.49,c=b/9),0,ar(a,(d=ar(a,3e-3,c).round(1/3).lag(1.9)*91+252)+ar(a,c/9,0,b/(9+1),1/99)*b,0,c)+1/2,ar(a,6,c/3,0).max(ar(a,0.2,c)/9+(ar(a,9e-3)*0.3+0.4)))+ar(a,60,0,0.5,ar(a,3,0,0).max**3)+ar(a,d,c,ar(a,c/99)%1,1/3)/5)}

// 23.03.21
play{tanh(ar(a=SinOscFB,ar(a,1/64)<0*9+50,ar(a,1/8)+1/2,ar(HPF,c=ar(a,3)>0,4,5))!2+ar(Splay,ar(a,ar(Demand,ar(a,1/12),0,Dseq([1,1,2,3,4,1]*(ar(a,1/96)<0.5*19+99),inf)*b=[1,0.5,1.25]).lag3ud(1,3),ar(a,b/16)+1/3))+(ar(HPF,c>0.1,9**ar(a,1/19)+3)*ar(a,[12,9]*99)/6))}

// 05.03.21
play{ar(Splay,{|i|ar(CombC,ar(a=SinOsc,Scale.yu.degreeToFreq(\fredaglunch.ascii%12@i,ar(a,1/16)>0*2+6-(ar(a,ar(a,1/32,i))/20),5))/9,0.5,i+floor(ar(a,1/64)*6+6).varlag(0.1)%11/33+0.1+varlag(ar(a,ar(a,1/4,i/11*pi)<0*2)*0.1,0.01,ar(a,0.01,i)),ar(a,1/9)+1)}!11).tanh}

// 05.03.21
play{f={|x,y|ar(a,x,y?b).round};ar(Splay,c=ar(GrainSin,1,ar(a=SinOsc,f.(0.01,0)+10,b='TORSDAGKVÄLL'.ascii-64),0.85,f.(0.4)+f.(0.1)+2**f.(1/b)+1*99)/5;ar(HPF,ar(a,2,c*pi)+ar(PitchShift,c,0.5,f.(1)*f.(0.1)+2,0.05,1,0.15),5)+ar(a,50,0,ar(HPF,f.(1,[0,1]),1)/2)).tanh}
