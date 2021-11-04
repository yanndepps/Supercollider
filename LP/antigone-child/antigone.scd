(/*

Copyright (c) 2018 Luka Prinčič, All rights reserved.
This program is free software distributed under
GNU General Public Licence. See COPYING for more info.
- - - - - - - - - - - - - - - - - - - - - - - - - - - -

This is source code to Antigone/Child music release and
soundtrack to the stage piece by Matija Ferlin "Staging
a Play: Antigone" by Luka Prinčič. It replicates 6
tracks from the album and 6 tracks from the stage show.

If you openned this file in SuperCollider IDE, there are
two steps you have to do:

PART I:
Place the cursos anywhere between top parenthesis
and the closing one, which is the one above the line
that sais "Cooking Synths". In fact your cursor might
already at the begining of this file, which means you can
press CTRL+RETURN to run this part of code - booting and
preparing server. The code will flash, there is no sound
yet.)

PART II:
Scroll down to "Cooking Synths" and place the cursor inside
the first block (ACT I), and press CTRL+RETURN again. The
code will flash and slowly the sound should come in. If not,
check with CTRL+M to see meters and SC output visualy.
The piece will run out in about 5 minutes. Or you can
always stop it with CTRL+<PERIOD>. And run the next block.

Then play with parameters, break the code, start again.
Make music!




*/
// Be nice. Say hi!
postln("\n\n

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
>>> Hello.                                                        <<<

    _   _  _ _____ ___ ___  ___  _  _ ___   _____ _  _ ___ _    ___
   /_\\ | \\| |_   _|_ _/ __|/ _ \\| \\| | __| / / __| || |_ _| |  |   \
  / _ \\| .` | | |  | | (_ | (_) | .` | _| / / (__| __ || || |__| |) |
 /_/ \\_\\_|\\_| |_| |___\\___|\\___/|_|\\_|___/_/ \\___|_||_|___|____|___/

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

");

Server.default.waitForBoot { // if the SC server is not yet booted, boot it


	// home folder of current script
	var dir = PathName(thisProcess.nowExecutingPath).pathOnly;

	// find samples locations
	~granSmp = PathName(dir +/+ "smp/").files;
	~granBfrList = List();
	~granBfr = List();

	// be nice and verbose in the post window while loading to buffers
	postln(" \n~~~ Loading samples for granular synthesis ..." );
	~granSmp.do({ |item, i|
		postln("   " + i + "" + item.folderName +/+ item.fileName);
		~granBfrList.add(item.fileName);
		~granBfr.add(Buffer.readChannel(s, item.fullPath, channels:[0])); // [0] forces mono!
	});


	//////////////////////////////////////////////////////////////////////////////////////
	// granulator "Granny" synth definition - basic recipe for the cake

	SynthDef(\Granny, {

		// arguments - accessible/settable from outside
		arg bufnum,
		freq = 200, fvar = 0.05,
		dur = 0.3, durvar = 0.01,
		pitch = 1, pitchvar = 0.001,
		width = 0.4,
		gain = 0.2,
		reverb = 0.5,
		posvar = 0.05,

		// lpfLFO changes the frequency of low pass filter using a slow sine oscilator
		lpfLFOSpeed = 0.013, // frequency of the oscilator
		lpfLFOSpeedVar = 0.1, // varies the freq of the LF oscilator
		lpfLFOMin = 400, // from Hz
		lpfLFOMax = 5000, // to Hz

		// lpfLFO changes the position of granulation using a slow sine oscilator
		posLFOSpeed = 0.005,
		posLFOSpeedVar = 0.1,
		posLFOMin = 0,
		posLFOMax = 1
		;

		// variables
		var signal,
		lpfFreq = SinOsc.kr(freq:lpfLFOSpeed * SinOsc.kr(freq:lpfLFOSpeedVar, mul:0.5, add:1)).linlin(
			inMin:-1, inMax:1, outMin:lpfLFOMin, outMax:lpfLFOMax),
		pos =     SinOsc.kr(freq:posLFOSpeed * SinOsc.kr(freq:posLFOSpeedVar, mul:0.5, add:1)).linlin(
			inMin:-1, inMax:1, outMin:posLFOMin, outMax:posLFOMax),

		// envelopes
		gainEnv = Env.newClear(4),
		gainEnvCtl = \gainEnv.kr(gainEnv.asArray),

		lpfEnv = Env.newClear(4),
		lpfEnvCtl = \lpfEnv.kr(lpfEnv.asArray)
		;

		// main granular synthesis generator: GrainBuf uGen
		signal = GrainBuf.ar(
			numChannels: 2, // stereo
			trigger: Impulse.kr(freq + (freq * (fvar * LFNoise2.kr(freq)))), // a UGen
			dur: dur + (durvar * LFNoise2.kr(freq)), // in seconds
			sndbuf: bufnum,
			rate: pitch + (pitchvar * LFNoise2.kr(5)), // pitch
			pos: pos + (posvar * LFNoise2.kr(freq)), // position 0-1
			interp: 2, // interpolation for pitchshifting
			pan: LFNoise1.kr(10).range(width.neg, width),
			maxGrains: 512,
			mul: gain,
			add: 0
		);

		// low pass filter
		signal = LPF.ar(
			in: signal,
			// prevent filter clicks by lagging low pass filter freq changes
			freq: Lag.kr(lpfFreq, 0.2)
			* EnvGen.kr(envelope: lpfEnvCtl, gate: 1)); // filter frequency envelope

		// fade in, sustain, fade out
		signal = signal * EnvGen.kr(envelope: gainEnvCtl, gate: 1, doneAction: 2);

		// reverb
		signal = GVerb.ar(
			in: signal,
			roomsize: 243,
			revtime: 6,
			damping: 1,
			inputbw: 1,
			drylevel: -6.dbamp,
			earlyreflevel: reverb,
			taillevel: 0.dbamp
		);

		Out.ar(0, signal);

		postln("~~~ adding SynthDef: Granny ...");

	}).add; // add to server


}

)


//////////////////////////////////////////////////////////////////////////////////////
// cooking Synths
// run each one separately one after the other.



//  ACT I
(
~act_I = Synth(\Granny,
	[
		// which sample should we use?
		\bufnum, ~granBfr.at(21), // "09 - PART II - Chorus.7.wav"

		// fade-in, fade-out
		\gainEnv, Env([0, 1, 1, 0], [1,320,40], \lin),
		\lpfEnv,  Env([0.001, 1, 1, 0.001], [20,301,30], \exp),

		// LFOSpeed is the frequency of LF oscilator, then variation and min/max points
		\lpfLFOSpeed, 0.023, \lpfLFOSpeedVar, 0.041, \lpfLFOMin, 1000, \lpfLFOMax, 8000,
		\posLFOSpeed, 0.020, \posLFOSpeedVar, 0.089, \posLFOMin, 0.56, \posLFOMax, 0.92
	]
);
)


( //  ACT II --------------------------------------------------------------------------
~act_II = Synth(\Granny,
	[
		\bufnum, ~granBfr.at(43), // "23 - The Mother.6.wav"

		\gainEnv, Env([0, 1, 1, 0], [1,320,40], \lin),
		\lpfEnv,  Env([0.001, 1, 1, 0.001], [19,301,30], \exp),

		\lpfLFOSpeed, 0.013, \lpfLFOSpeedVar, 0.041, \lpfLFOMin, 1000, \lpfLFOMax, 4000,
		\posLFOSpeed, 0.020, \posLFOSpeedVar, 0.089, \posLFOMin, 0.25, \posLFOMax, 0.90	,

	]
);
)


( //  ACT IIb  --------------------------------------------------------------------------
~act_IIb = Synth(\Granny,
	[
		\bufnum, ~granBfr.at(28), // "13 - Chorus Of The Self-Righteous.7.wav"

		\gainEnv, Env([0, 1, 1, 0], [1,320,40], \lin),
		\lpfEnv,  Env([0.001, 1, 1, 0.001], [19,301,30], \exp),

		\lpfLFOSpeed, 0.013, \lpfLFOSpeedVar, 0.054, \lpfLFOMin, 1000, \lpfLFOMax, 2000,
		\posLFOSpeed, 0.057, \posLFOSpeedVar, 0.033, \posLFOMin, 0.1, \posLFOMax, 0.6,

	]
);
)

( //  ACT III (and ACT VII!)  ------------------------------------------------------------
~act_III = Synth(\Granny,
	[
		\bufnum, ~granBfr.at(25), // "11 - Chorus Of The Persecutors And Persecuted.8.wav"
		\pitch, 0.95,

		\gainEnv, Env([0, 1, 1, 0], [1,320,40], \lin),
		\lpfEnv,  Env([0.001, 1, 1, 0.001], [19,301,30], \exp),

		\lpfLFOSpeed, 0.063, \lpfLFOSpeedVar, 0.054, \lpfLFOMin, 1500, \lpfLFOMax, 6000,
		\posLFOSpeed, 0.037, \posLFOSpeedVar, 0.033, \posLFOMin, 0.1, \posLFOMax, 0.8,

	]
);
)


( //  ACT IV  --------------------------------------------------------------------------
~act_IV = Synth(\Granny,
	[
		\bufnum, ~granBfr.at(45), // "26 - Part III - Chorus.1.wav"

		\gainEnv, Env([0, 1, 1, 0], [1,320,40], \lin),
		\lpfEnv,  Env([0.001, 1, 1, 0.001], [19,301,30], \exp),

		\lpfLFOSpeed, 0.009, \lpfLFOSpeedVar, 0.054, \lpfLFOMin, 1000, \lpfLFOMax, 6000,
		\posLFOSpeed, 0.037, \posLFOSpeedVar, 0.033, \posLFOMin, 0.35, \posLFOMax, 0.95,

	]
);
)


( //  ACT V  --------------------------------------------------------------------------
~act_V = Synth(\Granny,
	[
		\bufnum, ~granBfr.at(51), // "29 - PRELUDIUM - General Ensemble.7.wav"

		\gainEnv, Env([0, 1, 1, 0], [1,320,40], \lin),
		\lpfEnv,  Env([0.001, 1, 1, 0.001], [19,301,30], \exp),

		\lpfLFOSpeed, 0.009, \lpfLFOSpeedVar, 0.054, \lpfLFOMin, 2000, \lpfLFOMax, 9000,
		\posLFOSpeed, 0.037, \posLFOSpeedVar, 0.033, \posLFOMin, 0.05, \posLFOMax, 0.55,

	]
);
)


( //  ACT VI  --------------------------------------------------------------------------
~act_VI = Synth(\Granny,
	[
		\bufnum, ~granBfr.at(48), // "28 - Scena (Bass Solo & Chorus).8.wav"

		\gainEnv, Env([0, 1, 1, 0], [1,320,40], \lin),
		\lpfEnv,  Env([0.001, 1, 1, 0.001], [19,301,30], \exp),

		\lpfLFOSpeed, 0.031, \lpfLFOSpeedVar, 0.054, \lpfLFOMin, 700,  \lpfLFOMax, 1500,
		\posLFOSpeed, 0.037, \posLFOSpeedVar, 0.033, \posLFOMin, 0.15, \posLFOMax, 0.9,

	]
);
)


/////////////////////////////////////////////////////////////////////////////////////


(
// --------------------------------------------------------------------------
// Track 02 from the album - "Chorus 1 (SC)"

~chorus1 = Synth(\Granny,
	[
		\bufnum, ~granBfr.at(3), // "01 - PART I - Chorus.12.wav"
		\lpfLFOSpeed, 0.021, \lpfLFOMin, 700,  \lpfLFOMax, 6500,
		\posLFOSpeed, 0.017, \posLFOMin, 0.09, \posLFOMax, 0.91,
		\gain, 0.15,

		// fade-in, fade-out
		\gainEnv, Env([0, 1, 1, 0], [1,320,40], \lin),
		\lpfEnv,  Env([0.001, 1, 1, 0.001], [19,301,30], \exp),

		\lpfLFOSpeedVar, 0.054, \posLFOSpeedVar, 0.033,
	]
);
)




(
//  --------------------------------------------------------------------------
// Track 08 from the album - "Chorus 2 (SC)"

~number4 = Synth(\Granny,
	[
		\bufnum, ~granBfr.at(4), // "01 - PART I - Chorus.3.wav"
		\lpfLFOSpeed, 0.021, \lpfLFOMin, 700,  \lpfLFOMax, 6500,
		\posLFOSpeed, 0.017, \posLFOMin, 0.09, \posLFOMax, 0.91,
		\gain, 0.15,

		// fade-in, fade-out
		\gainEnv, Env([0, 1, 1, 0], [1,320,40], \lin),
		\lpfEnv,  Env([0.001, 1, 1, 0.001], [19,301,30], \exp),

		\lpfLFOSpeedVar, 0.054, \posLFOSpeedVar, 0.033,
	]
);
)




(
//  --------------------------------------------------------------------------
// Track 10 from the album - "The Oppressed 2 (SC)"

~number12 = Synth(\Granny,
	[
		\bufnum, ~granBfr.at(12), //  "05 - Chorus Of The Oppressed.11.wav"
		\lpfLFOSpeed, 0.015, \lpfLFOMin, 700,  \lpfLFOMax, 5000,
		\posLFOSpeed, 0.01, \posLFOMin, 0.05, \posLFOMax, 0.95,
		\gain, 0.15, \pitch, 0.80,

		// fade-in, fade-out
		\gainEnv, Env([0, 1, 1, 0], [1,320,40], \lin),
		\lpfEnv,  Env([0.001, 1, 1, 0.001], [15,301,30], \exp),

		\lpfLFOSpeedVar, 0.054, \posLFOSpeedVar, 0.033,
	]
);
)











