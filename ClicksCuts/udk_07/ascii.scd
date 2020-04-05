s.boot;

65.asAscii
90.asAscii
120.asAscii
130.asAscii
255.asAscii

// 0-127

"ABx".ascii

{SinOsc.ar("xv".ascii)}.play;

{SinOsc.ar("xv".ascii * 10)}.play;

{SinOsc.ar("ac".ascii.midicps)}.play;

65.midicps;

{SinOsc.ar(Duty.ar(0.1, 0, Dseq("abcfz".ascii.midicps, inf)))!2}.play;

{SinOsc.ar(Duty.ar(0.1, 0, Dseq(("abcfz".ascii-36).midicps, inf)))!2}.play;

{SinOsc.ar( Duty.ar(0.1, 0, Dseq("@@@@@@@@@@@                ..alasjdkjha....  ".ascii.midicps, inf)))!2}.play;

{SinOsc.ar( [Duty.ar(0.1, 0, Dseq("ab  @ . Ac".ascii.midicps, inf)), Duty.ar(0.1001, 0, Dseq("ab  @ . Acd".ascii.midicps, inf))] )}.play;

{SinOsc.ar( Duty.ar(0.1, 0, Dseq("ABCDEFGHIJKLMNOPQRSTUVWXYZ".ascii.midicps, inf)))!2}.play;

{SinOsc.ar( Duty.ar(0.1, 0, Dseq("xxxxxxxxxxxx            ©@£|§|©∞@£|§∞..........".ascii.midicps, inf)))!2}.play;

{LFPulse.ar( Duty.ar([0.06, 0.05], 0, Dseq("xxxxxxxxxxxx            ©@£|§|©∞@£|§∞..........".ascii.midicps, inf)))}.play;

{BLowPass4.ar(LFPulse.ar( Duty.ar([0.06, 0.05], 0, Dseq("xxxxxxxxxxxx            ©@£|§|©∞@£|§∞..........".ascii.midicps, inf))))}.play;


//now rewrite any example from above as Ndef so that we can change it dynamically

Ndef(\text).play;
Ndef(\text2).play;
Ndef(\text3).play;
Ndef(\text4).play;

Ndef(\text, {SinOsc.ar( Duty.ar(0.1, 0, Dseq("ABCDEFGHIJKLMNOPQRSTUVWXYZ".ascii.midicps, inf)))})

//you can keep changing the code and reevaluating the lines below - i.e. don't stop in between changes

Ndef(\text, {SinOsc.ar( Duty.ar(0.1, 0, Dseq("@@@@@@@@@@@@@@@@ @@@@@@ @ @@@@ z".ascii.midicps, inf)))!2})

Ndef(\text2, {SinOsc.ar( Duty.ar(0.1, 0, Dseq("@@@@@@@@@@@@@@@@ @@@@@@ @ @@@@ zo".ascii.midicps, inf)))!2})

Ndef(\text3, {SinOsc.ar( Duty.ar(0.1, 0, Dseq("@@@@@@@@@@@@@@@@ @@@@@@ @ @@@@ zoo".ascii.midicps, inf)))!2})

Ndef(\text4, {SinOsc.ar( Duty.ar(0.2, 0, Dseq("xxxxxx   ".ascii.midicps, inf)))!2})

NdefMixer(s) //makes a gui automatically

s.reboot;

Ndef(\ascii).play;

Ndef(\ascii, {SinOsc.ar(Duty.ar(0.1, 0, Dseq("lkjasdlkjalsjk".ascii.midicps, inf)), 0, 0.5)!2});

Ndef(\ascii, {SinOsc.ar(Duty.ar(0.1, 0, Dseq("A B C D".ascii.midicps, inf)), 0, 0.5)!2});

Ndef(\ascii, {SinOsc.ar(Duty.ar(0.1, 0, Dseq("A B C d".ascii.midicps, inf)), 0, 0.5)!2});

Ndef(\ascii).stop;