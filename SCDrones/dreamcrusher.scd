// DreamCrusher
// © Zack Scholl
// Recoded

// --- start --- //
s.options.memSize = 8192 * 256;

s.boot;

s.quit;

s.meter;
s.scope;
s.makeWindow;

FreqScope.new;

s.plotTree;

s.prepareForRecord;
s.record;
s.stopRecording;

// --- 1. Tone --- //
// start with a basic tone ( basic C3 sine wave ) and turn it into a drone
(
x = SynthDef("basic",
	{
		arg hz=131.81, amp=0.5;
		var sig;
		sig = SinOsc.ar(
			freq:hz,
			mul:amp,
		);
		// make two version -> left & right
		sig = sig.dup;
		Out.ar(0, sig);
	}
).play;
)

// change freq & amp while playing
x.set("hz", 65.41*3); // up one octave
x.set("amp", 0.01); // volume down

// --- 2. overtones --- //
// overtones are multiples of fundamental at lower volumes