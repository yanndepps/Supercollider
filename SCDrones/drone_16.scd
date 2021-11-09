// 2012.05.04
// Work for NX014 Class
// Inspiration: A Rukano Tweet. Thanks rukano!
// Comment: Cosmic Organ.

p = ProxySpace.push(s.boot);

~a.play;

~a = {  var alpha,gamma;
		alpha= LFNoise2;
	        gamma= {[rrand(30,50),rrand(50,70),rrand(50,70),rrand(70,100)].choose.midicps*alpha.kr(1,0.01,1)}!24;
	Pan2.ar(LeakDC.ar(Normalizer.ar(
		BPeakEQ.ar(BPeakEQ.ar(BPeakEQ.ar(BPeakEQ.ar(FreeVerb.ar(
	Splay.ar(RLPF.ar(LFSaw.ar(gamma)/4,gamma*LFCub.kr(rrand(0.01,0.1),0,2,3),alpha.kr(1/8,0.6,0.7)))			
		,0.1,0.1,0.1)
		 ,100,6.0,6),1000,6.0,0),5000,6.0,0),10000,6.0,6)
		 ,(0.8/0.999)*1,0.1)),0)
};

~a = nil;
