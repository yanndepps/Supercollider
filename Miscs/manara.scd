

(
SynthDef(\fm7_mannara,
{
    arg  note = 60,out_bus=0,amp=0.5,sustain = 0.5,release = 0.5,cutoff = 10000,rq = 1,pan = 0,lfo_speed = 5,lfo_amp = 0;
	var ctls, mods, chans,out,pitch,gate,

        envAmp1,envAmp2,envAmp3,envAmp4,envAmp5,envAmp6,env1,
		envEnv1,envEnv2,envEnv3,envEnv4,envEnv5,envEnv6,envAmp,envEnv,lfo;

        gate = Trig1.kr(1, sustain);

		envEnv1 = Env.new([0 ,1.0823 ,0.9928 ,0.0047 ,0], [1.1327 ,0 ,54.559 ,release], [3.0 ,-3.0 ,-3.0 ,-3.0],3);
		envAmp1 = EnvGen.kr(envEnv1,gate,doneAction: 0);

		envEnv2 = Env.new([0.0 ,0.1259 ,0.0052 ,0.0005 ,0.0], [0.0038 ,44.1847 ,34.3659 ,release], [3.0 ,-3.0 ,-3.0 ,-3.0],3);
		envAmp2 = EnvGen.kr(envEnv2,gate,doneAction: 0);

		envEnv3 = Env.new([0.0002 ,1.0862 ,0.5935 ,0.5935 ,0.0002], [0.1446 ,3.0325 ,0.0 ,release], [3.0 ,-3.0 ,-3.0 ,-3.0],3);
		envAmp3 = EnvGen.kr(envEnv3,gate,doneAction: 0);

		envEnv4 = Env.new([0.0 ,0.2287 ,0.2287 ,0.2287 ,0.0], [0.0977 ,0.0 ,0.0 ,release], [3.0 ,-3.0 ,-3.0 ,-3.0],3);
		envAmp4 = EnvGen.kr(envEnv4,gate,doneAction: 0);

		envEnv5 = Env.new([0.0 ,0.1485 ,0.0812 ,0.0 ,0.0], [0.004 ,0.0049 ,86.1372 ,0.0], [3.0 ,-3.0 ,-3.0 ,-3.0],3);
		envAmp5 = EnvGen.kr(envEnv5,gate,doneAction: 0);

		envEnv6 = Env.new([0.0001 ,0.4976 ,0.2719 ,0.0001 ,0.0001], [0.0105 ,0.0035 ,96.7982 ,0.0], [3.0 ,-3.0 ,-3.0 ,-3.0],3);
		envAmp6 = EnvGen.kr(envEnv6,gate,doneAction: 0);

        envEnv = Env.new([0,1,1,0], [0.0001,sustain,release],[0,0,0]);
		envAmp = EnvGen.kr(envEnv,gate,doneAction:2);

		lfo = LFTri.kr(lfo_speed);
		lfo = LinLin.ar(lfo, 0, 1, lfo_amp.neg.midiratio  , lfo_amp.midiratio);


        pitch = note.midicps/4;

   ctls = [
			[2 * 1 * (pitch + ((11-7)/32))* lfo, 0, envAmp1],

		    [2 * 1.01 * (pitch  + ((0-7)/32))* lfo , 0, envAmp2],

		    [8 * 1 * (pitch  + ((14-7)/32))* lfo , 0, envAmp3],

		    [2 * 1 * (pitch  + ((9-7)/32))* lfo , 0, envAmp4],

		    [2 * 1 * (pitch  + ((5-7)/32))* lfo , 0, envAmp5],

		    [18 * 1 * (pitch  + ((12-7)/32))* lfo, 0, envAmp6]
	];

	mods = [
		[0, 12.5664, 0,       0, 0,             0],
		[0, 0,       12.5664, 0, 0,             0],
		[0, 0,       0,       0, 0,             0],
		[0, 0,       0,       0, 12.5664,       0],
		[0, 0,       0,       0, 0,       12.5664],
		[0, 0,       0,       0, 0,        5.5418]
	];
	chans = [0, 1, 2, 3, 4, 5];
	out = FM7.ar(ctls, mods).slice(chans) * -12.dbamp;
	out = Mix.new([
		(out[0] * 1),
		(out[1] * 0),
		(out[2] * 0),
		(out[3] * 1),
		(out[4] * 0),
		(out[5] * 0),
	]);
	out = RLPF.ar(out,cutoff,rq);
	Out.ar(out_bus,Pan2.ar(out,pan,amp));
}).add;
)

(
u = ((
Pdef(\ss,
		Pbind(
			\instrument, \fm7_mannara,
			\note, Pwhite([36,40],[57,64],inf),
			\amp,0.5,
			\cutoff,10000,
			\rq,1,
                        \sustain,10,
			\lfo_amp,0.05,
			\release,18,
			\pan,Pwhite(-1.0,1.0,inf),
			\dur,12

))).play;
)
)
u.stop;
