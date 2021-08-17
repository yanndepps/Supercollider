(
// how many
n = 9;

// grid of nxn
~grid = 0!n!n;

// our process
~process = {1.0.rand2};

// our wait
~wait = 1/60;

// the process
r = Routine {
	loop {
		// run the process
		~update.(~process);

		// sound producing code
		// goes here
		// ...
		s.makeBundle(0.2,{
			Synth.grain(\sine,[
				freq: ~grid[0][4].linexp(-1,1,200,2000),
				phase:~grid[0][5]*pi,
				amp:~grid[0][6].linlin(-1,1,0.01,0.1),
				dur:~grid[0][7].linlin(-1,1,0.01,0.1),
				pan:~grid[0][8]
			]);
		});

		// drawing
		// we need to defer!
		{ v.refresh }.defer;

		// then
		~wait.().wait;
	}
};
// drawing func
~pen = (
	grid: {
		9.do { |i|
			9.do { |j|
				Pen.fillColor = Color.grey(~grid[i][j]*0.5+0.5);
				Pen.fillRect(Rect(j*z, i*z, z-2, z-2));
			};
		};
	},
	line: {
		9.do { |i|
			9.do { |j|
				Pen.line(
					Point(j*z+(8*~grid[i][j])+10,i*z),
					Point(j*z+(8*~grid[i][j]).neg+10, i*z+15)
				);
				Pen.strokeColor = Color.grey(~grid[i][j]*0.5+0.5);
				Pen.fillStroke;
			};
		};
	};
);
~update = { |f|
	8.do { |i|
		9.do { |j|
			~grid[8-i][j] = ~grid[7-i][j];
		};
	};
	9.do { |i| ~grid[0][i] = f.() };
};
SynthDef(\sine, { |freq,phase,amp,dur,pan|
	var sig,env;
	sig = FSinOsc.ar(freq,phase,amp);
	env = Env.sine(dur).kr(2);
	sig = Pan2.ar(sig*env,pan);
	Out.ar(0,sig);
}).add;
w = Window("", Rect(400.0, 285.0, 202.0, 234.0));
z = 20;
v = UserView.new;
v.drawFunc = ~pen[\grid];
w.layout = VLayout(
	Button.new
	.canFocus_(false)
	.states_([
		[">",  Color.grey,Color.white],
		[":.", Color.white,Color.grey(0.3,0.8)]
	])
	.action_({ |b|
		if(b.value==1, {
			r.reset;
			// start process
			// Synth.tail(g,\verb);
			// Synth.tail(g,\master);
			SystemClock.play(r);
		}, { r.stop })
	}),
	v
);
CmdPeriod.doOnce {
	r.stop;
	w.close;
};
w.front;
)

// alter process on-the-fly
m = Pseq((-1.0,-0.99..1.0),inf).asStream;
~process = {m.next};

// another process
m = Pseq((-1.0,-0.995..1.0),inf).asStream;
m = Pbrown(-1.0, 1.0, 0.1).asStream;
m = Pbrown(-1.0, 1.0, 0.05).asStream;

// change drawing
v.drawFunc = ~pen[\line];
v.drawFunc = ~pen[\grid];