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
