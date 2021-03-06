//Standard sample rate
s.options.sampleRate = 44100;

//Increase memory capacity
s.options.memSize = 2.pow(20);


o = Server.local.options;

//16 output bus channels for JackRouter
o.numOutputBusChannels = 16;

//Connect JackRouter to SC
//s.options.device_("JackRouter");

s.options.outDevice_("BlackHole 16ch");

//To check if JackRouter is connected
ServerOptions.devices;


Server.killAll;

s.boot;

s.meter;


(
SynthDef.new(\unison, {
	arg attackTime=0.5, decayTime=0.05, sustainLevel=0.5, releaseTime=1, freq=50.0, amp, width, which, which2, which3, freqfilter, t_trig = 0, whichsig, whichsig2, whichsig3, whichsig4, whichmainsig, time, whichsub1, whichsub2, whichsubosc, whichnoise, noiseamp, whichlfo1, lfoval1, whichlfo2, whichunison, whichsigforunison, loFreq = 600, hiFreq = 4000, cent1, cent2, cent3, cent4, cent5, cent6, cent7, cent8, cent9, cent10, cent11, cent12, cent13, cent14, cent15, cent16, mainamp, lfoCycle, lfoFreq1, lfoFreq2, sus, gate=1, ampdist, smooth, freeze, whichlfo3, out;
	var env, envplot, selectsig, selectsig2, selectsig3, selectsig4, mainsig, selectfilter, selectfilter2, selectsubsig, selectsubsig2, whichsub, noise, amplfo, cutofflfo, voiceonea, voiceoneb, voiceonesubosc, voiceonesum, voicetwoa, voicetwob, voicetwosubosc, voicetwosum, twovoiceunison, voicethreea, voicethreeb, voicethreesubosc, voicethreesum, voicefoura, voicefourb, voicefoursubosc, voicefoursum, fourvoiceunison, voicefivea, voicefiveb, voicefivesubosc, voicefivesum, voicesixa, voicesixb, voicesixsubosc, voicesixsum, voicesevena, voicesevenb, voicesevensubosc, voicesevensum, voiceeighta, voiceeightb, voiceeightsubosc, voiceeightsum, eightvoiceunison, voiceninea, voicenineb, voiceninesubosc, voiceninesum, voicetena, voicetenb, voicetensubosc, voicetensum, voiceelevena, voiceelevenb, voiceelevensubosc, voiceelevensum, voicetwelvea, voicetwelveb, voicetwelvesubosc, voicetwelvesum, voicethirteena, voicethirteenb, voicethirteensubosc, voicethirteensum, voicefourteentha, voicefourteenthb, voicefourteenthsubosc, voicefourteenthsum, voicefifteentha, voicefifteenthb, voicefifteenthsubosc, voicefifteenthsum, voicesixteentha, voicesixteenthb, voicesixteenthsubosc, voicesixteenthsum, sixteenvoiceunison, unisonselect, binRange, loBin, hiBin, sig, chain, bufSize = 2048, centbank1, centbank2, centbank3, centbank4, centbank5, centbank6, centbank7, centbank8, centbank9, centbank10, centbank11, centbank12, centbank13, centbank14, centbank15, centbank16, legatofilter, legatoenv, envamp, dist, cutoffplusamplfo;

	// ENVELOPE MODULE
	env = EnvGen.kr(Env([0, 1, 0.75, 0.75, 0], [attackTime, decayTime, sustainLevel, releaseTime]), t_trig, doneAction:2);

	// CENTS & SIGNAL SELECTION MODULE
	// SIGNAL 1
	selectsig = Select.ar(whichsig,
		[DC.ar(0),
			Saw.ar(freq*1, amp),
			Saw.ar(freq*1.0005777895065548, amp), // 1 CENT
			Saw.ar(freq*1.001734370234696, amp), // 3 CENTS
			Saw.ar(freq*1.0052121400414757, amp), // 9 CENTS
			Saw.ar(freq*1.0087019837903988, amp), // 15 CENTS
			Saw.ar(freq*1.0127887842161452, amp), // 22 CENTS
			Saw.ar(freq*1.017479692102686, amp)]); // 30 CENTS

	// SIGNAL 2
	selectsig2 = Select.ar(whichsig2,
		[DC.ar(0),
			Saw.ar(freq*1, amp),
			Saw.ar(freq*0.9994225441413808, amp), // -1 CENT
			Saw.ar(freq*0.9982686325973925, amp), // -3 CENTS
			Saw.ar(freq*0.9948148855014218, amp), // -9 CENTS
			Saw.ar(freq*0.9913730874626623, amp), // -15 CENTS
			Saw.ar(freq*0.9873727035533445, amp), // -22 CENTS
			Saw.ar(freq*0.9828205985452514, amp)]); // -30 CENTS

	// SIGNAL 3
	selectsig3 = Select.ar(whichsig3,
		[DC.ar(0),
			Pulse.ar(freq*1, width, amp),
			Pulse.ar(freq*1.0005777895065548, width, amp), // -1 CENT
			Pulse.ar(freq*1.001734370234696, width, amp), // -3 CENTS
			Pulse.ar(freq*1.0052121400414757, width, amp), // -9 CENTS
			Pulse.ar(freq*1.0087019837903988, width, amp), // -15 CENTS
			Pulse.ar(freq*1.0127887842161452, width, amp), // -22 CENTS
			Pulse.ar(freq*1.017479692102686, width, amp)]); // -30 CENTS

	// SIGNAL 4
	selectsig4 = Select.ar(whichsig4,
		[DC.ar(0),
			Pulse.ar(freq*1, width, amp),
			Pulse.ar(freq*0.9994225441413808, width, amp), // -1 CENT
			Pulse.ar(freq*0.9982686325973925, width, amp), // -3 CENTS
			Pulse.ar(freq*0.9948148855014218, width, amp), // -9 CENTS
			Pulse.ar(freq*0.9913730874626623, width, amp), // -15 CENTS
			Pulse.ar(freq*0.9873727035533445, width, amp), // -22 CENTS
			Pulse.ar(freq*0.9828205985452514, width, amp)]); // -30 CENTS

	// SUB-OSCILLATOR SELECTION MODULE
	selectsubsig = Select.ar(whichsub1,
		[DC.ar(0),
			Pulse.ar(freq*0.5, width, amp), // -1 OCTAVE
			Pulse.ar(freq*0.25, width, amp), // -2 OCTAVES
			Pulse.ar(freq*0.125, width, amp), // -3 OCTAVES
			Pulse.ar(freq*0.0625, width, amp)]); // -4 OCTAVES
	selectsubsig2 = Select.ar(whichsub2,
		[DC.ar(0),
			LFTri.ar(freq*0.5, 0, amp), // -1 OCTAVE
			LFTri.ar(freq*0.25, 0, amp), // -2 OCTAVES
			LFTri.ar(freq*0.125, 0, amp), // -3 OCTAVES
			LFTri.ar(freq*0.0625, 0, amp)]); // -4 OCTAVES

	// SUMMING SUB-OSCILLATORS
	whichsub = Select.ar(whichsubosc, [DC.ar(0), selectsubsig, selectsubsig2]);

	// NOISE SELECTION MODULE
	noise = Select.ar(whichnoise,
		[DC.ar(0),
			WhiteNoise.ar(noiseamp),
			PinkNoise.ar(noiseamp),
			BrownNoise.ar(noiseamp),
			GrayNoise.ar(noiseamp)]);

	// SUMMING SIGNALS
	mainsig = selectsig + selectsig2 + selectsig3 + selectsig4 + whichsub + noise;

	// CENT SELECTION
	centbank1 = Select.kr(cent1, [DC.ar(0), ~pos1cents, ~pos2cents, ~pos3cents, ~pos4cents, ~pos5cents, ~pos6cents, ~pos7cents, ~pos8cents, ~pos9cents, ~pos10cents, ~pos11cents, ~pos12cents, ~pos13cents, ~pos14cents, ~pos15cents, ~pos16cents, ~pos17cents, ~pos18cents, ~pos19cents, ~pos20cents, ~pos21cents, ~pos22cents, ~pos23cents, ~pos24cents, ~pos25cents, ~pos26cents, ~pos27cents, ~pos28cents, ~pos29cents, ~pos30cents, ~pos31cents, ~pos32cents, ~pos33cents, ~pos34cents, ~pos35cents, ~pos36cents, ~pos37cents, ~pos38cents, ~pos39cents, ~pos40cents, ~pos41cents, ~pos42cents, ~pos43cents, ~pos44cents, ~pos45cents, ~pos46cents, ~pos47cents, ~pos48cents, ~pos49cents, ~pos50cents, ~pos51cents, ~pos52cents, ~pos53cents, ~pos54cents, ~pos55cents, ~pos56cents, ~pos57cents, ~pos58cents, ~pos59cents, ~pos60cents, ~pos61cents, ~pos62cents, ~pos63cents, ~pos64cents, ~pos65cents, ~pos66cents, ~pos67cents, ~pos68cents, ~pos69cents, ~pos70cents, ~pos71cents, ~pos72cents, ~pos73cents, ~pos74cents, ~pos75cents, ~pos76cents, ~pos77cents, ~pos78cents, ~pos79cents, ~pos80cents, ~pos81cents, ~pos82cents, ~pos83cents, ~pos84cents, ~pos85cents, ~pos86cents, ~pos87cents, ~pos88cents, ~pos89cents, ~pos90cents, ~pos91cents, ~pos92cents, ~pos93cents, ~pos94cents, ~pos95cents]);
	centbank2 = Select.kr(cent2, [DC.ar(0), ~neg1cent, ~neg2cents, ~neg3cents, ~neg4cents, ~neg5cents, ~neg6cents, ~neg7cents, ~neg8cents, ~neg9cents, ~neg10cents, ~neg11cents, ~neg12cents, ~neg13cents, ~neg14cents, ~neg15cents, ~neg16cents, ~neg17cents, ~neg18cents, ~neg19cents, ~neg20cents, ~neg21cents, ~neg22cents, ~neg23cents, ~neg24cents, ~neg25cents, ~neg26cents, ~neg27cents, ~neg28cents, ~neg29cents, ~neg30cents, ~neg31cents, ~neg32cents, ~neg33cents, ~neg34cents, ~neg35cents, ~neg36cents, ~neg37cents, ~neg38cents, ~neg39cents, ~neg40cents, ~neg41cents, ~neg42cents, ~neg43cents, ~neg44cents, ~neg45cents, ~neg46cents, ~neg47cents, ~neg48cents, ~neg49cents, ~neg50cents, ~neg51cents, ~neg52cents, ~neg53cents, ~neg54cents, ~neg55cents, ~neg56cents, ~neg57cents, ~neg58cents, ~neg59cents, ~neg60cents, ~neg61cents, ~neg62cents, ~neg63cents, ~neg64cents, ~neg65cents, ~neg66cents, ~neg67cents, ~neg68cents, ~neg69cents, ~neg70cents, ~neg71cents, ~neg72cents, ~neg73cents, ~neg74cents, ~neg75cents, ~neg76cents, ~neg77cents, ~neg78cents, ~neg79cents, ~neg80cents, ~neg81cents, ~neg82cents, ~neg83cents, ~neg84cents, ~neg85cents, ~neg86cents, ~neg87cents, ~neg88cents, ~neg89cents, ~neg90cents, ~neg91cents, ~neg92cents, ~neg93cents, ~neg94cents, ~neg95cents]);
	centbank3 = Select.kr(cent3, [DC.ar(0), ~pos1cents, ~pos2cents, ~pos3cents, ~pos4cents, ~pos5cents, ~pos6cents, ~pos7cents, ~pos8cents, ~pos9cents, ~pos10cents, ~pos11cents, ~pos12cents, ~pos13cents, ~pos14cents, ~pos15cents, ~pos16cents, ~pos17cents, ~pos18cents, ~pos19cents, ~pos20cents, ~pos21cents, ~pos22cents, ~pos23cents, ~pos24cents, ~pos25cents, ~pos26cents, ~pos27cents, ~pos28cents, ~pos29cents, ~pos30cents, ~pos31cents, ~pos32cents, ~pos33cents, ~pos34cents, ~pos35cents, ~pos36cents, ~pos37cents, ~pos38cents, ~pos39cents, ~pos40cents, ~pos41cents, ~pos42cents, ~pos43cents, ~pos44cents, ~pos45cents, ~pos46cents, ~pos47cents, ~pos48cents, ~pos49cents, ~pos50cents, ~pos51cents, ~pos52cents, ~pos53cents, ~pos54cents, ~pos55cents, ~pos56cents, ~pos57cents, ~pos58cents, ~pos59cents, ~pos60cents, ~pos61cents, ~pos62cents, ~pos63cents, ~pos64cents, ~pos65cents, ~pos66cents, ~pos67cents, ~pos68cents, ~pos69cents, ~pos70cents, ~pos71cents, ~pos72cents, ~pos73cents, ~pos74cents, ~pos75cents, ~pos76cents, ~pos77cents, ~pos78cents, ~pos79cents, ~pos80cents, ~pos81cents, ~pos82cents, ~pos83cents, ~pos84cents, ~pos85cents, ~pos86cents, ~pos87cents, ~pos88cents, ~pos89cents, ~pos90cents, ~pos91cents, ~pos92cents, ~pos93cents, ~pos94cents, ~pos95cents]);
	centbank4 = Select.kr(cent4, [DC.ar(0), ~neg1cent, ~neg2cents, ~neg3cents, ~neg4cents, ~neg5cents, ~neg6cents, ~neg7cents, ~neg8cents, ~neg9cents, ~neg10cents, ~neg11cents, ~neg12cents, ~neg13cents, ~neg14cents, ~neg15cents, ~neg16cents, ~neg17cents, ~neg18cents, ~neg19cents, ~neg20cents, ~neg21cents, ~neg22cents, ~neg23cents, ~neg24cents, ~neg25cents, ~neg26cents, ~neg27cents, ~neg28cents, ~neg29cents, ~neg30cents, ~neg31cents, ~neg32cents, ~neg33cents, ~neg34cents, ~neg35cents, ~neg36cents, ~neg37cents, ~neg38cents, ~neg39cents, ~neg40cents, ~neg41cents, ~neg42cents, ~neg43cents, ~neg44cents, ~neg45cents, ~neg46cents, ~neg47cents, ~neg48cents, ~neg49cents, ~neg50cents, ~neg51cents, ~neg52cents, ~neg53cents, ~neg54cents, ~neg55cents, ~neg56cents, ~neg57cents, ~neg58cents, ~neg59cents, ~neg60cents, ~neg61cents, ~neg62cents, ~neg63cents, ~neg64cents, ~neg65cents, ~neg66cents, ~neg67cents, ~neg68cents, ~neg69cents, ~neg70cents, ~neg71cents, ~neg72cents, ~neg73cents, ~neg74cents, ~neg75cents, ~neg76cents, ~neg77cents, ~neg78cents, ~neg79cents, ~neg80cents, ~neg81cents, ~neg82cents, ~neg83cents, ~neg84cents, ~neg85cents, ~neg86cents, ~neg87cents, ~neg88cents, ~neg89cents, ~neg90cents, ~neg91cents, ~neg92cents, ~neg93cents, ~neg94cents, ~neg95cents]);
	centbank5 = Select.kr(cent5, [DC.ar(0), ~pos1cents, ~pos2cents, ~pos3cents, ~pos4cents, ~pos5cents, ~pos6cents, ~pos7cents, ~pos8cents, ~pos9cents, ~pos10cents, ~pos11cents, ~pos12cents, ~pos13cents, ~pos14cents, ~pos15cents, ~pos16cents, ~pos17cents, ~pos18cents, ~pos19cents, ~pos20cents, ~pos21cents, ~pos22cents, ~pos23cents, ~pos24cents, ~pos25cents, ~pos26cents, ~pos27cents, ~pos28cents, ~pos29cents, ~pos30cents, ~pos31cents, ~pos32cents, ~pos33cents, ~pos34cents, ~pos35cents, ~pos36cents, ~pos37cents, ~pos38cents, ~pos39cents, ~pos40cents, ~pos41cents, ~pos42cents, ~pos43cents, ~pos44cents, ~pos45cents, ~pos46cents, ~pos47cents, ~pos48cents, ~pos49cents, ~pos50cents, ~pos51cents, ~pos52cents, ~pos53cents, ~pos54cents, ~pos55cents, ~pos56cents, ~pos57cents, ~pos58cents, ~pos59cents, ~pos60cents, ~pos61cents, ~pos62cents, ~pos63cents, ~pos64cents, ~pos65cents, ~pos66cents, ~pos67cents, ~pos68cents, ~pos69cents, ~pos70cents, ~pos71cents, ~pos72cents, ~pos73cents, ~pos74cents, ~pos75cents, ~pos76cents, ~pos77cents, ~pos78cents, ~pos79cents, ~pos80cents, ~pos81cents, ~pos82cents, ~pos83cents, ~pos84cents, ~pos85cents, ~pos86cents, ~pos87cents, ~pos88cents, ~pos89cents, ~pos90cents, ~pos91cents, ~pos92cents, ~pos93cents, ~pos94cents, ~pos95cents]);
	centbank6 = Select.kr(cent6, [DC.ar(0), ~neg1cent, ~neg2cents, ~neg3cents, ~neg4cents, ~neg5cents, ~neg6cents, ~neg7cents, ~neg8cents, ~neg9cents, ~neg10cents, ~neg11cents, ~neg12cents, ~neg13cents, ~neg14cents, ~neg15cents, ~neg16cents, ~neg17cents, ~neg18cents, ~neg19cents, ~neg20cents, ~neg21cents, ~neg22cents, ~neg23cents, ~neg24cents, ~neg25cents, ~neg26cents, ~neg27cents, ~neg28cents, ~neg29cents, ~neg30cents, ~neg31cents, ~neg32cents, ~neg33cents, ~neg34cents, ~neg35cents, ~neg36cents, ~neg37cents, ~neg38cents, ~neg39cents, ~neg40cents, ~neg41cents, ~neg42cents, ~neg43cents, ~neg44cents, ~neg45cents, ~neg46cents, ~neg47cents, ~neg48cents, ~neg49cents, ~neg50cents, ~neg51cents, ~neg52cents, ~neg53cents, ~neg54cents, ~neg55cents, ~neg56cents, ~neg57cents, ~neg58cents, ~neg59cents, ~neg60cents, ~neg61cents, ~neg62cents, ~neg63cents, ~neg64cents, ~neg65cents, ~neg66cents, ~neg67cents, ~neg68cents, ~neg69cents, ~neg70cents, ~neg71cents, ~neg72cents, ~neg73cents, ~neg74cents, ~neg75cents, ~neg76cents, ~neg77cents, ~neg78cents, ~neg79cents, ~neg80cents, ~neg81cents, ~neg82cents, ~neg83cents, ~neg84cents, ~neg85cents, ~neg86cents, ~neg87cents, ~neg88cents, ~neg89cents, ~neg90cents, ~neg91cents, ~neg92cents, ~neg93cents, ~neg94cents, ~neg95cents]);
	centbank7 = Select.kr(cent7, [DC.ar(0), ~pos1cents, ~pos2cents, ~pos3cents, ~pos4cents, ~pos5cents, ~pos6cents, ~pos7cents, ~pos8cents, ~pos9cents, ~pos10cents, ~pos11cents, ~pos12cents, ~pos13cents, ~pos14cents, ~pos15cents, ~pos16cents, ~pos17cents, ~pos18cents, ~pos19cents, ~pos20cents, ~pos21cents, ~pos22cents, ~pos23cents, ~pos24cents, ~pos25cents, ~pos26cents, ~pos27cents, ~pos28cents, ~pos29cents, ~pos30cents, ~pos31cents, ~pos32cents, ~pos33cents, ~pos34cents, ~pos35cents, ~pos36cents, ~pos37cents, ~pos38cents, ~pos39cents, ~pos40cents, ~pos41cents, ~pos42cents, ~pos43cents, ~pos44cents, ~pos45cents, ~pos46cents, ~pos47cents, ~pos48cents, ~pos49cents, ~pos50cents, ~pos51cents, ~pos52cents, ~pos53cents, ~pos54cents, ~pos55cents, ~pos56cents, ~pos57cents, ~pos58cents, ~pos59cents, ~pos60cents, ~pos61cents, ~pos62cents, ~pos63cents, ~pos64cents, ~pos65cents, ~pos66cents, ~pos67cents, ~pos68cents, ~pos69cents, ~pos70cents, ~pos71cents, ~pos72cents, ~pos73cents, ~pos74cents, ~pos75cents, ~pos76cents, ~pos77cents, ~pos78cents, ~pos79cents, ~pos80cents, ~pos81cents, ~pos82cents, ~pos83cents, ~pos84cents, ~pos85cents, ~pos86cents, ~pos87cents, ~pos88cents, ~pos89cents, ~pos90cents, ~pos91cents, ~pos92cents, ~pos93cents, ~pos94cents, ~pos95cents]);
	centbank8 = Select.kr(cent8, [DC.ar(0), ~neg1cent, ~neg2cents, ~neg3cents, ~neg4cents, ~neg5cents, ~neg6cents, ~neg7cents, ~neg8cents, ~neg9cents, ~neg10cents, ~neg11cents, ~neg12cents, ~neg13cents, ~neg14cents, ~neg15cents, ~neg16cents, ~neg17cents, ~neg18cents, ~neg19cents, ~neg20cents, ~neg21cents, ~neg22cents, ~neg23cents, ~neg24cents, ~neg25cents, ~neg26cents, ~neg27cents, ~neg28cents, ~neg29cents, ~neg30cents, ~neg31cents, ~neg32cents, ~neg33cents, ~neg34cents, ~neg35cents, ~neg36cents, ~neg37cents, ~neg38cents, ~neg39cents, ~neg40cents, ~neg41cents, ~neg42cents, ~neg43cents, ~neg44cents, ~neg45cents, ~neg46cents, ~neg47cents, ~neg48cents, ~neg49cents, ~neg50cents, ~neg51cents, ~neg52cents, ~neg53cents, ~neg54cents, ~neg55cents, ~neg56cents, ~neg57cents, ~neg58cents, ~neg59cents, ~neg60cents, ~neg61cents, ~neg62cents, ~neg63cents, ~neg64cents, ~neg65cents, ~neg66cents, ~neg67cents, ~neg68cents, ~neg69cents, ~neg70cents, ~neg71cents, ~neg72cents, ~neg73cents, ~neg74cents, ~neg75cents, ~neg76cents, ~neg77cents, ~neg78cents, ~neg79cents, ~neg80cents, ~neg81cents, ~neg82cents, ~neg83cents, ~neg84cents, ~neg85cents, ~neg86cents, ~neg87cents, ~neg88cents, ~neg89cents, ~neg90cents, ~neg91cents, ~neg92cents, ~neg93cents, ~neg94cents, ~neg95cents]);
	centbank9 = Select.kr(cent9, [DC.ar(0), ~pos1cents, ~pos2cents, ~pos3cents, ~pos4cents, ~pos5cents, ~pos6cents, ~pos7cents, ~pos8cents, ~pos9cents, ~pos10cents, ~pos11cents, ~pos12cents, ~pos13cents, ~pos14cents, ~pos15cents, ~pos16cents, ~pos17cents, ~pos18cents, ~pos19cents, ~pos20cents, ~pos21cents, ~pos22cents, ~pos23cents, ~pos24cents, ~pos25cents, ~pos26cents, ~pos27cents, ~pos28cents, ~pos29cents, ~pos30cents, ~pos31cents, ~pos32cents, ~pos33cents, ~pos34cents, ~pos35cents, ~pos36cents, ~pos37cents, ~pos38cents, ~pos39cents, ~pos40cents, ~pos41cents, ~pos42cents, ~pos43cents, ~pos44cents, ~pos45cents, ~pos46cents, ~pos47cents, ~pos48cents, ~pos49cents, ~pos50cents, ~pos51cents, ~pos52cents, ~pos53cents, ~pos54cents, ~pos55cents, ~pos56cents, ~pos57cents, ~pos58cents, ~pos59cents, ~pos60cents, ~pos61cents, ~pos62cents, ~pos63cents, ~pos64cents, ~pos65cents, ~pos66cents, ~pos67cents, ~pos68cents, ~pos69cents, ~pos70cents, ~pos71cents, ~pos72cents, ~pos73cents, ~pos74cents, ~pos75cents, ~pos76cents, ~pos77cents, ~pos78cents, ~pos79cents, ~pos80cents, ~pos81cents, ~pos82cents, ~pos83cents, ~pos84cents, ~pos85cents, ~pos86cents, ~pos87cents, ~pos88cents, ~pos89cents, ~pos90cents, ~pos91cents, ~pos92cents, ~pos93cents, ~pos94cents, ~pos95cents]);
	centbank10 = Select.kr(cent10, [DC.ar(0), ~neg1cent, ~neg2cents, ~neg3cents, ~neg4cents, ~neg5cents, ~neg6cents, ~neg7cents, ~neg8cents, ~neg9cents, ~neg10cents, ~neg11cents, ~neg12cents, ~neg13cents, ~neg14cents, ~neg15cents, ~neg16cents, ~neg17cents, ~neg18cents, ~neg19cents, ~neg20cents, ~neg21cents, ~neg22cents, ~neg23cents, ~neg24cents, ~neg25cents, ~neg26cents, ~neg27cents, ~neg28cents, ~neg29cents, ~neg30cents, ~neg31cents, ~neg32cents, ~neg33cents, ~neg34cents, ~neg35cents, ~neg36cents, ~neg37cents, ~neg38cents, ~neg39cents, ~neg40cents, ~neg41cents, ~neg42cents, ~neg43cents, ~neg44cents, ~neg45cents, ~neg46cents, ~neg47cents, ~neg48cents, ~neg49cents, ~neg50cents, ~neg51cents, ~neg52cents, ~neg53cents, ~neg54cents, ~neg55cents, ~neg56cents, ~neg57cents, ~neg58cents, ~neg59cents, ~neg60cents, ~neg61cents, ~neg62cents, ~neg63cents, ~neg64cents, ~neg65cents, ~neg66cents, ~neg67cents, ~neg68cents, ~neg69cents, ~neg70cents, ~neg71cents, ~neg72cents, ~neg73cents, ~neg74cents, ~neg75cents, ~neg76cents, ~neg77cents, ~neg78cents, ~neg79cents, ~neg80cents, ~neg81cents, ~neg82cents, ~neg83cents, ~neg84cents, ~neg85cents, ~neg86cents, ~neg87cents, ~neg88cents, ~neg89cents, ~neg90cents, ~neg91cents, ~neg92cents, ~neg93cents, ~neg94cents, ~neg95cents]);
	centbank11 = Select.kr(cent11, [DC.ar(0), ~pos1cents, ~pos2cents, ~pos3cents, ~pos4cents, ~pos5cents, ~pos6cents, ~pos7cents, ~pos8cents, ~pos9cents, ~pos10cents, ~pos11cents, ~pos12cents, ~pos13cents, ~pos14cents, ~pos15cents, ~pos16cents, ~pos17cents, ~pos18cents, ~pos19cents, ~pos20cents, ~pos21cents, ~pos22cents, ~pos23cents, ~pos24cents, ~pos25cents, ~pos26cents, ~pos27cents, ~pos28cents, ~pos29cents, ~pos30cents, ~pos31cents, ~pos32cents, ~pos33cents, ~pos34cents, ~pos35cents, ~pos36cents, ~pos37cents, ~pos38cents, ~pos39cents, ~pos40cents, ~pos41cents, ~pos42cents, ~pos43cents, ~pos44cents, ~pos45cents, ~pos46cents, ~pos47cents, ~pos48cents, ~pos49cents, ~pos50cents, ~pos51cents, ~pos52cents, ~pos53cents, ~pos54cents, ~pos55cents, ~pos56cents, ~pos57cents, ~pos58cents, ~pos59cents, ~pos60cents, ~pos61cents, ~pos62cents, ~pos63cents, ~pos64cents, ~pos65cents, ~pos66cents, ~pos67cents, ~pos68cents, ~pos69cents, ~pos70cents, ~pos71cents, ~pos72cents, ~pos73cents, ~pos74cents, ~pos75cents, ~pos76cents, ~pos77cents, ~pos78cents, ~pos79cents, ~pos80cents, ~pos81cents, ~pos82cents, ~pos83cents, ~pos84cents, ~pos85cents, ~pos86cents, ~pos87cents, ~pos88cents, ~pos89cents, ~pos90cents, ~pos91cents, ~pos92cents, ~pos93cents, ~pos94cents, ~pos95cents]);
	centbank12 = Select.kr(cent12, [DC.ar(0), ~neg1cent, ~neg2cents, ~neg3cents, ~neg4cents, ~neg5cents, ~neg6cents, ~neg7cents, ~neg8cents, ~neg9cents, ~neg10cents, ~neg11cents, ~neg12cents, ~neg13cents, ~neg14cents, ~neg15cents, ~neg16cents, ~neg17cents, ~neg18cents, ~neg19cents, ~neg20cents, ~neg21cents, ~neg22cents, ~neg23cents, ~neg24cents, ~neg25cents, ~neg26cents, ~neg27cents, ~neg28cents, ~neg29cents, ~neg30cents, ~neg31cents, ~neg32cents, ~neg33cents, ~neg34cents, ~neg35cents, ~neg36cents, ~neg37cents, ~neg38cents, ~neg39cents, ~neg40cents, ~neg41cents, ~neg42cents, ~neg43cents, ~neg44cents, ~neg45cents, ~neg46cents, ~neg47cents, ~neg48cents, ~neg49cents, ~neg50cents, ~neg51cents, ~neg52cents, ~neg53cents, ~neg54cents, ~neg55cents, ~neg56cents, ~neg57cents, ~neg58cents, ~neg59cents, ~neg60cents, ~neg61cents, ~neg62cents, ~neg63cents, ~neg64cents, ~neg65cents, ~neg66cents, ~neg67cents, ~neg68cents, ~neg69cents, ~neg70cents, ~neg71cents, ~neg72cents, ~neg73cents, ~neg74cents, ~neg75cents, ~neg76cents, ~neg77cents, ~neg78cents, ~neg79cents, ~neg80cents, ~neg81cents, ~neg82cents, ~neg83cents, ~neg84cents, ~neg85cents, ~neg86cents, ~neg87cents, ~neg88cents, ~neg89cents, ~neg90cents, ~neg91cents, ~neg92cents, ~neg93cents, ~neg94cents, ~neg95cents]);
	centbank13 = Select.kr(cent13, [DC.ar(0), ~pos1cents, ~pos2cents, ~pos3cents, ~pos4cents, ~pos5cents, ~pos6cents, ~pos7cents, ~pos8cents, ~pos9cents, ~pos10cents, ~pos11cents, ~pos12cents, ~pos13cents, ~pos14cents, ~pos15cents, ~pos16cents, ~pos17cents, ~pos18cents, ~pos19cents, ~pos20cents, ~pos21cents, ~pos22cents, ~pos23cents, ~pos24cents, ~pos25cents, ~pos26cents, ~pos27cents, ~pos28cents, ~pos29cents, ~pos30cents, ~pos31cents, ~pos32cents, ~pos33cents, ~pos34cents, ~pos35cents, ~pos36cents, ~pos37cents, ~pos38cents, ~pos39cents, ~pos40cents, ~pos41cents, ~pos42cents, ~pos43cents, ~pos44cents, ~pos45cents, ~pos46cents, ~pos47cents, ~pos48cents, ~pos49cents, ~pos50cents, ~pos51cents, ~pos52cents, ~pos53cents, ~pos54cents, ~pos55cents, ~pos56cents, ~pos57cents, ~pos58cents, ~pos59cents, ~pos60cents, ~pos61cents, ~pos62cents, ~pos63cents, ~pos64cents, ~pos65cents, ~pos66cents, ~pos67cents, ~pos68cents, ~pos69cents, ~pos70cents, ~pos71cents, ~pos72cents, ~pos73cents, ~pos74cents, ~pos75cents, ~pos76cents, ~pos77cents, ~pos78cents, ~pos79cents, ~pos80cents, ~pos81cents, ~pos82cents, ~pos83cents, ~pos84cents, ~pos85cents, ~pos86cents, ~pos87cents, ~pos88cents, ~pos89cents, ~pos90cents, ~pos91cents, ~pos92cents, ~pos93cents, ~pos94cents, ~pos95cents]);
	centbank14 = Select.kr(cent14, [DC.ar(0), ~neg1cent, ~neg2cents, ~neg3cents, ~neg4cents, ~neg5cents, ~neg6cents, ~neg7cents, ~neg8cents, ~neg9cents, ~neg10cents, ~neg11cents, ~neg12cents, ~neg13cents, ~neg14cents, ~neg15cents, ~neg16cents, ~neg17cents, ~neg18cents, ~neg19cents, ~neg20cents, ~neg21cents, ~neg22cents, ~neg23cents, ~neg24cents, ~neg25cents, ~neg26cents, ~neg27cents, ~neg28cents, ~neg29cents, ~neg30cents, ~neg31cents, ~neg32cents, ~neg33cents, ~neg34cents, ~neg35cents, ~neg36cents, ~neg37cents, ~neg38cents, ~neg39cents, ~neg40cents, ~neg41cents, ~neg42cents, ~neg43cents, ~neg44cents, ~neg45cents, ~neg46cents, ~neg47cents, ~neg48cents, ~neg49cents, ~neg50cents, ~neg51cents, ~neg52cents, ~neg53cents, ~neg54cents, ~neg55cents, ~neg56cents, ~neg57cents, ~neg58cents, ~neg59cents, ~neg60cents, ~neg61cents, ~neg62cents, ~neg63cents, ~neg64cents, ~neg65cents, ~neg66cents, ~neg67cents, ~neg68cents, ~neg69cents, ~neg70cents, ~neg71cents, ~neg72cents, ~neg73cents, ~neg74cents, ~neg75cents, ~neg76cents, ~neg77cents, ~neg78cents, ~neg79cents, ~neg80cents, ~neg81cents, ~neg82cents, ~neg83cents, ~neg84cents, ~neg85cents, ~neg86cents, ~neg87cents, ~neg88cents, ~neg89cents, ~neg90cents, ~neg91cents, ~neg92cents, ~neg93cents, ~neg94cents, ~neg95cents]);
	centbank15 = Select.kr(cent15, [DC.ar(0), ~pos1cents, ~pos2cents, ~pos3cents, ~pos4cents, ~pos5cents, ~pos6cents, ~pos7cents, ~pos8cents, ~pos9cents, ~pos10cents, ~pos11cents, ~pos12cents, ~pos13cents, ~pos14cents, ~pos15cents, ~pos16cents, ~pos17cents, ~pos18cents, ~pos19cents, ~pos20cents, ~pos21cents, ~pos22cents, ~pos23cents, ~pos24cents, ~pos25cents, ~pos26cents, ~pos27cents, ~pos28cents, ~pos29cents, ~pos30cents, ~pos31cents, ~pos32cents, ~pos33cents, ~pos34cents, ~pos35cents, ~pos36cents, ~pos37cents, ~pos38cents, ~pos39cents, ~pos40cents, ~pos41cents, ~pos42cents, ~pos43cents, ~pos44cents, ~pos45cents, ~pos46cents, ~pos47cents, ~pos48cents, ~pos49cents, ~pos50cents, ~pos51cents, ~pos52cents, ~pos53cents, ~pos54cents, ~pos55cents, ~pos56cents, ~pos57cents, ~pos58cents, ~pos59cents, ~pos60cents, ~pos61cents, ~pos62cents, ~pos63cents, ~pos64cents, ~pos65cents, ~pos66cents, ~pos67cents, ~pos68cents, ~pos69cents, ~pos70cents, ~pos71cents, ~pos72cents, ~pos73cents, ~pos74cents, ~pos75cents, ~pos76cents, ~pos77cents, ~pos78cents, ~pos79cents, ~pos80cents, ~pos81cents, ~pos82cents, ~pos83cents, ~pos84cents, ~pos85cents, ~pos86cents, ~pos87cents, ~pos88cents, ~pos89cents, ~pos90cents, ~pos91cents, ~pos92cents, ~pos93cents, ~pos94cents, ~pos95cents]);
	centbank16 = Select.kr(cent16, [DC.ar(0), ~neg1cent, ~neg2cents, ~neg3cents, ~neg4cents, ~neg5cents, ~neg6cents, ~neg7cents, ~neg8cents, ~neg9cents, ~neg10cents, ~neg11cents, ~neg12cents, ~neg13cents, ~neg14cents, ~neg15cents, ~neg16cents, ~neg17cents, ~neg18cents, ~neg19cents, ~neg20cents, ~neg21cents, ~neg22cents, ~neg23cents, ~neg24cents, ~neg25cents, ~neg26cents, ~neg27cents, ~neg28cents, ~neg29cents, ~neg30cents, ~neg31cents, ~neg32cents, ~neg33cents, ~neg34cents, ~neg35cents, ~neg36cents, ~neg37cents, ~neg38cents, ~neg39cents, ~neg40cents, ~neg41cents, ~neg42cents, ~neg43cents, ~neg44cents, ~neg45cents, ~neg46cents, ~neg47cents, ~neg48cents, ~neg49cents, ~neg50cents, ~neg51cents, ~neg52cents, ~neg53cents, ~neg54cents, ~neg55cents, ~neg56cents, ~neg57cents, ~neg58cents, ~neg59cents, ~neg60cents, ~neg61cents, ~neg62cents, ~neg63cents, ~neg64cents, ~neg65cents, ~neg66cents, ~neg67cents, ~neg68cents, ~neg69cents, ~neg70cents, ~neg71cents, ~neg72cents, ~neg73cents, ~neg74cents, ~neg75cents, ~neg76cents, ~neg77cents, ~neg78cents, ~neg79cents, ~neg80cents, ~neg81cents, ~neg82cents, ~neg83cents, ~neg84cents, ~neg85cents, ~neg86cents, ~neg87cents, ~neg88cents, ~neg89cents, ~neg90cents, ~neg91cents, ~neg92cents, ~neg93cents, ~neg94cents, ~neg95cents]);

	// 2 VOICE UNISON
	voiceonea = Select.ar(whichsigforunison, [Saw.ar(centbank1*freq, amp), Pulse.ar(centbank1*freq, 0.5, amp)]);
	voiceoneb = Select.ar(whichsigforunison, [Saw.ar(centbank1*freq, amp), Pulse.ar(centbank1*freq, 0.5, amp)]);
	voiceonesubosc = Select.ar(whichsigforunison, [Saw.ar(centbank1*freq/2, amp), Pulse.ar(centbank1*freq/2, 0.5, amp)]);
	voiceonesum = voiceonea + voiceoneb + voiceonesubosc;
	voiceonesum = Pan2.ar(voiceonesum, Saw.kr(1).range(-0.8, -0.1));

	voicetwoa = Select.ar(whichsigforunison, [Saw.ar(centbank2*freq, amp), Pulse.ar(centbank2*freq, 0.5, amp)]);
	voicetwob = Select.ar(whichsigforunison, [Saw.ar(centbank2*freq, amp), Pulse.ar(centbank2*freq, 0.5, amp)]);
	voicetwosubosc = Select.ar(whichsigforunison, [Saw.ar(centbank2*freq/2, amp), Pulse.ar(centbank2*freq/2, 0.5, amp)]);
	voicetwosum = voicetwoa + voicetwob + voicetwosubosc;
	voicetwosum = Pan2.ar(voicetwosum, Saw.kr(0.8).range(-0.1, 0.5));

	twovoiceunison = voiceonesum + voicetwosum + noise;

	// 4 VOICE UNISON
	voicethreea = Select.ar(whichsigforunison, [Saw.ar(centbank3*freq, amp), Pulse.ar(centbank3*freq, 0.5, amp)]);
	voicethreeb = Select.ar(whichsigforunison, [Saw.ar(centbank3*freq, amp), Pulse.ar(centbank3*freq, 0.5, amp)]);
	voicethreesubosc = Select.ar(whichsigforunison, [Saw.ar(centbank3*freq/2, amp), Pulse.ar(centbank3*freq/2, 0.5, amp)]);
	voicethreesum = voicethreea + voicethreeb + voicethreesubosc;

	voicefoura = Select.ar(whichsigforunison, [Saw.ar(centbank4*freq, amp), Pulse.ar(centbank4*freq, 0.5, amp)]);
	voicefourb = Select.ar(whichsigforunison, [Saw.ar(centbank4*freq, amp), Pulse.ar(centbank4*freq, 0.5, amp)]);
	voicefoursubosc = Select.ar(whichsigforunison, [Saw.ar(centbank4*freq/2, amp), Pulse.ar(centbank4*freq/2, 0.5, amp)]);
	voicefoursum = voicefoura + voicefourb + voicefoursubosc;

	fourvoiceunison = voiceonesum + voicetwosum + voicethreesum + voicefoursum + noise;

	// 8 VOICE UNISON
	voicefivea = Select.ar(whichsigforunison, [Saw.ar(centbank5*freq, amp), Pulse.ar(centbank5*freq, 0.5, amp)]);
	voicefiveb = Select.ar(whichsigforunison, [Saw.ar(centbank5*freq, amp), Pulse.ar(centbank5*freq, 0.5, amp)]);
	voicefivesubosc = Select.ar(whichsigforunison, [Saw.ar(centbank5*freq/2, amp), Pulse.ar(centbank5*freq/2, 0.5, amp)]);
	voicefivesum = voicefivea + voicefiveb + voicefivesubosc;

	voicesixa = Select.ar(whichsigforunison, [Saw.ar(centbank6*freq, amp), Pulse.ar(centbank6*freq, 0.5, amp)]);
	voicesixb = Select.ar(whichsigforunison, [Saw.ar(centbank6*freq, amp), Pulse.ar(centbank6*freq, 0.5, amp)]);
	voicesixsubosc = Select.ar(whichsigforunison, [Saw.ar(centbank6*freq/2, amp), Pulse.ar(centbank6*freq/2, 0.5, amp)]);
	voicesixsum = voicesixa + voicesixb + voicesixsubosc;

	voicesevena = Select.ar(whichsigforunison, [Saw.ar(centbank7*freq, amp), Pulse.ar(centbank7*freq, 0.5, amp)]);
	voicesevenb = Select.ar(whichsigforunison, [Saw.ar(centbank7*freq, amp), Pulse.ar(centbank7*freq, 0.5, amp)]);
	voicesevensubosc = Select.ar(whichsigforunison, [Saw.ar(centbank7*freq/2, amp), Pulse.ar(centbank7*freq/2, 0.5, amp)]);
	voicesevensum = voicesevena + voicesevenb + voicesevensubosc;

	voiceeighta = Select.ar(whichsigforunison, [Saw.ar(centbank8*freq, amp), Pulse.ar(centbank8*freq, 0.5, amp)]);
	voiceeightb = Select.ar(whichsigforunison, [Saw.ar(centbank8*freq, amp), Pulse.ar(centbank8*freq, 0.5, amp)]);
	voiceeightsubosc = Select.ar(whichsigforunison, [Saw.ar(centbank8*freq/2, amp), Pulse.ar(centbank8*freq/2, 0.5, amp)]);
	voiceeightsum = voiceeighta + voiceeightb + voiceeightsubosc;

	eightvoiceunison = voiceonesum + voicetwosum + voicethreesum + voicefoursum + voicefivesum + voicesixsum + voicesevensum + voiceeightsum + noise;

	// 16 VOICE UNISON
	voiceninea = Select.ar(whichsigforunison, [Saw.ar(centbank9*freq, amp), Pulse.ar(centbank9*freq, 0.5, amp)]);
	voicenineb = Select.ar(whichsigforunison, [Saw.ar(centbank9*freq, amp), Pulse.ar(centbank9*freq, 0.5, amp)]);
	voiceninesubosc = Select.ar(whichsigforunison, [Saw.ar(centbank9*freq/2, amp), Pulse.ar(centbank9*freq/2, 0.5, amp)]);
	voiceninesum = voiceninea + voicenineb + voiceninesubosc;

	voicetena = Select.ar(whichsigforunison, [Saw.ar(centbank10*freq, amp), Pulse.ar(centbank10*freq, 0.5, amp)]);
	voicetenb = Select.ar(whichsigforunison, [Saw.ar(centbank10*freq, amp), Pulse.ar(centbank10*freq, 0.5, amp)]);
	voicetensubosc = Select.ar(whichsigforunison, [Saw.ar(centbank10*freq/2, amp), Pulse.ar(centbank10*freq/2, 0.5, amp)]);
	voicetensum = voicetena + voicetenb + voicetensubosc;

	voiceelevena = Select.ar(whichsigforunison, [Saw.ar(centbank11*freq, amp), Pulse.ar(centbank11*freq, 0.5, amp)]);
	voiceelevenb = Select.ar(whichsigforunison, [Saw.ar(centbank11*freq, amp), Pulse.ar(centbank11*freq, 0.5, amp)]);
	voiceelevensubosc = Select.ar(whichsigforunison, [Saw.ar(centbank11*freq/2, amp), Pulse.ar(centbank11*freq/2, 0.5, amp)]);
	voiceelevensum = voiceelevena + voiceelevenb + voiceelevensubosc;

	voicetwelvea = Select.ar(whichsigforunison, [Saw.ar(centbank12*freq, amp), Pulse.ar(centbank12*freq, 0.5, amp)]);
	voicetwelveb = Select.ar(whichsigforunison, [Saw.ar(centbank12*freq, amp), Pulse.ar(centbank12*freq, 0.5, amp)]);
	voicetwelvesubosc = Select.ar(whichsigforunison, [Saw.ar(centbank12*freq/2, amp), Pulse.ar(centbank12*freq/2, 0.5, amp)]);
	voicetwelvesum = voicetwelvea + voicetwelveb + voicetwelvesubosc;

	voicethirteena = Select.ar(whichsigforunison, [Saw.ar(centbank13*freq, amp), Pulse.ar(centbank13*freq, 0.5, amp)]);
	voicethirteenb = Select.ar(whichsigforunison, [Saw.ar(centbank13*freq, amp), Pulse.ar(centbank13*freq, 0.5, amp)]);
	voicethirteensubosc = Select.ar(whichsigforunison, [Saw.ar(centbank13*freq/2, amp), Pulse.ar(centbank13*freq/2, 0.5, amp)]);
	voicethirteensum = voicethirteena + voicethirteenb + voicethirteensubosc;

	voicefourteentha = Select.ar(whichsigforunison, [Saw.ar(centbank14*freq, amp), Pulse.ar(centbank14*freq, 0.5, amp)]);
	voicefourteenthb = Select.ar(whichsigforunison, [Saw.ar(centbank14*freq, amp), Pulse.ar(centbank14*freq, 0.5, amp)]);
	voicefourteenthsubosc = Select.ar(whichsigforunison, [Saw.ar(centbank14*freq/2, amp), Pulse.ar(centbank14*freq/2, 0.5, amp)]);
	voicefourteenthsum = voicefourteentha + voicefourteenthb + voicefourteenthsubosc;

	voicefifteentha = Select.ar(whichsigforunison, [Saw.ar(centbank15*freq, amp), Pulse.ar(centbank15*freq, 0.5, amp)]);
	voicefifteenthb = Select.ar(whichsigforunison, [Saw.ar(centbank15*freq, amp), Pulse.ar(centbank15*freq, 0.5, amp)]);
	voicefifteenthsubosc = Select.ar(whichsigforunison, [Saw.ar(centbank15*freq/2, amp), Pulse.ar(centbank15*freq/2, 0.5, amp)]);
	voicefifteenthsum = voicefifteentha + voicefifteenthb + voicefifteenthsubosc;

	voicesixteentha = Select.ar(whichsigforunison, [Saw.ar(centbank16*freq, amp), Pulse.ar(centbank16*freq, 0.5, amp)]);
	voicesixteenthb = Select.ar(whichsigforunison, [Saw.ar(centbank16*freq, amp), Pulse.ar(centbank16*freq, 0.5, amp)]);
	voicesixteenthsubosc = Select.ar(whichsigforunison, [Saw.ar(centbank16*freq/2, amp), Pulse.ar(centbank16*freq/2, 0.5, amp)]);
	voicesixteenthsum = voicesixteentha + voicesixteenthb + voicesixteenthsubosc;

	sixteenvoiceunison = voiceonesum + voicetwosum + voicethreesum + voicefoursum + voicefivesum + voicesixsum + voicesevensum + voiceeightsum + voiceninesum + voicetensum + voiceelevensum + voicetwelvesum + voicethirteensum + 	voicefourteenthsum +  voicefifteenthsum + voicesixteenthsum + noise;


	// UNISON SELECTION
	unisonselect = Select.ar(whichunison, [mainsig, twovoiceunison, fourvoiceunison, eightvoiceunison, sixteenvoiceunison]);

	// LFO MODULE - AMPLITUDE
	amplfo = Select.ar(whichlfo1,
		[DC.ar(0),
			LFSaw.ar(lfoval1, 0, 0.6),
			LFTri.ar(lfoval1),
			LFPulse.ar(lfoval1),
			SinOsc.ar(lfoval1)]);

	// LFO MODULE - CUTOFF
	cutofflfo = Select.ar(whichlfo2,
		[DC.ar(0),
			BLowPass.ar(unisonselect, LFTri.kr(lfoCycle, 0, lfoFreq1, 2040)),
			BHiPass.ar(unisonselect, LFTri.kr(1, 0, 2000, 2040)),
			BBandPass.ar(unisonselect, LFTri.kr(1, 0, 2000, 2040))]);

	cutoffplusamplfo = Select.ar(whichlfo3,
		[DC.ar(0),
			BLowPass.ar(unisonselect, LFTri.kr(lfoCycle, 0, lfoFreq1, 2040))*amplfo,
			BHiPass.ar(unisonselect, LFTri.kr(1, 0, 2000, 2040))*amplfo,
			BBandPass.ar(unisonselect, LFTri.kr(1, 0, 2000, 2040))*amplfo]);

	// FILTER MODULE
	// FILTER SELECTION
	selectfilter = Select.ar(which2,
		[unisonselect,
		    BLowPass.ar(unisonselect, freqfilter),
		    BHiPass.ar(unisonselect, freqfilter),
		    BBandPass.ar(unisonselect, freqfilter)]);

	// FILTER ENVELOPE
	selectfilter2 = Select.ar(which3,
	 [unisonselect,
		BLowPass.ar(unisonselect, Line.ar(100, 3000, 2.5)),
		BHiPass.ar(unisonselect, EnvGen.kr(Env([5000, 100], [time]))),
		BBandPass.ar(unisonselect, EnvGen.kr(Env([100, 5000], [time])))]);

	dist = CrossoverDistortion.ar(cutoffplusamplfo, ampdist, smooth);

	chain = FFT(LocalBuf(bufSize), cutoffplusamplfo);
	chain = PV_MagFreeze(chain, MouseY.kr > 0.5);
	Out.ar(out, env*IFFT(chain)!2*mainamp);
}).load;
)



(
~ambientcomp = Ppar([
~synthrhythm = PmonoArtic(
	\unison,
	\freq, Pseq([~cmajor74, ~fmajor74, ~gmajor74], inf),
	\amp, 0.4,
	\dur, 1/2,
	\stretch, Pfunc {~stretchvar},
	\attackTime, Pfunc {~attackTimevar},
	\decayTime, 0.05,
	\sustainLevel, 0.5,
	\releaseTime, Pfunc {~releaseTimevar},
	\ampdist, Pfunc {~ampdistvar},
	\smooth, Pfunc {~smoothvar},
	\width, 0.5,
	\whichunison, 3,
	\whichnoise, 1,
	\noiseamp, 0.7,
	\which2, 1,
	\freqfilter, Pfunc {~freqfiltervar},
	\t_trig, 1,
	\whichsigforunison, 1,
	\which3, 1,
	\whichlfo1, Pfunc {~whichlfo1},
	\lfoval1, Pfunc {~lfoval1},
	\lfoval1, 5,
	\whichlfo2, 1,
	\lfoCycle, Pfunc {~lfoCyclevar},
	\lfoFreq1, Pfunc {~lfoFreq1var},
	\lfoFreq2, 2100,
	\whichmainsig, 5,
	\whichlfo3, Pfunc {~whichlfo3},
	\cent1, Pfunc {~cent1and2var},
	\cent2, Pfunc {~cent1and2var},
	\cent3, Pfunc {~cent3and4var},
	\cent4, Pfunc {~cent3and4var},
	\cent5, Pfunc {~cent5and6var},
	\cent6, Pfunc {~cent5and6var},
	\cent7, Pfunc {~cent7and8var},
	\cent8, Pfunc {~cent7and8var},
	\cent9, Pfunc {~cent9and10var},
	\cent10, Pfunc {~cent9and10var},
	\cent11, Pfunc {~cent11and12var},
	\cent12, Pfunc {~cent11and12var},
	\cent13, Pfunc {~cent13and14var},
	\cent14, Pfunc {~cent13and14var},
	\cent15, Pfunc {~cent15and16var},
	\cent16, Pfunc {~cent15and16var},
	\mainamp, 0.7,
	\out, 0),
]);
)



(
~ambientsynth = [
	\cent1and2var, [2, 9, \lin, 1, 7],
	\cent3and4var, [10, 24, \lin, 1, 14],
	\cent5and6var, [25, 37, \lin, 1, 12],
	\cent7and8var, [38, 50, \lin, 1, 12],
	\cent9and10var, [51, 63, \lin, 1, 12],
	\cent11and12var, [64, 76, \lin, 1, 12],
	\cent13and14var, [77, 88, \lin, 1, 11],
	\cent15and16var, [89, 95, \lin, 1, 6],
	\whichlfo1, [0, 4, \lin, 1, 5],
	\lfoval1, [0.1, 5, \lin, 0.1, 5],
	\whichlfo3, [0, 3, \lin, 1, 4],
	\lfoCyclevar, [0.1, 3, \lin, 0.1, 3],
	\lfoFreq1var, [100, 2000, \lin, 100, 2000],
	\attackTimevar, [0.1, 2.5, \lin, 0.1, 2.5],
	\releaseTimevar, [0.1, 2.5, \lin, 0.1, 2.5],
	\ampdistvar, [0.1, 0.9, \lin, 0.1, 0.9],
	\smoothvar, [0.1, 0.9, \lin, 0.1, 0.9],
	\freqfiltervar, [100, 5000, \lin, 100, 5000],
	\stretchvar, [1.0, 12.0, \lin, 1.0, 12.0]
];
~varGui = VarGui(~ambientsynth, stream:~ambientcomp).gui;
)
