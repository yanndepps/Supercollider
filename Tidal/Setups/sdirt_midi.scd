SuperDirt.start

MIDIClient.init;

~midiOut = MIDIOut.newByName("Gestionnaire IAC", "Tidal1");

~midiOut.latency = 0;

~dirt.soundLibrary.addMIDI(\midi, ~midiOut);