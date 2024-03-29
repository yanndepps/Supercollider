// Boot
// increase this if "alloc failed" messages
s.options.memSize = 8192 * 256;

s.options.sampleRate = 44100;

s.boot;

s.quit;

// GUIs
s.meter;

s.scope;

FreqScope.new;

s.plotTree;

// --- record
// ---

s.recSampleFormat = "int24";  // default to 32
s.recHeaderFormat = "wav";    // default to aiff

s.record("/home/depps/Musique/Samplz/SC_Recs/sctweets_170822.wav", duration:90);

s.stopRecording;

// ---
// 06.01.22
play{d=ar(a=QuadC,5);ar(a,500)*d/99+ar(Splay,ar(a,999*b=[5,2.5,6])*ar(a,b/15).max/999*ar(a,b))+ar(AllpassN,ar(a,[12,16]*99)*ar(a,0.1,xi:[-0.5,-1]).max*ar(a,15).max/15+ar(Pan2,ar(a,99*b,1,ar(a,1/b/[15,5])>0*0.375-1.25).tanh,0.5*c=ar(a,b/15)*d,c).mean,e=1/15,e,15)}

// 28.04.22
play{(c=(f=ar(a=SinOsc,_,[0,5])).(25+f.(50.01)*ar(BLowPass,f.(0.1)/8+0.5*f.(252)*g=f.(5),round(g/2+1)/9**round(f.(1)*f.(5e-3)+1.02)*30*(g*3+40),0.05)*50)*f.(50.5*f.(50)/5+0.5)*f.(0.505)/5)+ar(d=PitchShift,c,0.5,0.5,0,0.5)+ar(d,c,0.5,round(5**f.(5e-3)),0.05,0.05)}

// 01.04.22
play{ar(a=LorenzL,ar(a,7,13,10,2.1,0.1)+3*(4**ar(a,1)+0.5)*d=[8000,8008])*ar(a,1)/5};defer({play{b=[4,2,1,8,6];ar(Splay,9/b*max(0.5-ar(a,b/3+1))/2*ar(a,d/4*b,2**ar(a,2**ar(a,1))/12+10,ar(a,b/3).round(0.5).lag2*12+35,ar(a,1/11).round(1/3).lag2/12+0.153,0.1))}},13)

// 12.07.22
play{x=ar(Splay,ar(SinOscFB,ar(a=StandardL,(b=Scale.yu(\mean5).semitones)/8+8,b/5+1)+f=midicps(ar(DegreeToKey,LocalBuf newFrom:b,2**ar(a,ar(a,b+1/32,b+1),b/7+1)*12)+36-(ar(a,1/32)>0)),ar(a,1/3,b/8+1)+1/3,ar(a,b+2/32,b/9+1).max*kr(AmpComp,f)/16));x+ar(GVerb,x,99)}

// 23.08.22
play{mean({|i|ar(a=SinOscFB,(i+1*c=ar(a,1/64).round*10+50)+ar(a,2.02,1,2),ar(a,i+1/24,1)+1/2,ar(a,i+1/16,1))%ar(a,i+1*50.05**ar(a,6,1),1,ar(a,i+1/36,1))}!12).tanh+ar(Splay,ar(a,ar(a,(1..5),1,3).round+5*c,1,ar(a,12,1).max*3).tanh/9)+ar(a,c,0.7,ar(a,3,1).min(0)/3)}

// 10.11.22
play{ar(Splay,7**ar(a=SinOsc,g=1/(b=(1..9))/99)/9*ar(a,999*b.scramble/ar(f=RLPF,ar(c=Latch,round(ar(d=WhiteNoise),0.5)+2,ar(e=BrownNoise)+1.4>ar(a,b/999)),9**ar(a,g*9)*999,ar(a,b/77)/2+0.6))*ar(f,ar(c,ar(d),ar(e)+1.3>ar(a,b/99)),9**ar(a,g)*999,ar(a,b/88)/2+0.6))}

//---
// #supercollider with bass please...
play{AllpassC.ar(SinOsc.ar(55).tanh,0.4,TExpRand.ar(2e-4,0.4,Impulse.ar(8)).round([2e-3,4e-3]),2)};
