// allow Fosc to communicate with LilyPond
FoscConfiguration.lilypondExecutablePath = "/usr/bin/lilypond";

// test that Fosc is able to call LilyPond
FoscConfiguration.getLilypondVersionString;

// --- 1. Displaying music --- //
// display a note
// ~/.config/SuperCollider/fosc-output/
a = FoscNote(60, 1/4);
a.show();

// display some notes in sequence
a = FoscVoice([FoscNote('C4', 1/4), FoscNote('D4', 1/8)]);
a.show;

// view lilypond output in the post window
a = FoscVoice([FoscNote('C4', 1/4), FoscNote('D4', 1/8)]);
a.format;

// display a score
a = FoscVoice([FoscNote('C4', 1/4), FoscNote('D4', 1/8)]);
b = FoscVoice([FoscNote('Bb3', 1/8), FoscNote('Ab3', 1/4)]);
c = FoscScore([FoscStaff([a]), FoscStaff([b])]);
c.show;

// --- 2. Indicators --- //
// indicators attach to leaves
a = FoscNote(60, 1/4);
a.attach(FoscArticulation('>'));
a.attach(FoscDynamic('f'));
a.show;

// --- 3. Spanners --- //
// Spanners attach to two or more contiguous leaves.
a = FoscStaff(FoscLeafMaker().(#[60,62,64,65], [1/8]));
a.selectLeaves.slur;
a.selectLeaves.hairpin('p < f');
a.show;

// --- 4. Tweaks, overrides, settings --- //
// Tweak lilypond grob properties
a = FoscNote(60, 1/4);
tweak(a.noteHead).style = 'harmonic';
a.show;

// override lilypond grob properties
a = FoscNote(60, 1/4);
override(a).noteHead.color = 'red';
a.show;

// set lilypond context properties
a = FoscScore([FoscStaff(FoscLeafMaker().(#[60,62,64,65], 1/8))]);
set(a[0]).instrumentName = FoscMarkup("Violin");
set(a).proportionalNotationDuration = FoscSchemeMoment(#[1,64]);
a.show;

// --- 5. Generate music with FoscLeafMaker --- //
// Integer, String or Symbol elements in 'pitches' slot result in notes.
m = FoscLeafMaker().(pitches: #[60,64,"G4",'Bb4'], durations: [1/4]);
m.show;

// Array elements in 'pitches' result in chords.
m = FoscLeafMaker().(pitches: #[[60,64,67],['Eb4','G4','Bb4']], durations: [1/2]);
m.show;

// Nil-valued elements in 'pitches' result in rests.
m = FoscLeafMaker().(pitches: nil, durations: 1/4 ! 4);
m.show;

// Values passed to 'pitches' can be mixed and matched.
m = FoscLeafMaker().(pitches: #[[60,64,67],nil,'Eb4','Bb4'], durations: [1/4]);
m.show;

// Pitches are repeated cyclically when the length of 'pitches' is less than the length of 'durations'.
m = FoscLeafMaker().(pitches: #[72,71], durations: [3/8,1/8,1/4,2/8]);
m.show;

// Durations are repeated cyclically when the length of 'durations' is less than the length of 'pitches'.
m = FoscLeafMaker().(pitches: #[72,74,76,77], durations: [3/8,1/8]);
m.show;

// Elements in 'durations' with non-power-of-two denominators result in tuplet-nested leaves.
m = FoscLeafMaker().(pitches: #[60,62,64,65], durations: [1/4, 1/12, 1/6, 1/2]);
m.show;

// --- 6. Generate rhythms with FoscRhythmMaker
// 'Ratios' embed into 'divisions' as rhythmic proportions.
