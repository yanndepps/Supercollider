s.boot;
s.options.memSize=128*1024;
//Define busses
~b=Bus.audio(s,1);
~b2=Bus.audio(s,1);
~b3=Bus.audio(s,1);
~b4=Bus.audio(s,1);
~c1=Bus.control(s);
~c2=Bus.control(s);
~c3=Bus.control(s);
~buff=Buffer.alloc(s, s.sampleRate * 30.0, 2);
//Define Synths and effects
(
SynthDef(\rec,{arg r=0; var sig;
  sig=In.ar(~b3);
  RecordBuf.ar([sig,sig],~buff.bufnum,run:r,loop:0);
};
).add;
SynthDef(\play,{
  Out.ar(0,PlayBuf.ar(2,~buff,rate:-1,loop:1)*EnvGen.ar(Env([0,0.5,1.0,0.5,0],[6,5,10,9]))*0.2);
};
).add;
SynthDef(\perc,{arg freq=80; var d,l=4;
  d=LPF.ar(Mix(SinOsc.ar(freq,0,0.5),SinOsc.ar(2*freq,0,0.3),SinOsc.ar(3*freq,0,0.2))*EnvGen.kr(Env.perc(0.01,l),doneAction:2),3000);
  Out.ar(~b3,0.3*d);
  Out.ar(~b4,d);
};
).add;
SynthDef(\pad,{arg freq=80,vol=0.5; var d;
  d=LPF.ar(Mix(SinOsc.ar(freq,0,0.3),SinOsc.ar(2*freq,0,0.3),SinOsc.ar(3.01*freq,0,0.3))*EnvGen.ar(Env([0,1,0],[10,10]),doneAction:2),2000);
  Out.ar(~b,vol*d);
};
).add;
SynthDef(\delay,{
  Out.ar(0,[CombN.ar(In.ar(~b),0.5,0.3,2,mul:0.1),CombN.ar(In.ar(~b),0.5,0.4,2,mul:0.1)]);
};
).add;
SynthDef(\fx,{
  arg feed=0.999,m=0.05;
  var sig,local;
  sig = (In.ar(~b2)+In.ar(~b4)*m)*0.01;
  local= LocalIn.ar(2)+sig.dup;
  15.do{local=AllpassN.ar(local,0.06,Rand(0.001,0.06),3)};
  LocalOut.ar(local*feed);
  Out.ar(0,LPF.ar(sig+local,1000)*(0.5+In.kr(~c2)));
};
).add;
SynthDef(\out,{arg vol=0;var sig;
  Out.ar(0,[0.8*CombN.ar(In.ar(~b3),0.5,0.3,2,mul:0.1)*In.kr(~c1),CombN.ar(0.8*In.ar(~b3),0.5,0.4,2,mul:0.1)*In.kr(~c1)]);
};
).add;
SynthDef(\env,{
  Out.kr(~c1,EnvGen.kr(Env([0,0.5,1.0],[20,20]),doneAction:2));
};
).add;
SynthDef(\env2,{
  Out.kr(~c3,EnvGen.kr(Env([0,0.5,1.0],[20,20]),doneAction:2));
};
).add;
SynthDef(\ring,{arg freq=0;
  Out.kr(~c2,SinOsc.kr(freq,0,0.1));
}
).add;
SynthDef(\mic,{var s;
  s=70*SoundIn.ar(0);
  Out.ar(~b2,s.dup*In.kr(~c3));
};
).add;
)
//
(
q=Synth(\rec);
Synth(\delay);
y=Synth(\fx);
h=Synth(\ring);
z=Synth(\out);
p=Synth(\mic);
a=(12+Pxrand([36,40,41,43,45,48,52,53,55,57],inf));
fork{
  f=Pbind(\instrument,\pad,\freq,a.midicps,\dur,20).play;
  30.wait;
  g=Pbind(\instrument,\pad,\vol,0.1,\freq,(a-12.dup(10)).midicps,\dur,20).play;
  45.wait;
  e=Pbind(\instrument,\perc,\freq,a.midicps,\dur,Prand([0.1,0.2,0.3,0.4,0.5],inf),\l,1+2.rand).play;
  Synth(\env);
  80.wait;
  q.set(\r,1);
  31.wait;
  q.free;
  f.stop;
  g.stop;
  y.set(\m,0.8);
  do(60,{arg i;
    h.set(\freq,i*5);
    (0.5).wait}
  );
  Synth(\play);
  e.stop;
  Synth(\env2);
  40.wait;
  p.free;
  y.set(\feed,0.1);
};
);

s.quit;
