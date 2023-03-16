/*
	trans.fail / XENO TOPIC . NETWORK
*/

//(
//s.waitForBoot({

s.boot;
(
s.meter;
s.plotTree;
s.scope;
)
// init > + load all libs/ & smp/

this.executeFile(PathName.new(thisProcess.nowExecutingPath).pathOnly +/+ "xinit.scd")

// server latency for Patterns?
s.latency = 0.05;  // nujno za video!

// init tempo
TempoClock.default.tempo = 120/120;

/////////////////////////////////////////////////////////////////////////////////////////
// BUSSES

(
// feedback delay bus // -----------------------------------------------------------
~localfdlyBus.free; ~localfdlyBus = Bus.audio(s, 2);

~localFeedFX.free; ~localFeedFX = Synth(\localFeedbackDelay1, [\inBus, ~localfdlyBus, \outBus, 0, \amount, 0.9], addAction:\addToTail);

// control
//~localFeedFX.set(\amount, 0.9)



// low pass filter // ----------------------------------------------------------------
~lpfFXBus1.free; ~lpfFXBus1 = Bus.audio(s, 2);

~lpfFX1.free; ~lpfFX1 = Synth(\lpfFX, [\inBus, ~lpfFXBus1, \outBus, ~localfdlyBus, \cutoff, 20000], target: ~localFeedFX, addAction:\addBefore);

// control
//~lpfFX1.set(\cutoffLag, 2, \cutoff, 50)
//~lpfFX1.set(\cutoffLag, 30, \cutoff, 20000)


// reverb fx  ----------------------------------------------------------------------------
~revFXbus1.free; ~revFXbus1 = Bus.audio(s, 2);
~reverb1.free;
~reverb1 = Synth(\revfx, [\inBus, ~revFXbus1, \wet, 1], addAction:\addToTail);

// saturation fx -------------------------------------------------------------------------
~satBus1.free; ~satBus1 = Bus.audio(s, 2);
~saturator1.free; ~saturator1 = Synth(\saturator, [\inBus, ~satBus1, \amp, 1], addAction:\addToTail);

//~saturator1.set(\amp, 1)
//~saturator1.set(\amp, 0)

)



/////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
// processing control / init

~sOsc.value("playVideoToggle", 1);
~sOsc.value("playVideoToggle", 0);

~sOsc.("drawPlatesimgAid", 15);

~sOsc.("drawPlatesToggle", 0);

~sOsc.value("drawTilesToggle", 1);
~sOsc.value("drawTilesToggle", 0);

~sOsc.value("drawImageBlenderToggle", 1);
~sOsc.value("drawImageBlenderToggle", 0);


osc:		Pfunc { |e|
	~sOsc.value("drawFlylinesflyBrightRotation", e.brot);
	~sOsc.value("drawFlylinesLineLength", e.linlen);
	//	~sOsc.value("drawFlylinesflyDirection", e.dir);
};






// strobe warning
~oscTitles0a.value
~sOsc.("drawPlatesToggle", 0);

// title
~oscTitles0b.value
~sOsc.("drawPlatesToggle", 0);





// ZERO /////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
// qebrus 1 ///////////////////////////////////////////////////////////////////////////////////

// ZERO TITLE1
~oscTitles1.value
~sOsc.("drawPlatesToggle", 0);

(
~zeroVinit = {
~sOsc.("drawPlatesToggle", 1);
~sOsc.("drawPlatesimgAbank", 3);
~sOsc.("drawPlatesimgBbank", 3);
~sOsc.("drawPlatesimgCbank", 3);
~sOsc.("drawPlatesimgBblendMode", 2);
~sOsc.("drawPlatesimgCblendMode", 3);

};
~zeroVinit.value;
)


(
Pbindef(\playBufP, *[ instrument: \playBuf,
	bufnum:	~getSmp.("qebrus_machines_snip1"),
	dur: Pxrand([1,1/2,1/2,1/4,Pn(1/8,2)],inf) * 1/2,
	legato:[0.9,0.1,0.2] * Pwhite(0.9,1),
	amp: Pwhite(0.5,0.6),
	rate: Pwhite(0.99,1),

	start: Pseq([
		Pn(0.1, 200),
		Pwhite(0.05,0.15,100),
		Pwhite(0.05,0.25,100),
		Pwhite(0.05,0.35,100),
		Pwhite(0.05,0.55,100),
		Pwhite(0.05,0.85,100),
		Pwhite(0.05,0.95,100),
		Pn(0.89,79),
		Pn(0.88,79),
		Pn(0.89,79),
		Pn(0.1, 100),
		Pwhite(0.05,0.95,100),
		Pn(0.1, 100),
		Pwhite(0.05,0.95,100),
		Pn(0.88,79),
		Pn(0.1, 100),
		Pwhite(0.05,0.95,100),
		Pn(0.1, 100),
		Pwhite(0.05,0.95,100),
		Pn(0.88,79),
	], inf),
	osc: Pfunc { |e|
		~sOsc.("drawPlatesimgAid", 45.rand);
		~sOsc.("drawPlatesimgBid", 45.rand);
		~sOsc.("drawPlatesimgCid", 45.rand);
		~sOsc.("drawPlatesTexAspeed", 0.rand);
		~sOsc.("drawPlatesTexBspeed", 0.rand);
		~sOsc.("drawPlatesTexCspeed", 0.rand);
		~sOsc.("drawPlatesTexAdirection", 127.rand);
		~sOsc.("drawPlatesTexBdirection", 127.rand);
		~sOsc.("drawPlatesTexCdirection", 127.rand);
	};


]).play(quant:4);

(
~platesSpeedRandRange = 0;
Pbindef(\playBufP, *[ instrument: \playBuf,
	osc: Pfunc { |e|
		~sOsc.("drawPlatesimgAid", 45.rand);
		~sOsc.("drawPlatesimgBid", 45.rand);
		~sOsc.("drawPlatesimgCid", 45.rand);
		~sOsc.("drawPlatesTexAspeed", ~platesSpeedRandRange.rand);
		~sOsc.("drawPlatesTexBspeed", ~platesSpeedRandRange.rand);
		~sOsc.("drawPlatesTexCspeed", ~platesSpeedRandRange.rand);
		~sOsc.("drawPlatesTexAdirection", 127.rand);
		~sOsc.("drawPlatesTexBdirection", 127.rand);
		~sOsc.("drawPlatesTexCdirection", 127.rand);
	};
])
);


Pbindef(\playBufBleep, *[ instrument: \playBuf,
	bufnum: ~getSmp.("Bleeps007"),
	legato:1,
	dur:Pseq([1/4,Pn(3,7)],inf),
	amp:0.3,
	rate: 1
]);

Pbindef(\playBufBleep2, *[ instrument: \playBuf,
	bufnum: ~getSmp.("Bleeps015"),
	legato:Pwhite(0.01,0.1),
	dur:Pseq([1/4,Pn(1.5,7)],inf) * 1/2,
	amp:0.2,
	rate: 0.25
]);

Pbindef(\playBufHat, *[ instrument: \playBuf,
	bufnum: ~getSmp.("Hats076"),
	legato:1,
	dur:Pseq([Pn(1/4,6),Pn(1/8,3)],inf),
	dur:1/4,
	amp: 3 * Pseq([1,1/5],inf) * Pwhite(0.3,1),
	rate: Pwhite(0.95,1.01)
]);
);




Pbindef(\playBufBleep).play(quant:4);
Pbindef(\playBufBleep2).play(quant:4);
Pbindef(\playBufHat).play(quant:4);

~platesSpeedRandRange = 10;
~platesSpeedRandRange = 20;
~platesSpeedRandRange = 30;
~platesSpeedRandRange = 30;
~platesSpeedRandRange = 70;


(
Pbindef(\playBufP).stop;
Pbindef(\playBufBleep).stop;
Pbindef(\playBufBleep2).stop;
Pbindef(\playBufHat).stop;
~sOsc.("drawPlatesToggle", 0);

)


/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////






/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
// INTERRUPT!
// somanymen granulation 1


// title2 INTERRUPT
~oscTitles2.value
~sOsc.("drawPlatesToggle", 0);


(
~drawImageBlenderInit.value;

~zeroVinit = {
    ~sOsc.("drawImageBlenderBank", 0 );
    ~sOsc.("drawImageBlenderID", 1);
    ~sOsc.("iblNum", 10); //{ iblNum = int(oscVal2) ; } // 6
    ~sOsc.("iblX", 74 ); //{ iblX = ((oscVal2-64) / 64.0) * width/2 ; } // 7  int( ((oscVal2-64) / 64.0) * width/2 ); }
    ~sOsc.("iblY", 84 ); //{ iblY = ((oscVal2-64) / 64.0) * width/2 ; } // 8
    ~sOsc.("iblWidth", 87); //{ iblWidth = oscVal2 * oscVal2 * 0.2 * norm(width, 0, width) ; } // 9  int(oscVal2 * oscVal2 * 0.05 * norm(width, 0, width));
    ~sOsc.("iblHeight", 70 ); //{ iblHeight = oscVal2 * oscVal2 * 0.1 * norm(height, 0, height) ; } // 10

    ~sOsc.("iblRot", 0 ); //{ iblRot =  radians(oscVal2 * 360 / 120) ; } // 11
    ~sOsc.("iblTexWidth", 64 ); //{ iblTexWidth = (oscVal2 - 64) * oscVal2 ; } // 18
    ~sOsc.("iblTexHeight", 64 ); //{ iblTexHeight = (oscVal2 - 64) * oscVal2 ; } // 19

    ~sOsc.("iblTexSpeedXfactor", 70 ); //{ iblTexSpeedXfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 22
    ~sOsc.("iblTexSpeedYfactor", 64 ); //{ iblTexSpeedYfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 23

    ~sOsc.("iblH", 64 ); //{ iblH = int(oscVal2) ; } // 24
    ~sOsc.("iblS", 127); //{ iblS = int(oscVal2) ; } // 25
    ~sOsc.("iblB", 127 ); //{ iblB = int(oscVal2) ; } // 26
    ~sOsc.("iblA", 40 ); //{ iblA = int(oscVal2) ; } // 27
    ~sOsc.("iblBflicker", 0 ); //{ iblBflicker = int(oscVal2) ; } // 28

    ~sOsc.("iblItX", 94 ); //{ iblItX = ((oscVal2-64) * abs(oscVal2-64) * 0.1) ; } // 29
    ~sOsc.("iblItY", 64 ); //{ iblItY = ((oscVal2-64) * abs(oscVal2-64) * 0.1) ; } // 30
    ~sOsc.("iblItTexX", 9); //{ iblItTexX = oscVal2 * 4 ; } // 31
    ~sOsc.("iblItTexY", 10 ); //{ iblItTexY = oscVal2 * 4; } // 32
    ~sOsc.("iblItRot", 20); //{ iblItRot = radians(oscVal2) ; } // 33

};

~zeroVinit.value;
~sOsc.("drawImageBlenderToggle", 1);
)

(
TempoClock.default.tempo = 120/120;

Pbindef(\granPlayP, *[
	instrument: \granPlay,
	dur: 		16,
	legato: 	1,
	amp: 		0.6,
	pitch: 		[0.5,1],
	autoPosN: 	0.03,
	autoPosS: 	0.01,
	outBus: 	~lpfFXBus1,
	gpos: 		Pdup(3, Pxrand([0.4,0.45,0.6,0.2],inf)),
	bufnum: 	Prand([
		~getSmp.("somanymen_1"),
		~getSmp.("somanymen_2")
	],inf)
]);

Pbindef(\playBufErr1, *[ instrument: \playBuf,
	bufnum: Pdup(3,
		Prand([
			~getSmp.("Misc034"),
			~getSmp.("Misc106"),
			~getSmp.("Misc188"),
			~getSmp.("RawGlitch_259"),
			~getSmp.("RawGlitch_412"),
			~getSmp.("RawGlitch_336")
		],inf)
	),
	start: 0,
	legato:1,
	dur:12,
	amp:0.7,
	rate:1
]);

Pbindef(\playBufErr2, *[ instrument: \playBuf,
	bufnum: ~getSmp.("RawGlitch_335"),
	start: 0,
	legato:1,
	dur:8,
	amp:0.7,
	rate:1,
	osc: Pfunc { |e|
	    ~sOsc.("drawImageBlenderID", 29.rand);
		~sOsc.("iblTexSpeedXfactor", 20.rand+50 ); //{ iblTexSpeedXfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 22
		~sOsc.("iblTexSpeedYfactor", 20.rand+50 ); //{ iblTexSpeedYfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 23
	}

]);

Pbindef(\harpsiPingP, *[
	instrument: \beep_sus,
	dur: Pseq([1,Pn(6)]),
	amp: 0.5,
	octave: 9,
	degree:Pseq([Rest(),Pn(-1)]),
	legato:0.01,
	outBus: ~revFXbus1,
	osc: Pfunc { |e|
    ~sOsc.("iblItRot", 10.rand+10); //{ iblItRot = radians(oscVal2) ; } // 33
	}

]);
)

Pbindef(\granPlayP).play(quant:4);

Pbindef(\playBufErr1).play(quant:4);
Pbindef(\harpsiPingP).play(quant:4);
// bass:
Pbindef(\playBufErr2).play(quant:4);


(
Pbindef(\granPlayP).stop;
Pbindef(\playBufErr1).stop;
Pbindef(\playBufErr2).stop;
Pbindef(\harpsiPingP).stop;
)
~sOsc.("drawImageBlenderToggle", 0);




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

// TRAP //


// title3 TRAP
~oscTitles3.value
~sOsc.("drawPlatesToggle", 0);

// init
(
    ~sOsc.("drawImageBlenderBank", 2 );
    ~sOsc.("drawImageBlenderID", 18);
    ~sOsc.("iblNum", 20); //{ iblNum = int(oscVal2) ; } // 6
    ~sOsc.("iblX", 64 ); //{ iblX = ((oscVal2-64) / 64.0) * width/2 ; } // 7  int( ((oscVal2-64) / 64.0) * width/2 ); }
    ~sOsc.("iblY", 24 ); //{ iblY = ((oscVal2-64) / 64.0) * width/2 ; } // 8
    ~sOsc.("iblWidth", 77); //{ iblWidth = oscVal2 * oscVal2 * 0.2 * norm(width, 0, width) ; } // 9  int(oscVal2 * oscVal2 * 0.05 * norm(width, 0, width));
    ~sOsc.("iblHeight", 20 ); //{ iblHeight = oscVal2 * oscVal2 * 0.1 * norm(height, 0, height) ; } // 10

    ~sOsc.("iblRot", 0 ); //{ iblRot =  radians(oscVal2 * 360 / 120) ; } // 11
    ~sOsc.("iblTexWidth", 64 ); //{ iblTexWidth = (oscVal2 - 64) * oscVal2 ; } // 18
    ~sOsc.("iblTexHeight", 64 ); //{ iblTexHeight = (oscVal2 - 64) * oscVal2 ; } // 19

    ~sOsc.("iblTexSpeedXfactor", 69 ); //{ iblTexSpeedXfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 22
    ~sOsc.("iblTexSpeedYfactor", 59 ); //{ iblTexSpeedYfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 23

    ~sOsc.("iblH", 70 ); //{ iblH = int(oscVal2) ; } // 24
    ~sOsc.("iblS", 127); //{ iblS = int(oscVal2) ; } // 25
    ~sOsc.("iblB", 127 ); //{ iblB = int(oscVal2) ; } // 26
    ~sOsc.("iblA", 127 ); //{ iblA = int(oscVal2) ; } // 27
    ~sOsc.("iblBflicker", 0 ); //{ iblBflicker = int(oscVal2) ; } // 28

    ~sOsc.("iblItX", 64 ); //{ iblItX = ((oscVal2-64) * abs(oscVal2-64) * 0.1) ; } // 29
    ~sOsc.("iblItY", 89 ); //{ iblItY = ((oscVal2-64) * abs(oscVal2-64) * 0.1) ; } // 30
    ~sOsc.("iblItTexX", 40); //{ iblItTexX = oscVal2 * 4 ; } // 31
    ~sOsc.("iblItTexY", 127 ); //{ iblItTexY = oscVal2 * 4; } // 32
    ~sOsc.("iblItRot", 0); //{ iblItRot = radians(oscVal2) ; } // 33
)



(
Pbindef(\akjDisChordp, *[
	instrument: \akjDisChord,
	freq:300,
	dur: 16,
	legato: 1.3,
	amp: 0.8,
	out: 0
]).play(quant:4);
)




(

Pbindef(\playBufBd1, *[ instrument: \playBuf,
	bufnum: Prand([
		~getSmp.("loop9"),
		~getSmp.("loop7"),
		~getSmp.("loop33"),
		~getSmp.("loop37")
		], inf),
	dur: Prand([4,2,1,1/2,Pn(1/4,2),Pn(1/8,4),Pseq([3/8,1/8]),Pseq([3/4,1/4])],inf),
	legato:0.1,
	start: Pxrand([0,1,2,3,4,5,6,7],inf) * 1/16,
	amp:1,
	osc: Pfunc { |e|
		~sOsc.("drawImageBlenderToggle", 1);
	    ~sOsc.("drawImageBlenderID", 19.rand);
		~sOsc.("iblTexSpeedXfactor", 30.rand+50 ); //{ iblTexSpeedXfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 22
		~sOsc.("iblTexSpeedYfactor", 20.rand+54 ); //{ iblTexSpeedYfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 23
	}

]).play(quant:4);
)

(
Pbindef(\akjClickp, *[
	instrument: \akjClick,
	dur: Pseq([
		Pn(1/8, 7), Rest(1/8), // 1
		Rest(1), // 1
		Pn(1/4, 3), Rest(3/8), Pn(1/8, 1),
		Pn(1/4, 3), Rest(3/8), Pn(1/8, 1),
		Pn(1/4, 3), Rest(4/8),
		Pn(1/8, 7),	Rest(1/8),
		Prand([ Rest(1), Pn(1/6,6) ]),
		Pn(1/8, 3),	Rest(1/8),
		Prand([ Rest(1.25), Pn(1/4, 5) ]),
		Prand([ Pn(1/8, 3), Pn(1/16, 6)	]), Rest(1/8),
	],inf),
	amp: 9/20,
	releaseTime: 0.3,
	freq:1,
	out: 0
]).play(quant:4);
)

(
Pbindef(\akjBazp, *[
	instrument: \akjBaz,
	freq: 300,
	dur: 10,
	amp: 0.3,
	legato: 0.20,

	out: 0,
	osc: Pfunc { |e|
	    ~sOsc.("iblH", 20.rand+54 );
		~sOsc.("iblItTexY", 127.rand );
	}
]).play(quant:4);
)

(
Pbindef(\granGlitcho, *[
	instrument: \granPlay,
	dur: 		4,
	legato: 	1,
	amp: 		0.5,
	pitch: 		[0.5,1],
	autoPosN: 	0.1,
	autoPosS: 	0.1,
	outBus: 	0,
	gpos: 		[0.6,0.7,0.8,0.2],
	width:		1,
	bufnum: 	Pdup(16, Pseq([~getSmp.("loop99"), ~getSmp.("loop97")],inf))
]).play(quant:4);
)




Pbindef(\akjDisChordp).stop
Pbindef(\granGlitcho).stop

(
Pbindef(\playBufBd1).stop;
Pbindef(\akjClickp).stop;
Pbindef(\akjBazp).stop;
~sOsc.("drawImageBlenderToggle", 0);
)



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
// PARITY /////////////////////////////////////////////////////////////////////////////////////////


// title4 PARITY
~oscTitles4.value
~sOsc.("drawPlatesToggle", 0);

( // init video
~sOsc.value("playVideoToggle", 0);
~sOsc.value("playVideoBank", 0 );//) {  playVideoBank = int(oscVal2); } // 44
~sOsc.value("playVideoID", 0 );//) {  playVideoID = int(oscVal2); } // 45
~sOsc.value("playVideoPausePlay", 0 );  //) {  playVideoPausePlay = boolean(int(oscVal2)); } // 47
~sOsc.value("playVideoHue", 79 ); //) {  playVideoHue = int(oscVal2); } // 44
~sOsc.value("playVideoSaturation", 0 ); //) {  playVideoSaturation = int(oscVal2); } // 44
~sOsc.value("playVideoBrightness", 127 ); //) {  playVideoBrightness = int(oscVal2); } // 44
~sOsc.value("playVideoAlpha", 127 );//) {  playVideoAlpha = int(oscVal2); } // 44
~sOsc.value("playVideoSpeed", 100);  //) {  playVideoPausePlay = boolean(int(oscVal2)); } // 47
~sOsc.value("playVideoJump", 0);
)

Pbindef(\granPlayPMARO).clear

(
Pbindef(\granPlayPMARO, *[
	instrument: \granPlay,
	dur: 		16,
	legato: 	1,
	amp: 		0.9,
	pitch: 		1,
	autoPosN: 	0.02,
	autoPosS: 	0.01,
	outBus: 	~lpfFXBus1,
	gpos: 		Pdup(2, Pseq([ 0.9, 0.8, 0.7, 0.65, 0.2, 0.1 ],inf)),
	width:		0.4,
	bufnum:		~getSmp.("saudade_CUT1")
]).play;

)


Pbindef(\granPlayPMARO).stop
(
Pbindef(\playBufHatM, *[ instrument: \playBuf,
	bufnum: [~getSmp.("Hats108"),~getSmp.("Hats085")],
	legato:1,
	//dur:Pseq([Pn(1/4,6),Pn(1/8,3)],inf),
	dur:8,
	amp: [2,0.3] * 1.2,
	rate: Pwhite(0.95,1.01),
	osc: Pfunc { |e|
		~sOsc.value("playVideoHue", 127.rand ); //) {  playVideoHue = int(oscVal2); } // 44
		~sOsc.value("playVideoSaturation", 64+64.rand ); //) {  playVideoSaturation = int(oscVal2); } // 44
	}
]).play(quant:4);
);
Pbindef(\playBufHatM).clear

(
Pbindef(\noise, *[
	instrument: \noise,
	dur:10,
	legato:0.2,
	amp:0.08,
	videojump: Pseq([10,15,20,25,30,35,40,45,50,55],inf),
	osc: Pfunc { |e|
		~sOsc.value("playVideoToggle", 1);
		~sOsc.value("playVideoPausePlay", 1 );
		~sOsc.value("playVideoJump", e.videojump);
	}

]).play(quant:4)
)

Pbindef(\noise).clear

Ndef(\subwob2).fadeTime = 10;
(
Ndef(\subwob2, {
	var snd = SinOsc.ar([43,42]* 0.5);
	snd = (snd*2).tanh;
	snd = (snd*2).clip2;
	snd = RLPF.ar(snd,
		SinOsc.ar(LFNoise1.kr(1/5).range(0.5,6)).range(50,LFNoise1.kr(1/5).range(60,150)));
	Rotate2.ar(snd[0],DelayN.ar(snd[1],0.1,0.04),LFNoise1.kr(1/5).range(-1,1)) * 0.2 * 1.3;
}).play
)
Ndef(\subwob2).fadeTime = 10;
Ndef(\subwob2).release;

Pbindef(\playBufHatM).stop
Pbindef(\noise).stop
Pbindef(\granPlayPMARO).stop

// pause
~sOsc.value("playVideoPausePlay", 0 );

// cut to black
~sOsc.value("playVideoToggle", 0);


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
// ADJUST /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

// title5 ADJUST
~oscTitles5.value
~sOsc.("drawPlatesToggle", 0);

(
    ~sOsc.("drawImageBlenderBank", 4 );
    ~sOsc.("drawImageBlenderID", 4);
    ~sOsc.("iblNum", 3); //{ iblNum = int(oscVal2) ; } // 6
    ~sOsc.("iblX", 64 ); //{ iblX = ((oscVal2-64) / 64.0) * width/2 ; } // 7  int( ((oscVal2-64) / 64.0) * width/2 ); }
    ~sOsc.("iblY", 64 ); //{ iblY = ((oscVal2-64) / 64.0) * width/2 ; } // 8
    ~sOsc.("iblWidth", 87); //{ iblWidth = oscVal2 * oscVal2 * 0.2 * norm(width, 0, width) ; } // 9  int(oscVal2 * oscVal2 * 0.05 * norm(width, 0, width));
    ~sOsc.("iblHeight", 70 ); //{ iblHeight = oscVal2 * oscVal2 * 0.1 * norm(height, 0, height) ; } // 10

    ~sOsc.("iblRot", 0 ); //{ iblRot =  radians(oscVal2 * 360 / 120) ; } // 11
    ~sOsc.("iblTexWidth", 64 ); //{ iblTexWidth = (oscVal2 - 64) * oscVal2 ; } // 18
    ~sOsc.("iblTexHeight", 64 ); //{ iblTexHeight = (oscVal2 - 64) * oscVal2 ; } // 19

    ~sOsc.("iblTexSpeedXfactor", 70 ); //{ iblTexSpeedXfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 22
    ~sOsc.("iblTexSpeedYfactor", 69 ); //{ iblTexSpeedYfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 23

    ~sOsc.("iblH", 64 ); //{ iblH = int(oscVal2) ; } // 24
    ~sOsc.("iblS", 127); //{ iblS = int(oscVal2) ; } // 25
    ~sOsc.("iblB", 127 ); //{ iblB = int(oscVal2) ; } // 26
    ~sOsc.("iblA", 40 ); //{ iblA = int(oscVal2) ; } // 27
    ~sOsc.("iblBflicker", 0 ); //{ iblBflicker = int(oscVal2) ; } // 28

    ~sOsc.("iblItX", 94 ); //{ iblItX = ((oscVal2-64) * abs(oscVal2-64) * 0.1) ; } // 29
    ~sOsc.("iblItY", 64 ); //{ iblItY = ((oscVal2-64) * abs(oscVal2-64) * 0.1) ; } // 30
    ~sOsc.("iblItTexX", 9); //{ iblItTexX = oscVal2 * 4 ; } // 31
    ~sOsc.("iblItTexY", 10 ); //{ iblItTexY = oscVal2 * 4; } // 32
    ~sOsc.("iblItRot", 50); //{ iblItRot = radians(oscVal2) ; } // 33


)

// ~sOsc.("drawImageBlenderToggle", 1);

(
Pbindef(\lcmnoip,
	\instrument, \lcmnoise,
	\dur, 8,
	\amp, 0.6,
	\amp1, 0.1, //Pseq([1,0.1],inf),
	\amp2, 3, //Pseq([0.6,1],inf),
	\legato, 1,
	//\legato, 0.5,
	\outBus, ~satBus1,
	\osc, Pfunc { |e|
		~sOsc.("drawImageBlenderToggle", 1);
	    ~sOsc.("drawImageBlenderID", 29.rand);
		~sOsc.("iblTexSpeedXfactor", 10.rand+60 ); //{ iblTexSpeedXfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 22
		~sOsc.("iblTexSpeedYfactor", 10.rand+60 ); //{ iblTexSpeedYfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 23
	}

).play(quant:4)
)

Pbindef(\lcmnoip).stop


(
Pbindef(\playBufGlitch1,
	*[
		instrument: \playBuf,
		bufnum:	Prand([
			~getSmp.("qebrus_machines_snip5"),
			~getSmp.("qebrus_machines_snip2"),
			~getSmp.("qebrus_machines_snip1")
		],inf),
		legato:1,
		//dur:Pseq([Pn(1/4,6),Pn(1/8,3)],inf),
		dur:8,
		start:Pwhite(0.0,0.4),
		rate: [0.5,0.7,1],
		amp: 0.5,
		sdel: 0.01,
		//outBus: 0,
		outBus: Prand([0, ~satBus1],inf),
	]).play(quant:4);
)

Pbindef(\playBufGlitch1).stop;
(
Pbindef(\lcmnoip).stop;
~sOsc.("drawImageBlenderToggle", 0);
)


/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
// CARRY (or PARITY?)


// title6 CARRY
~oscTitles6.value
~sOsc.("drawPlatesToggle", 0);

(
    ~sOsc.("drawImageBlenderBank", 1 );
    ~sOsc.("drawImageBlenderID", 4);
    ~sOsc.("iblNum", 60); //{ iblNum = int(oscVal2) ; } // 6
    ~sOsc.("iblX", 0 ); //{ iblX = ((oscVal2-64) / 64.0) * width/2 ; } // 7  int( ((oscVal2-64) / 64.0) * width/2 ); }
    ~sOsc.("iblY", 64 ); //{ iblY = ((oscVal2-64) / 64.0) * width/2 ; } // 8
    ~sOsc.("iblWidth", 17); //{ iblWidth = oscVal2 * oscVal2 * 0.2 * norm(width, 0, width) ; } // 9  int(oscVal2 * oscVal2 * 0.05 * norm(width, 0, width));
    ~sOsc.("iblHeight", 80 ); //{ iblHeight = oscVal2 * oscVal2 * 0.1 * norm(height, 0, height) ; } // 10

    ~sOsc.("iblRot", 60 ); //{ iblRot =  radians(oscVal2 * 360 / 120) ; } // 11
    ~sOsc.("iblTexWidth", 64 ); //{ iblTexWidth = (oscVal2 - 64) * oscVal2 ; } // 18
    ~sOsc.("iblTexHeight", 64 ); //{ iblTexHeight = (oscVal2 - 64) * oscVal2 ; } // 19

    ~sOsc.("iblTexSpeedXfactor", 70 ); //{ iblTexSpeedXfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 22
    ~sOsc.("iblTexSpeedYfactor", 69 ); //{ iblTexSpeedYfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 23

    ~sOsc.("iblH", 64 ); //{ iblH = int(oscVal2) ; } // 24
    ~sOsc.("iblS", 127); //{ iblS = int(oscVal2) ; } // 25
    ~sOsc.("iblB", 127 ); //{ iblB = int(oscVal2) ; } // 26
    ~sOsc.("iblA", 40 ); //{ iblA = int(oscVal2) ; } // 27
    ~sOsc.("iblBflicker", 0 ); //{ iblBflicker = int(oscVal2) ; } // 28

    ~sOsc.("iblItX", 84 ); //{ iblItX = ((oscVal2-64) * abs(oscVal2-64) * 0.1) ; } // 29
    ~sOsc.("iblItY", 64 ); //{ iblItY = ((oscVal2-64) * abs(oscVal2-64) * 0.1) ; } // 30
    ~sOsc.("iblItTexX", 9); //{ iblItTexX = oscVal2 * 4 ; } // 31
    ~sOsc.("iblItTexY", 50 ); //{ iblItTexY = oscVal2 * 4; } // 32
    ~sOsc.("iblItRot", 0); //{ iblItRot = radians(oscVal2) ; } // 33


)






Pbindef(\sawp0).clear

(
Pbindef(\sawp0,
	\instrument, \softSaw,
	\dur, 10,
	\attackTime, 5,
	\releaseTime,5,
	\legato,1,
	\degree, Pseq([
		[-2,2,12,25],
		[-2,1,9,19],
		[-2,3,11,20],
		[-2,6,8,22],
		[-2,3,12,18],
		[-2,5,7,21],
	],inf),
	\octave, 3,
	\amp, [1,0.5,0.2,0.1] * 0.7,
	\out, 0
).play(quant:4);
)
(
Pbindef(\playBufHat2, *[ instrument: \playBuf,
	bufnum: ~getSmp.("Hats076"),
	legato:1,
	dur:Pseq([Pn(1/4,6),Pn(1/8,3)],inf),
	dur:1/4,
	amp: 1 * Pseq([1,1/5],inf) * Pwhite(0.3,1),
	rate: Pwhite(0.95,1.01)
]).play(quant:4);
);
(
Pbindef(\playBufBleep2, *[ instrument: \playBuf,
	bufnum: ~getSmp.("Bleeps007"),
	legato:1,
	dur:Pseq([1/4,Pn(3,7)],inf),
	amp:0.2,
	rate: 1,
	osc: Pfunc { |e|
		~sOsc.("drawImageBlenderToggle", 1);
	    ~sOsc.("drawImageBlenderID", 41.rand);
		~sOsc.("iblTexSpeedXfactor", 30.rand+55 ); //{ iblTexSpeedXfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 22
		~sOsc.("iblTexSpeedYfactor", 20.rand+55 ); //{ iblTexSpeedYfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 23
    ~sOsc.("iblItTexX", 20.rand+60); //{ iblItTexX = oscVal2 * 4 ; } // 31
    ~sOsc.("iblItTexY", 20.rand+60 ); //{ iblItTexY = oscVal2 * 4; } // 32
	}

]).play(quant:4);
)
(
Pbindef(\playBufBleep3, *[ instrument: \playBuf,
	bufnum: ~getSmp.("Bleeps015"),
	legato:Pwhite(0.01,0.1),
	dur:Pseq([1/4,Pn(1.5,7)],inf) * 1/2,
	amp:0.08,
	rate: 1
]).play(quant:4);
)

(
Pbindef(\playBufGlitch4, *[ instrument: \playBuf,
	bufnum: ~getSmp.("Misc106"),
	legato:0.3,
	dur:32,
	amp:0.2,
	rate: 1
]).play(quant:4);
)

Pbindef(\sawp0).stop;
(
Pbindef(\playBufHat2).stop;
Pbindef(\playBufBleep2).stop;
Pbindef(\playBufBleep3).stop;
Pbindef(\playBufGlitch4).stop;
~sOsc.("drawImageBlenderToggle", 0);
)
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
// OVERFLOW

// title7 OVERFLOW
~oscTitles7.value
~sOsc.("drawPlatesToggle", 0);


(
~zeroVinit = {
	~sOsc.("drawPlatesToggle", 0);
	~sOsc.("drawPlatesimgAbank", 5);
	~sOsc.("drawPlatesimgBbank", 5);
	~sOsc.("drawPlatesimgCbank", 5);
	~sOsc.("drawPlatesimgBblendMode", 2);
	~sOsc.("drawPlatesimgCblendMode", 1);
	~sOsc.("drawPlatesTexAspeed", 0);
	~sOsc.("drawPlatesTexBspeed", 0);
	~sOsc.("drawPlatesTexCspeed", 0);
};
~platesSpeedRandRange = 0;

~zeroVinit.value;
)

(
Pbindef(\playBufqebP, *[ instrument: \playBuf,
	bufnum:	~getSmp.("qebrus_machines_snip4"),
	dur: Pxrand([1,1/2,1/2,1/4,Pn(1/8,2)],inf) * 1/2,
	legato:[0.9,0.1,0.2] * Pwhite(0.9,1),
	amp: Pwhite(0.5,0.6) * 0.7,
	rate: Pwhite(0.99,1),
	hpff: 120,

	start: Pseq([
		Pn(0, 60),
		Pwhite(0,0.15, 40),
		Pwhite(0,0.25, 50),
		Pwhite(0,0.35, 40),
		Pwhite(0,0.55, 50),
		Pwhite(0,0.65, 50),
		Pwhite(0,0.55, 100),
		Pwhite(0,0.25, 50),
		Pwhite(0,0.15, 40),
		Pwhite(0,0.55, 100),
		Pwhite(0,0.25, 50),
		Pwhite(0,0.15, 40),
		Pwhite(0,0.05, 40),
	], inf),
	sdel: Pdup(50, Pxrand([1,2,3,4]*0.001,inf)),
	osc: Pfunc { |e|
		~sOsc.("drawPlatesToggle", 1);
		~sOsc.("drawPlatesimgAid", 19.rand);
		~sOsc.("drawPlatesimgBid", 19.rand);
		~sOsc.("drawPlatesimgCid", 19.rand);
		~sOsc.("drawPlatesTexAspeed", ~platesSpeedRandRange.rand);
		~sOsc.("drawPlatesTexBspeed", ~platesSpeedRandRange.rand);
		~sOsc.("drawPlatesTexCspeed", ~platesSpeedRandRange.rand);
		~sOsc.("drawPlatesTexAdirection", 127.rand);
		~sOsc.("drawPlatesTexBdirection", 127.rand);
		~sOsc.("drawPlatesTexCdirection", 127.rand);
	};
	
]).play(quant:4);
)

~platesSpeedRandRange = 5;
~platesSpeedRandRange = 10;
~platesSpeedRandRange = 15;
~platesSpeedRandRange = 20;
~platesSpeedRandRange = 30;
~platesSpeedRandRange = 40;
~platesSpeedRandRange = 50;




(
Pbindef(\granPlayP, *[
	instrument: \granPlay,
	dur: 		4,
	legato: 	1,
	amp: 		0.5,
	pitch: 		[0.5,1],
	autoPosN: 	0.03,
	autoPosS: 	0.01,
	outBus: 	~lpfFXBus1,
	gpos: 		Pdup(6, Pxrand([0,0.1,0.3],inf)),
	bufnum: 	~getSmp.("qebrus_machines_snip4")
]).play(quant:4);
)

(
Pbindef(\playBufHat5, *[ instrument: \playBuf,
	bufnum: ~getSmp.("Hats079"),
	legato:1,
	dur:1/4,
	amp: 4 * Pseq([1,1/5],inf) * Pwhite(0.3,1),
	rate: Pwhite(0.95,1.01),
]).play(quant:4);
);

(
Pbindef(\sawp2,
	\instrument, \softSaw,
	\dur, 10,
	\attackTime, 5,
	\releaseTime,5,
	\legato,1,
	\scale, Scale.minor,
	\note, Pxrand([-4,-2,0,1],inf),
	//\out, 0
	//\out, 	~lpfFXBus1,
	\out, ~satBus1,
	\octave, [3,4,5],
	\octave, [3,4],
	\octave, [3],
	\amp, [1,0.5,0.2,0.1] * 0.6,
).play(quant:4);
)


Pbindef(\playBufHat5).stop;
~platesSpeedRandRange = 2;

Pbindef(\playBufqebP).stop;

(
Pbindef(\sawp2).stop;
~lpfFX1.set(\cutoffLag, 30, \cutoff, 50);
)

Pbindef(\granPlayP).stop;
	~sOsc.("drawPlatesToggle", 0);

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////







