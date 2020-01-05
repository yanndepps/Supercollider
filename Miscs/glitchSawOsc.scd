(
Ndef(\x,
	{arg freq1=100, freq2=107, freq3=170, hyst=20, lowLim=0.15, upLim=0.3, amp=0.8;
	var sig;
		sig = GlitchSawOsc.ar(freq1, freq2, freq3, hyst, lowLim, upLim);
		sig*amp ! 2
}).play;
);
Ndef(\x).gui;
Ndef(\x).clear;
(
Spec.add(\freq1, \freq.asSpec);
Spec.add(\freq2, \freq.asSpec);
Spec.add(\freq3, \freq.asSpec);
Spec.add(\upLim, \amp.asSpec);
Spec.add(\lowLim,\amp.asSpec);
Spec.add(\hyst,ControlSpec(1,1000,'lin',0,10));
)