// make sure to first choose the output device in audio setup
// boot the server and start
(
s.options.numBuffers = 1024 * 128; // increase this to load more samples
s.options.memSize = 8192 * 128; // increase this if "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if "too many nodes"
s.options.device = nil;
// s.options.device = "Soundflower (64ch)";
s.options.numOutputBusChannels = 2; //  defaults 2
s.waitForBoot {
	~dirt = SuperDirt(2, s); // increase to pan across more channels
	s.sync; // wait for samples to be read
	~dirt.start(57120, [0, 0]);
	// ~dirt.start(57120, [0, 2, 4, 6]); // specify num of orbits (4 orbits = 8 mono channels)
	3.wait;
	~dirt.loadSoundFiles("/Users/yanndepps/Documents/Musik/samplz/Tidal_Lab/*");
	1.wait;
	"-> SuperDirt Loaded".postln;
};

s.latency = 0.3; // increase this if "late" messages
)


// GUIs
s.meter;
s.volume.gui;
FreqScope.new;
HelpBrowser.new;
ServerOptions.devices;

// Record
s.recChannels = 8;
s.prepareForRecord;
s.record;

s.stopRecording