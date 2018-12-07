# GameBoy Sound Chip

This is a clone of the sound chip in the original Nintendo GameBoy.  It aims to reproduce all or almost all game music, though it is not bug-for-bug compatible.  At the moment, the sound chip is incomplete.

This is a project for Computer Architecture at Olin College, over Fall 2018.  Most of the information used in creating and documenting this project has come from the [GBDev Wiki](http://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware).

## Behavior overview

The GameBoy sound chip exists to synthesize simple sounds for music and sound effects.  It tries to do work so the CPU doesn't have to, since the CPU is fairly slow and might not have time.  (Today, "sound cards" are mostly just DACs, because modern CPUs can spare the time to generate sounds in software.)

Sounds are created by four *channels*: two square wave channels, one noise channel, and one arbitrary wave channel.  The four channels are mixed together and played in stereo.  Each channel has only four bits, but because they have individual volume controls, some subtlety and dynamic range is possible.

Each channel has its volume control, and a "length counter" which can shut the channel off after some amount of time.  The square wave and noise channels also have "volume envelopes", which can continuously vary the volume of the channel.

The square wave channels create square waves of arbitrary frequency and volume, and with a duty cycle of either 12.5%, 25%, 50%, or 75%.  The first square wave channel can also continuously vary its frequency over time, with a programmable speed.

The noise channel uses a linear feedback shift register (LFSR) as a simple pseudorandom number generator to create white noise.  Its frequency and shift-register length are adjustable.

The wave channel can play arbitrary samples.  There are 32 four-bit "samples", each of which represents just a single point in time, though the playback speed can be adjusted.  The samples, like all of the sound chip's inputs, are memory-mapped to the CPU's memory.

The GameBoy sound system is mostly the same between the first few generations of GameBoy (original, Pocket, Color, Super Game Boy), with some obscure differences.  We won't bother to copy those differences.