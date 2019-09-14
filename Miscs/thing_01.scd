(

	var rep = [4, 8, 16, 32];
	var n = rep.choose;
	var x = [

	      54, 60, 66, 72, 81, 90, 96, 102,
	      108, 128, 132, 144, 162, 180, 192, 204,
	      216, 240, 264, 288, 324, 360, 384, 408,
	      432, 480, 528, 576, 648, 720, 768, 816,
	      864, 960, 1056, 1152, 1296, 1440, 1536, 1632,
	      1728, 1920, 2112, 2304, 2592, 2880, 3072, 3264,
	      3456, 3840, 4224, 4608, 5184, 5760, 6144, 6528,
	      6912, 7680, 8448, 9216, 10368, 11520, 12288, 528

       ];
	var fac1 = [1,10,100,1000].choose;
	var fac2 = [1,10,100,1000].choose;
	var fac3 = [1,10,100,1000].choose;
	Mix.fill(n,
		{
			var detune = 5.rand;
			var saw;
			var sin;
			detune = XLine.kr(0.1,1+250.0.rand ,2+9.0.rand) * 2.0.rand* [1,-1].choose;
			sin = SinOsc.ar(x.choose * ( 1 + ( SinOsc.ar(x.choose/fac1) * x.choose/fac2 )) + detune, 4.rand, 0.25);
			saw = RLPF.ar(Saw.ar(x.choose*0.01+detune, 0.75), x.choose, 2.rand);
			saw = [
				saw,
				saw.fold2( SinOsc.ar(x.choose/fac3).range(0.1,1) ),
				saw.wrap2( SinOsc.ar(x.choose/fac3).range(0.1,1) ),
				saw *  SinOsc.ar(x.choose/2),
				( saw *  SinOsc.ar(x.choose/fac3).range(1,20) ).tanh/2,
			].choose;
			Pan2.ar((sin+saw) * EnvGen.kr(Env.sine(12, 1/n), 1, doneAction:2),
			1.rand2) 
		}
	);
};
)

(
// DEFINE A ROUTINE
r = Routine({

    inf.do({
		f.play;
        10.wait;
    })
});
)

r.reset.play;
