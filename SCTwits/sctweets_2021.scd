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

// 23.03.21
play{tanh(ar(a=SinOscFB,ar(a,1/64)<0*9+50,ar(a,1/8)+1/2,ar(HPF,c=ar(a,3)>0,4,5))!2+ar(Splay,ar(a,ar(Demand,ar(a,1/12),0,Dseq([1,1,2,3,4,1]*(ar(a,1/96)<0.5*19+99),inf)*b=[1,0.5,1.25]).lag3ud(1,3),ar(a,b/16)+1/3))+(ar(HPF,c>0.1,9**ar(a,1/19)+3)*ar(a,[12,9]*99)/6))}

// 24.03.21
play{b=(1..9);ar(Splay,ar(a=VarSaw,63*b+ar(a,0.49,c=b/9),0,ar(a,(d=ar(a,3e-3,c).round(1/3).lag(1.9)*91+252)+ar(a,c/9,0,b/(9+1),1/99)*b,0,c)+1/2,ar(a,6,c/3,0).max(ar(a,0.2,c)/9+(ar(a,9e-3)*0.3+0.4)))+ar(a,60,0,0.5,ar(a,3,0,0).max**3)+ar(a,d,c,ar(a,c/99)%1,1/3)/5)}

// 16.04.21
play{ar(Splay,(b=ar(a=SinOscFB,1/64))*d=ar(a,[199,ar(a,1/24)<0*99+49,ar(a,1/128)>0*249+49,99]-(f=b<0*2)*c=ar(a,1/32)<0+1.05**ar(e=Blip,2,b+4).max,ar(a,1/[88,55,66,44]).abs);d+ar(PitchShift,d,1,2)/2+ar(e,249-f,c+1,ar(BPF,ar(CombN,d,1,3/[4,3,6,8]),999,0.45))).tanh}

// 16.04.21
play{ar(f=LFCub,ar(x=Demand,t=ar(TDuty,(r={|q|Dseq(q.ascii,inf)}).("22221252222125222122121221212214")-48/12),0,r.("FDFA=A:FDFA=A:FHIHIIFHFHHDFDFFBF")+c=ar(PulseCount,t) div:32).midicps)*lagud(t,0)+ar(f,ar(x,y=ar(f,3),0,r.(":::::::::::8866:")+c).midicps,0,y<0)!2}

// 21.04.21
play{ar(LPF,Mix(Mix({|i|kr(Line,0,1,i*24)*ar(a=VarSaw,f=[kr(Demand,kr(a,(b=[1,2]+i/7)/64,i*b/40),0,Dseq(Scale.yu(\mean5).at((0..9).permute(i=i+1)),inf))+42,[30,33.084]].midicps.lag3.rotate(i)*i,0,ar(a,b/4*i/22,b)/6+0.2,kr(a,b/64/i,1/4)*kr(AmpComp,f))}!3))/9,1e4)}

// 19.05.21
play{clump(ar(HPF,ar(AllpassN,ar(a=SinOscFB,ar(Duty,b=[2,6,3,1],ar(a,b/9),Dseq((ar(a,b/24).round+(0..9)*7+29.17).midicps,inf)),ar(a,b/13).max/3*2)/8,1,0.51,8)+ar(GVerb,ar(BPF,ar(Hasher,ar(a,b/12).max,ar(a,b/c=500).max/c),2**ar(a,b/c*2)*1e4,1/99),99,9,0.2),50),2)}

// 21.05.21
play{ar(LPF,tanh(sin(d=ar(HPF,ar(MantissaMask,c=ar(b=Duty,4e-3,0,Dseries(1,[1,2],i=inf)%ar(b,8.192,0,Dseq((1..6)*75,i)))),5))+ar(a=SinOscFB,63,(f=ar(a,_).max).(0.8),d)/9+ar(a,[250,200]*ar(b,4.096,0,Dseq([4,6,5,5,5,5,3]/4,i)).lag,f.(0.08),f.(1/[99,60])/3))/2,1e4)}

// 22.05.21
play{tanh(ar(f=CombN,c=ar(RLPF,ar(a=SinOscFB,ar(Demand,t=Impulse ar:5,0,Dseq(midicps(flat([24,0,3,5,7,10,36]+.t[36,48,36,33,60,72])),inf)/g=[3,2]),a ar:0.02,e=t.lagud(1e-3,ar(a,g/99)+1.08)),3**ar(a,0.04)+e*2e3,3**ar(a,g/9)/3,4).tanh,1,1/2,4)+ar(f,c,1,1/3,5)/8+c)}

// 20.06.21
n=play{|z|ar(SinOsc,[3,2],z)/6};w=plot(o=Image(384,256),\,12@8*99);r{do(inf,{|i|o.pixels=Int32Array.fill(1e5,{|j|c=asInteger(sin(j*sin(i/1e4)*sin(i/4e3)+(x=j%385/50))/cos(i/(x+0.1))%256);248<<24+(c<<16)+(c<<8)+c});w.refresh;0.05.wait;set(n,\z,c)})}.play(AppClock)
