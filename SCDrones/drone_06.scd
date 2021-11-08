// nxE004 -> computer.music.neix

~x.play;

~x = { var alpha,beta; alpha = rrand(99,399); beta = alpha = rrand(99,399);Pan2.ar(LeakDC.ar(Normalizer.ar(BPeakEQ.ar(BPeakEQ.ar(BPeakEQ.ar(BPeakEQ.ar(
FreeVerb.ar(Formant.ar(TRand.kr(alpha,alpha+(rrand(5,20)),Impulse.kr(rrand(10,100))), TRand.kr(beta,beta+(rrand(5,20)),Impulse.kr(rrand(10,100))), EnvGen.kr(Env.adsr,Impulse.kr(rrand(100,666)))*rrand(666,3333),0.125),
rrand(0.5,1.0),rrand(0.5,1.0),rrand(0.5,1.0))
,100,6.0,12),1000,6.0,0),5000,6.0,0),10000,6.0,12),0.6,0.1)),0)
};
