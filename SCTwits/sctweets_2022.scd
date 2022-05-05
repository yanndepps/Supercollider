// Boot
// increase this if "alloc failed" messages
s.options.memSize = 8192 * 256;

s.boot;

s.quit;

// GUIs
s.meter;

s.scope;

FreqScope.new;

s.plotTree;

// record
s.prepareForRecord;

s.record;

s.stopRecording;

// ---
// 06.01.22
play{d=ar(a=QuadC,5);ar(a,500)*d/99+ar(Splay,ar(a,999*b=[5,2.5,6])*ar(a,b/15).max/999*ar(a,b))+ar(AllpassN,ar(a,[12,16]*99)*ar(a,0.1,xi:[-0.5,-1]).max*ar(a,15).max/15+ar(Pan2,ar(a,99*b,1,ar(a,1/b/[15,5])>0*0.375-1.25).tanh,0.5*c=ar(a,b/15)*d,c).mean,e=1/15,e,15)}

// 28.04.22
play{(c=(f=ar(a=SinOsc,_,[0,5])).(25+f.(50.01)*ar(BLowPass,f.(0.1)/8+0.5*f.(252)*g=f.(5),round(g/2+1)/9**round(f.(1)*f.(5e-3)+1.02)*30*(g*3+40),0.05)*50)*f.(50.5*f.(50)/5+0.5)*f.(0.505)/5)+ar(d=PitchShift,c,0.5,0.5,0,0.5)+ar(d,c,0.5,round(5**f.(5e-3)),0.05,0.05)}

// 01.04.22
play{ar(a=LorenzL,ar(a,7,13,10,2.1,0.1)+3*(4**ar(a,1)+0.5)*d=[8000,8008])*ar(a,1)/5};defer({play{b=[4,2,1,8,6];ar(Splay,9/b*max(0.5-ar(a,b/3+1))/2*ar(a,d/4*b,2**ar(a,2**ar(a,1))/12+10,ar(a,b/3).round(0.5).lag2*12+35,ar(a,1/11).round(1/3).lag2/12+0.153,0.1))}},13)