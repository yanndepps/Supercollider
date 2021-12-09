// --- Rhythm : Techniques for modifying rhythms --- //

("../Setup/setup.scd").loadRelative;

p.fadeTime = 3;

// random rhythm with Pwhite
(
~sn = Pbind(\instrument, \vplaym, \buf, d["sd"][0], \dur, Pwhite(1,5.0), \amp, 1);
~h = Pbind(\instrument, \vplaym, \buf, d["sd"][1], \dur, Pwhite(0.25,0.75), \amp, Pwhite(0.2,1));
~c = Pbind(\instrument, \vplaym, \buf, d["sd"][2], \dur, Pwhite(0.75,2), \amp, 1);
~t = Pbind(\instrument, \vplaym, \buf, d["sd"][3], \dur, Pwhite(1,5.0), \amp, 1);
~sn.play(out:0);
~h.play(out:2);
~c.play(out:4);
~t.play(out:6);
)

// even with a regular kickdrum, the other rhythms don't sound good
(
~k = Pbind(\instrument, \vplaym, \buf, d["sd"][0], \dur, 1, \amp, 1);
~k.play(out:8);
)

// same example with all rhythms constrained
(
~sn = Pbind(\instrument, \vplaym, \buf, d["sd"][0], \dur, Pwhite(1,5.0).round(1), \amp, 1);
~h = Pbind(\instrument, \vplaym, \buf, d["sd"][1], \dur, Pwhite(0.25,0.75).round(0.25), \amp, Pwhite(0.2,1));
~c = Pbind(\instrument, \vplaym, \buf, d["sd"][2], \dur, Pwhite(0.75,2).round(0.75), \amp, 1);
~t = Pbind(\instrument, \vplaym, \buf, d["sd"][3], \dur, Pwhite(1,5.0).round(0.5), \amp, 1);
~sn.play(out:0);
~h.play(out:2);
~c.play(out:4);
~t.play(out:6);
)

// sounds more palatable
(
~k = Pbind(\instrument, \vplaym, \buf, d["sd"][0], \dur, 1, \amp, 1);
~k.play(out:8);
)

// same example again
(
~sn = Pbind(\instrument, \vplaym, \buf, d["sd"][0], \dur, Pwhite(1,5.0).round(1), \amp, 1);
~h = Pbind(\instrument, \vplaym, \buf, d["sd"][1], \dur, Pwhite(0.25,0.75).round(0.25), \amp, Pwhite(0.2,1));
~c = Pbind(\instrument, \vplaym, \buf, d["sd"][2], \dur, Pwhite(0.75,2).round(0.75), \amp, 1);
~t = Pbind(\instrument, \vplaym, \buf, d["sd"][3], \dur, Pwhite(1,5.0).round(0.5), \amp, 1);
~sn.play(out:0);
~h.play(out:2);
~c.play(out:4);
~t.play(out:6);
)

// add whole note fx, short, medium and long
(
~fx1 = Pbind(\instrument, \vplaym, \buf, d["sp"][7], \dur, Pwhite(1,5), \amp, 0.6);
~fx2 = Pbind(\instrument, \vplaym, \buf, d["sp"][8], \dur, Pwhite(1,10), \amp, 0.6);
~fx3 = Pbind(\instrument, \vplaym, \buf, d["sp"][9], \dur, Pwhite(1,20), \amp, 0.6);
~fx1.play(out:8);
~fx2.play(out:10);
~fx3.play(out:12);
)

// layering at diferent pitches
p.clock.tempo = 2.3;

(
~k = Pbind(\instrument, \vplaym, \buf, d["sd"][1], \dur, Pbjorklund2(3,8)/4, \amp, 0.6, \rate, Pseq([1,1.2], inf));
~k.play(out:0);
)

// kicks at a different pitch. different permutations.
(
~k2 = Pbind(\instrument, \vplaym, \buf, d["sd"][3], \dur, Pbjorklund2(3,8)/4, \amp, 0.6, \rate, Pseq([1,1.8], inf)*4);
~k2.play(out:2);
)

// layering slightly different rhythms
// 1. 
(
p.clock.tempo = 1.7;
~t = Pbind(\instrument, \vplaym, \buf, d["sd"][0], \dur, Pseq([1,1,1,0.5], inf), \amp, 0.6);
~t.play(out:0);
)

// 2.
// re-evaluate 1 to get them playing together
(
~t = Pbind(\instrument, \vplaym, \buf, d["sd"][0], \dur, Pseq([1,1,1,0.5], inf), \amp, 0.6);
~t2 = Pbind(\instrument, \vplaym, \buf, d["sd"][1], \dur, Pseq([1,1,1,0.25], inf), \amp, 0.6, \rate, 2);
~t2.play(out:2);
)

// 3.
(
~t = Pbind(\instrument, \vplaym, \buf, d["sd"][0], \dur, Pseq([1,1,1,0.5], inf), \amp, 0.6);
~t2 = Pbind(\instrument, \vplaym, \buf, d["sd"][1], \dur, Pseq([1,1,1,0.25], inf), \amp, 0.6);
~t3 = Pbind(\instrument, \vplaym, \buf, d["sd"][2], \dur, Pseq([1,1,1,0.75], inf), \amp, 0.6);
~t3.play(out:4);
)
