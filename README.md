Read about our project, [view the Git repo](https://github.com/aselker/gameboy-sound-chip), or [listen to the music](https://raw.githubusercontent.com/aselker/gameboy-sound-chip/master/audio%20files/zelda3.mp3)!

# GameBoy Sound Chip

This is Verilog simulation of the sound chip in the original Nintendo GameBoy.  

We use the same control signals as the original hardware, and produce a 4-bit, stereo audio signal. It should be able to fully reproduce original GameBoy music, though it is not bug-for-bug compatible.

This is a project for Computer Architecture at Olin College, over Fall 2018.  Most of the information used in creating and documenting this project has come from the [GBDev Wiki](http://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware).

## Behavior overview

The GameBoy sound chip exists to synthesize simple sounds for music and sound effects.  It tries to do work so the CPU doesn't have to, since the CPU is fairly slow and might not have time.  (Today, "sound cards" are mostly just DACs, because modern computers have the resources to generate sounds in software.)

#### Sound Channels

Sounds are created by four *channels*, mixed together and played in stereo:
- A square wave channel that perform frequency sweeps,
- A second square wave channel that can only play a constant frequency,
- A noise channel, and
- An arbitrary wave channel.

The four channels are mixed together and played in stereo.  Each channel has only four bits, but because they have individual volume controls, some subtlety and dynamic range is possible.

#### Specific Channel Behaviors

Each channel has its volume control, and a "length counter" which can shut the channel off after some amount of time.  The square wave and noise channels also have "volume envelopes", which can continuously vary the volume of the channel.

The square wave channels create square waves of arbitrary frequency and volume, and with a duty cycle of either 12.5%, 25%, 50%, or 75%.  The first square wave channel can also continuously vary its frequency over time, with a programmable speed.

The noise channel uses a linear feedback shift register (LFSR) as a simple pseudorandom number generator to create white noise.  Its frequency and shift-register length are adjustable.

The wave channel can play arbitrary samples.  There are 32 four-bit "samples", each of which represents just a single point in time, though the playback speed can be adjusted.  The samples, like all of the sound chip's inputs, are memory-mapped to the CPU's memory.

The GameBoy sound system is mostly the same between the first few generations of GameBoy (original, Pocket, Color, Super Game Boy), with some obscure differences.  We won't bother to copy those differences.

## Verilog Implementation

Because of the relative complexity of the system, we broke it down into its four channels, and then further into several smaller modules.

#### System

![System](https://github.com/aselker/gameboy-sound-chip/blob/master/System.jpg?raw=true)

#### Pulse Channels

The two pulse channels generate square waves with variable frequency, duty cycle, length, and volume envelope. The control signals for Pulse Channel 2 are defined below:

| Signal         | Length | Description |
| -------------- | --- | --- |
| Duty Cycle | 2 | Selects a duty cycle among 12.5%, 25%, 50%, and 75% | 
| Length Load | 6 | Defines a time to pulse, after which channel stops |
| Volume | 4 | Starting volume |
| Add Mode | 1 | When true, volume envelope increases in amplitude |
| Period | 3 | Defines the period at which the envelope is incremented |
| Frequency | 11 | Defines the starting frequency of the pulse wave |
| Trigger | 1 | When true, starts playback and resets counters |
| Length Enable | 1 | When true, length counter is decremented |

Based on these definitions, we broke down the second pulse channel into a number of submodules:

- **Frequency Timer**: This module takes in the frequency argument and produces a clock signal eight times the desired frequency.

- **Duty Cycler**: This module takes in the frequency clock and the duty cycle argument. It produces a pulse signal by cycling through one of four eight-bit shift register selected by the duty cycle input. The output frequency is therefore one eigth that of the frequency timer.

- **Length Timer**: This module sets an internal counter on each trigger event, and decrements every clock cycle. After the counter reaches zero, the output is set low, silencing the channel.

- **Volume Controller**: This module controls the volume envelope of the channel. On a trigger event, it sets its output equal to the starting volume argument. It then decrements (or increments, if add mode is true) with a period defined by the period argument every clock cycle. This essentially gives the ability to "fade" notes in and out of the channel.

A diagram of the entire channel is illustrated below:

![Pulse Channel 2](https://github.com/aselker/gameboy-sound-chip/blob/master/Pulse2.jpg?raw=true)

The first pulse channel, in addition to having the same functionality as Pulse Channel 2, has a frequency sweeper module:

- **Frequency Sweeper**: This module allows the channel to continuously change its frequency over a sustained note. On a trigger event, its output is set to the frequency argument, after which it begins to increment (or decrement, depending on negate) an amount based on the shift argument. This frequency output is fed into the Frequency Timer.

![Pulse Channel 1](https://github.com/aselker/gameboy-sound-chip/blob/master/Pulse1.jpg?raw=true)

#### Noise Channel

![Noise Channel](https://github.com/aselker/gameboy-sound-chip/blob/master/Noise.jpg?raw=true)

The core of the noise channel is a linear-feedback shift register (LFSR), which functions as a simple pseudorandom number generator.  The LFSR consists of a 15-bit shift register.  Every time-step, the shift register XORs the two low bits, inserts it in the high bit, and shifts the rest of the bits right by one.

If the "width mode" input is set, then the LFSR also inserts the result of the XOR into bit 6 (after the shift), making the shift register effectively only 7 bits long.

The clock for the LFSR is driven by a timer from the main 4mhz clock.  The timer's period is controlled by an input to the channel, and can be set to either 8 ticks, or between 16 and 112 (inclusive) in steps of 16.

Because the LFSR is not very random, the "noise" it produces has noticeable periodic components and does not sound exactly like "real" white noise.

It has a length timer and volume controller to simplify generation of short pulses of noise.

#### Wave Channel

![Wave Channel](https://github.com/aselker/gameboy-sound-chip/blob/master/Wave.jpg?raw=true)

The wave channel can play an arbitrary wave.  The wave is composed of 32 4-bit samples, each of which defines the output at a single timestep.  The channel loops through the 32 samples at a speed controlled by the channel's inputs, where an input of X plays one sample every (2048-X)\*2 cycles of the 4mhz clock.  The wave channel also has a volume control, which can set the volume to 0% (silent), 25%, 50%, or 100%.

Like the other channels, it has a length timer.  It does not have a volume controller.

#### Mixer

The mixer takes as input the outputs of the four channels, and a few control signals.  It combines them into a stereo audio signal. There is a separate enable wire for each channel and each ear, for a total of eight enable wires.  There is also a 3-bit volume controller for each ear.  

In the original hardware, the mixing was done using analog signals, with a separate DAC for each of the four channels.  There is also a "raw input" which comes straight from the game cartridge, which could contain its own audio hardware.  Neither of these makes sense to emulate here, since FPGAs are inherently digital and there is no cartridge.

The mixer control signals are fixed in our demo, because there is no reason to change them for a single song.  They could be sequenced as easily as the other components, however.
