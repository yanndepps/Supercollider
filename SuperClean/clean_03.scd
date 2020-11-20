// an example using uio which is the built in additive synthesizer
(
Pdef(\0,
	Pbind(*[
		type: \cln,
		snd: \uio,
		amp: Pexprand(1/2,8.0),
		freq: Pfunc{
			var x = 160 * rrand(1,500).geom(1,30/29);
			x.reject{|i| i > 20000 }
		},
		dur: Pstutter(Pexprand(1,11).round,Pexprand(1,3).round/Pexprand(5,29).round).trace,
		atk: Pexprand(0.0001,1.1),
		rel: Pkey(\dur)-(Pexprand(0.000001,0.01)),
		hpf: Pexprand(20,20000),
		crv: Pexprand(-116.0,-4),
		pan: Pstutter(Pexprand(1,19),Pwhite(0.0,1.0)),
	])
).play(quant: 1);
)
