s.boot;

{SinOsc.ar(LFNoise0.kr([10,15], 400, 800), 0, 0.3)}.play;

(
  {
    RLPF.ar(
      LFSaw.ar([8,12], 0, 0.1),
      LFNoise1.ar([2,3].choose, 1500, 1600),
      0.05,
      mul: 0.4
    )
  }.play;
)

// clarity with vars
(
  {
    a = SinOsc.ar(3, 0, 500, 1000);
    b = LFNoise0.kr([12,14]);
    c = max(0,b);
    SinOsc.ar(a, mul: c);
  }.play;
)

// Rising Sines
(
{
	CombN.ar(SinOsc.ar(LFNoise1.kr(4, 24, LFSaw.kr([8,7.23], 0, 3, 80)).midicps, 0, 0.04), 0.2, 0.2, 4)
}.play;
)

// ---