-- benjolis params
let oscA = pF "oscA"
    oscB = pF "oscB"
    runA = pF "runA"
    runB = pF "runB"
    runF = pF "runF"
    res = pF "res"
    freq = pF "freq"

-- olbos
    note = pF "note" --shared by all my SynthDefs
    tuning = pF "tuning" --shared by all my SynthDefs, SC code by Guiot
    waveblender = pF "waveblender" -- the name of a custom wavetable synthesizer
    wb = "waveblender" --shortcut for the waveblender SynthDef
    xenbass = pF "xenbass" -- a stochastic synth bass
    xenharp = pF "xenharp" -- a stochastic harp sound suitable for melodic fragments
    tubes = pF "tubes" -- a physical model of two resonating tubes, written with Nesso
    depth = pF "depth" --generally used as a detuned chorus effect on SynthDefs (in the tubes synth the range is 0-1, in all others synths it's the frequency amount of displacement)
    pos = pF "pos" --the position of the bufreader in the Waveblender SynthDef, from 0 to 1
    f1 = pF "f1" -- freq control of tube1 of tubes synth (range 3,1000)
    f2 = pF "f2" --freq control of tube2 of tubes synth (range 3, 1000)
    diffract = pF "diffract" --an FFT stretch/shift effect, this param is for stretch
    diffshift = pF "diffshift" -- shift parameter for diffract FFT effect
    diffmix = pF "diffmix" -- dry/wet control diffract FFT effect (0 to 1)
    invert = pF "invert" --fft spectral inversion (from 0 to 1, be careful with high values and use lpf to avoid strong hi freq sounds)
    tanh = pF "tanh" --tanh limiter/distortion (from 1 to n, high number will increase loudness A LOT)
    tantanh = pF "tantanh" --tantanh limiter/distortion (same param as tanh with a different flavour)
    ringshape = pF "ringshape" -- ringmod/waveshaping, the parameter controls frequency
    scr = pF "scr" -- wipe factor of bin scramble effect by Nesso, from 0 to 1
    smooth = pF "smooth" -- sets power of 2 value of fft bins for bin scrambling
    scry = pF "scry" -- amount of random displacement of bin scramble, from 0 to 1
    diff x y z = diffract x # diffshift y # diffmix z

-- chop
    tilt = pF "tilt"

-- mutable synths
    timbre = pF "timbre"
    color = pF "color"
    model = pI "model"
    mode = pI "mode"
    tidesshape = pF "tidesshape"
    tidessmooth = pF "tidessmooth"
    slope = pF "slope"
    shift = pF "shift"
    engine = pI "engine"
    harm = pF "harm"
    morph = pF "morph"
    level = pF "level"
    lpgdecay = pF "lpgdecay"
    lpgcolour = pF "lpgcolour"
    lpg d c = lpgdecay d # lpgcolour c

-- mutable effects
    cloudspitch = pF "cloudspitch"
    cloudspos = pF "cloudspos"
    cloudssize = pF "cloudssize"
    cloudsdens = pF "cloudsdens"
    cloudstex = pF "cloudstex"
    cloudswet = pF "cloudswet"
    cloudsgain = pF "cloudsgain"
    cloudsspread = pF "cloudsspread"
    cloudsrvb = pF "cloudsrvb"
    cloudsfb = pF "cloudsfb"
    cloudsfreeze = pF "cloudsfreeze"
    cloudsmode = pF "cloudsmode"
    cloudslofi = pF "cloudslofi"
    clouds p s d t = cloudsgain 1 # cloudspos p # cloudssize s # cloudsdens d # cloudstex t
    cloudsblend w s f r = cloudsgain 1 # cloudswet w # cloudsspread s # cloudsfb f # cloudsrvb r
    elementspitch = pF "elementspitch"
    elementsstrength = pF "elementsstrength"
    elementscontour = pF "elementscontour"
    elementsbowlevel = pF "elementsbowlevel"
    elementsblowlevel = pF "elementsblowlevel"
    elementsstrikelevel = pF "elementsstrikelevel"
    elementsflow = pF "elementsflow"
    elementsmallet = pF "elementsmallet"
    elementsbowtimb = pF "elementsbowtimb"
    elementsblowtimb = pF "elementsblowtimb"
    elementsstriketimb = pF "elementsstriketimb"
    elementsgeom = pF "elementsgeom"
    elementsbright = pF "elementsbright"
    elementsdamp = pF "elementsdamp"
    elementspos = pF "elementspos"
    elementsspace = pF "elementsspace"
    elementsmodel = pI "elementsmodel"
    elementseasteregg = pI "elementseasteregg"
    mu = pF "mu"
    ringsfreq = pF "ringsfreq"
    ringsstruct = pF "ringsstruct"
    ringsbright = pF "ringsbright"
    ringsdamp = pF "ringsdamp"
    ringspos = pF "ringspos"
    ringsmodel = pF "ringsmodel"
    ringspoly = pI "ringspoly"
    ringsinternal = pI "ringsinternal"
    ringseasteregg = pI "ringseasteregg"
    rings f s b d p = ringsfreq f # ringsstruct s # ringsbright b # ringsdamp d # ringspos p
    ripplescf = pF "ripplescf"
    ripplesreson = pF "ripplesreson"
    ripplesdrive = pF "ripplesdrive"
    ripples c r d = ripplescf c # ripplesreson r # ripplesdrive d
    verbgain = pF "verbgain"
    verbwet = pF "verbwet"
    verbtime = pF "verbtime"
    verbdamp = pF "verbdamp"
    verbhp = pF "verbhp"
    verbfreeze = pI "verbfreeze"
    verbdiff = pF "verbdiff"
    verb w t d h = verbgain 1 # verbwet w # verbtime t # verbdamp d # verbhp h

d1 $ s "bd:0"
