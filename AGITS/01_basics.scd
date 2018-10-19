"Hello World".postln;

{SinOsc.ar}.play;

s.volume.gui;

{SinOsc.ar(LFNoise0.kr(10).range(500, 1500), mul: 0.1)}.play;

{RLPF.ar(Dust.ar([12, 15]), LFNoise1.ar([0.3, 0.2]).range(100, 3000), 0.12)}.play;

// use parens to force a specific order of operation:
5 + (2 * 2);

// quick record
s.record;
{Saw.ar(LFNoise0.kr([2, 3]).range(100, 2000), LFPulse.kr([4, 5]) * 0.1)}.play;
s.stopRecording;
// GUI with record, volume, mute:
s.makeWindow;

// vars starting with a tilde are Environment vars; lowercase letter are Interpreter vars
~myFreqs = [415, 220, 440, 880, 220, 990];
~myDurs = [0.1, 0.2, 0.2, 0.5, 0.2, 0.1];
Pbind(\freq, Pseq(~myFreqs), \dur, Pseq(~myDurs)).play;

// local vars are declared with the keyword var; they exist only within the scope of a code block
(
var apples = 4, oranges = 3, lemons = 8, bananas = 10;
["citrus fruits", oranges + lemons].postln;
["non-citrus fruits", bananas + apples].postln;
"End".postln;
apples; // -> 4
)
apples; // -> nil

// vars can be reassigned at any time :
a = 10 + 3;
a.postln;
a = 999;
a.postln;

// End of Part I