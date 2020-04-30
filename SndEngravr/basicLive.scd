s.boot;
s.meter;
s.plotTree;

s.reboot;
s.quit;


// Mic synthdef

(
SynthDef.new(\mic, {
	arg in=0, out=0, amp=0.8;
	var sig;
	sig = SoundIn.ar(in!2);
	sig = sig*amp;
	Out.ar(out, sig);
}).add;
)

~micSynth = Synth(\mic);
~micSynth.free;

// Delay, Synth & Bus
// the maxdelaytime (maxDel here) is used to start delay buffer size

(
SynthDef.new(\delayL, {
	arg in=0, amp=0.5, maxDel=4, delTime=4, mix=0.5, pan=0, out=0;
	var sig, delay;
	sig = SoundIn.ar(in!2);
	sig = sig*amp;
	delay = DelayL.ar(sig, maxDel, delTime);
	sig = XFade2.ar(sig, delay, mix);
	Out.ar(out, sig);
}).add;
)

~delSynth = Synth(\delayL);
~delSynth.free;

~delSynth.set(\delTime, rrand(0.1, 3));   // do not exceed maxDel value

~delBus = Bus.audio(s, 2);
~delBus.free;

~delSynth = Synth.new(\delayL, [\in, ~delBus, \mix, 0.63]);   // for group syntax
~delSynth.free;

// Reverb & Bus

(
SynthDef.new(\reverb, {
	arg in, deltime=0.1, revtime=2, lpf=5000, mix=0.2, amp=1, out=0;
	var dry, wet, temp, sig;
	dry = In.ar(in,2);
	wet = 0;
	temp = In.ar(in,2);
	temp = DelayN.ar(temp, 0.2, deltime);
	16.do{
		temp = AllpassN.ar(temp, 0.04, {Rand(0.001, 0.05)}!2, revtime);
		temp = LPF.ar(temp, lpf);
		wet = wet + temp;
	};
	sig = XFade2.ar(dry, wet, mix*2-1, amp);
	Out.ar(out, sig);
}).add;
)

~reverbSynth = Synth.new(\reverb);
~reverbSynth.free;

~reverBus = Bus.audio(s,2);
~reverbSynth = Synth.new(\reverb, [\in, ~reverbBus, \mix, 0.63]);   // for group syntax

// group setup

(
~micGrp = Group.new;
~delGrp = Group.after(~micGrp);
~revGrp = Group.after(~delGrp);
)

(
~micSynthDirect = Synth(\mic, [\in, 0, \out, ~reverbBus], ~micGrp);
~delSynthDirect = Synth(\delayL, [\in, ~delBus, \amp, 0.3, \mix, 0.5, \delTime, 0.33, \out, ~reverbBus], ~delGrp);
~revSynthDirect = Synth(\reverb, [\in, ~reverbBus, \amp, 0.3, \mix, 0.33, \revtime, 1, \out, 0], ~revGrp);
)


(
~micSynthDirect.free;
~delSynthDirect.free;
~revSynthDirect.free;
)


(
~micGrp.free;
~delGrp.free;
~revGrp.free;
)

~revSynthDirect.set(\revtime, rrand(1,10), \lpf, rrand(1000,5000), \mix, rrand(0.1, 0.88));
~delSynthDirect.set(\delTime, rrand(0.1, 4));

// ---