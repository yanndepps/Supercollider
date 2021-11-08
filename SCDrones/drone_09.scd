s.boot;

(
SynthDef("lazerdrone", {
	var in, freq, hasFreq;

	
	in = SinOsc.ar(440 * LFSaw.kr(100, 1000));

	# freq, hasFreq = Pitch.kr(
					in,
					ampThreshold: 0.09,
					median: 1);
	freq = freq * hasFreq;
	//freq.poll;
	
	SinOsc.kr(freq).poll;
	
		Out.ar(0, in + 
		SinOsc.ar(440, 
			0, 
			Clip.kr(
				SinOsc.kr(freq), 
				0)
		)!2
	);
}).play;
)
