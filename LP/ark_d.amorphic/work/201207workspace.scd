// =====================================================================
// SuperCollider Workspace
// =====================================================================



////////////////////////////////////////////////////////////////////////
(
~tempo = 2;
~tempoSynth = { |tempo=2| Impulse.ar(tempo)*1 }.play;
~myClock = TempoBusClock.new(~tempoSynth);
SynthDef(\beep, { Out.ar(0, Impulse.ar(\freq.kr(440), mul:\amp.kr)!2*EnvGate()) }).add;
{
	Ndef(\a).proxyspace.clock = ~myClock;
	Ndef(\a).proxyspace.quant = 1;
	Ndef(\b).proxyspace.clock = ~myClock;
	Ndef(\b).proxyspace.quant = 1;
	
	Ndef(\a, Pbind(\instrument, \beep,
		\dur, 1,
		\freq, ~tempo,
		\amp, 1));
	Ndef(\b, {Impulse.ar(~tempo, 1, mul:1)!2});
	
	Ndef(\a).play;
	Ndef(\b).play;
	
}.fork(~myClock);
)

s.record

/* 

https://scsynth.org/t/how-to-sync-between-clock-and-running-synth/2979

The code above causes Pulses and notes from Pbind to go out of
sync, which to me is unexpected. I read Scheduling and Server timing
doc, but I’m not sure I understand how to force clock on the lang be
in sync with an oscilation on the server. Could anyone provide any
insight? Is this drift inherent in the architecture and needs to be
overcome in a different way - Synth on server controling events in the
lang? I might getting some things completely wrong. 

*/










(
{
	WhiteNoise.ar([1,1])
	//* LFPulse.ar(LFTri.ar(0.1).range(10,1),1, width:0.1)
	* EnvGen.ar(
		envelope: Env.adsr([0.001,0.0001], 0.2, MouseX.kr(0,01), 0.1),
		gate: LFPulse.ar(LFTri.ar(0.1).range(10,1), width:0.1)
	)
}.play
//}.plot(1)
)

s.scope


([ Env.adsr(0.00001, 0.2, 0.5, 0.2),Env.adsr(0.001, 0.2, 0.5, 0.2)]).plot





50.do({"whatever you want to do, you can do, but ".post;})

s.meter
s.plotTree




//////////////////////////////////////////////////////////////////////////////////////////////
// lcm and gcd code tennis
// https://www.listarc.bham.ac.uk/lists/sc-users/msg68907.html

~clklcm = TempoClock.new(1);
Ndef(\lcmnoise).play(~clklcm)
Ndef(\lcmnoise).fadeTime = 10;


(
Ndef(\lcmnoise, {
	var snd, revchain;
	snd = [
		tanh(lcm(SinOsc.ar(
			LFNoise0.kr(LFNoise0.kr(1/10).exprange(0.1,1)).exprange(1,15000)
		).range(-100,100).round(1),SinOsc.ar(
			LFNoise0.kr(LFNoise0.kr(1/10).exprange(0.1,1)).exprange(1,15000)
		).range(-100,100).round(1))*0.0001),
		tanh(lcm(Saw.ar(
			LFNoise0.kr(LFNoise0.kr(1/10).exprange(0.1,1)).exprange(1,15000)
		).range(-100,100).round(1),LFCub.ar(
			LFNoise0.kr(LFNoise0.kr(1/10).exprange(0.1,1)).exprange(1,15000)
		).range(-100,100).round(1))*0.0001)
	] ;
	snd = BHiPass.ar(snd, 180);
	snd = snd.softclip * 0.8;
	snd = Splay.ar(snd, spread:1);
	revchain = snd * Lag.ar(
		LFPulse.ar(
			LFNoise0.ar(1).exprange(0.01,2),
			width:0.001),
		0.1) * LFNoise1.ar(1).range(10,10000);
	
	revchain = Greyhole.ar(       in: revchain,
		              delayTime: LFNoise1.ar(1).range(0.0001,0.2),
		                   damp: 0.5,
		                   size: LFNoise1.ar(0.1).exprange(0.0001,5),
		               feedback: 0.95);
	revchain = LeakDC.ar(revchain);
	revchain = Limiter.ar(revchain) * LFNoise1.ar([1,1]).range(0,0.9);
	snd = snd * LFNoise0.ar([0.9,0.8]).range(0,2);
	snd = snd + revchain;
	snd = LPF.ar(snd.softclip, LFNoise1.ar(0.1).exprange(100,20000)) * 1;
})
)


{tanh(lcm(SinOsc.ar(LFNoise0.ar(5).range(0.5,1000)).range(MouseX.kr(-100,100),100).round(1),SinOsc.ar.range(MouseY.kr(-100,100),100).round(1))*0.001)!2}.scope

{tanh(gcd(SinOsc.ar(MouseX.kr(1,1000,'exponential')).range(1,100).round(1),SinOsc.ar(MouseY.kr(1,1000,'exponential')).range(1,100).round(1))*0.1)!2}.scope

{tanh(lcm(Saw.ar(MouseX.kr(1,1000,'exponential')).range(-100,100).round(1),LFCub.ar(MouseY.kr(1,1000,'exponential')).range(-100,100).round(1))*0.001) * [1,0]}.scope

///////////////////////////////////////////////////////////////
// https://www.listarc.bham.ac.uk/lists/sc-users/msg68916.html
(
{
	var a = LFSaw.ar(2) * 100;
	var b = LFSaw.ar(1.2) * 100;
	SinOsc.ar(lcm(a, b).poll + 300) * 0.1
}.play;
)



(
{
	var a = LFSaw.ar(0.02) * 300 + 1;
	var b = LFSaw.ar(1.24 + [0, 0.1]) * 200 + 1;
	SinOsc.ar(gcd(a, b).poll * 30 + 300) * 0.1
}.play;
)



(
{
	var a = LFSaw.ar(0.012) * 300 + 1;
	var b = LFSaw.ar(0.24 + [0, 0.01]) * 200 + 1;
	SinOsc.ar(gcd(a, b).poll * 30 + 300) * 0.1
}.play;
)



(
{
	var a = LFSaw.kr(0.002) * 300 + 1;
	var b = LFSaw.kr(0.024 + [0, 0.001]) * 200 + 1;
	var freq = ((gcd(a, b) * 43 + 300).cpsmidi - 0).midicps;
	var snd;
	freq = [freq, freq/2];
	snd = SinOsc.ar(freq) * 0.1;
	//snd = snd + Saw.ar(freq*1.01, mul:0.08) * 1;
	//snd = RLPF.ar(snd, LFNoise1.ar(0.7).exprange(500, 20000), rq:0.7);
	//snd = snd + CombN.ar(snd, 1, LFNoise1.ar(1).range(0.01,0.7), 7, mul:0.4);
	snd = snd * 2;
}.play;
)

///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////


(
x = play {
 var t = PulseCount.ar(Impulse.ar(3000)) % 200;
 var u = PulseCount.ar(Impulse.ar(3000)) % 201;
 var sig = gcd(t, u + [30, 20]);
 Limiter.ar(LPF.ar(HPF.ar(sig, 50), 5000), 0.3)
}
)

x.release


(
x = play {
 var t = PulseCount.ar(Impulse.ar(3000)) % 100;
 var u = PulseCount.ar(Impulse.ar(2995)) % 100;
 var sig = gcd(t, u + [30, 25]);
 Limiter.ar(LPF.ar(HPF.ar(sig, 20), 10000), 0.3)
}
)

x.release


(
x = play {
 var a = TDuty.ar(Dseq((1..20), inf) + 41 * SampleDur.ir);
 var b = TDuty.ar(Dseq((21..1), inf) + 40 * SampleDur.ir);
 var t = PulseCount.ar(a) % 20;
 var u = PulseCount.ar(b) % 20;
 var sig = gcd(t, u + [3, 7]);
 Limiter.ar(LPF.ar(HPF.ar(sig, 20), 10000), 0.3)
}
)

x.release


(
x = play {
 var a = TDuty.ar(Dseq((1..10), inf) + 102 * SampleDur.ir);
 var b = TDuty.ar(Dseq((1..10), inf) + 101 * SampleDur.ir);
 var c = TDuty.ar(Dseq((1..10), inf) + 100 * SampleDur.ir);
 var t = PulseCount.ar(a) % 100;
 var u = PulseCount.ar(b) % 101;
 var v = PulseCount.ar(c) % 102;
 var sig = gcd(gcd(t + [0, 0], u + [0, 10]), v + [0, 20]);
 Limiter.ar(LPF.ar(HPF.ar(sig, 20), 10000), 0.3)
}
)

x.release


(
x = play {
 var a = TDuty.ar(Dseq((1..10), inf) + 52 * SampleDur.ir);
 var b = TDuty.ar(Dseq((1..11), inf) + 51 * SampleDur.ir);
 var c = TDuty.ar(Dseq((1..12), inf) + 50 * SampleDur.ir);
 var t = PulseCount.ar(a) % 200;
 var u = PulseCount.ar(b) % 201;
 var v = PulseCount.ar(c) % 202;
 var sig = gcd(gcd(t + [0, 0], u + [0, 1]), v + [0, 2]);
 Limiter.ar(LPF.ar(HPF.ar(sig, 20), 10000), 0.3)
}
)

x.release


(
x = play {
 var a = TDuty.ar(Dseq((1..10), inf) + 152 * SampleDur.ir);
 var b = TDuty.ar(Dseq((1..11), inf) + 151 * SampleDur.ir);
 var c = TDuty.ar(Dseq((1..12), inf) + 150 * SampleDur.ir);
 var t = PulseCount.ar(a) % 100;
 var u = PulseCount.ar(b) % 101;
 var v = PulseCount.ar(c) % 102;
 var sig = gcd(gcd(t + [0, 0], u + [0, 1]), v + [0, 2]);
 Limiter.ar(LPF.ar(HPF.ar(sig, 20), 10000), 0.3)
}
)

x.release


////////////////////////////////////




//distorted amplitude mod (a is unipolar)
(
x = scope {
 var a = SinOsc.ar(MouseX.kr(1,300)).range(1,100);
 var b = SinOsc.ar(MouseY.kr(1,300))*40;

 var sig = gcd(a,b)%100; //distort
 var sig2 = lcm(a,b)%300; //distort

 tanh([sig*sig2,a*b]*0.0001)

}
)



(
x = play {
 var c = TDuty.ar(Dseq((51..77), inf) * XLine.kr(100,0.1,100)* SampleDur.ir);
 var t = PulseCount.ar(Impulse.ar(10)) % 300;
 var u = PulseCount.ar(c) % 101;
 var sig = gcd(t, u + [0, 2]);
 var sig2 = gcd(lcm(t+ [0, 2], u ),sig);

 sig = SinOsc.ar(sig * 443 + 600) * 0.1;
 sig2 = SinOsc.ar(sig2 * 43 + 61) * 0.4;

 Limiter.ar(LPF.ar(HPF.ar(sig, 50)+sig2, 5000), 0.3)

}
)

(
x = play {
 var c = TDuty.ar(Dseq((1..99), inf) * XLine.kr(10,0.01,100)* SampleDur.ir);
 var t = PulseCount.ar(Impulse.ar(MouseX.kr(1,100))) % 500;
 var u = PulseCount.ar(c) % 501;
 var sig = gcd(t, u + [0, 2]);
 var sig2 = gcd(lcm(t+ [1, 3], u ),sig);

 sig = SinOsc.ar(sig * 443 + 400) * 0.1;
 sig2 = SinOsc.ar(sig2 * 53 + MouseY.kr(1,99)) * 0.3;

 Limiter.ar(LPF.ar(HPF.ar(sig, 50)+sig2, 5000), 0.3)

}
)



(
x.release;
x = play {
var a = TDuty.ar(Dseq((1..20), inf) + 41 * SampleDur.ir);
var b = TDuty.ar(Dseq((21..1), inf) + 40 * SampleDur.ir);
var t = PulseCount.ar(a) % 20;
var u = PulseCount.ar(b) % 20;
var daniel_sig = gcd(t, u + [3, 7]);
var julian_a = LFSaw.kr(0.002) * 300 + 1;
var julian_b = LFSaw.kr(0.024 + [0, 0.001]) * 200 + 1;
var julian_sig = SinOsc.ar(gcd(julian_a, julian_b).poll * 43 + 300) * 0.1;
var sig = Mix.new([daniel_sig * 0.125, julian_sig * 7, SinOsc.ar(daniel_sig * 17 + 200) ]);
Limiter.ar(LPF.ar(HPF.ar(sig, 20), 10000), 0.3)
}
)

///////////////////////////////////////////////////////////////////

(
x = play {
 var a = TDuty.ar(Dseq((0..3), inf) + 50 * SampleDur.ir);
 var b = TDuty.ar(Dseq((3..0), inf) + 50.1 * SampleDur.ir);
 var mod = 50;
 var t = PulseCount.ar(a) % mod;
 var u = PulseCount.ar(b) % mod;
 var n, j, d, e;

 d = LocalIn.ar(2);
 n = gcd(t, u + [0, 1]);
 e = n.linexp(0, mod, 70, 10000);
 j = SinOsc.ar(e, 0, d / 2);

 LocalOut.ar(e.reverse);
 Out.ar(0, Limiter.ar(LPF.ar(HPF.ar(j, 20), 10000), 0.3) * EnvGate())
}
)

x.release


// gcd feedback used for FM

(
x = play {
 var a = TDuty.ar(Dseq((0..3), inf) + 50 * SampleDur.ir);
 var b = TDuty.ar(Dseq((3..0), inf) + 50.1 * SampleDur.ir);
 var mod = 50;
 var t = PulseCount.ar(a) % mod;
 var u = PulseCount.ar(b) % mod;
 var n, j, d, e;

 d = LocalIn.ar(2);
 n = gcd(t, u + [0, 1]);
 e = n.linexp(0, mod, 70, 10000);
 j = SinOsc.ar(e * (d / 10 + 1));

 LocalOut.ar(d.reverse);
 Out.ar(0, Limiter.ar(LPF.ar(HPF.ar(j, 20), 10000), 0.3) * EnvGate())
}
)

x.release


// GCD SINMODFEED /////////////////////////////////////////////////////////////////////////////////////////
// feedback of modulated SinOsc
(
x = play {
	var a = TDuty.ar(Dseq((0..3), inf) + 5 * SampleDur.ir);
	var b = TDuty.ar(Dseq((3..0), inf) + 5.01 * SampleDur.ir);
	var mod = 50;
	var t = PulseCount.ar(a) % mod;
	var u = PulseCount.ar(b) % mod;
	var n, j, d, e, c;

	d = LocalIn.ar(2);
	n = gcd(t, u + [0, 1]);
	e = n.linexp(0, mod, 70, 10000);
	j = SinOsc.ar(e);
	LocalOut.ar(j * d);
	c = CombC.ar(j, 1, [0.009,0.007,0.008, 0.006] * LFNoise1.ar([0.01,0.01]).range(1.3,0.7), 30, mul:0.05);
	j = j * LFNoise1.ar(0.2).range(0,0.5) + Splay.ar(c);
	j = Greyhole.ar(j, damp:0.5, diff:0.5 size:4);
	j = Limiter.ar(LPF.ar(HPF.ar(j, 20), LFNoise1.kr(0.1).exprange(200,18000)), 0.5, 0.2);
	j = j * LFPulse.ar([2.2,4.4]*2, width:LFNoise1.ar(0.2).range(0.8,0.95)).range(LFNoise1.ar(0.1).range(0,1),1);
	j = j + LFPulse.ar([2.2,4.4], mul: LFNoise1.kr(1/10).range(0,0.5) * Line.kr(0,1,10));
	j = LeakDC.ar(j);
 
 Out.ar(0, j * EnvGate())
}
)

x.release



(
x = play {
 var a = TDuty.ar(Dseq((0..3), inf) + 50 * SampleDur.ir);
 var b = TDuty.ar(Dseq((4..0), inf) + 50 * SampleDur.ir);
 var mod = 100;
 var t = PulseCount.ar(a) % mod;
 var u = PulseCount.ar(b) % mod;
 var n, j, d, e;

 d = LocalIn.ar(2);
 n = gcd(t, u + [0, 1]);
 e = n.linexp(0, mod, 70, 10000);
 j = SinOsc.ar(e);
 LocalOut.ar(j * d);
 
 Out.ar(0, Limiter.ar(LPF.ar(HPF.ar(j, 20), 10000), 0.3) * EnvGate())
}
)

x.release



//////////////////////////////

(
{

var freq,time, ex, delay, filter, local;

freq = 440;

time = freq.reciprocal;

ex = WhiteNoise.ar * (Pulse.ar(1,time).abs);

local = LocalIn.ar(1);

filter = ex+local;

delay = DelayN.ar(filter, time, time-ControlDur.ir);

//LocalOut.ar(LeakDC.ar(gcd((delay*120),120)/Line.kr(120,12000,10))*0.9);

LocalOut.ar(LeakDC.ar(gcd((delay*120),120)/MouseX.kr(120,12000))*MouseY.kr(0.1,0.97,'exponential'));

Out.ar(0, tanh(filter))

}.scope
)


//////////////////////////////////////////////////////////////////


(
{
 var factors = [2,3,5,7];
 var fprod = factors.product;
 var m;
 var input = SinOscFB.ar(440,MouseX.kr(0,2pi)); //PMOsc

 //either 1 or factor randomly over time
 m = factors.collect{|f| (ToggleFF.ar(Dust.ar(LFNoise0.kr(f).range(0.2,2))) * (f-1)) + 1 };

 (gcd(input * fprod,m.product)/(fprod))!2;

}.scope
)



(
{
 var factorfunc;
 var f1 = [2,3,5]; //[2,2,2,3,5,7];
 var f2 = [2,3,5]; //[2,2,3,7];
 var scaling = gcd(f1.product,f2.product);
 var gcdoutput;

 factorfunc = {|factors|
 var fprod = factors.product;

 //either 1 or factor randomly over time
 factors.collect{|f| (ToggleFF.ar(Dust.ar(LFNoise0.kr(f).range(1,MouseX.kr(16,440,'exponential')))) * (f-1)) + 1 };

 };

 gcdoutput = gcd(factorfunc.(f1).product,factorfunc.(f2).product)/scaling;

 (SinOsc.ar(MouseX.kr(20,2000)*gcdoutput)*0.3)!2

}.scope
)





(
{
 var factorfunc;
 var f1 = [2,2,2,3,5,7,11];
 var f2 = [2,2,3,7,13];
 var scaling = gcd(f1.product,f2.product);
 var scaling2 = lcm(f1.product,f2.product);
 
 var gcdoutput,lcmoutput;

 factorfunc = {|factors|
 var fprod = factors.product;

 //either 1 or factor randomly over time
 factors.collect{|f| (ToggleFF.ar(Dust.ar(LFNoise0.kr(f).range(1,MouseY.kr(1,440,'exponential')))) * (f-1)) + 1 };

 };
 
 f1 = factorfunc.(f1).product;
 f2 = factorfunc.(f2).product;

 gcdoutput = gcd(f1,f2)/scaling;
 lcmoutput = lcm(f1,f2)/scaling2;

 //SinOsc.ar(MouseX.kr(20,[2000,4001])*[gcdoutput,lcmoutput])*0.3
 //SinOsc.ar(([gcdoutput,lcmoutput]*2000) + (gcdoutput*MouseX.kr(0.1,10,'exponential')*SinOsc.ar(lcmoutput)))*0.3
 PMOsc.ar(lcmoutput*[5000,5001],gcdoutput*[700,703],MouseX.kr(1,10))
 
}.scope
)




/////////////////////////////////////


(
Ndef(\x, {

	var in, d, a;
	var z1, z2, m, freq, freq2;
	m = MouseX.kr(-10, 10);
	in = LFSaw.kr(0.062).range(-10, 10) ;
	in = in + (MouseY.kr(0, 5) * (0..8));
	d = in.frac;
	a = 0.8 - d.moddif(0.5, 1);
	z1 = gcd(in, m) + d;
	z2 = lcm(in, m) + d;
	freq = 120 * ([z1, z2].flop.abs + 1);
	(SinOsc.ar(freq) * AmpComp.kr(freq) * a).mean * 0.6

}).play
)
