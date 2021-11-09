// 2012.05.09
// Work for NX012 Class
// Comment: High Voltage Electric Lines.

p = ProxySpace.push(s.boot);

~a.play;

~a = { 
	var alpha;
	alpha = rrand(3,30);
	Pan2.ar(LeakDC.ar(Normalizer.ar(
	BPeakEQ.ar(BPeakEQ.ar(BPeakEQ.ar(BPeakEQ.ar(FreeVerb.ar(
		EnvGen.kr(Env.adsr(0.1,3,1,rrand(0.1,1.0)), 
			Impulse.kr(TRand.kr(66,133.33,Impulse.kr(rrand(0.1,0.1))))) * 
		HPF.ar(Pulse.ar(TRand.kr(alpha,alpha+10, Impulse.kr(rrand(33,100)))),
			rrand(100,15000).postln)	
	,0.1,0.1,0.1)
	,100,6.0,6),1000,6.0,0),5000,6.0,0),10000,6.0,6)
	,(1.33/0.999)*1,0.1)),0)
};

~a = nil;
