/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
// Open Sound Control to Processing
// osc connection

// TODO move to init

(
~conOsc = NetAddr.new("localhost", 12000);
//~conOsc = NetAddr.new("roosta.remote", 12000);
~sOsc = { // helper function to reduce redundancy
	arg target, value;
	target = "/" +/+ target; // +/+ does not add whitespace
	~conOsc.sendMsg("/ctlin", target, value);
	postln(">>> rcv/snd: /ctlin " + target + " value:" + value );
};
);


(
~oscTitles0a = {
	~sOsc.("drawPlatesimgCbank", 7);
	~sOsc.("drawPlatesimgCblendMode", 7);
	~sOsc.("drawPlatesimgCid", 0);
	~sOsc.("drawPlatesTexCspeed", 0);
	~sOsc.("drawPlatesToggle", 1);
};

~oscTitles0b = {
	~sOsc.("drawPlatesimgCbank", 7);
	~sOsc.("drawPlatesimgCblendMode", 7);
	~sOsc.("drawPlatesimgCid", 1);
	~sOsc.("drawPlatesTexCspeed", 0);
	~sOsc.("drawPlatesToggle", 1);
};
~oscTitles1 = {
	~sOsc.("drawPlatesimgCid", 2);
	~sOsc.("drawPlatesimgCbank", 7);
	~sOsc.("drawPlatesimgCblendMode", 7);
	~sOsc.("drawPlatesTexCspeed", 0);
	~sOsc.("drawPlatesToggle", 1);
};
~oscTitles2 = {
	~sOsc.("drawPlatesimgCid", 3);
	~sOsc.("drawPlatesimgCbank", 7);
	~sOsc.("drawPlatesimgCblendMode", 7);
	~sOsc.("drawPlatesTexCspeed", 0);
	~sOsc.("drawPlatesToggle", 1);
};
~oscTitles3 = {
	~sOsc.("drawPlatesimgCid", 4);
	~sOsc.("drawPlatesimgCbank", 7);
	~sOsc.("drawPlatesimgCblendMode", 7);
	~sOsc.("drawPlatesTexCspeed", 0);
	~sOsc.("drawPlatesToggle", 1);
};
~oscTitles4 = {
	~sOsc.("drawPlatesimgCid", 5);
	~sOsc.("drawPlatesimgCbank", 7);
	~sOsc.("drawPlatesimgCblendMode", 7);
	~sOsc.("drawPlatesTexCspeed", 0);
	~sOsc.("drawPlatesToggle", 1);
};
~oscTitles5 = {
	~sOsc.("drawPlatesimgCid", 6);
	~sOsc.("drawPlatesimgCbank", 7);
	~sOsc.("drawPlatesimgCblendMode", 7);
	~sOsc.("drawPlatesTexCspeed", 0);
	~sOsc.("drawPlatesToggle", 1);
};
~oscTitles6 = {
	~sOsc.("drawPlatesimgCid", 7);
	~sOsc.("drawPlatesimgCbank", 7);
	~sOsc.("drawPlatesimgCblendMode", 7);
	~sOsc.("drawPlatesTexCspeed", 0);
	~sOsc.("drawPlatesToggle", 1);
};
~oscTitles7 = {
	~sOsc.("drawPlatesimgCid", 8);
	~sOsc.("drawPlatesimgCbank", 7);
	~sOsc.("drawPlatesimgCblendMode", 7);
	~sOsc.("drawPlatesTexCspeed", 0);
	~sOsc.("drawPlatesToggle", 1);
};
);


~drawImageBlenderInit =  {
	~sOsc.("drawImageBlenderToggle", 0);
    ~sOsc.("drawImageBlenderBank", 0 );
    ~sOsc.("drawImageBlenderID", 0);

    ~sOsc.("iblNum", 10); //{ iblNum = int(oscVal2) ; } // 6
    ~sOsc.("iblX", 64 ); //{ iblX = ((oscVal2-64) / 64.0) * width/2 ; } // 7  int( ((oscVal2-64) / 64.0) * width/2 ); }
    ~sOsc.("iblY", 64 ); //{ iblY = ((oscVal2-64) / 64.0) * width/2 ; } // 8
    ~sOsc.("iblWidth", 67); //{ iblWidth = oscVal2 * oscVal2 * 0.2 * norm(width, 0, width) ; } // 9  int(oscVal2 * oscVal2 * 0.05 * norm(width, 0, width));
    ~sOsc.("iblHeight", 70 ); //{ iblHeight = oscVal2 * oscVal2 * 0.1 * norm(height, 0, height) ; } // 10

    ~sOsc.("iblRot", 0 ); //{ iblRot =  radians(oscVal2 * 360 / 120) ; } // 11
    ~sOsc.("iblTexWidth", 64 ); //{ iblTexWidth = (oscVal2 - 64) * oscVal2 ; } // 18
    ~sOsc.("iblTexHeight", 64 ); //{ iblTexHeight = (oscVal2 - 64) * oscVal2 ; } // 19

    ~sOsc.("iblTexSpeedXfactor", 64 ); //{ iblTexSpeedXfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 22
    ~sOsc.("iblTexSpeedYfactor", 64 ); //{ iblTexSpeedYfactor = ((oscVal2-64) * abs(oscVal2-64) * 0.6) ; } // 23

    ~sOsc.("iblH", 64 ); //{ iblH = int(oscVal2) ; } // 24
    ~sOsc.("iblS", 127); //{ iblS = int(oscVal2) ; } // 25
    ~sOsc.("iblB", 127 ); //{ iblB = int(oscVal2) ; } // 26
    ~sOsc.("iblA", 127 ); //{ iblA = int(oscVal2) ; } // 27
    ~sOsc.("iblBflicker", 0 ); //{ iblBflicker = int(oscVal2) ; } // 28

    ~sOsc.("iblItX", 64 ); //{ iblItX = ((oscVal2-64) * abs(oscVal2-64) * 0.1) ; } // 29
    ~sOsc.("iblItY", 64 ); //{ iblItY = ((oscVal2-64) * abs(oscVal2-64) * 0.1) ; } // 30
    ~sOsc.("iblItTexX", 0); //{ iblItTexX = oscVal2 * 4 ; } // 31
    ~sOsc.("iblItTexY", 0 ); //{ iblItTexY = oscVal2 * 4; } // 32
    ~sOsc.("iblItRot", 0); //{ iblItRot = radians(oscVal2) ; } // 33
};





































// OSC tests ////////////////////////////////////////////////////////////////////////////////////////////

/*

(
// VIDEO player
~sOsc.value("playVideoToggle", 1);
~sOsc.value("playVideoBank", 0 );//) {  playVideoBank = int(oscVal2); } // 44
~sOsc.value("playVideoID", 0 );//) {  playVideoID = int(oscVal2); } // 45
~sOsc.value("playVideoPausePlay", 1 );  //) {  playVideoPausePlay = boolean(int(oscVal2)); } // 47
~sOsc.value("playVideoHue", 64 ); //) {  playVideoHue = int(oscVal2); } // 44
~sOsc.value("playVideoSaturation", 0 ); //) {  playVideoSaturation = int(oscVal2); } // 44
~sOsc.value("playVideoBrightness", 127 ); //) {  playVideoBrightness = int(oscVal2); } // 44
~sOsc.value("playVideoAlpha", 127 );//) {  playVideoAlpha = int(oscVal2); } // 44
~sOsc.value("playVideoSpeed", 100);  //) {  playVideoPausePlay = boolean(int(oscVal2)); } // 47
~sOsc.value("playVideoJump", 25);
)

~sOsc.value("playVideoPausePlay", 0 );
~sOsc.value("playVideoPausePlay", 1 );
~sOsc.value("playVideoJump", rand(99));

// just don't use reverse/negatives!
~sOsc.value("playVideoSpeed", -100);
~sOsc.value("playVideoSpeed", 100);

~sOsc.value("playVideoToggle", 0);


// examples for SC->P5 connections
(
~subPattern1 = Pbind(*[
	instrument: "subPulse",
    dur:	Pseq([6,6,4],inf),
	note:	Pseq([30], inf),
	amp: 	0.1,
	filterCurve: Pseq([-1],inf),
	imgspeed: Prand([1,2,3], inf),
	imgdirection: Pseq([10,30,50,70,90,110,127], inf),
	osc:	Pfunc { |e|
		~sOsc.value("drawPlatesTexAspeed", e.imgspeed);
		~sOsc.value("drawPlatesTexAdirection", e.imgdirection);
	}
]);
)

(
~cracklePattern0 = Pbind(*[
	instrument: "cracklePulse",
	dur:		Pseq([16],inf),
	length: 	Pseq([0.01], inf),
	amp: 		0.2,
	chaos:		Pseq([1.5], inf),
	id:			Pwalk( (0 .. 54), Prand([ -2,-1, 1, 2], inf)),
	dir:		Pseq([127,64], inf),
	osc:		Pfunc { |e|
		~sOsc.value("drawFlylinesflyPixId", e.id);
		~sOsc.value("drawFlylinesflyDirection", e.dir);
	};
]);
)

*/
