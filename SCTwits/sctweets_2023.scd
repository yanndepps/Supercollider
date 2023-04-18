// Boot
// increase this if "alloc failed" messages
s.options.memSize = 8192 * 256;

s.options.sampleRate = 44100;

s.boot;

s.quit;

// GUIs
s.meter;

s.scope;

FreqScope.new;

s.plotTree;

// record
s.recSampleFormat = "int24";  // default to 32
s.recHeaderFormat = "wav";    // default to aiff

s.record("/home/depps/Musique/Samplz/SC_Recs/sctweets_040323.wav", duration:60);

s.stopRecording;

// ---

// 04.03.23
r{loop{x.release(24);play(x={ar(Splay,ar(a=AllpassC,ar(a,ar(RLPF,ar(VarSaw,midicps({[0,2,5,7,9].choose+[36,48].choose}!4+l=kr(c=LFTri,d=1/12,b=(1..8)/4)/8),0,l+0.4),8**kr(c,d*b)*999),1,ar(c,[6,4,6]/4,[0,1])+1/2),1,1/2,4,d))},s,0,9);wait(9.rand/8+33.rand+8)}}.play

// ---