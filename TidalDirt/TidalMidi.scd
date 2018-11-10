// start SuperDirt
SuperDirt.start;

// MIDI //
// init SC MIDI client
MIDIClient.init;

// use a target MIDI device
~midiOut = MIDIOut.newByName("Gestionnaire IAC", "Tidal1");

~midiOut.latency = 0;

// connect MIDI device to SuperDirt
~dirt.soundLibrary.addMIDI(\midi, ~midiOut);