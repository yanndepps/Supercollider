// bass line pattern by eli fieldsteel

(
SynthDef(
	"sawbass",
	{
		|note=35, amp=1.2, cutoff=350, decay=1|
		var env, audio;
		env = EnvGen.kr(Env.new([0,1,0],[0.001,2],[3,-50]), doneAction:2);
		audio = RLPF.ar(Saw.ar(note.midicps,amp), cutoff)*env;
		audio = CombC.ar(audio, 1, 0.125, decay);
		Out.ar([0,1], audio);
	}
).store;

Pbind(*[
	\instrument: \sawbass,
	\note: Pseq(
		[
			Pseq([35,47,35,45,47],14),
			Pseq([38,50,38,38,49,37,49,37,49,30],1),
			Pseq([35,47,35,45,47]-5,8)
		],1
	),
	\dur: Pseq([0.375,0.25,0.125,0.125,0.125],inf),
	\amp: 1.4,
	\cutoff: Pseq([450,300,550,450,300],inf),
	\decay: Pseq([2,1,0.75,0.75,0.75],inf),
]
).play
)

s.boot