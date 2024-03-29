//--------------
// Tidal Startup
//--------------

//"SC_JACK_DEFAULT_OUTPUTS".setenv("REAPER");

(
// configure the sound server: here you could add hardware specific options
// see http://doc.sccode.org/Classes/ServerOptions.html
s.options.numBuffers = 1024 * 512; // increase this if you need to load more samples
s.options.memSize = 8192 * 64; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
//s.options.outDevice_("BlackHole 16ch");
//s.options.outDevice_("Built-in Output");
s.options.numOutputBusChannels = 16; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary
// boot the server and start SuperDirt
s.waitForBoot {
	~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
	  // load mi-ugens.scd synthdefs
  	load("/home/depps/.local/share/SuperCollider/synthdefs/mi-ugens.scd");
  	// end load mi-ugens.scd synthdefs
	// ~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
	~dirt.loadSoundFiles("/home/depps/Musique/Samplz/Dirts/MOOG_DS/*");
	~dirt.postSampleInfo;
	// s.sync; // optionally: wait for samples to be read
	~dirt.start(57120, [0, 2, 4, 6, 8, 12, 14]);   // start listening on port 57120, create two busses each sending audio to channel 0

	// optional, needed for convenient access from sclang:
	(
		~d1 = ~dirt.orbits[0]; ~d2 = ~dirt.orbits[1]; ~d3 = ~dirt.orbits[2];
		~d4 = ~dirt.orbits[3]; ~d5 = ~dirt.orbits[4]; ~d6 = ~dirt.orbits[5];
		~d7 = ~dirt.orbits[6]; ~d8 = ~dirt.orbits[7]; ~d9 = ~dirt.orbits[8];
		~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
	);
	 // define global effects for mutable instruments effects
	~dirt.orbits.do { |x|
		var clouds = GlobalDirtEffect(\global_mi_clouds, [\cloudspitch, \cloudspos, \cloudssize, \cloudsdens, \cloudstex, \cloudswet, \cloudsgain, \cloudsspread, \cloudsrvb, \cloudsfb, \cloudsfreeze, \cloudsmode, \cloudslofi]);
		var verb = GlobalDirtEffect(\global_mi_verb, [\verbwet, \verbtime, \verbdamp, \verbhp, \verbfreeze, \verbdiff, \verbgain]);
		x.globalEffects = x.globalEffects
		.addFirst(clouds)
		.addFirst(verb);
		x.initNodeTree;
	};
      // end define global effects for mutable instruments effects
};

s.latency = 0.3; // increase this if you get "late" messages

);

//-------------

MIDIClient.init;

~midiOut = MIDIOut.newByName("Midi Through", "Midi Through Port-0");

~midiOut.latency = 0;

~dirt.soundLibrary.addMIDI(\midi, ~midiOut);

//-------------
