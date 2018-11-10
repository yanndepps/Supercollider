
(
// configure the sound server: here you could add hardware specific options
// see http://doc.sccode.org/Classes/ServerOptions.html
s.options.numBuffers = 1024 * 16; // increase this to load more samples
s.options.memSize = 8192 * 16; // increase this if "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if "too many nodes"
s.options.device = "Soundflower (64ch)";
s.options.numOutputBusChannels = 8; // 16, defaults 2
s.waitForBoot {
	~dirt = SuperDirt(2, s); // increase to pan across more channels
	~dirt.loadSoundFiles("/Users/yanndepps/Documents/Musik/samplz/Tidal_Lab/*");
	s.sync; // wait for samples to be read
	//~dirt.start(57120, [0, 0]);
	~dirt.start(57120, [0,2,4,6,8,10,12,14]);
};

s.latency = 0.3; // increase this if "late" messages
);

s.meter;

ServerOptions.devices;