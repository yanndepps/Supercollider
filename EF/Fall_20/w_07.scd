// register a keyboard macro using the following command: :qa vap C-c C-c q.
// the macro is stored in @a. Type @a to summon it.

s.options.numBuffers = 1024 * 64; // increase if you need to load more samples

s.boot;

s.quit;

s.makeWindow;

s.meter;

s.scope;

FreqScope.new;

s.plotTree;

// Intro to sampling
// a buffer is basically a server side version of array. an order collection of numbers
// a buffer only contains floats.
// most often they are used to hold audio samples.
~oval_1 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/OVAL/Scatter.wav");
~oval_2 = Buffer.read(s, "./Musique/Samplz/Dirts/OVAL/Rhitmik.wav");
~oval_3 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/OVAL/Pinkertonn.wav");

// did it work ?
~oval_3.play;

// how many channels does have our sound file ?
~oval_1.numChannels;

// what is the duration ?
~oval_1.duration;

// frames are like samples ( individual numbers that make up an audio file )
// digital audio files are just a sequence of numbers that represent the amplitude of each samples. ( bipolar between -1 and 1 )
//
// two channels of a very short buffer with 25 samples : each individual x is a sample

*===============================================*
|x|x|x| | | | | | | | | | | | | | | | | | | | | | L
*===============================================*
|x|x|x| | | | | | | | | | | | | | | | | | | | | | R
*===============================================*
     ^
     |
// this is a frame : a single sample worth of time; it contains all of the samples ( one for each channels )
// in the case of a monophonic buffer, ( a one channel buffer ), the number of frames equals the number of samples.
// but in a stereo buffer, the number of samples is equal to the number of frames * the number of channels.
// we can think of a buffer as a two dimensional array.
// numFrames * 2 = number of samples in our stereo audio file.

// an audio file has a sample rate associated with it :
// the samples are meant to play back at a particular rate.
~oval_1.sampleRate;

// a buffNum is simply an integer that gets assigned to a buffer when it is read into memory.
// every buffer has an integer associated with it.
~oval_1.bufnum;

// free a buffer from the server :
~oval_3.free;

// free all buffers
Buffer.freeAll;

// ---
// absolute path to this code file : always path accurate

// ~path = PathName.new(thisProcess.nowExecutingPath) +/+ "./audio/00015_HBH.wav";

~oval_1 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/HBH/00003_HBH.wav");
~oval_2 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/HBH/00013_HBH.wav");
~oval_3 = Buffer.read(s, "/home/depps/Musique/Samplz/Dirts/HBH/00094_HBH.wav");


// confirm
~oval_1.play;

// show if there is sth in the buffer :
~oval_2.plot;

// ---
// unit generators : PlayBuf & BufRd
// rate is a ratio : 1 -> plays at the original speed
(
{
	var sig;
	sig = PlayBuf.ar(
		2,
		~oval_2.bufnum,
		1, // 0.5 -> an octave down
		doneAction:2
	);
	sig = sig * 0.5;
}.play;
)

// BufRateScale returns the ratio of the buffer sampling rate to the server 
// sampling rate. it compensates for the shift that happens as a result of 
// these two sampling rates.
// 44100/48000 -> ratio
// poll will periodically mesures unit generator outputs

(
{
	var sig;
	sig = PlayBuf.ar(
		2,
		~oval_2.bufnum,
		BufRateScale.ir(~oval_2.bufnum).poll; // scale it to the correct rate
		doneAction:2
	);
	sig = sig * 0.5;
}.play;
)

// ---

(
{
	var sig;
	sig = PlayBuf.ar(
		2,
		~oval_2.bufnum,
		BufRateScale.ir(~oval_2.bufnum) * 0.5; // multiply it by the rate wanted 
		doneAction:2
	);
	sig = sig * 0.5;
}.play;
)

// frequency : 5 semitones up 
440 * 5.midiratio;

// go up by x semitone

(
{
	var sig;
	sig = PlayBuf.ar(
		2,
		~oval_2.bufnum,
		BufRateScale.ir(~oval_2.bufnum) * 1.midiratio; 
		doneAction:2
	);
	sig = sig * 0.5;
}.play;
)

// trigger and start position 

(
x = {
	arg t_trig = 1;
	var sig;
	sig = PlayBuf.ar(
		2,
		~oval_2.bufnum,
		BufRateScale.ir(~oval_2.bufnum) * 0.midiratio; 
		t_trig,
		13000,
		doneAction:0
	);
	sig = sig * 0.5;
}.play;
)

x.set(\t_trig, 1);
x.free;

// impulse and dust
// both are designed to output triggers
// show 0.5 second worth of 100 triggers per second
{Impulse.ar(100)}.plot(0.05);

// Dust is similar except it's stochastic
{Dust.ar(100)}.plot(0.05);

// those can be used to automate the trigger of a sound file
(
x = {
	var sig;
	sig = PlayBuf.ar(
		2,
		~oval_2.bufnum,
		BufRateScale.ir(~oval_2.bufnum) * 0.midiratio; 
		Impulse.kr(4), // 4 impulses per second
		// turn it into an oscillator
		// Impulse.ar(30),
		13000, // drastically change the timbre by cycling to a different chunk of audio
		doneAction:0
	);
	sig = sig * 0.5;
}.play;
)

// loop
a = [];

(
a = a.add(
	{
		var sig;
		sig = PlayBuf.ar(
			2,
			~oval_2.bufnum,
			BufRateScale.ir(~oval_2.bufnum) * 0.midiratio; 
			loop:1,
			13000, 
			doneAction:0 // when loop is 1, doneAction is ignored
		);
		sig = sig * 0.5;
	}.play;
)
)

a.do({arg n; n.set(\gate, 0, \fadeTime, 5)});

// put loop into an arg
(
x =	{
	arg loop = 1;
	var sig;
	sig = PlayBuf.ar(
		2,
		~oval_2.bufnum,
		BufRateScale.ir(~oval_2.bufnum) * 0.midiratio; 
		loop,
		13000, 
		doneAction:2 // doneAction is triggered if we set the loop arg to 0 
	);
	sig = sig * 0.5;
}.play;
)

x.set(\loop, 0);
