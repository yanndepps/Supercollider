// patterns definitions


// AKJ -----------------------------------------------------------------------------------
Pbindef(\akjDisChordp, *[
	instrument: \akjDisChord,
	freq:300,
	dur:5,
	legato: 1,
	amp: 1
]);

Pbindef(\akjClickp, *[
	instrument: \akjClick,
	dur: Pseq([Pseq([1,2,3]/8, 2), Pseq([1,2,1,2,1,1]/8,3), Pseq([1]/8, 4), Pseq([1]/16, 2), ],inf),
	//dur: Pseq([Pn(1/8, 31), Rest(1/8)],inf),
	amp: Prand([5,7,8,9]/10, inf),
	releaseTime: 0.3,
	freq:1
	
]);

Pbindef(\akjBazp, *[
	instrument: \akjBaz,
	freq: 300,
	dur: 8,
	amp: 0.5,
	legato: 0.20
]);



// SHIPPO ---------------------------------------------------------------------------------
Pbindef(\shippoP, *[
	instrument: \shippo,
	degree: 4,
	octave: 3,
	dur: Pseq([1,2,3], inf),
	legato:0.2,
	amp: 0.5
]);



// DISTORTED DRONE
Pbindef(\s1DistP,
	\instrument, \s1Dist,
	\degree, -1,
	\dur, 2,
	\octave, [2,3],
	\amp, 0.9,
	\legato, 1,
	// needs wrangled delay!
	\out, ~wranglerBus,
	\dlywet, Pstutter(8, Pfunc({~dlywrang1.set(\wet, rrand(0, ((3..6) * 0.1).choose ) ) })),
	
	\d1, Prand((1..5),inf),
	\d2,  Prand((1..5),inf),
	\d3, 5,
	\ffreq, 460
);


// lorenz pattern ---------------------------

~dotsP = Pbind(
	\dur, Pflatten(1, Plorenz() * 1),
	\attack, 0.01,
	\octave, 3,
	\nharms, Prand((2..7),500) );

~linesP = Pbind(
	\dur, Pflatten(1, Plorenz() * 5),
	\attack, 3,
	\octave, Prand([2,3,4],inf),
	\nharms, Prand((1..4),80),
	\amp, 0.075 );

~highP = Pbind(
	\dur, Pflatten(1, Plorenz() * 5),
	\attack, 3,
	\octave, 5,
	\nharms, Prand((1..3),50),
	\amp, 0.008 );


// gcd mod ---------------------------------------------------------
Pbindef(\n1,
	\instrument, \dNoz,
	\dur, Pseq([20,Rest(10)],inf),
	\amp, 0.5,
	\legato, 1,
);


Pdef(\gcdkick, {
	Pbind(*[
		instrument: \tribd,
		dur: Pseq([
			Rest(32),
			Pseq(
				[
					Prand( [ Pseq([1.5,1.5]), 3 ] ),
					3,
					Prand([
						4,
						Pn(1,3),
						Pn(Pseq([1/2,1,Prand([1/2,1.5])]),1)
					])
				] / 2, 32)
		],inf),
		//dur: 1,
		//dur: Pseq([1.5,1,1.5,1/2,2,1/2,1.5,1/2,1/4,1/2,1/4,3],inf),
		freq:77 + Prand((1..10)/5, inf),
		octave:2,
		amp:0.1
	])		
};);


// be back lighter -------------------------------------------

Pbindef(\prand,
	//Pdef(\prand,
	\midinote, Prout({
		var tone0, tone1, tone2, interval, freq0, delta;
		loop {
			tone0 = rrand(0,11);
			interval = rrand(2,4);
			tone1 = Scale.minor(\pythagorean).at(tone0) + [0,12,24].choose + 0.1;
			tone2 = Scale.minor(\pythagorean).at(tone0 + interval) + [0,12,24].choose;
			//freq0 = [tone1,tone2]+47;
			//freq0 = [tone1,tone2]+52;
			freq0 = [tone1,tone2] + 52;
			//postln(freq0);
			freq0.yield;
		}
	}) - Pstutter(4, Prand([0,1] * 12,inf)),
    \dur, Prand([1,2,4,8,12,16,4,6,8], inf) / 20,
	//\ctranspose, Pstutter(64, Pxrand([-5,0,7],inf)),
	\ctranspose, 0,
    \instrument, \param,
	\amp, 0.4,
	\sustain, 1,
	\out, ~verbDelayBus
);


