
// load libs and samples

var libPath, smpPath;

"\n\n
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
>>> Hello. Starting Jitakami                            <<<

═══════════════════════════════════════════════════════════".postln;

libPath = PathName.new(
	PathName.new(thisProcess.nowExecutingPath).pathOnly	+/+ "lib/");
smpPath = PathName.new(
	PathName.new(thisProcess.nowExecutingPath).pathOnly	+/+ "smp/");


"\n--- loading libs ...".postln;

libPath.filesDo({|afile, i|
	//postln("   " + afile.fullPath);
	postln("    - " + afile.folderName +/+ afile.fileName);
	// for each file in list, load/execute it
	this.executeFile(afile.fullPath);
});

"\n \n~~~ Loading sample files to buffers ...".postln;
s.freeAllBuffers; // free all buffers now!
~samples = smpPath.files;
~smpList = List(); // init, clean
~bfrList = List(); // init, clean
~samples.do({ |item, i|
	postln("   " + i + "" + item.folderName +/+ item.fileName);
	~smpList.add(item.fileName);
	~bfrList.add(Buffer.readChannel(s, item.fullPath, channels:[0])); // [0] forces mono!
});

"... done.\n\n".postln;
"";
