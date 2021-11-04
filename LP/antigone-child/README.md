# About

This the source code to the album Antigone/Child released in 2018 via Kamizdat. This code will not produce exact replica of the album, but will output generative version very close to the final audio recordings. You need [SuperCollider](https://supercollider.github.io/) software installed for this to work.

# Download
You can use git to pull the repo, or you can also just [download a zip](https://gitlab.com/lukap/antigone-child/-/archive/master/antigone-child-master.zip) or by clicking on little cloud icon with an arrow on the top right ⇗⇗⇗

# How to use

Currently the best way is to open the code in SC IDE - SuperCollider intergrated development environment aka The Editor - and run parts of it from there.

You might learn a little bit about the SC on the way. The code has two parts.

Part one is a definition of a Synth - so called SynthDef. It's a recipe how the SC server could create an instance of a synth. It defines a granular synthesis generator (UGen), a low pass filter and a reverb effect. It also defines which parameters can be controlled 'from the outside'. This code has to be executed first - so that server knows how to bake a cake.

Part two has different instructions for different cakes for server to make using the recipe it already knows and parameters from the instructions. This is called instantiation - creating an instance of a synth on the server running and actually producing sound. Each instance to run represents a track - it has a fade-in and fade-out, and various parameters.

So, first select the SynthDef part (between parenthesis) and run it by pressing CTRL+RETURN. The codeblock will light up. If the server is not yet booted, it will boot. The SynthDef will be added, samples should load. No sound yet.

Secondly choose first act (ACT I) - you can place the cursor anywhere inside that part of code and run it with CTRL+RETURN. After 10 seconds there should be clear sound. You can listen to it for it's full length - cca. 5 minutes. If there is no sound, you can check if SC is actually producing sound by opening the meters (CTRL-M).

You can check other acts, other code-blocks. You can stop sound with CTRL-. (control + dot/fullstop). You can run more blocks at the same time. Change code, play with it.

# Download

See [Kamizdat](http://kamizdat.si) for album download, videos and more.

# Licence

This program is free to use, modify and distribute under the conditions of GNU GPL licence. See COPYING for more info.