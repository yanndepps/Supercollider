// sc mini 01 : recording to an audio file

s.boot;

// ---

s.recSampleFormat = "int24";  // default to 32
s.recHeaderFormat = "wav";    // default to aiff
s.recChannels;

// ---

(
Routine({
	// s.record("/home/depps/Musique/Samplz/sc-rec/snd.wav", duration:4);

	wait(0.02);

	x = {
		var sig, amp, freq, reverb;
		freq = LFNoise0.ar(8!8).exprange(60, 440).round(60);
		amp = VarSaw.ar(8, 0, 0.004).range(0, 1).pow(2);
		sig = LFTri.ar(freq);
		sig = sig * amp * 0.4;
		sig = Splay.ar(sig);
	}.play(fadeTime:0);
}).play;

)

x.release(1);

s.stopRecording;

// ---

s.makeWindow;

Platform.recordingsDir;

// ---
