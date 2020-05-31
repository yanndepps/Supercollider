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
// 08.01.18
play{Klang.ar(`[(_.linexp(0,2e4,99,1e4))!2e4,1e-3]).tanh!2}

// 01.04.18
play{q=SinOsc;a={|x...y|perform(x,\ar,*y)};Splay ar:a.(CombN,c=a.(q,0,a.(Blip,1/f=(1..8),888/a.(q,1/88,0,2,3).ceil*a.(Duty,a.(q,1/8)>0+2*1/8,0,Dseq([8,88,888],inf)))*188),1,8-f/8,8)/8+a.(CombN,a.(GVerb,a.(BPF,8*e=c.mean,88,1/8),88),1,1)+a.(q,88,0,a.(q,0,e)<0/88)}

// 19.04.18
play{a=SinOsc;f={|...x|1.5**perform(a,\ar,*x)};Splay ar:({|i|l=perform(a,\ar,f.(i+5/150)<1).abs.round(0.5);y=perform(VarSaw,\ar,1.5**l*(f.(l/155,0,5).ceil*50.05),0,f.(l*f.(l/50))-0.55,max(f.(i+1/500.05)-1,0));y+perform(PitchShift,\ar,y*f.(0.1),0.5,5,0.05,1)}!15)}

// 24.06.18
play{a=VarSaw;b=(2..6)/4;c={|f,v|Splay ar:perform(BBandPass,\ar,perform(CombC,\ar,perform(a,\ar,f*b+perform(a,\ar,4,0,0.4,v/14),0.4,perform(a,\ar,b/40)+1/4),2,perform(a,\ar,perform(a,\ar,b/4e4)+1*b/4,b/400).lag+1,4)/v,4**b*44%1e4,9).tanh};c.(140,14)+c.(1400,144)}

// 29.06.18
play{a=LFTri;c=perform(Splay,x=\ar,perform(Resonz,x,perform(VarSaw,x,5,0,d=perform(a,x,0.15,b=(1..5)),perform(EnvGen,x,Env.perc(f=15e-4,0.05,d,d*5),perform(a,x,b/1.5))),1.5**b*(50*perform(a,x,0.015,b/5).round+150),d+1.15*f,150));c+perform(PitchShift,x,c,1.5,0.5)}

// 14.09.18
play{a=SinOsc;c=VarSaw;Splay ar:perform(a,x=\ar,0,perform(BRF,x,perform(c,x,perform(c,x,perform(a,x,b=(6..1)*2.1)*b,0,7-b/9)>0+(perform(a,x,1/b)>perform(a,x,0.1/b)+1)*[99,198]*b/9,0,perform(c,x,b/48)+1/2),2**perform(c,x,b/24)*488,0.4)*perform(a,x,0.012,b,2pi))/2}

// 05.10.18
play{x={|z...y|perform(z,*y)};Splay ar:({|i|(b=x.(a=SinOscFB,f=\ar,x.(e=Duty,f,i+1/9,0,Dseq(9.fib%8,inf))/c=1/x.(e,f,1+i/8,0,Dstutter(24,Dseq(99/(1..4),inf))).lag(4),x.(a,f,c)))*x.(CombN,f,b,1,i/99+0.1)/8+x.(Ringz,f,x.(Pulse,f,4/9,i/19.4,c),b+1*99,c).tanh/4}!20)}

// 24.11.18
play{f={|...a|LFTri.perform(\ar,*a)};g=DelayN.perform(\ar,_);c=Splay ar:GVerb.perform(\ar,Splay ar:HPF.perform(\ar,f.(2/b=8.fib.mirror)>f.(1/b),f.(1/b/2)+1.03*3e3),b,5,*f.(1/6.fib/12)+1/2);c+f.(54,[0,1],RLPF.perform(\ar,d=g.(c),999))+RHPF.perform(\ar,g.(d),99)/8}
