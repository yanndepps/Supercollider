(
s.latency= 0.025;
s.waitForBoot{
    var waveSize= 735;  //1/60*44100
    var processing= NetAddr("127.0.0.1", 47130);
    var waveBuf= Buffer.alloc(s, waveSize, 1);
    CmdPeriod.doOnce({waveBuf.free});
    SynthDef(\waveTrk, {|in= 0, buf, sample= 1|
        var z= HPF.ar(Mix(In.ar(in, 2)), 9);
        //var trig= Trig1.ar(HPZ1.ar(z>0).abs, 1/60);
        var trig= Impulse.ar(60);
        var phase= Sweep.ar(trig, sample*SampleRate.ir);
        BufWr.ar(z, buf, phase, 0);
    }).add;
    s.sync;
    Synth(\waveTrk, [\buf, waveBuf], s.defaultGroup, addAction:'addAfter');
    Routine.run({
        inf.do{
            waveBuf.getn(0, waveSize, {|data| processing.sendMsg(\waveData, *data)});
            (1/60).wait;
        };
    });
};
)


//some simple testsounds
{SinOsc.ar(MouseX.kr(1, 999))!2}.play;
{Saw.ar(MouseX.kr(50, 500))!2}.play;
{Pulse.ar(140)*0.1!2}.play;
{SoundIn.ar!2}.play;


{Saw.ar(XLine.kr(4000, 40, 20))}.play;
{LFTri.ar(XLine.kr(4000, 40, 20))}.play;
{LFTri.ar(60)}.play;
{LFTri.ar(59.5)}.play;