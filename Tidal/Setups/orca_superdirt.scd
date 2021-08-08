// Orca + SuperDirt setup

SuperDirt.default = ~dirt;

(
// Add your scales here, to use with =S message
var myScales = [Scale.egyptian, Scale.dorian];

// Map your synths/samples here in (`sample_name`, `number`) pairs
// `sample_name` would be the name of the sample/synth in SuperDirt
// `number` is the number that you will use in ORCA
// e.g.  `=A` is mapped to `klang` sample
var synths = [
	// \808, \8,
	// \microStudies, \g,
	// \at2, \a,
	// \klang, \A,
	\h, \h,
	// \fm, \f,
	// \saw, \s,
	// \plk, \p,
];

// Orca sends OSC messages to port 49162 by default
var orcaPort = 49162;

~scale = myScales[0];

synths.pairsDo { |synth, pathName|
	var path = "/" ++ pathName.asString;
	OSCdef(pathName, { |msg, time, addr, recvPort|
		var note, octave, legato, gain, cut;

		// optional parameters
		if (msg.size > 0) {
			// Here you can change how you use ORCA parameters (msg[0] is the number of synth)
			note = msg[1].degreeToKey(~scale);
			octave = (msg.size >= 3).if { msg[2] } { 4 };
			legato = (msg.size >= 4).if { msg[3] } { 1 };
			gain = (msg.size >= 5).if { msg[4] / 8 } { 1 };
			cut = (msg.size >= 6).if { msg[5] } { 0 };

			SystemClock.schedAbs(time, {
				(type: \dirt, s: synth, n: note, octave: octave, sustain: legato, gain: gain, cut: cut).play;
			});
		}
	}, path, n, orcaPort);
};

// Scale message
// Use =S to set a scale from the list. If number is longer than list size, it will wrap around.
OSCdef(\S, { |msg, time, addr, recvPort|
	var scaleIdx = (msg.size >= 1).if { msg[1] } { 0 };
	// "set scale to %".format(~scale).postln;
	~scale = myScales[scaleIdx % myScales.size];
}, "/S", n, orcaPort);

"oscdefs updated"
)

// clear all
(
synths.pairsDo { |synth, pathName|
	OSCdef(synth).clear
}
)

OSCFunc.trace(true)
OSCFunc.trace(false)
