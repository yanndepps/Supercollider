s.boot;

//tweet0006
r{loop{x={GVerb.ar(MoogFF.ar(ClipNoise.ar*0.4,LFPar.kr({0.3.rand}!2,0,600,990)),9,9,1)}.play(s,0,19);3.wait;x.release}}.play

//--tweet0014
play{a=SinOscFB;sum({|i|a.ar(a.ar(a.ar(a.ar(i+1,1/9,999),1/9,a.ar(1/9,1,1/9)),a.ar(0.1,3),i+2*999),a.ar(1/9,1/9),1/9)}!9)!2}

//--tweet0017
play{b=LocalBuf(8e4,2).clear;i=Sweep.ar(BufRd.ar(2,b,Saw.ar(3.1,4e4,4e4)),8e4);BufWr.ar(Blip.ar([2,3]),b,i);BufRd.ar(2,b,i)}

//--tweet0019
play{b=LocalBuf(1e4,2).clear;i=Sweep.ar(BufRd.ar(2,b,Saw.ar(1,2e3,5e3)),5e5);BufWr.ar(Saw.ar([8,50]),b,i);BufRd.ar(2,b,i)/3}

//--tweet0220
a=SinOsc;play{RecordBuf.ar(c=InFeedback.ar,b=Buffer.alloc(s,9e4));HPF.ar(a.ar(99,c*6)/9+TGrains.ar(2,a ar:3,b,c+3,2,12),9)}

//--tweet0033
play{f=LFPar.ar(1/14).round*20+80;Splay.ar(LFPar.ar({|i|[i+1*f,i*f+(i+1/3)]}!4)>BrownNoise.ar(Pulse.ar({|i|i+1}!4,0.35))/3)}

//--tweet0045
play{a=SinOsc;a.ar(a.ar(a.ar(0.11)),a.ar(a.ar(95*a.ar(0.01,0,1,1),0,a.ar(5e-3,0,50),100),a.ar([98,97]),pi+a.ar(5e-4))).tanh}

//--pakt26
(
Ndef(\grid, {var n= 8; Mix({|i|
        var t= i/n;
        var z= LeakDC.ar(VarSaw.ar(SinOsc.ar(VarSaw.ar(i+1*VarSaw.ar(0.048, 0, 0.5, 25, 150), t, 1/3, 150), VarSaw.ar(100+i, t, VarSaw.ar(0.024, t, 0.25, 0.475, 0.5))*pi, VarSaw.ar(0.012, t, 0.75, VarSaw.ar(0.064, t, 0.5, 25, 50), 200), VarSaw.ar(0.16, t, 2/3, VarSaw.ar(0.02, t, 0.5, 7.5).abs, 300)), t));
        Pan2.ar(z, VarSaw.ar(0.02, t, 0.5), 1/n);
}!n)});
)
Ndef(\grid).play
Ndef(\grid).stop

//--pakt27
(
Ndef(\sweep, {var n= 9; GVerb.ar(Mix({|i|
        var t= i/n;
        var t2pi= t*2pi;
        var f= 2**i*10+100;
        var z= LeakDC.ar(VarSaw.ar(SinOsc.ar(i+1*0.005, SinOsc.ar(i+1*SinOsc.ar(0.05, t2pi, 0.2, 0.4), 0, 2pi), f*SinOsc.ar(0.002, t2pi, 0.3, 0.5), f), t, SinOsc.ar(i+1*0.006, t2pi, 0.4, 0.5), i.linlin(0, n-1, 0.4, 0.1)));
        Pan2.ar(z, SinOsc.ar(0.015, t2pi, i.linlin(0, n-1, 0.99, 0.2)), 1/n);
}!n), 30, 5, 0.3, 0.8, 10)});
)
Ndef(\sweep).play
Ndef(\sweep).stop

//--28

Ndef(\round).play
(
Ndef(\round, {var n= 28; GVerb.ar(Limiter.ar(LeakDC.ar(Mix({|i|
        var z= SinOsc.ar(i.linexp(0, n-1, 70, 1500), LFSaw.ar(i+1*5, 0, 0.5pi), LFSaw.ar(0.2+SinOsc.ar(i+1*0.001, 0, 0.5), i/n, 0.4).max(0))*SinOsc.ar(200+i, 0, SinOsc.ar(0.03, i+1, 0.5, 1))*SinOsc.ar(400+i, 0, SinOsc.ar(0.04, i+2, 0.5, 1))*SinOsc.ar(800+i, 0, SinOsc.ar(0.05, i+3, 0.5, 1));
        Pan2.ar(z, i.linlin(0, n-1, -0.925, 0.925), 1/n);
}!n))), 3, 5, 0.2, 0.8, 20, 0.1)});
)
Ndef(\round).stop

//--pak29
(
Ndef(\wrap, {var n= 29; Splay.ar({|i|
        var w= i+LFSaw.ar(i+1*SinOsc.ar(0.1, i/n*2pi, 1, 0.1), 0, 2, 2);
        Saw.ar(340+LFSaw.ar(0.1, i/n, 10, 10).round(20)+i)%Saw.ar(60+w, SinOsc.ar(0.01, i/n*2pi, 2, 2.05))*0.25;
}!n)});
)
Ndef(\wrap).play
Ndef(\wrap).stop

//--pakt24

Ndef(\swoop).play
(
Ndef(\swoop, {var n= 24; Mix({|i|
        var t= i/n;
        var f= SinOsc.ar(0.01, t*0.5pi).exprange(i*22+100, i*44+1000);
        var a= SinOsc.ar(0.05*t, t*2pi, 0.15).max(0);
        var z= RLPF.ar(GrayNoise.ar(a), f*(a+1), 1.4-a-t);
        Pan2.ar(z, LFTri.ar(0.05, t*4, 0.95));
}!n)});
)
Ndef(\swoop).stop

//--pakt17
Ndef(\shades).play
(
Ndef(\shades, {Mix({|i|
        var x= SinOsc.ar(0, SinOsc.ar(0.01*i+0.03, i, 2pi));
        var y= SelectX.ar(x.range(0, 4), [WhiteNoise.ar, GrayNoise.ar, PinkNoise.ar, BrownNoise.ar]);
        var z= Pan2.ar(y, x*0.4);
        BPF.ar(Rotate2.ar(z[0], z[1], i/3*2-1), i+1*500, SinOsc.kr(0, SinOsc.ar(i*0.02+0.01, i, pi)).range(1, 10), 0.3);
}!4)});
)
Ndef(\shades).stop

//--pakt16
Ndef(\wheel).play
(
Ndef(\wheel, {Splay.ar(BPF.ar(PinkNoise.ar(1!3)*SinOsc.ar(VarSaw.ar(#[0.011, 0.012, 0.013], #[0, 0.1, 0.2], 0.5, VarSaw.ar(#[0.01, 0.02, 0.03], #[0, 0.1, 0.2]).exprange(5, 50), #[300, 303, 309]), CombN.ar(Saw.ar(#[3, 2.5, 1], 0.5pi).sum, 0.05, 0.05), 3), VarSaw.ar(#[0.021, 0.022, 0.023], #[0.2, 0.1, 0.3]).exprange(500, 2000), VarSaw.ar(#[0.031, 0.032, 0.033], #[0, 0.1, 0.2]).exprange(0.06, 0.6)))});
)
Ndef(\wheel).stop

//--pakt14

Ndef(\interfere).play
(
Ndef(\interfere, {var a= #[3, 1, 5, 2]; Limiter.ar(Splay.ar(Formlet.ar(LFPulse.ar(a*100+SinOsc.ar(a, 0, a/20), 0, SinOsc.ar(a/10, 0, 0.45, 0.5), LFPulse.ar(a+a, 0, SinOsc.ar(a/10, 0, 0.45, 0.5), 0.1)), a*100+LFPulse.ar(a/2, 0, 0.5, a*SinOsc.ar(a/100, 0, 150, 200)), SinOsc.ar(a/30, 0, 0.01, 0.0125), SinOsc.ar(a/60, 0, 0.05, 0.055), 0.2)))});
)
Ndef(\interfere).stop

//--pack13

Ndef(\pulse).play
(
Ndef(\pulse, {GVerb.ar(Splay.ar(Resonz.ar(LFPulse.ar(#[121, 232, 343]), LFPulse.ar(#[0.121, 0.232, 0.343]).exprange(LFPulse.ar(#[12.1, 23.2, 34.3]).range(80, 100), LFPulse.ar(#[1.21, 2.32, 3.43].reverse).range(800, 1000)).sum*LFPulse.ar(#[0.121, 0.232, 0.343]).range(0.5, 1), 0.3, 0.15)), 34, 3, 0.2)});
)
Ndef(\pulse).stop

//--pakt12

Ndef(\waves).play
(
Ndef(\waves, {var n= 3; Mix({|i|
	var z= VarSaw.ar(i+1*0.01, 0, 0.5, 5, VarSaw.ar(i+1*10, 0, 0.5, 0.5, 10));
	var w= VarSaw.ar(i+1*VarSaw.ar(i+1*0.001, 0, 0.5, z, z*z), 0, 0.5, 0.5, 0.5);
	Pan2.ar(
		SinOsc.ar(0, VarSaw.ar(i+1*w*100, 0, w, 2pi), VarSaw.ar(i+1*w*0.1, 0, w, 0.5)),
		i.linlin(0, n-1, -0.9, 0.9),
		2/n
	)
}!n)});
)
Ndef(\waves).stop

//--pakt11

Ndef(\hail).play
(
Ndef(\hail, {Splay.ar(Ringz.ar(SinOsc.ar(#[0.000101, 0.000202, 0.000303, 0.000404, 0.000505, 0.000606], SinOsc.ar(#[101, 202, 303, 404, 505, 606], 0, SinOsc.ar(#[0.0101, 0.0202, 0.0303, 0.0404, 0.0505, 0.0606], 0, pi)))*VarSaw.ar(#[1.01, 2.02, 3.03, 4.04, 5.05, 6.06], #[0.101, 0.202, 0.303, 0.404, 0.505, 0.606], SinOsc.ar(#[0.00101, 0.00202, 0.00303, 0.00404, 0.00505, 0.00606], 0, 0.5, 0.5)), #[1010, 2020, 3030, 4040, 5050, 6060], SinOsc.ar(#[10.1, 20.2, 30.3, 40.4, 50.5, 60.6], 0, 0.1, 0.2), 0.2))});
)
Ndef(\hail).stop

//--pakt11

Ndef(\hail).play
(
Ndef(\hail, {Splay.ar(Ringz.ar(SinOsc.ar(#[0.000101, 0.000202, 0.000303, 0.000404, 0.000505, 0.000606], SinOsc.ar(#[101, 202, 303, 404, 505, 606], 0, SinOsc.ar(#[0.0101, 0.0202, 0.0303, 0.0404, 0.0505, 0.0606], 0, pi)))*VarSaw.ar(#[1.01, 2.02, 3.03, 4.04, 5.05, 6.06], #[0.101, 0.202, 0.303, 0.404, 0.505, 0.606], SinOsc.ar(#[0.00101, 0.00202, 0.00303, 0.00404, 0.00505, 0.00606], 0, 0.5, 0.5)), #[1010, 2020, 3030, 4040, 5050, 6060], SinOsc.ar(#[10.1, 20.2, 30.3, 40.4, 50.5, 60.6], 0, 0.1, 0.2), 0.2))});
)
Ndef(\hail).stop

//--pakt10

Ndef(\rain).play
(
Ndef(\rain, {
	var n= 30;
	Mix({|i|
		var z= SinOsc.ar(i+1*0.01, 0, 0.001);
		var f= i*100+100+SinOsc.ar(0.0123+z, i/n*2pi).exprange(1, 30);
		var q= SinOsc.ar(0.0234+z, i/n*2pi, 0.3, 0.7);
		var p= SinOsc.ar(0.0345+z, i/n*2pi);
		var a= SinOsc.ar(0.0456+z, i/n*2pi, 0.4, 0.45);
		var x= HPF.ar(BPF.ar(HPF.ar(ClipNoise.ar(2)*Crackle.ar(SinOsc.ar(0.0123+z, i/n*2pi, 0.1, 1.8))), f, q));
		Pan2.ar(x, p, a);
	}.dup(n));
});
)
Ndef(\rain).stop

//--pakt

Ndef(\snow).play
(
Ndef(\snow, {
	Mix({|i|
		var m= SinOsc.ar(0.005, i/5*2pi, 2pi);
		var p= WhiteNoise.ar(SinOsc.ar(i*5000+5000)*SinOsc.ar(i*500+500)*SinOsc.ar(i*50+50)*SinOsc.ar(i*5+5));
		Pan2.ar(SinOsc.ar(p, p*m, p), p, 0.5);
	}.dup(5));
});
)
Ndef(\snow).stop

//--pakt08

Ndef(\redqueen3).play
(
Ndef(\redqueen3, {GVerb.ar(LeakDC.ar(
	Saw.ar(
		Saw.ar([100, 101]+Saw.ar([102, 103], Saw.ar([4, 5], Saw.ar([1, 2], 6, 7).sum).sum).sum).exprange(Saw.ar(1/12, 4, 50), Saw.ar(1/8, 3, Saw.ar(1/16, 4, 65))),
		Saw.ar([21, 20], Saw.ar([40, 41], 0, 0.1), 0.2)
)), 60, 4, 0.5, 0.5, 5, 0.5, 0.5, 0.75)});
)
Ndef(\redqueen3).stop

//--pakt07

Ndef(\redqueen2).play
(
Ndef(\redqueen2, {GVerb.ar(LeakDC.ar(
	SinOsc.ar(
		SinOsc.ar(
			SinOsc.ar(
				SinOsc.ar(
					SinOsc.ar(
						SinOsc.ar(
							SinOsc.ar(
								1,
								0,
								2,
								SinOsc.ar(1/2).exprange(1, 2)
							),
							0,
							8,
							SinOsc.ar(1/4).exprange(4, 8)
						),
						0,
						32,
						SinOsc.ar(1/8).exprange(16, 32)
					),
					0,
					128,
					SinOsc.ar(1/16).exprange(64, 128)
				),
				0,
				512,
				SinOsc.ar(1/32).exprange(256, 512)
			),
			0,
			2048,
			SinOsc.ar(1/64).exprange(1024, 2048)
	), 0, 0.1)
), 16, 8, 0.75, 0.5)});
)
Ndef(\redqueen2).stop

//--pakt06

Ndef(\redqueen).play
(
Ndef(\redqueen, {GVerb.ar(LeakDC.ar(SinOsc.ar(SinOsc.ar([1/16, 1/12], 0, 5), SinOsc.ar(0, SinOsc.ar([SinOsc.ar(3, 0, 5, 12), SinOsc.ar(4, 0, 4, 16)], SinOsc.ar([SinOsc.ar(1/64, SinOsc.ar(0.5, 0, pi)).exprange(1, 30), SinOsc.ar(1/48, SinOsc.ar(0.75, 0, pi)).exprange(1, 30)], SinOsc.ar(SinOsc.ar(1/32, 0, 4), 0, 2pi), SinOsc.ar([1/6, 1/8], 0, 0.5pi, 2pi)), SinOsc.ar([1/3, 2/3], 0, 0.5pi, SinOsc.ar(1/8, 0, 0.5pi, 2pi))), SinOsc.ar([4/3, 3/4], 0, 0.5pi, SinOsc.ar([SinOsc.ar(1/256).exprange(80, 800), SinOsc.ar(1/256).exprange(80.8, 808)], 0, 0.5pi, 2pi)))))*0.05, 10, 3, 0.5, 0.5)});
)
Ndef(\redqueen).stop


//--pakt04
Ndef(\lines).play
(
Ndef(\lines, {Splay.ar(LeakDC.ar(SinOsc.ar([0.033, 0.066, 0.055, 0.044], SinOsc.ar([0.12, 0.13, 0.11, 0.14]*SinOsc.ar([0.151, 0.152, 0.153, 0.154], SinOsc.ar([5, 4, 3, 2], 0, 2pi), SinOsc.ar([0.043, 0.053, 0.063, 0.073], 0, [80, 60, 40, 100])), SinOsc.ar(([60, 64, 67, 71]+SinOsc.ar([0.024, 0.025, 0.026, 0.027], SinOsc.ar([0.01, 0.02, 0.03, 0.04], 0, pi), 1).round).midicps, 0, 2pi)), 0.2)))})
)
Ndef(\lines).stop

//--pakt03
Ndef(\varsaws).play
(
Ndef(\varsaws, {GVerb.ar(CombC.ar(VarSaw.ar(SinOsc.ar([0.1, 0.11], 0, 5, 100+SinOsc.ar([0.05, 0.055], 0, 50, 50).round(50)), 0, SinOsc.ar([0.2, 0.22], 0, 0.5, SinOsc.ar([0.3, 0.33], 0, 0.1, 0.5)), 0.1), 1.01, SinOsc.ar([0.4, 0.44], 0, 0.01, 1), 8), 80, 5, 0.9)})
)
Ndef(\varsaws).stop

//--pakt02
Ndef(\saws).play
(
Ndef(\saws, {Splay.ar(BPF.ar(LeakDC.ar(Saw.ar(SinOsc.ar((0..5)+1*0.02, SinOsc.ar((0..5)+1*101+300, 0, 2pi+SinOsc.ar(0.01, 0, 0.5*pi)), 400, 700))), SinOsc.ar((0..5)+1*0.004, 0, 100, 400), SinOsc.ar((0..5)+1*0.006, 0, 0.4, 0.8)))})
)
Ndef(\saws).stop

//--pakt00
Ndef(\sines).play
(
Ndef(\sines, {GVerb.ar(Splay.ar(SinOsc.ar([100, 200, 300]+SinOsc.ar([0.11, 0.22, 0.33]), SinOsc.ar([0.1, 0.2, 0.3], 0, 2pi), 0.1+SinOsc.ar([0.01, 0.02, 0.03], 0, 0.05)), SinOsc.ar(SinOsc.ar(SinOsc.ar(0.13, 0, 5, 6), 0, 8, 50), 0, 1, 1), 0.7, SinOsc.ar(1.2, 0, 0.6)), 20, 5, 1, 0.5, 25, 0, 1, 1)})
)
Ndef(\sines).stop
