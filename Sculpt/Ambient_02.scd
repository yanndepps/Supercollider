//Standard sample rate
s.options.sampleRate = 44100;

//Increase memory capacity
s.options.memSize = 2.pow(20);


o = Server.local.options;

//16 output bus channels for JackRouter
o.numOutputBusChannels = 16;

//Connect JackRouter to SC
//s.options.device_("JackRouter");

s.options.device_("BlackHole 16ch");

//To check if JackRouter is connected
ServerOptions.devices;


Server.killAll;

s.boot;



//MIDI CODE TO USE FOR KEYBOARD

MIDIClient.init;
MIDIIn.connectAll;

~notes = Array.newClear(128);


(
MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	~notes[nn] = Synth.new(
		\synthpad3, [
			\freq, nn.midicps,
			\amp, vel.linexp(1, 127, 0.1, 0.75),
	        \gate, 1,
	])
});
)



(
MIDIdef.noteOff(\noteOffTest, {
	arg vel, nn;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
})
)



/*
SYNTH CHARACTERISTICS:
1. UNISON
2. LFO-PULSE WIDTH
3. SUB-OSCILLATORS
4. NOISE
5. DISTORTION
6. FILTER ENVELOPE
7. AMP ENVELOPE
*/



~inputbus = Bus.audio(s, 2);



(
SynthDef.new(\synthpad3, {
	arg freq, mainamp, distamp, distsmooth, s, f, which, val, out=0;
	var sig1a, sig2a, subosca, siga, sig1b, sig2b, suboscb, sigb, sig1c, sig2c, suboscc, sigc, sig1d, sig2d, suboscd, sigd, mainsig, noise, dist, pan, filter, ampenv, filter2;
    sig1a = Pulse.ar(freq*1.0052121400414762, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	sig2a = Pulse.ar(freq*1.0052121400414762, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	subosca = Pulse.ar(freq/2*1.0052121400414762, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	siga = sig1a + sig2a + subosca;
	sig1b = Pulse.ar(freq*0.9948148855014215, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	sig2b = Pulse.ar(freq*0.9948148855014215, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	suboscb = Pulse.ar(freq/2*0.9948148855014215, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	sigb = sig1b + sig2b + suboscb;
	sig1c = Pulse.ar(freq*1.0026026830412313, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	sig2c = Pulse.ar(freq*1.0026026830412313, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	suboscc = Pulse.ar(freq/2*1.0026026830412313, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	sigc = sig1c + sig2c + suboscc;
	sig1d = Pulse.ar(freq*0.9974040733330809, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	sig2d = Pulse.ar(freq*0.9974040733330809, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	suboscd = Pulse.ar(freq/2*0.9974040733330809, 0.5*LFTri.kr({Rand(1,3)}), 0.25);
	sigd = sig1d + sig2d + suboscd;
	noise = WhiteNoise.ar(1);
	dist = CrossoverDistortion.ar(noise, distamp, distsmooth);
	mainsig = siga + sigb + sigc + sigd + dist;
	mainsig = mainsig*Select.kr(which, [LFTri.kr(val), SinOsc.kr(val), LFPulse.kr(val), LFSaw.kr(val)]);
	filter = BLowPass.ar(mainsig, EnvGen.kr(Env([100, 1000, 60], [s, f], [-1, 12]), doneAction:0));
	ampenv = EnvGen.kr(Env([0,1,0], [0.01, 5.5]), doneAction:2);
	filter = filter*ampenv;
	filter2 = BLowPass.ar(filter, 1000);
	pan = PanAz.ar(2, filter2, 0.0, 1, 2);
    Out.ar(out, mainamp*pan.dup);
}).add;
)


(
~ambient = Ppar([
~pad = Pbind(
	\instrument, \synthpad3,
	\freq, Pseq([[220, 329.63, 392.00], [196.00, 246.94, 659.25], [349.23, 523.25, 220]], inf),
	\stretch, 9.0,
	\dur, 1/4,
	\distamp, Pdefn(\amp, 0.8),
	\distsmooth, Pdefn(\smooth, 0.8),
	\s, Pdefn(\attack, 2.5),
	\f, Pdefn(\release, 2.5),
	\which, Pdefn(\whichlfo, 0),
	\val, Pdefn(\lfoval, 0.1),
	\mainamp, 1.0,
	\out, 0),
	//\out, Pdefn(\outbus),
~lead = Pbind(
	\instrument, \synthpad3,
	\freq, Prand([220, 329.63, 392.00, 196.00, 246.94, 659.25, 349.23, 523.25, 220]*2, inf),
	\stretch, 9.0,
	\dur, Pseq([Pseq([2], 1), Prand([1/4, 1/8, 1/16], inf)], inf),
	\distamp, Pdefn(\amp2, 0.8),
	\distsmooth, Pdefn(\smooth2, 0.8),
	\s, Pdefn(\attack2, 2.5),
	\f, Pdefn(\release2, 2.5),
	\which, Pdefn(\whichlfo2, 0),
	\val, Pdefn(\lfoval2, 0.1),
	\mainamp, Pdefn(\mainamp, 0.1),
	\out, 2,
	)
]).play;
)



// CONTROLS FOR PAD
//DISTORTION:

Pdefn(\amp, 0.8);
Pdefn(\smooth, 0.8);



//ENVELOPE:
Pdefn(\attack, 0.1);
Pdefn(\release, 2.5);



//LFO:
Pdefn(\whichlfo, 1);
Pdefn(\lfoval, 0.5);





//CONTROLS FOR LEAD
//DISTORTION:

Pdefn(\amp2, 0.8);
Pdefn(\smooth2, 0.8);



//ENVELOPE:
Pdefn(\attack2, 1.5);
Pdefn(\release2, 1.5);
Pdefn(\mainamp, 0.15);



//LFO:
Pdefn(\whichlfo2, 0);
Pdefn(\lfoval2, 3);





